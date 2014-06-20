# coding: utf-8
require 'spec_helper'

describe WordScoop do
  before(:each) do
    keywords = %w|ninja 忍者|
    @tree = WordScoop.new(keywords)
  end

  context "#serch" do
    it "pickup keywords" do
      pickup = @tree.search("I am a ninja. 私は忍者です。Are you a ninja?")
      expect(pickup).to eq(%w|ninja 忍者 ninja|)
    end
  end

  context "#filter_html" do
    it "add link to keywords" do
      text = "I am a ninja. 私は忍者です。Are you a ninja?"
      html = @tree.filter_html(text)
      expect(html).to eq(
        text.gsub(/ninja|忍者/) do |keyword|
          "<a href='http://ja.wikipedia.org/wiki/#{keyword}'>#{keyword}</a>"
        end
      )
    end
  end
end
