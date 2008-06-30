require 'rubygems'
require 'activesupport'
require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/negative_captcha'))

class NegativeCaptchaTest < Test::Unit::TestCase
  def test_valid_submission
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert_equal "", filled_form.error
    assert filled_form.valid?
  end
  
  def test_missing_timestamp
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:spinner => captcha.spinner}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/timestamp/).is_a?(MatchData)
  end
  
  def test_bad_timestamp
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => 14.days.ago.to_i, :spinner => captcha.spinner}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/timestamp/).is_a?(MatchData)
  end
  
  def test_missing_spinner
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/spinner/).is_a?(MatchData)
  end
  
  def test_bad_spinner
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner.reverse}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/spinner/).is_a?(MatchData)
  end
  
  def test_includes_honeypots
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}
    
    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner, :name => "Test"}.merge(captcha.fields.inject({}){|hash, name, encrypted_name| hash[encrypted_name] = name; hash})
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/hidden/i).is_a?(MatchData)
  end
end
