require_relative "../hit_a_key"

class Coord
  attr_accessor :x,:y
  def initialize y,x
    @y,@x=y,x
  end

  def valid?(sx,sy)
    (x>=0) and (x<=sx-1) and (y>0) and (y<=sy-1)
  end
end

class Map
  attr_accessor :dims
  def initialize nb_rows,nb_cols
    @dims=Coord.new(nb_rows,nb_cols)
    @elements=Hash[(-1..nb_rows).map{|y| [y,Hash[(-1..nb_cols).map{|x| [x,9]}]]}]
  end

  def []=(y,x,v)
    @elements[y][x]=v
  end

  def [](y,x)
    @elements[y][x]
  end

  def show
    for row in -1..@dims.y
      for col in -1..@dims.x
        print self[row,col]
      end
      puts
    end
  end
end

def build_map filename
  lines=IO.readlines(filename).map(&:chomp)
  nb_rows,nb_cols=lines.size,nb_cols=lines.first.size
  map=Map.new(nb_rows,nb_cols)
  lines.each_with_index do |line,y|
    line.chars.each_with_index do |v,x|
      map[y,x]=v.to_i
    end
  end
  map.show
  map
end

def find_mins map
  mins=[]
  for y in 0..map.dims.y-1
    for x in 0..map.dims.x-1
      val_c=map[y,x]
      neighbours={
        n: map[y-1,x],
        w: map[y  ,x-1],
        e: map[y  ,x+1],
        s: map[y+1,x],
      }
      mins << val_c if neighbours.map{|pcard,val| val_c < val}.all?(true)
    end
  end
  return mins
end

def compute_risk mins
  mins.map{|min| min+1}.sum
end

filename=ARGV.first || "test.txt"

map=build_map(filename)
mins=find_mins(map)
result=compute_risk(mins)
puts "result = #{result}"
