require 'libpixel/view_helpers'

module LibPixel
  class Railtie < Rails::Railtie
    
    ActiveSupport.on_load(:action_view) do
      LibPixel.setup do |config|
        config.host = ENV['LIBPIXEL_HOST']
        config.secret = ENV['LIBPIXEL_SECRET']
      end

      include LibPixel::ViewHelpers
    end
  end
end
