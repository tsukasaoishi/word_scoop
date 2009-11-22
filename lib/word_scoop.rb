$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'word_scoop.so'
class WordScoop
  VERSION = '2.0.0'

  attr_accessor :link_url
end

