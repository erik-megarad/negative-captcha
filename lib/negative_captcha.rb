require 'action_view'
require 'active_support/hash_with_indifferent_access'
require 'openssl'

class NegativeCaptcha
  attr_accessor :fields,
    :values,
    :secret,
    :spinner,
    :css,
    :message,
    :timestamp,
    :error

  @@test_mode = false
  def self.test_mode=(value)
    class_variable_set(:@@test_mode, value)
  end

  def initialize(secret, opts)
    self.secret = secret

    if opts.has_key?(:params)
      self.timestamp = opts[:params][:timestamp] || Time.now.to_i
    else
      self.timestamp = Time.now.to_i
    end

    self.spinner = self.generate_session_secret(
      self.secret,
      self.timestamp,
      opts[:spinner]
    )

    self.css = opts[:css] || "position: absolute; left: -2000px;"

    self.message = opts[:message] || <<-MESSAGE
Please try again.
This usually happens because an automated script attempted to submit this form.
    MESSAGE

    self.fields = opts[:fields].each_with_object({}) do |hash, field_name|
      hash[field_name]   = "test-#{field_name}" if @@test_mode
      hash[field_name] ||= self.generate_authenticator(self.spinner, field_name)
    end

    self.values = HashWithIndifferentAccess.new
    self.error = "No params provided"

    if opts[:params] && (opts[:params][:spinner] || opts[:params][:timestamp])
      process(opts[:params])
    end
  end

  def [](name)
    fields[name]
  end

  def valid?
    error.blank?
  end

  def process(params)
    timestamp_age = (Time.now.to_i - params[:timestamp].to_i).abs

    if params[:timestamp].nil? || timestamp_age > 86400
      self.error = "Error: Invalid timestamp.  #{message}"
    elsif params[:spinner] != spinner
      self.error = "Error: Invalid spinner.  #{message}"
    elsif fields.keys.detect {|name| params[name] && params[name] =~ /\S/}
      self.error = <<-ERROR
Error: Hidden form fields were submitted that should not have been. #{message}
      ERROR

      false
    else
      self.error = ""

      fields.each do |name, authenticator|
        self.values[name] = params[authenticator] if params.include? authenticator
      end
    end
  end
  
  protected
  
  def generate_session_secret(secret, nonce, context)
    # securely compose the message by using fixed-size 64-bit length prefixes
    # before each component
    nonce          = nonce  .to_s
    context        = context.to_s
    nonce_length   = [ timestamp.length ].pack('Q>')
    context_length = [ context  .length ].pack('Q>')
    
    message = (
      nonce_length   + nonce
      context_length + context
    )

    self.generate_authenticator(secret, message)
  end
  
  def generate_authenticator(secret, message)
    # decode the secret from hex into raw bytes
    secret = [ secret ].pack('H*')
    
    # compute HMAC-SHA-256 of the message
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest::SHA256.new,
      key,
      message
    )
  end
end


require 'negative_captcha/view_helpers'
require "negative_captcha/form_builder"

class ActionView::Base
  include NegativeCaptchaHelpers
end
