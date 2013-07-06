require 'test_helper'

class NegativeCaptchaTest < MiniTest::Unit::TestCase
  def test_view_helpers
    assert ActionView::Base.instance_methods.include?(:negative_captcha)
  end

  def encrypted_params captcha, fields=nil
    params = {}
    fields ||= captcha.fields.keys
    fields.each do |field|
      params[captcha.fields[field]] = field.to_s
    end
    params
  end

  def test_valid_submission
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}

    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner}.merge(encrypted_params(captcha))
    )
    assert_equal "", filled_form.error
    assert filled_form.valid?
    assert_equal 'name', filled_form.values[:name]
    assert_equal 'comment', filled_form.values[:comment]
  end

  def test_missing_fields_are_not_in_values
    fields = [:name, :comment, :widget]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}

    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner}.merge(encrypted_params(captcha, [:name, :comment]))
    )
    assert_equal "", filled_form.error
    assert filled_form.valid?

    assert_equal({:name => 'name', :comment => 'comment'}, filled_form.values)
  end

  def test_missing_timestamp
    fields = [:name, :comment]
    captcha = NegativeCaptcha.new(:fields => fields)
    assert captcha.fields.is_a?(Hash)
    assert_equal captcha.fields.keys.sort{|a,b|a.to_s<=>b.to_s}, fields.sort{|a,b|a.to_s<=>b.to_s}

    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:spinner => captcha.spinner}.merge(encrypted_params(captcha))
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
      :params => {:timestamp => 1209600, :spinner => captcha.spinner}.merge(encrypted_params(captcha))
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
      :params => {:timestamp => captcha.timestamp}.merge(encrypted_params(captcha))
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
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner.reverse}.merge(encrypted_params(captcha))
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
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner, :name => "Test"}.merge(encrypted_params(captcha))
    )
    assert !filled_form.valid?
    assert filled_form.error.match(/hidden/i).is_a?(MatchData)
  end

  def test_valid_submission_with_only_whitespaces_in_fields
    fields = [:one, :two, :three]
    captcha = NegativeCaptcha.new(:fields => fields)

    filled_form = NegativeCaptcha.new(
      :fields => fields,
      :timestamp => captcha.timestamp,
      :params => {:timestamp => captcha.timestamp, :spinner => captcha.spinner, :one => ' ', :two => "\r\n", :three => "\n"}.merge(encrypted_params(captcha))
    )
    assert_equal "", filled_form.error
    assert filled_form.valid?
  end
end
