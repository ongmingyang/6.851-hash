require_relative "hash.rb"
require 'minitest/autorun'
 
class TestHash < MiniTest::Unit::TestCase
 
  describe 'Hashy' do
    before do
      @old_hash = Hash.new
      @new_hash = Hashy.new
      @n = 10000
    end

    it 'adds 1000 items to hash' do
      for i in 1..@n
        string = rand(@n).to_s(36)
        @old_hash[string] = i
        assert_equal @old_hash[string], i
      end
    end

    it 'adds #1000 items to hashy' do
      for i in 1..@n
        string = rand(@n).to_s(36)
        @new_hash[string] = i
        assert_equal @new_hash[string], i
      end
    end
  end
end
