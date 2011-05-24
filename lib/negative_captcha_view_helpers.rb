module NegativeCaptchaViewHelpers
  def negative_captcha(captcha)
    [
      hidden_field_tag('timestamp', captcha.timestamp), 
      hidden_field_tag('spinner', captcha.spinner),
    ].join
  end
  
  def negative_text_field_tag(negative_captcha, field, options={})
    text_field_tag(negative_captcha.fields[field], negative_captcha.values[field], options) +
    content_tag('div', :style => 'position: absolute; left: -2000px;') {
      text_field_tag(field, '', :tabindex => '999', :autocomplete => 'off')
    }
  end
  
  def negative_text_area_tag(negative_captcha, field, options={})
    text_area_tag(negative_captcha.fields[field], negative_captcha.values[field], options) +
    content_tag('div', :style => 'position: absolute; left: -2000px;') {
      text_area_tag(field, '', :tabindex => '999', :autocomplete => 'off')
    }
  end

  def negative_hidden_field_tag(negative_captcha, field, options={})
    [
      hidden_field_tag(negative_captcha.fields[field], negative_captcha.values[field], options),
      "<div style='position: absolute; left: -2000px;'>" + hidden_field_tag(field, '', :tabindex => '999') + "</div>"
    ].join
  end

  def negative_password_field_tag(negative_captcha, field, options={})
    [
      password_field_tag(negative_captcha.fields[field], negative_captcha.values[field], options),
      "<div style='position: absolute; left: -2000px;'>" + password_field_tag(field, '', :tabindex => '999') + "</div>"
    ].join
  end
  
  def negative_label_tag(negative_captcha, field, name, options={})
    label_tag(negative_captcha.fields[field], name, options)
  end
  
  #TODO: Select, check_box, etc
end
