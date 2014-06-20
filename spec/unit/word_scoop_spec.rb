# coding: utf-8
require 'spec_helper'

describe WordScoop do
  context "#serch" do
    before(:each) do
      keywords = %w|ninja 忍者|
      @tree = WordScoop.new(keywords)
    end

    it "pickup keywords" do
      pickup = @tree.search("I am a ninja. 私は忍者です。Are you a ninja?")
      expect(pickup).to eq(%w|ninja 忍者 ninja|)
    end
  end
end
