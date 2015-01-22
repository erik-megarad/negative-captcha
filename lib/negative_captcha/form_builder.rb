module ActionView
  module Helpers
    class FormBuilder
      def negative_text_field(captcha, method, options = {})
        html = @template.negative_text_field_tag(
          captcha,
          method,
          options
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end

      def negative_text_area(captcha, method, options = {})
        html = @template.negative_text_area_tag(
          captcha,
          method,
          options
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end

      def negative_hidden_field(captcha, method, options = {})
        @template.negative_hidden_field_tag(captcha, method, options).html_safe
      end

      def negative_file_field(captcha, method, options = {})
        html = @template.negative_file_field_tag(
          captcha,
          method,
          options
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end

      def negative_check_box_field(captcha, method, options = {})
        html = @template.negative_check_box_tag(
          captcha,
          method,
          options
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end

      def negative_password_field(captcha, method, options = {})
        html = @template.negative_password_field_tag(
          captcha,
          method,
          options
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end

      def negative_label(captcha, method, name, options = {}, &block)
        html = @template.negative_label_tag(
          captcha,
          method,
          name,
          options,
          &block
        ).html_safe

        if @object.errors[method].present?
          html = "<div class='fieldWithErrors'>#{html}</div>"
        end

        html.html_safe
      end
    end
  end
end
