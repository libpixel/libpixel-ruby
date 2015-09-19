# LibPixel

[![Build Status](https://travis-ci.org/libpixel/libpixel-ruby.svg?branch=master)](https://travis-ci.org/libpixel/libpixel-ruby)

Ruby library and Rails plugin to generate and sign LibPixel URLs.

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
  config.default_source = "us-east-1/source" # optional source to be used, can be overriden
end
```

The configuration for host and secret will be automatically set from the environment variables LIBPIXEL_HOST and LIBPIXEL_SECRET if they are present.

### Sign URLs

You can sign an existing URL using the `sign` function:

```ruby
url = LibPixel.sign("http://test.libpx.com/images/1.jpg?width=400")
```

### Generate URLs

You can also generate and sign URLs at the same time with the `url` function:

```ruby
url = LibPixel.url("/us-east-1/images/1.jpg", height: 400, blur: 20, saturation: -80)
```

If you're using the `src` parameter, you can skip the path:

```ruby
url = LibPixel.url(src: "http://...", width: 300)
```

But even simpler, if the library sees a url beginning with http or https it knows what to do:

```ruby
url = LibPixel.url("http://...", width: 300)
```

You can specify whether you what an http or https url in your call:

```ruby
url = LibPixel.url("/us-east-1/images/1.jpg", height: 400, blur: 20, saturation: -80, https: true)
```

If you are using a default_source, you don't need to specify it in the path:

```ruby
url = LibPixel.url("1.jpg", height: 400, blur: 20, saturation: -80)
```

But you can override it with the source parameter:

```ruby
url = LibPixel.url("1.jpg", height: 400, blur: 20, saturation: -80, source: "us-west-1/source2")
```


### Multiple clients

It's also possible to have multiple instances of LibPixel clients (e.g. when dealing with multiple accounts):

```ruby
client = LibPixel::Client.new(host: "test.libpx.com", https: true, secret: "...")
```

You may then call the `#url` and `#sign` methods on the client object.

## Ruby on Rails

The LibPixel gem includes a Rails plugin that provides a view helper that you can use in place of normal calls to `image_tag`. The libpixel host and libpixel secret settings should be set in an initializer, or will be automatically picked up from the environment variables `LIBPIXEL_HOST` and `LIBPIXEL_SECRET`.

```ruby
libpixel_image_tag("eu-west-1/source/foo.jpg")
=> "<img src=\"http://example.libpx.com/eu-west-1/source/foo.jpg\" alt=\"Foo\" />"
```

You specify the libpixel processing parameters in a hash within the normal options hash, denoted by the key `:libpixel`.

```ruby
libpixel_image_tag("eu-west-1/source/foo.jpg", :libpixel => {:width => 300})
```

The normal parameters that Rails uses will also work.

```ruby
libpixel_image_tag("eu-west-1/source/foo.jpg", :libpixel => {:width => 300, :dpr => 2}, :size => "300x250")
```

If all your images are from the same source, it's helpful to configure a `default_source` in an initializer.

```ruby
LibPixel.default_source = "eu-west-1/source"
```

Then you can omit the source in your tags.

```ruby
libpixel_image_tag("foo.jpg", :libpixel => {:width => 300, :dpr => 2}, :size => "300x250")
```

If you need to override the default source, you can do that using the source parameter.

```ruby
libpixel_image_tag("foo.jpg", :libpixel => {:width => 300, :dpr => 2, :source => "eu-west-1/source2"}, :size => "300x250")
```

Referring to an image outside of your configured sources is also possible.

```ruby
libpixel_image_tag("http://example.com/images/foo.jpg", :libpixel => {:width => 300, :dpr => 2}, :size => "300x250")
```

You can configure your generated image src urls to use https or http in your initializer.

```ruby
LibPixel.https = true  # default is false
```

And you can specify it on a per-tag basis.

```ruby
libpixel_image_tag("us-east-1/source/foo.jpg", :libpixel => {:https => true})
=> "<img src=\"https://example.libpx.com/us-east-1/source/foo.jpg\" alt=\"Foo\" />"
```



## License

[MIT](LICENSE)
