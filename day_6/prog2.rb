# If coded naively, by enumerating the state space, the complexity grows exponentially
# reaching 256 iterations is then impossible !
# To succeed :  DO NOT enumerate the state space !
# Instead :
# 1) build a hash (x -> #x) with x in 0..8
# 2) compute the evolution of this hash

def update data_h
  next_h=(0..8).map{|v| [v,0]}.to_h
  data_h.each do |k,v|
    case k
    when 0
      next_h[6]=v
      next_h[8]=v
    else
      if k==7
        next_h[6]+=v
      else
        next_h[k-1]=v
      end
    end
  end
  next_h
end

filename=ARGV.first || "input.txt"
init_line=IO.readlines(filename).first
init_data=init_line.split(':').last.gsub(' ','')
init_data=init_data.split(',').map(&:to_i)

data_h=init_data.tally #!

256.times do |day_m1|
  day=day_m1+1
  data_h=update(data_h)
  puts "day #{day} size=#{data_h.values.sum}"
end
