require 'test_helper'

describe ActionView::Helpers::NegativeCaptchaHelpers do
	let(:view) { ActionView::Base.new }
	let(:captcha) do
		NegativeCaptcha.new(
			secret: 'secret',
      spinner: '0.0.0.1',
      fields: [:name],
      params: {}
    )
	end

	describe :negative_captcha do
		it { view.negative_captcha(captcha).must_match 'name="timestamp"' }
		it { view.negative_captcha(captcha).must_match 'name="spinner"' }
	end

	describe :negative_text_field_tag do
		it { view.negative_text_field_tag(captcha, :name).must_match 'type="text"' }
		it { view.negative_text_field_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_email_field_tag do
		it { view.negative_email_field_tag(captcha, :name).must_match 'type="email"' }
		it { view.negative_email_field_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_text_area_tag do
		it { view.negative_text_area_tag(captcha, :name).must_match 'textarea' }
		it { view.negative_text_area_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_hidden_field_tag do
		it { view.negative_hidden_field_tag(captcha, :name).must_match 'type="hidden"' }
		it { view.negative_hidden_field_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_file_field_tag do
		it { view.negative_file_field_tag(captcha, :name).must_match 'type="file"' }
		it { view.negative_file_field_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_check_box_tag do
		it { view.negative_check_box_tag(captcha, :name).must_match 'type="checkbox"' }
		it { view.negative_check_box_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_password_field_tag do
		it { view.negative_password_field_tag(captcha, :name).must_match 'type="password"' }
		it { view.negative_password_field_tag(captcha, :name).must_match %{name="#{captcha.fields[:name]}"} }
	end

	describe :negative_label_tag do
		it { view.negative_label_tag(captcha, :name, 'Label Name').must_match '<label' }
		it { view.negative_label_tag(captcha, :name, 'Label Name').must_match %{for="#{captcha.fields[:name]}"} }
	end
end