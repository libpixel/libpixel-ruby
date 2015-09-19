require "libpixel/version"
require "libpixel/client"

module LibPixel

  @@default_client = Client.new

  def self.setup
    yield @@default_client
  end

  def self.host=(host)
    @@default_client.host = host
  end

  def self.secret=(secret)
    @@default_client.secret = secret
  end

  def self.https=(https)
    @@default_client.https = https
  end

  def self.default_source=(default_source)
    @@default_client.default_source = default_source
  end

  def self.sign(uri)
    @@default_client.sign(uri)
  end

  def self.url(path, options={})
    @@default_client.url(path, options)
  end

end

require 'libpixel/railtie' if defined?(Rails)
