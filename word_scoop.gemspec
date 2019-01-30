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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]
  spec.extensions    = ["ext/word_scoop/extconf.rb"]

  spec.add_development_dependency "bundler", ">= 1.3.0", "< 2.0"
  spec.add_development_dependency "rake", ">= 0.8.7"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake-compiler", '~> 0.9'
end
