# LibPixel

[![Build Status](https://travis-ci.org/libpixel/libpixel-ruby.svg?branch=master)](https://travis-ci.org/libpixel/libpixel-ruby)

Ruby library to generate and sign LibPixel URLs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'libpixel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libpixel

## Usage

Configure the LibPixel client:

```ruby
LibPixel.setup do |config|
  config.host = "test.libpx.com" # Your LibPixel domain. Required.
  config.https = true # Generates HTTPS URLs. Optional. Default is false.
  config.secret = "..." # Auth secret for your LibPixel account. Required for signing requests.
end
```

### Sign URLs

You can sign an existing URL using the `sign` function:

```ruby
url = LibPixel.sign("http://test.libpx.com/images/1.jpg?width=400")
```

### Generate URLs

You can also generate and sign URLs at the same time with the `url` function:

```ruby
url = LibPixel.url("/images/1.jpg", height: 400, blur: 20, saturation: -80)
```

If you're using the `src` parameter, you can skip the path:

```ruby
url = LibPixel.url(src: "http://...", width: 300)
```

### Multiple clients

It's also possible to have multiple instances of LibPixel clients (e.g. when dealing with multiple accounts):

```ruby
client = LibPixel::Client.new(host: "test.libpx.com", https: true, secret: "...")
```

You may then call the `#url` and `#sign` methods on the client object.

## License

[MIT](LICENSE)
