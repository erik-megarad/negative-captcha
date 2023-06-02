module ActionView
  module Helpers
    module NegativeCaptchaHelpers
      def negative_captcha(captcha)
        [
          hidden_field_tag('timestamp', captcha.timestamp),
          hidden_field_tag('spinner', captcha.spinner),
        ].join.html_safe
      end

      def negative_text_field_tag(negative_captcha, field, options={})
        text_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
          content_tag('div', :style => negative_captcha.css) do
          text_field_tag(field, '', :tabindex => '999', :autocomplete => SecureRandom.hex(10))
        end.html_safe
      end

      def negative_email_field_tag(negative_captcha, field, options={})
        email_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
          content_tag('div', :style => 'position: absolute; left: -2000px;') do
          email_field_tag(field, '', :tabindex => '999', :autocomplete => SecureRandom.hex(10))
        end.html_safe
      end

      def negative_text_area_tag(negative_captcha, field, options={})
        text_area_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
          content_tag('div', :style => negative_captcha.css) do
          text_area_tag(field, '', :tabindex => '999', :autocomplete => SecureRandom.hex(10))
        end.html_safe
      end

      def negative_hidden_field_tag(negative_captcha, field, options={})
        hidden_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
        content_tag('div', :style => negative_captcha.css) do
          hidden_field_tag(field, '', :tabindex => '999')
        end.html_safe
      end

      def negative_file_field_tag(negative_captcha, field, options={})
        file_field_tag(
          negative_captcha.fields[field],
          options.merge(:value => negative_captcha.values[field])
        ) +
        content_tag('div', :style => negative_captcha.css) do
          file_field_tag(field, :tabindex => '999')
        end
      end

      def negative_check_box_tag(negative_captcha, field, options={})
        check_box_tag(
          negative_captcha.fields[field],
          '1',
          negative_captcha.values[field].present?,
          options
        ) +
        content_tag('div', :style => negative_captcha.css) do
          check_box_tag(field, '1', false, :tabindex => '999')
        end
      end

      def negative_password_field_tag(negative_captcha, field, options={})
        password_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
        content_tag('div', :style => negative_captcha.css) do
          password_field_tag(field, '', :tabindex => '999')
        end.html_safe
      end

      def negative_label_tag(negative_captcha, field, name, options={}, &block)
        label_tag(negative_captcha.fields[field], name, options, &block)
      end

      def negative_number_field_tag(negative_captcha, field, options={})
        number_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
        content_tag('div', :style => negative_captcha.css) do
          number_field_tag(field, '', :tabindex => '999')
        end.html_safe
      end

      def negative_phone_field_tag(negative_captcha, field, options={})
        phone_field_tag(
          negative_captcha.fields[field],
          negative_captcha.values[field],
          options
        ) +
        content_tag('div', :style => negative_captcha.css) do
          number_field_tag(field, '', :tabindex => '999')
        end.html_safe
      end
    end

    #TODO: Select, check_box, etc
  end
end
