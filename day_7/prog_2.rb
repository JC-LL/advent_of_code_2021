def mean ary
    ary.sum.to_f / ary.size
end

def dist xi,m
  (xi-m).abs
end

def comp_moves ary,c
  pos=mean(ary)
  pmin,pmax=[v=pos.to_i,v+1]
  sum1=ary.map{|x| dist(x,pmin)*(dist(x,pmin)+1)}.sum/2
  sum2=ary.map{|x| dist(x,pmax)*(dist(x,pmax)+1)}.sum/2
  [sum1,sum2].min
end

filename=ARGV.first || "input.txt"

positions=IO.read(filename).split(",").map(&:to_i)

p comp_moves(positions,mean(positions))
