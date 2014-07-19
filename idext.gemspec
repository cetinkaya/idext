# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idext/version'

Gem::Specification.new do |spec|
  spec.name          = "idext"
  spec.version       = Idext::VERSION
  spec.authors       = ["Ahmet Cetinkaya"]
  spec.email         = ["cetinkayaahmet@yahoo.com"]
  spec.summary       = %q{A simple tool to extract data from images.}
  spec.description   = %q{Idext is a simple tool to extract tabular data from images.}
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rmagick"
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
