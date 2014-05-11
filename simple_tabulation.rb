require_relative 'hash.rb'

$T = Array.new

# I need 8 tables, each of size 8 bits. Each table entry points to a 64 bit word.
open('RandomNumbers', 'rb') do |file|
  for i in 0..7
    $T[i] = Array.new
    for j in 0..255
      $T[i] << file.read(8).unpack('Q')[0]
    end
  end
end

class Hashyst < Hashy
  # accepts a 64 bit integer x and returns its simple tabulation hash
  def key_index(key_hash)
    c = Array.new
    c << ((key_hash & 18374686479671623680) << -56) # 11111111(0)^56
    c << ((key_hash & 71776119061217280) << -48) # 11111111(0)^48
    c << ((key_hash & 280375465082880) << -40) # 11111111(0)^40
    c << ((key_hash & 1095216660480) << -32) # 11111111(0)^32
    c << ((key_hash & 4278190080) << -24) # 11111111(0)^24
    c << ((key_hash & 16711680) << -16) # 11111111(0)^16
    c << ((key_hash & 65280) << -8) # 11111111(0)^8
    c << (key_hash & 255) #11111111

    h = $T[0][c[0]]^$T[1][c[1]]^$T[2][c[2]]^$T[3][c[3]]^$T[4][c[4]]^$T[5][c[5]]^$T[6][c[6]]^$T[7][c[7]]
    h & @mask
  end
  private :key_index
end
