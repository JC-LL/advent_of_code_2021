# the right "center" point is not the mean, but the median !!!

def find_shortest_distance ary
  tab=ary.sort
  len=ary.size
  pos=len.to_f/2
  pmin,pmax=[v=pos.to_i,v+1]
  min,max=tab[pmin],tab[pmax]
  sum1=comp_moves(ary,min)
  sum2=comp_moves(ary,max)
  [sum1,sum2].min
end

def comp_moves ary,mean
  ary.map{|v| (v-mean).abs}.sum
end

filename=ARGV.first || "input.txt"

positions=IO.read(filename).split(",").map(&:to_i)
p find_shortest_distance(positions)
