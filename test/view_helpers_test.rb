require "action_view"
require 'test/unit'
require_relative '../lib/negative_captcha'

class ActionView::Helpers::ViewHelpersTest < ActionView::TestCase
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::NegativeCaptchaHelpers

  def test_options_are_passed_to_rails_helper
    fields = [:accept_tos]

    captcha = NegativeCaptcha.new :fields => fields
    captcha.values[:accept_tos] = "on"

    actual = negative_check_box_tag captcha, :accept_tos, :class => 'tos'
    expected = /<input checked="checked" class="tos" id="#{captcha[:accept_tos]}" name="#{captcha[:accept_tos]}" type="checkbox"/

    assert_match actual, expected
  end
end
