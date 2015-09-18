# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libpixel/version'

Gem::Specification.new do |spec|
  spec.name          = "libpixel"
  spec.version       = LibPixel::VERSION
  spec.authors       = ["Joao Carlos", "Stephen Sykes"]
  spec.email         = ["joao@libpixel.com"]
  spec.summary       = %q{Ruby library and Rails plugin to generate and sign LibPixel URLs.}
  spec.homepage      = "https://github.com/libpixel/libpixel-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails", "~> 4.2.3"
end
