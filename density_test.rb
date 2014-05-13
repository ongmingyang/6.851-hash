require_relative "simple_tabulation.rb"

$avg_probes = Float 0
$p_n = 0

class Hashyp < Hashy
  def find_item(key)
    key_hash = key.hash
    index = key_index key_hash
    item = @entries[index]

    current_max_length = 0
    while item
      current_max_length += 1
      if !item.deleted and @state.match? item.key, item.key_hash, key, key_hash
        $avg_probes = ( $avg_probes * $p_n + current_max_length ) / ( $p_n + 1 )
        current_max_length = 0
        $p_n += 1
        return item
      end

      index = (1 + index) % @capacity
      item = @entries[index]
    end
  end
end

class Hashystp < Hashyst
  def find_item(key)
    key_hash = key.hash
    index = key_index key_hash
    item = @entries[index]

    current_max_length = 0
    while item
      current_max_length += 1
      if !item.deleted and @state.match? item.key, item.key_hash, key, key_hash
        $avg_probes = ( $avg_probes * $p_n + current_max_length ) / ( $p_n + 1 )
        current_max_length = 0
        $p_n += 1
        return item
      end

      index = (1 + index) % @capacity
      item = @entries[index]
    end
  end
end

def put_into_hash(hash, n)
  for i in 1..n
    begin
      string = rand(n).to_s(36)
    end while hash.has_key? string
    hash[string] = i
  end
end

def put_in_order(hash, n)
  for i in 1..n
    hash[i] = i
  end
end

def access(hash)
  $avg_probes = Float 0
  $p_n = 0
  for i in hash.keys
    hash[i]
  end
  return $avg_probes
end

def write_output(filename, h)
  f = File.open filename, "w"

  max_length = 0
  current_max_length = 0
  c_n = 0 # number of chains
  average_length = Float 0

  h.entries.each do |slot|
    if slot.nil?
      f.syswrite "0"
      unless current_max_length == 0
        if current_max_length >= max_length
          max_length = current_max_length
        end
        average_length = ( average_length * c_n + current_max_length ) / ( c_n + 1 )
        current_max_length = 0
        c_n += 1
      end
    else
      f.syswrite "1"
      current_max_length += 1
    end
  end

  if current_max_length >= max_length
    max_length = current_max_length
  end

  print "Max length: ", max_length, "\nAverage length: ", average_length, "\n"

  #f.syswrite "\nMax length    : "
  #f.syswrite max_length
  #f.syswrite "\nAverage length: "
  #f.syswrite average_length
  #f.syswrite "\n"
  
end

hash = Hashyp.new
hashyst = Hashystp.new
hash2 = Hashyp.new
hashyst2 = Hashystp.new
n = 49152 #98305 #196610
n = n+1 # offset for zero index

print "\nTesting Hashy (ordered):\n"
put_in_order hash, n
write_output "output_ordered.txt", hash
print "Average Probes: ", access(hash), "\n"

print "\nTesting Hashy (unordered):\n"
put_into_hash hash2, n
write_output "output_unordered.txt", hash2
print "Average Probes: ", access(hash2), "\n"

print "\nTesting Hashy (ordered) with simple tabulation hashing:\n"
put_in_order hashyst, n
write_output "output_ordered.txt", hashyst
print "Average Probes: ", access(hashyst), "\n"

print "\nTesting Hashy (unordered) with simple tabulation hashing:\n"
put_into_hash hashyst2, n
write_output "output_unordered.txt", hashyst2
print "Average Probes: ", access(hashyst2), "\n"
