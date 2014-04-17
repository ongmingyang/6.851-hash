require_relative "hash.rb"
require 'benchmark'

def run_hash(hash, n)
  for i in 1..n
    hash[rand(n).to_s(36)] = i
  end
end

n = 10000
Benchmark.bm do |x|
  x.report { run_hash(Hash.new, n) }
  x.report { run_hash(Hashy.new, n) }
end
