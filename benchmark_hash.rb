require_relative "hash.rb"
require 'benchmark'

# inserts n unique keys into hash
def put_into_hash(hash, n)
  a = []
  for i in 1..n
    key = rand(n).to_s(36)
    hash[key] = i
    a << key
  end
  return a
end

def lookup_hash(hash, keys)
  for key in keys
    a = hash[key]
  end   
end

# Deletes n random keys from hash
def delete_from_hash(hash, n, keys)
  for i in 1..n 
    hash.delete(keys[rand(n)])
  end   
end

def put_in_order(hash, n)
  for i in 1..n
    hash[i] = i
  end
end

n = 10000
# The times for some benchmarks depend on the order in which items are run. 
# These differences are due to the cost of memory allocation and garbage collection. 
# To avoid these discrepancies, the bmbm method is provided. 
Benchmark.bmbm do |x|
  $new_hash = Hashy.new
  $old_hash = Hash.new
  $new_keys = put_into_hash($new_hash, n)
  $old_keys = put_into_hash($old_hash, n)
  # Hash now has 10000 objects

  puts ">> Inserting #{n} elements into Hashy and Hash"
  x.report("new") { put_into_hash($new_hash, n) }
  x.report("old") { put_into_hash($old_hash, n) }

  # Hash now has 20000 objects

  puts ">> Accessing #{n} elements in Hashy and Hash"
  x.report("new") { lookup_hash($new_hash, $new_keys) }
  x.report("old") { lookup_hash($old_hash, $old_keys) }

  puts ">> Deleting #{n} random elements from Hashy and Hash"
  x.report("new") { delete_from_hash($new_hash, n, $new_keys) }
  x.report("old") { delete_from_hash($old_hash, n, $old_keys) }

  # Hash now has >10000 objects

  puts ">> Deleting and inserting random elements from Hashy and Hash"
  x.report("new") { delete_from_hash($new_hash, n, $new_keys); put_into_hash($new_hash, n) }
  x.report("old") { delete_from_hash($old_hash, n, $old_keys); put_into_hash($old_hash, n) }

  puts ">> Inserting #{n} elements in order into empty Hashy and Hash"
  x.report("new") { put_in_order(Hashy.new, n) }
  x.report("old") { put_in_order(Hash.new, n) }
end
