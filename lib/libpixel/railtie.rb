require 'libpixel/view_helpers'

module LibPixel
  class Railtie < Rails::Railtie

    ActiveSupport.on_load(:action_view) do
      include LibPixel::ViewHelpers
    end
  end
end
