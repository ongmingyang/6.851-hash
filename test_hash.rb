require_relative "hash.rb"
require 'minitest/autorun'
 
class TestHash < MiniTest::Unit::TestCase
 
  describe 'Hashy' do
    before do
      @old_hash = Hash.new
      @new_hash = Hashy.new
      @n = 1000
      @list = []
    end

    it 'adds 1000 unique items to hash' do
      for i in 1..@n
        string = rand(@n).to_s(36) until !@old_hash.has_key? string
        @old_hash[string] = i
        @list[i] = string
      end
      for i in 1..@n
        assert_equal @old_hash[@list[i]], i
      end
    end

    it 'adds 1000 unique items to hashy' do
      for i in 1..@n
        string = rand(@n).to_s(36) until !@new_hash.has_key? string
        @new_hash[string] = i
        @list[i] = string
      end
      for i in 1..@n
        assert_equal @new_hash[@list[i]], i
      end
    end
  end
end
