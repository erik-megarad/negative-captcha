require 'negative_captcha'
if !ActionView::Base.instance_methods.include? 'negative_captcha'
  require 'negative_captcha_view_helpers'
  ActionView::Base.class_eval { include NegativeCaptchaViewHelpers }
end