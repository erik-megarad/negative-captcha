require 'test_helper'

describe NegativeCaptchaFormBuilder do
	class TestObject
		attr_accessor :errors
		def initialize
			self.errors = {}
		end
	end

	class TestFormBuilder
		def initialize
			@template = ActionView::Base.new
			@object = TestObject.new
		end
		include NegativeCaptchaFormBuilder
	end

	let(:form_builder) { TestFormBuilder.new }
	let(:captcha) do
		NegativeCaptcha.new(
			secret: 'secret',
      spinner: '0.0.0.1',
      fields: [:name],
      params: {}
    )
	end

	describe :negative_text_field do
		it { form_builder.negative_text_field(captcha, :name).must_match 'type="text"' }
		it { form_builder.negative_text_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_email_field do
		it { form_builder.negative_email_field(captcha, :name).must_match 'type="email"' }
		it { form_builder.negative_email_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_text_area do
		it { form_builder.negative_text_area(captcha, :name).must_match 'textarea' }
		it { form_builder.negative_text_area(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_hidden_field do
		it { form_builder.negative_hidden_field(captcha, :name).must_match 'type="hidden"' }
		it { form_builder.negative_hidden_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_file_field do
		it { form_builder.negative_file_field(captcha, :name).must_match 'type="file"' }
		it { form_builder.negative_file_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_check_box_field do
		it { form_builder.negative_check_box_field(captcha, :name).must_match 'type="checkbox"' }
		it { form_builder.negative_check_box_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_password_field do
		it { form_builder.negative_password_field(captcha, :name).must_match 'type="password"' }
		it { form_builder.negative_password_field(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_label do
		it { form_builder.negative_label(captcha, :name, 'Label Name').must_match '<label' }
		it { form_builder.negative_label(captcha, :name, 'Label Name').must_match %{for="#{captcha.fields[:name]}"} }
	end
end