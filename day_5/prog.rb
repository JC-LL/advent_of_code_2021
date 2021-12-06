require_relative "../hit_a_key"


Coord=Struct.new(:x,:y)

Path=Struct.new(:source,:dest)

def parse filename
  puts "parsing"
  lines=IO.readlines filename
  paths=[]
  lines.each do |line|
    s,d=line.split("->").map(&:strip).map{|couple| Coord.new(*couple.split(",").map(&:to_i))}
    paths << Path.new(s,d)
  end
  return paths
end

def vertical_and_horizontal_lines paths
  puts "selecting vertical or horizontal lines"
  paths.select do |path|
    path.source.x==path.dest.x or
    path.source.y==path.dest.y
  end
end

def vertical_lines paths
  puts "selecting vertical lines"
  paths.select do |path|
    path.source.x==path.dest.x
  end
end

def horizontal_lines paths
  puts "selecting vertical lines"
  paths.select do |path|
    path.source.y==path.dest.y
  end
end

def compute_covering paths
  puts "determining covered points"
  covering=[]
  paths.each do |path|
    x1,y1=path.source.x,path.source.y
    x2,y2=path.dest.x,path.dest.y
    minx,maxx=*([x1,x2].minmax)
    miny,maxy=*([y1,y2].minmax)
    (minx..maxx).each do |x|
      (miny..maxy).each do |y|
        covering << Coord.new(x,y)
      end
    end
  end
  covering
end

def counting_overlaps coords
  puts "counting overlaps"
  counter={}
  coords.each do |coord|
    key=[coord.x,coord.y]
    counter[key]||=0
    counter[key]+=1
  end
  counter
end

def compute_danger count_h
  puts "counting danger points"
  count_h.count{|k,v| v>=2}
end

paths=parse("input.txt")
puts "\t#path..............#{paths.size}"

subset=vertical_and_horizontal_lines(paths)
puts "\t#subset............#{subset.size}"

covering=compute_covering(subset)
puts "\t#covering..........#{covering.size}"

count_h=counting_overlaps(covering)
puts "\t#overlaps..........#{count_h.size}"

danger=compute_danger(count_h)
pp danger
puts "\t#dangers points....#{danger}"
