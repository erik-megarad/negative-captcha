module NegativeCaptchaFormBuilder
  def negative_text_field(*args)
    negative_form_input :negative_text_field_tag, *args
  end

  def negative_email_field(*args)
    negative_form_input :negative_email_field_tag, *args
  end

  def negative_text_area(*args)
    negative_form_input :negative_text_area_tag, *args
  end

  def negative_hidden_field(captcha, method, options = {})
    @template.negative_hidden_field_tag(captcha, method, options).html_safe
  end

  def negative_file_field(*args)
    negative_form_input :negative_file_field_tag, *args
  end

  def negative_check_box_field(*args)
    negative_form_input :negative_check_box_tag, *args
  end

  def negative_password_field(*args)
    negative_form_input :negative_password_field_tag, *args
  end

  def negative_label(captcha, method, name, options = {})
    html = @template.negative_label_tag(
      captcha,
      method,
      name,
      options
    ).html_safe

    if @object.errors[method].present?
      html = "<div class='fieldWithErrors'>#{html}</div>"
    end

    html.html_safe
  end

  private

  def negative_form_input(method_name, captcha, method, options = {})
    html = @template.send(method_name,
      captcha,
      method,
      options
    ).html_safe

    if @object.errors[method].present?
      html = "<div class='fieldWithErrors'>#{html}</div>"
    end

    html.html_safe
  end
end