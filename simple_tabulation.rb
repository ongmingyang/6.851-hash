T1 = Array.new
T2 = Array.new
T3 = Array.new
T4 = Array.new
T5 = Array.new
T6 = Array.new
T7 = Array.new
T8 = Array.new

# I need 8 tables, each of size 8 bits. Each table entry points to a 64 bit word.
open('RandomNumbers', 'rb') do |file|
  for array in [T1, T2, T3, T4, T5, T6, T7, T8]
    for i in 1..256
      array << file.read(8).unpack('Q')[0]
    end
  end
end

print T1
print T2
print T3
print T4
print T5
print T6
print T7
print T8
