# If coded naively, by enumerating the state space, the complexity grows exponentially.
# Reaching 256 iterations is then impossible !
# To succeed :  DO NOT enumerate the state space !
# Instead :
# 1) build a hash (x -> #x) with x in 0..8
# 2) compute the evolution of this hash

def update h
  next_h=(0..8).map{|v| [v,0]}.to_h
  h.each do |k,v|
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

init_data=IO.read(filename).split(',').map(&:to_i)

hash=init_data.tally

256.times do
  hash=update(hash)
end

puts hash.values.sum
