require_relative "hash.rb"
require 'benchmark'

# inserts n unique keys into hash
def put_into_hash(hash, n)
  a = []
  for i in 1..n
    key = rand(n).to_s(36) until !hash.has_key? key
    hash[key] = i
    a[i] = key
  end

  for i in 1..n
    raise StandardError unless hash[a[i]] == i
  end
end

n = 10000
Benchmark.bm do |x|
  puts ">> Inserting #{n} elements into Hash and Hashy"
  x.report { put_into_hash(Hash.new, n) }
  x.report { put_into_hash(Hashy.new, n) }
end
