require_relative "hash.rb"
require 'minitest/autorun'
 
class TestHash < MiniTest::Unit::TestCase

  describe 'Hashy' do
    before do
      @hash = Hashy.new
      @n = 1000
      @list = []

      # Inserts into hash a unique string of size n 
      def insert(i, n)
        begin
          string = rand(n).to_s(36)
        end while @hash.has_key? string
        @hash[string] = i
        @list[i] = string
      end

      # Deletes a random item from n items
      # This random item must exist in the table
      def delete(n, i=0)
        i = rand(n) while @list[i].nil?
        @hash.delete(@list[i])
        @list[i] = nil
      end
    end

    it 'adds unique items to hashy' do
      for i in 1..@n
        insert(i, @n)
      end
      for i in 1..@n
        assert_equal i, @hash[@list[i]], "Asserts key value pairs are matched correctly"
      end
      assert_equal @n, @hash.size, "Asserts size matches after insertions"
    end

    it 'adds and deletes unique items to hashy' do
      mid = @n / 2
      for i in 1..mid
        insert(i, @n)
      end

      inserted = deleted = 0
      for i in mid+1..@n
        if rand(2) == 1
          insert(i, @n)
          inserted += 1
        else
          delete(mid)
          deleted += 1
        end
      end

      for i in 1..@list.length
        key = @list[i]
        if key.nil?
          assert_nil @hash[key], "Asserts items are deleted"
        else
          assert_equal i, @hash[key], "Asserts inserted items remain"
        end
      end
      
      size = mid + inserted - deleted
      assert_equal size, @hash.size, "Assert size matches after deletions"
    end
  end
end
