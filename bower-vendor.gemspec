# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bower-vendor/version'

Gem::Specification.new do |gem|
  gem.name          = "bower-vendor"
  gem.version       = BowerVendor::VERSION
  gem.authors       = ["Peter Fern"]
  gem.email         = ["ruby@obfusc8.org"]
  gem.description   = %q{Vendor the bower assets you want for Ruby on Rails}
  gem.summary       = %q{Vendor the bower assets you want for Ruby on Rails}
  gem.homepage      = "http://github.com/pdf/bower-vendor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9.2'

  gem.add_dependency('ruby-bower', '~> 0.0.1')
  gem.add_dependency('rails', '>= 3.1.0')
end
