$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# rails must be loaded first so that LibPixel loads the view helper
require 'bundler/setup'
require 'rails'

require 'libpixel'

require 'minitest/autorun'
