require_relative "../hit_a_key"

Entry=Struct.new(:pattern,:digits)

def parse lines
  lines.collect do |line|
    pattern,digits=line.split("|")
    pattern=pattern.split(' ')
    digits=digits.split(' ')
    Entry.new(pattern,digits)
  end
end

filename=ARGV.first || "input.txt"
lines=IO.readlines(filename)

pp entries=parse(lines)

count=0
entries.each do |entry|
  entry.digits.each do |digit|
    case digit.size
    when 2,3,4,7
      count+=1
    end
  end
end

puts "count = #{count}"
