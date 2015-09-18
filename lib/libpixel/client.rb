require "openssl"
require "uri"

module LibPixel
  class Client
    attr_accessor :host, :secret, :https, :default_source

    def initialize(options={})
      options.each do |key, value|
        send("#{key}=", value)
      end

      self.host   ||= ENV["LIBPIXEL_HOST"]
      self.secret ||= ENV["LIBPIXEL_SECRET"]
    end

    def sign(uri)
      if secret.nil?
        raise "Your LibPixel secret must be defined (e.g. LibPixel.secret = 'SECRET')"
      end

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

    def url(path_or_options, options={})
      path = nil
      
      if host.nil?
        raise "Your LibPixel host name must be defined (e.g. LibPixel.host = 'example.libpx.com')"
      end

      if path_or_options.respond_to? :fetch
        options = path_or_options
      elsif !path_or_options.nil?
        uri = URI(path_or_options)
        if uri.scheme == "http" || uri.scheme == "https"
          options[:src] = path_or_options
        else
          path = path_or_options
        end
      end

      source = options.fetch(:source) {default_source}
      options = options.reject {|k| k == :source}

      query = options.map { |k,v| "#{k}=#{URI.encode_www_form_component(v)}" }.join("&")

      if query == ""
        query = nil
      end
      
      if !source.nil? && !source.empty?
        source_clean = source.gsub(/^\//, "").gsub(/\/$/, "")
        path_clean = (path || "").gsub(/^\//, "")
        path = "/#{source_clean}/#{path_clean}"
      else
        if path.nil? || path !~ /^\//
          path = "/#{path}"
        end
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
