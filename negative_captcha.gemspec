# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "negative_captcha"
  s.version     = "0.3.2"
  s.authors     = ["Erik Peterson"]
  s.email       = ["erik@subwindow.com"]
  s.homepage    = "http://github.com/subwindow/negative-captcha"
  s.description = %q{A library to make creating negative captchas less painful}
  s.summary     = s.description # Yeah, really. Fuck you.
  s.files        = [
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "lib/negative_captcha.rb",
    "lib/negative_captcha/form_builder.rb",
    "lib/negative_captcha/view_helpers.rb"
  ]
  s.require_paths = ['lib/']

  s.add_dependency 'actionpack'
end
