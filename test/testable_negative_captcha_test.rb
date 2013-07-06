require 'test_helper'

class TestableNegativeCaptchaTest < MiniTest::Unit::TestCase 
  def test_can_be_predictable_for_tests
    NegativeCaptcha.test_mode = true
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
end