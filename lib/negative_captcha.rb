if RUBY_VERSION.to_f >= 1.9
  RUBY_19 = true
  require 'digest/md5'
else
  RUBY_19 = false
  require 'md5'
end

class NegativeCaptcha
  attr_accessor :fields
  attr_accessor :values
  attr_accessor :secret
  attr_accessor :spinner
  attr_accessor :message
  attr_accessor :timestamp
  attr_accessor :error

  def initialize(opts)
    @secret = opts[:secret]||(RUBY_19 ? Digest::MD5.hexdigest("this_is_a_secret_key") : MD5.hexdigest("this_is_a_secret_key"))
    @timestamp =  (opts.has_key?(:params) ? opts[:params][:timestamp] : nil) || Time.now.to_i
    spinner_text = ([@timestamp, @secret] + (opts[:spinner].is_a?(Array) ? opts[:spinner] : [opts[:spinner]]))*'-'
    @spinner = RUBY_19 ? Digest::MD5.hexdigest(spinner_text) : MD5.hexdigest(spinner_text)
    @message = opts[:message]||"Please try again. This usually happens because an automated script attempted to submit this form."
    @fields = opts[:fields].inject({}){ |hash, field_name|
      hash[field_name] = \
      if RUBY_19
        Digest::MD5.hexdigest([field_name, @spinner, @secret]*'-')
      else
        MD5.hexdigest([field_name, @spinner, @secret]*'-')
      end

      hash
    }
    @values = {}
    @error = "No params provided"
    process(opts[:params]) if opts[:params] && (opts[:params][:spinner]||opts[:params][:timestamp])
  end

  def [](name)
    @fields[name]
  end

  def valid?
    @error.nil? || @error == "" || @error.empty?
  end

  def process(params)
    if params[:timestamp].nil? || (Time.now.to_i - params[:timestamp].to_i).abs > 86400
      @error = "Error: Invalid timestamp.  #{@message}"
    elsif params[:spinner] != @spinner
      @error = "Error: Invalid spinner.  #{@message}"
    elsif fields.keys.detect {|name| params[name] && params[name].length > 0}
      @error = "Error: Hidden form fields were submitted that should not have been.  #{@message}"
      false
    else
      @error = ""
      @fields.each do |name, encrypted_name|
        @values[name] = params[encrypted_name]
      end
    end
  end
end
