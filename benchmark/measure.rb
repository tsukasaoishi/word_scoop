# coding: utf-8
require 'benchmark'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'word_scoop'

class WordScoopBenchmark
  def initialize
    keywords = []
    File.open(File.expand_path("../keywords.txt", __FILE__), "r") do |f|
      f.each do |line|
        keywords << line.strip
      end
    end

    @keywords = keywords.uniq
    @article = File.read(File.expand_path("../article.txt", __FILE__))

    puts "keywords size\t#{@keywords.size}"
    puts "article size\t#{@article.size}\n\n"
  end

  def run
    keywords_size = @keywords.size

    Benchmark.bm(7, "avg") do |x|
      tree = nil
      regist_ms = x.report("register") { tree = WordScoop.new(@keywords) }
      searcg_ms = x.report("search") { 1000.times{ tree.search(@article) }}

      regist_avg = regist_ms.real * 1000 * 1000 / keywords_size
      puts "1 word regist avg\t#{"%.03f" % regist_avg} µs"
      puts "search avg\t\t#{"%.03f" % searcg_ms.real} ms"
    end
  end
end

WordScoopBenchmark.new.run if File.basename($PROGRAM_NAME) == File.basename(__FILE__)
