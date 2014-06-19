# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'word_scoop/version'

Gem::Specification.new do |spec|
  spec.name          = "word_scoop"
  spec.version       = WordScoop::VERSION
  spec.authors       = ["Tsukasa OISHI"]
  spec.email         = ["tsukasa.oishi@gmail.com"]
  spec.summary       = %q{WordScoop will pick up keywords that have been pre-registered from the text.}
  spec.description   = %q{WordScoop will pick up keywords that have been pre-registered from the text.}
  spec.homepage      = "https://github.com/tsukasaoishi/word_scoop"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "ext"]
  spec.extensions    = ["ext/word_scoop/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.0'
  spec.add_development_dependency "rspec", '~> 2.14'
  spec.add_development_dependency "rake-compiler", '~> 0.9'
end
