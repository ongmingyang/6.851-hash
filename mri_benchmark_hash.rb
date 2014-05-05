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

n = 1000000
# The times for some benchmarks depend on the order in which items are run. 
# These differences are due to the cost of memory allocation and garbage collection. 
# To avoid these discrepancies, the bmbm method is provided. 
Benchmark.bmbm do |x|
  $mri_hash = Hash.new
  $mri_keys = put_into_hash($mri_hash, n)
  # Hash now has 10000 objects

  puts ">> Inserting #{n} elements into MRI Hash"
  x.report("mri") { put_into_hash($mri_hash, n) }

  # Hash now has 20000 objects

  puts ">> Accessing #{n} elements in MRI Hash"
  x.report("mri") { lookup_hash($mri_hash, $mri_keys) }

  puts ">> Deleting #{n} random elements from MRI Hash"
  x.report("mri") { delete_from_hash($mri_hash, n, $mri_keys) }

  # Hash now has >10000 objects

  puts ">> Deleting and inserting random elements from MRI Hash"
  x.report("mri") { delete_from_hash($mri_hash, n, $mri_keys); put_into_hash($mri_hash, n) }

  puts ">> Inserting #{n} elements in order into empty MRI Hash"
  x.report("mri") { put_in_order(Hash.new, n) }
end
