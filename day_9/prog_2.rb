require_relative "../hit_a_key"

class Coord
  attr_accessor :x,:y
  def initialize y,x
    @y,@x=y,x
  end

  def valid?(sx,sy)
    (x>=0) and (x<=sx-1) and (y>0) and (y<=sy-1)
  end

  def to_s
    "(#{y},#{x})"
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
  #map.show
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
      mins << [y,x] if neighbours.map{|pcard,val| val_c < val}.all?(true)
    end
  end
  return mins
end

def find_bassins mins,map
  mins.map do |min|
    @visited=[]
    bassin=find_bassin_rec(*min,map)
    #puts "bassin towards #{min} : #{bassin.map{|coo| coo.to_s}}"
    bassin
  end
end

def find_bassin_rec y,x,map
  bassin=[]
  val=map[y,x]
  if val==9 or @visited.include?([y,x])
    return nil
  else
    bassin << Coord.new(y,x)
    @visited << [y,x]
    (bassin << find_bassin_rec(y-1,x,map)) if (y-1)>=0 #n
    (bassin << find_bassin_rec(y+1,x,map)) if (y-1)<=map.dims.y #s
    (bassin << find_bassin_rec(y,x+1,map)) if (x+1)<=map.dims.x #e
    (bassin << find_bassin_rec(y,x-1,map)) if (x-1)>=0 #w
    return bassin.flatten.compact
  end
end

filename=ARGV.first || "input.txt"

map=build_map(filename)
mins=find_mins(map)
bassins=find_bassins(mins,map)
result=bassins.map(&:size).sort.reverse.first(3).inject(:*)
puts "result = #{result}"
