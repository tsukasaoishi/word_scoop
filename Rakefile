require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"

# compile
gemspec = eval(File.read(File.expand_path('../word_scoop.gemspec', __FILE__)))
Rake::ExtensionTask.new("word_scoop", gemspec) do |ext|
  ext.lib_dir = "lib/word_scoop"
end

# spec
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
Rake::Task[:spec].prerequisites << :compile

# benchmark
task :benchmark do
  require File.expand_path("../benchmark/measure", __FILE__)
  WordScoopBenchmark.new.run
end
Rake::Task[:benchmark].prerequisites << :compile
