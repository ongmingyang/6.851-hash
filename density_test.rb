require_relative "hash.rb"

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

def write_output(filename, h)
  f = File.open filename, "w"

  max_length = 0
  current_max_length = 0
  c_n = 0
  average_length = Float 0

  h.entries.each do |slot|
    if slot.nil?
      f.syswrite "0"
      if current_max_length >= max_length
        max_length = current_max_length
      end
      average_length = ( average_length * c_n + current_max_length ) / ( c_n + 1 )
      current_max_length = 0
      c_n += 1
    else
      f.syswrite "1"
      current_max_length += 1
    end
  end

  if current_max_length >= max_length
    max_length = current_max_length
  end

  f.syswrite "\n"
  f.syswrite max_length
  f.syswrite "\n"
  f.syswrite average_length
  f.syswrite "\n"
  
end

hash = Hashy.new
hash2 = Hashy.new
n = 10000

put_into_hash hash, n
write_output "output_unordered.txt", hash

put_in_order hash2, n
write_output "output_ordered.txt", hash2
