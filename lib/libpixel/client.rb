require "openssl"
require "uri"

module LibPixel
  class Client
    attr_accessor :host, :secret, :https

    def initialize(options={})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def sign(uri)
      uri = URI.parse(uri) unless uri.kind_of?(URI::Generic)

      query = uri.query
      data = uri.path
      data += "?#{query}" if query && query != ""

      digest = OpenSSL::Digest.new("sha1")
      signature = OpenSSL::HMAC.hexdigest(digest, secret, data)

      query += "&" if query && query != ""
      query = "#{query}signature=#{signature}"
      uri.query = query

      uri.to_s
    end

    def url(path, options={})
      path = "/" if path.nil? || path.empty?
      query = options.map { |k,v| "#{k}=#{URI.encode_www_form_component(v)}" }.join("&")

      if query == ""
        query = nil
      end

      uri = URI::Generic.new(
        (https ? "https" : "http"), nil, host, nil, nil, path, nil, query, nil
      )

      if secret
        sign(uri)
      else
        uri.to_s
      end
    end
  end
end
