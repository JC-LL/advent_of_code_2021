horiz,depth,aim=0,0,0

IO.readlines("input.txt").each do |cmd|
  case cmd
  when /forward (\d+)/
    x=$1.to_i
    horiz+=x
    depth+=aim*x
  when /down (\d+)/
    aim+=$1.to_i
  when /up (\d+)/
    aim-=$1.to_i
  else
    raise "unknown command"
  end
end

puts "solution = #{horiz*depth}"
