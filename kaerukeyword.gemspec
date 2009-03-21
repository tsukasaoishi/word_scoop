# -*- encoding: utf-8 -*-


Gem::Specification.new do |s|
  s.name = %q{kaerukeyword}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FIXME full name"]
  s.date = %q{2009-03-07}
  s.description = %q{KaeruKeyword は登録されたキーワードが文中に存在 するかどうかを調べることができます。   インスタンスの作成時にキーワードを登録できます。  keywords = KaeruKeyword.new(["Ruby", "Rails"])   あとからキーワードを追加することもできます。  keywords << "Tsukasa"   searchメソッドで文中からキーワードを探し出します。 キーワードが見つかったときは、そのキーワードを 含めた配列を返します。  keywords.search("I Love Ruby") #=> ["Ruby"]}
  s.email = ["FIXME email"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/kaerukeyword.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{kaerukeyword}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{KaeruKeyword は登録されたキーワードが文中に存在 するかどうかを調べることができます。   インスタンスの作成時にキーワードを登録できます。  keywords = KaeruKeyword.new(["Ruby", "Rails"])   あとからキーワードを追加することもできます。  keywords << "Tsukasa"   searchメソッドで文中からキーワードを探し出します。 キーワードが見つかったときは、そのキーワードを 含めた配列を返します。  keywords.search("I Love Ruby") #=> ["Ruby"]}

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
