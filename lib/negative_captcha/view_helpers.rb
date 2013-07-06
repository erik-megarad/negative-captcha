module ActionView
  module Helpers
    module NegativeCaptchaHelpers
      def negative_captcha(captcha)
        [
          hidden_field_tag('timestamp', captcha.timestamp),
          hidden_field_tag('spinner', captcha.spinner),
        ].join.html_safe
      end

      def negative_text_field_tag(*args)
        negative_input_tag :text_field_tag, *args
      end

      def negative_email_field_tag(*args)
        negative_input_tag :email_field_tag, *args
      end

      def negative_text_area_tag(*args)
        negative_input_tag :text_area_tag, *args
      end

      def negative_hidden_field_tag(*args)
        negative_input_tag :hidden_field_tag, *args
      end

      def negative_check_box_tag(*args)
        negative_input_tag :check_box_tag, *args
      end

      def negative_password_field_tag(*args)
        negative_input_tag :password_field_tag, *args
      end

      def negative_label_tag(negative_captcha, field, name, options={})
        label_tag(negative_captcha.fields[field], name, options)
      end

      def negative_file_field_tag(negative_captcha, field, options={})
        file_field_tag(
          negative_captcha.fields[field],
          options.merge(:value => negative_captcha.values[field])
        ) +
        content_tag('div', :style => 'position: absolute; left: -2000px;') do
          file_field_tag(field, :tabindex => '999')
        end
      end
    end

    #TODO: Select, check_box, etc

    private

    def negative_input_tag(method_name, negative_captcha, field, options={})
      send(method_name,
        negative_captcha.fields[field],
        negative_captcha.values[field],
        options
      ) +
      content_tag('div', :style => 'position: absolute; left: -2000px;') do
        send(method_name, field, '', :tabindex => '999', :autocomplete => 'off')
      end.html_safe
    end
  end
end
