require "minitest_helper"

describe LibPixel::Client do

  before do
    ENV.delete("LIBPIXEL_HOST")
    ENV.delete("LIBPIXEL_SECRET")

    @client = LibPixel::Client.new({
      host: "test.libpx.com", https: false, secret: "LibPixel"
    })
  end

  describe ".new" do
    it "uses the LIBPIXEL_HOST env var as a default host" do
      ENV["LIBPIXEL_HOST"] = "env"
      client = LibPixel::Client.new
      assert_equal "env", client.host
    end

    it "uses the LIBPIXEL_SECRET env var as a default secret" do
      ENV["LIBPIXEL_SECRET"] = "secret-env"
      client = LibPixel::Client.new
      assert_equal "secret-env", client.secret
    end

    it "prefers the host option to the LIBPIXEL_HOST env var" do
      ENV["LIBPIXEL_HOST"] = "env"
      client = LibPixel::Client.new(host: "my-host")
      assert_equal "my-host", client.host
    end

    it "prefers the secret option to the LIBPIXEL_SECRET env var" do
      ENV["LIBPIXEL_SECRET"] = "secret-env"
      client = LibPixel::Client.new(secret: "top-secret")
      assert_equal "top-secret", client.secret
    end
  end

  describe "#sign" do
    it "adds the query string with the signature" do
      url = "http://test.libpx.com/images/1.jpg"
      signature = "bd5634c055d707c1638eff93eb88ff31277958f0"
      assert_equal "#{url}?signature=#{signature}", @client.sign(url)
    end

    it "appends the signature to an existing query string" do
      url = "http://test.libpx.com/images/2.jpg?width=400"
      signature = "baa12c05ed279dbc623ffc8b74b183f6044e5998"
      assert_equal "#{url}&signature=#{signature}", @client.sign(url)
    end

    it "ignores the '?' separator if there's no query string" do
      url = "http://test.libpx.com/images/1.jpg"
      assert_equal @client.sign(url), @client.sign("#{url}?")
    end

    it "supports URLs with a query string and a fragment" do
      assert_equal "http://test.libpx.com/images/3.jpg?width=300&height=220&signature=500ad73bdf2d9e77d6bb94f0ca1c72f9c1f495f8#image",
        @client.sign("http://test.libpx.com/images/3.jpg?width=300&height=220#image")
    end

    it "supports URLs with a fragment but no query string" do
      assert_equal "http://test.libpx.com/images/1.jpg?signature=bd5634c055d707c1638eff93eb88ff31277958f0#test",
        @client.sign("http://test.libpx.com/images/1.jpg#test")
    end

    it "requires the secret to be set" do
      @client.secret = nil
      assert_raises do
        @client.sign("http://test.libpx.com/images/1.jpg")
      end
    end
  end

  describe "#url" do
    it "constructs a URL for a given path" do
      client = LibPixel::Client.new(host: "test.libpx.com")
      url = "http://test.libpx.com/images/5.jpg"
      assert_equal url, client.url("/images/5.jpg")
    end

    it "turns options into a query string" do
      client = LibPixel::Client.new(host: "test.libpx.com")
      url = "http://test.libpx.com/images/101.jpg?width=200&height=400"
      assert_equal url, client.url("/images/101.jpg", width: 200, height: 400)
    end

    it "uses HTTPS if the https option is set to true" do
      client = LibPixel::Client.new(host: "test.libpx.com", https: true)
      url = "https://test.libpx.com/images/1.jpg"
      assert_equal url, client.url("/images/1.jpg")
    end

    it "signs the request if a secret is given" do
      client = LibPixel::Client.new(host: "test.libpx.com", secret: "LibPixel")
      url = "http://test.libpx.com/images/1.jpg?width=600&signature=dfcaec7b88d53a7a932e8a6a00d10b4f9ff1336b"
      assert_equal url, client.url("/images/1.jpg", width: 600)
    end

    it "sets the path to '/' if nil or empty" do
      client = LibPixel::Client.new(host: "test.libpx.com")
      url = "http://test.libpx.com/?src=url"
      assert_equal url, client.url("", src: "url")
      assert_equal url, client.url(nil, src: "url")
    end

    it "sets the path to '/' if the path is omitted" do
      client = LibPixel::Client.new(host: "test.libpx.com")
      url = "http://test.libpx.com/?src=url"
      assert_equal url, client.url(src: "url")
    end

    it "requires the host to be set" do
      @client.host = nil
      assert_raises do
        @client.url("images/1.jpg")
      end
    end
  end

end
