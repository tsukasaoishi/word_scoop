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
require 'forwardable'

class Kaerukeyword
  extend Forwardable

  VERSION = '1.0.2'

  # 委譲するメソッド
  def_delegators :@logic, :add, :search, :match

  #
  # コンストラクタ
  # 第2引数でデータ構造を選択できる
  #
  def initialize(key_array = nil, logic = :hash_tree)
    @logic =
      case logic
      when :hash_tree
        HashTree.new(key_array)
      when :double_array
        raise NotSupportError, "double array will support, but doesn't yet"
        DoubleArray.new(key_array)
      else
        raise LogicError, "you have to select logic"
      end
  end

  #
  # ハッシュ木からダブル配列への変換
  #
  def double_array!
    raise NotSupportError, "double array will support, but doesn't yet"
    raise LogicError, "already double array" if @logic.is_a?(DoubleArray)
    old_logic = @logic
    hash_tree = old_logic.tree

    @logic = DoubleArray.new
    @logic.construct_array(hash_tree, 0)

    old_logic = nil
    hash_tree = nil
    GC.start
    true
  end

  alias :<< :add
  
  #
  # ダブル配列
  #
  class DoubleArray
    def initialize(key_array = nil)
      hash_tree = HashTree.new(key_array)
      @base = [1]
      @check = [0]
      @code = {"end" => 1}
      construct_array(hash_tree.tree, 0) if key_array.is_a?(Array)
      hash_tree = nil
      GC.start
    end

    #
    # 未サポート
    #
    def add(key)
      raise NotSupportError, "you don't add keyword after initilize."
    end

    #
    # 検索
    #
    def search(text)
      list = []
      word = ""
      buffer = ""
      now_x = 0

      text.scan(/./).each do |c|
        code = @code[c]
        base = @base[now_x]
        if code && @base[base + code] && @check[base + code] == now_x
          now_x = base + code
          buffer << c
          if @base[@base[now_x] + @code["end"]].to_i < 0 && @check[@base[now_x] + @code["end"]] == now_x
            word = buffer.dup
          end
        else
          list << word unless word.empty?
          word = ""
          buffer = ""
          now_x = 0
        end
      end

      list << word unless word.empty?
      list
    end

    #
    # ハッシュ木からBC配列を構築
    #
    def construct_array(hash_tree, now_x)
      x_hash = {}
      chars = hash_tree.keys.sort_by{|k| k.to_s}
      code_set(chars)
      @base[now_x] = base = get_base(chars, now_x)

      chars.each do |c|
        @check[base + @code[c]] = now_x
        if c == "end"
          @base[base + @code[c]] = -base
        else
          @base[base + @code[c]] = base
          x_hash[c] = base + @code[c]
        end
      end

      x_hash.each {|c, x| construct_array(hash_tree[c], x)}
    end

    private

    #
    # コード配列の定義
    #
    def code_set(chars)
      chars.each {|c| @code[c] = @code.size + 1 unless @code.has_key?(c)}
    end

    #
    # 節のbase値の決定
    #
    def get_base(chars, now_x)
      base = @base[now_x]
      chars.each do |c|
        if @check[base + @code[c]] && @check[base + @code[c]] != now_x
          base += 1
          retry
        end
      end
      base
    end
  end

  class HashTree
    END_TAG = "en"

    attr_accessor :tree

    def initialize(key_array = [])
      @nodes = {}
      make_tree(key_array)
    end

    def make_tree(key_array)
      key_array.each{|key| add(key)}
    end

    #
    # キーワードの追加
    #
    def add(key)
      cur = @nodes
      key.scan(/./).each do |c|
        cur[c] ||= {}
        cur = cur[c]
      end
      cur[END_TAG] = true
    end

    def search(text)
      list = []
      word = ""
      buffer = ""
      cur = @nodes
      i = 0
      hit_i = nil
      str = text.scan(/./)

      loop do
        break unless c = str[i]

        unless cur.has_key?(c)
          if word.empty?
            i = (hit_i || i) + 1
          else
            list << word
            i = hit_i + word.scan(/./).size
            word = ""
          end
          hit_i = nil
          buffer = ""
          cur = @nodes
        end

        if cur.has_key?(c)
          cur = cur[c]
          buffer << c
          word = buffer.dup if cur.has_key?(END_TAG)
          hit_i = i unless hit_i
        end
        i += 1
      end

      list << word unless word.empty?
      list
    end
  end

  class LogicError < StandardError; end
  class NotSupportError < StandardError; end
end
