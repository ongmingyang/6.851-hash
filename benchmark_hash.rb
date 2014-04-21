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

n = 10000
Benchmark.bm do |x|
  $old_hash = Hash.new
  $new_hash = Hashy.new

  puts ">> Inserting #{n} elements into Hash and Hashy"
  x.report { $old_keys = put_into_hash($old_hash, n) }
  x.report { $new_keys = put_into_hash($new_hash, n) }

  puts ">> Accessing #{n} elements in Hash and Hashy"
  x.report { lookup_hash($old_hash, $old_keys) }
  x.report { lookup_hash($new_hash, $new_keys) }

  puts ">> Deleting #{n/2} elements from Hash and Hashy"
  x.report { delete_from_hash($old_hash, n/2, $old_keys) }
  x.report { delete_from_hash($new_hash, n/2, $new_keys) }
end
