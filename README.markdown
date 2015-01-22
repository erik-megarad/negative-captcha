# Negative Captcha

## What is a Negative Captcha?

A negative captcha has the exact same purpose as your run-of-the-mill image captcha: To keep bots from submitting forms. Image ("positive") captchas do this by implementing a step which only humans can do, but bots cannot: read jumbled characters from an image. But this is bad. It creates usability problems, it hurts conversion rates, and it confuses the shit out of lots of people. Why not do it the other way around? Negative captchas create a form that has tasks that only bots can perform, but humans cannot. This has the exact same effect, with (anecdotally) a much lower false positive identification rate when compared with positive captchas. All of this comes without making humans go through any extra trouble to submit the form. It really is win-win.

## How does it work?

In a negative captcha form there are two main parts and three ancillary parts. I'll explain them thusly.

### Honeypots

Honeypots are form fields which look exactly like real form fields. Bots will see them and fill them out. Humans cannot see them and thusly will not fill them out. They are hidden indirectly- usually by positioning them off to the left of the browser. They look kind of like this:

```html
<div style="position: absolute; left: -2000px;"><input type="text" name="name"  value="" /></div>
```

### Real fields

These fields are the ones humans will see, will subsequently fill out, and that you'll pull your real form data out of. The form name will be hashed so that bots will not know what it is. They look kind of like this:

```html
<input type="text" name="685966bd3a1975667b4777cc56188c7e" />
```

### Timestamp

This is a field that is used in the hash key to make the hash different on every GET request, and to prevent replayability.

### Spinner

This is a rotating key that is used in the hash method to prevent replayability. I'm not sold on its usefulness.

### Secret key

This is simply some key that is used in the hashing method to prevent bots from backing out the name of the field from the hashed field name.

## How does Negative Captcha work?

### Installation

You can let bundler install Negative Captcha by adding this line to your application’s Gemfile:

```ruby
gem 'negative_captcha'
```


### Controller Hooks

Place this before filter at the top of the controller you are protecting:

```ruby
before_filter :setup_negative_captcha, :only => [:new, :create]
```

In the same controller include the following private method:

```ruby
private
  def setup_negative_captcha
    @captcha = NegativeCaptcha.new(
      # A secret key entered in environment.rb. 'rake secret' will give you a good one.
      secret: NEGATIVE_CAPTCHA_SECRET,
      spinner: request.remote_ip,
      # Whatever fields are in your form
      fields: [:name, :email, :body],
      # If you wish to override the default CSS styles (position: absolute; left: -2000px;) used to position the fields off-screen
      css: "display: none",
      params: params
    )
  end
```

Modify your POST action(s) to check for the validity of the negative captcha form

```ruby
def create
  # Decrypted params are stored in @captcha.values
  @comment = Comment.new(@captcha.values)

  # @captcha.valid? will return false if a bot submitted the form
  if @captcha.valid? && @comment.save
    redirect_to @comment
  else
    # @captcha.error will explain what went wrong
    flash[:notice] = @captcha.error if @captcha.error
    render :action => 'new'
  end
end
```

### Automated tests

To make all field ids and names predictable for tests,
simply add the following line in your spec helper.

```ruby
NegativeCaptcha.test_mode = true
```

This will ensure that a field named `email` will not be referred to by a hash but by `test-email` instead.
A tool like capybara can now bypass this security while still going through the captcha workflow.

### Form Example

Modify your form to include the honeypots and other fields. You can probably leave any select, radio, and check box fields alone. The text field/text area helpers should be sufficient.

```erb
<% form_tag comments_path do -%>
  <%# The `negative_captcha` call gives us the honeypots, spinners and whatnot %>
  <%= raw negative_captcha(@captcha) %>
  <ul class="contact_us">
    <li>
      <%= negative_label_tag(@captcha, :name, 'Name:') %>
      <%= negative_text_field_tag(@captcha, :name) %>
    </li>
    <li>
      <%= negative_label_tag(@captcha, :email, 'Email:') %>
      <%= negative_text_field_tag(@captcha, :email) %>
    </li>
    <li>
      <%= negative_label_tag(@captcha, :body, 'Your Comment:') do %>
        <span>Accepts a block.</span>
      <% end %>
      <%= negative_text_area_tag(@captcha, :body) %>
    </li>
    <li>
      <%= submit_tag %>
    </li>
  </ul>
<% end -%>
```

### Test and enjoy!

## Possible Gotchas and other concerns

* It is still possible for someone to write a bot to exploit a single site by closely examining the DOM. This means that if you are Yahoo, Google or Facebook, negative captchas will not be a complete solution. But if you have a small application, negative captchas will likely be a very, very good solution for you. There are no easy work-arounds to this quite yet. Let me know if you have one.
* I'm not a genius. It is possible that a bot can figure out the hashed values and determine which forms are which. I don't know how, but I think they might be able to. I welcome people who have thought this out more thoroughly to criticize this method and help me find solutions. I like this idea a lot and want it to succeed.

## Credit

The idea of a negative captcha is not mine. It originates (I think) from Damien Katz of CouchDB. I (Erik Peterson) wrote the plugin. Calvin Yu wrote the original class which I refactored quite a bit and made into the gem.
