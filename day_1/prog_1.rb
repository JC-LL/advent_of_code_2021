data=IO.readlines("input.txt").map(&:to_i)
puts "read #{data.size} data"
prev=nil
increases=0
data.each do |dat|
  if prev
    increases+=1 if dat > prev
  end
  prev=dat
end
puts "#increases = #{increases}"
