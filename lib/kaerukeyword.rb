$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

#
#         KaeruKeyword
#
#
# KaeruKeyword は登録されたキーワードが文中に存在
# するかどうかを調べることができます。
#
#
# インスタンスの作成時にキーワードを登録できます。
#
# keywords = KaeruKeyword.new(["Ruby", "Rails"])
#
#
# あとからキーワードを追加することもできます。
#
# keywords << "Tsukasa"
#
#
# searchメソッドで文中からキーワードを探し出します。
# キーワードが見つかったときは、そのキーワードを
# 含めた配列を返します。
#
# keywords.search("I Love Ruby") #=> ["Ruby"]
#
#
#
# Copyright 2008 (c) Tsukasa OISHI, under MIT License.
#
# おおいしつかさ
# http://www.kaeruspoon.net
#
#
class Kaerukeyword
  VERSION = '1.0.1'

  def initialize(key_array = nil)
    @tree = {}
    key_array.each {|k| add(k)} if key_array.is_a?(Array)
  end

  def add(key)
    now = @tree
    key.split(//).each do |c|
      now[c] = {} unless now.has_key? c
      now = now[c]
    end
    now[:end] = key
  end
  alias :<< :add

  def search(text)
    list = []
    word = ""
    now = @tree
    text.split(//).each do |c|
      unless now.has_key? c
        unless word.empty?
          list << word
          word = ""
        end
        now = @tree
      end

      if now.has_key? c
        now = now[c]
        word = now[:end] if now[:end]
      end
    end

    unless word.empty?
      list << word
    end

    list
  end
end
