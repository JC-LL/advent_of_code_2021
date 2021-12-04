
def hit_a_key
  puts "-- hit a key --"
  $stdin.gets
end

horiz,depth,aim=0,0,0

IO.readlines("input.txt").each do |cmd|
  puts cmd
  case cmd
  when /forward (\d+)/
    x=$1.to_i
    horiz+=x
    depth+=aim*x
  when /down (\d+)/
    #depth+=$1.to_i
    aim+=$1.to_i
  when /up (\d+)/
    #depth-=$1.to_i
    aim-=$1.to_i
  else
    raise "unknown command"
  end
  puts "horiz=#{horiz}"
  puts "depth=#{depth}"
  #hit_a_key
end

puts "solution = #{horiz*depth}"
