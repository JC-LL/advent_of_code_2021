require_relative "../hit_a_key"

def parse filename
  lines=IO.readlines(filename).map(&:chomp)
  @template=lines.shift
  puts "template : #{@template}"
  lines.shift
  @rules=lines.map{|l| l.split(" -> ")}.to_h
end

def step
  str=@template.clone
  result=(chars=@template.chars)[0..-2].each_with_index.map do |char,idx|
    paire=[char,chars[idx+1]].join
    letter=@rules[paire]
    paire.insert(1,letter)+"-"
  end
  @template=result.join.gsub(/-.?/,'')
end

def evaluate
  min,max=@template.chars.tally.values.minmax
  max-min
end

parse ARGV.first
10.times{step}
puts evaluate
