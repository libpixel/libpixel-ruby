module LibPixel
  module ViewHelpers
    #
    # libpixel_image_tag("http://example.com/image.jpg", :width=>200, :libpixel=>{:width=>200, :dpr=>2, :source=>"images"})
    # => <img width="200" alt="image" src="http://example.libpx.com/images/?width=200&dpr=2&src=http%3A%2F%2Fexample.com%2Fimage.jpg" />
    # 
    # LibPixel.default_source = "source"
    # libpixel_image_tag("image.jpg", :libpixel=>{:width=>200})
    # => <img alt="image" src="http://example.libpx.com/source/image.jpg?width=200" />
    #
    def libpixel_image_tag(source, options = {})
      image_tag_options = nil
      
      if source.respond_to? :fetch
        libpixel_url = LibPixel.url(source[:libpixel])
        image_tag_options = source.reject {|k| k == :libpixel}
      else
        source = URI::escape(source)
        libpixel_url = LibPixel.url(source, options.fetch(:libpixel) {{}})
        image_tag_options = options.reject {|k| k == :libpixel}
      end

      uri = URI(libpixel_url)
      if uri.query
        query_items = CGI.parse(uri.query)
        src = query_items["src"].first
        if src
          image_tag_options[:alt] = image_tag_options.fetch(:alt) {image_alt(src)}
        end
      end

      image_tag(libpixel_url.html_safe, image_tag_options)
    end
  end
end
