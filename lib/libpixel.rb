require "libpixel/version"
require "libpixel/client"

module LibPixel

  @@default_client = Client.new

  def self.setup
    yield @@default_client
  end

  def self.sign(uri)
    @@default_client.sign(uri)
  end

  def self.url(path, options={})
    @@default_client.url(path, options)
  end

end
