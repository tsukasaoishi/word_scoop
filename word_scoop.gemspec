# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{word_scoop}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tsukasa OISHI"]
  s.date = %q{2009-11-21}
  s.description = %q{WordScoop is a library that searching keyword in text.}
  s.email = ["tsukasa.oishi@gmail.com"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/word_scoop.rb", "ext/extconf.rb", "ext/word_scoop.c", "ext/word_scoop.h"]
  s.has_rdoc = false
  s.homepage = %q{http://www.kaeruspoon.net/}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{word_scoop}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{WordScoop is a library that searching keyword in text.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
