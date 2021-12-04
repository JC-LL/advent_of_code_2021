require_relative "../hit_a_key"

data=IO.readlines("../day_1/input.txt").map(&:to_i)
puts "read #{data.size} data"
prev=nil
increases=0

(0..data.size-1).each do |idx|
  #hit_a_key
  sum=data.first(3).sum
  data.shift
  if prev
    increases+=1 if sum > prev
  end
  prev=sum
end
puts "#increases = #{increases}"
