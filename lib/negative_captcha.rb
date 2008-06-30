require 'md5'

class NegativeCaptcha
  attr_accessor :fields
  attr_accessor :values
  attr_accessor :secret
  attr_accessor :spinner
  attr_accessor :message
  attr_accessor :timestamp
  attr_accessor :error
  
  def initialize(opts)
    @secret = opts[:secret]||MD5.hexdigest("this_is_a_secret_key")
    @spinner = MD5.hexdigest(([timestamp, @secret] + (opts[:spinner].is_a?(Array) ? opts[:spinner] : [opts[:spinner]]))*'-')
    @message = opts[:message]||"Please try again. This usually happens because an automated script attempted to submit this form."
    @fields = opts[:fields].inject({}){|hash, field_name| hash[field_name] = MD5.hexdigest([field_name, @spinner, @secret]*'-'); hash }
    @timestamp = Time.now()
    @values = {}
    @error = "No params provided"
    process(opts[:params]) if opts[:params] && (opts[:params][:spinner]||opts[:params][:timestamp])
  end
  
  def [](name)
    @fields[name]
  end
  
  def valid?
    @error.blank?
  end
  
  def process(params)
    if params[:timestamp].nil? || (Time.now.to_i - params[:timestamp].to_i).abs > 1.day.to_i
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
