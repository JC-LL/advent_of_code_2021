def hit_a_key
  puts "hit a key"
  $stdin.gets
end

lines=IO.readlines("input.txt").map(&:chomp)
length=lines.first.length

p nb_ones=[0]*length
p nb_zeros=[0]*length

lines.each do |line|
  line.chars.each_with_index do |char,idx|
    case char
    when '0'
      nb_zeros[idx]+=1
    when '1'
      nb_ones[idx]+=1
    end
  end
end
pp nb_ones
pp nb_zeros

gamma_final_digits=[]
for i in 0..length-1
  if nb_ones[i]==nb_zeros[i]
    puts "idx #{i} : problem !"
  elsif nb_ones[i]>nb_zeros[i]
    gamma_final_digits << 1
  else
    gamma_final_digits << 0
  end
end
pp gamma_final_digits

p gamma_rate=gamma_final_digits.map(&:to_s).join.to_i(2)

epsilon_final_digits=[]
for i in 0..length-1
  if nb_ones[i]==nb_zeros[i]
    puts "idx #{i} : problem !"
  elsif nb_ones[i] < nb_zeros[i]
    epsilon_final_digits << 1
  else
    epsilon_final_digits << 0
  end
end
pp epsilon_final_digits
p epsilon_rate=epsilon_final_digits.map(&:to_s).join.to_i(2)

result=gamma_rate * epsilon_rate
puts "result = #{result}"

def most_common_bit_at idx,lines
  bits=lines.collect{|line| line.chars[idx]}
  ones=bits.count('1')
  zeros=bits.count('0')
  return '1' if ones==zeros
  ones > zeros ? '1' : '0'
end

puts "part two".center(40,'=')

puts "oxygen rate"

candidates=lines
for i in 0..length-1
  #puts i
  #hit_a_key
  mcb=most_common_bit_at(i,candidates)
  puts "mcb at #{i} : #{mcb}"
  candidates=candidates.select{|line| line.chars[i]==mcb}
  puts "remaining numbers : #{candidates.size}"
  if candidates.size==1
    puts "oxygen rate = #{oxy=candidates.first}"
    break
  end
end

def least_common_bit_at idx,lines
  bits=lines.collect{|line| line.chars[idx]}
  ones=bits.count('1')
  zeros=bits.count('0')
  return '0' if ones==zeros
  ones > zeros ? '0' : '1'
end

puts "CO2 rate"

candidates=lines
for i in 0..length-1
  #puts i
  #hit_a_key
  lcb=least_common_bit_at(i,candidates)
  puts "lcb at #{i} : #{lcb}"
  candidates=candidates.select{|line| line.chars[i]==lcb}
  puts "remaining numbers : #{candidates.size}"
  if candidates.size==1
    puts "CO2 rate = #{co2=candidates.first}"
    break
  end
end

result=oxy.to_i(2) * co2.to_i(2)
puts "result = #{result}"
