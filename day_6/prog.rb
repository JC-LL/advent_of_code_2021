require_relative "../hit_a_key"

class Counter
  def initialize val
    @val=val
  end

  def decrement
    @val-=1
  end

  def reset
    @val=6
  end

  def update
    case @val
    when 0
      reset
      return Counter.new(8)
    else
      decrement
      return nil
    end
  end

  def inspect
    @val
  end
end

def cycle counters
  next_counters=counters.clone
  counters.each do |counter|
    new_counter=counter.update
    next_counters << new_counter if new_counter
  end
  next_counters
end

filename=ARGV.first || "input.txt"
init_line=IO.readlines(filename).first
init_data=init_line.split(':').last.gsub(' ','')
init_data=init_data.split(',').map(&:to_i)

counters=init_data.map{|val| Counter.new(val)}

puts "initial state : #{counters.map(&:inspect).join(',')}"
18.times do |day|
  counters=cycle(counters)
  #puts "After #{day+1} days : #{counters.map(&:inspect).join(',')}"
  puts "After #{day+1} days : #{counters.size} fishes"
end
