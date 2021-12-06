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

def vertical_and_horizontal_and_diagonal_lines paths
  puts "selecting v,h,d lines"
  paths.select do |path|
    path.source.x==path.dest.x or
    path.source.y==path.dest.y or
    (path.source.y-path.dest.y).abs==(path.source.x-path.dest.x).abs # diagonal
  end
end

def compute_covering paths
  puts "determining covered points"
  covering=[]
  paths.each do |path|
    source,dest=path.source,path.dest
    x1,y1=source.x,source.y
    x2,y2=dest.x,dest.y
    minx,maxx=[x1,x2].minmax
    miny,maxy=[y1,y2].minmax
    if x1==x2 or y1==y2 # h or v
      (minx..maxx).each do |x|
        (miny..maxy).each do |y|
          covering << Coord.new(x,y)
        end
      end
    else # diagonals
      x,y=x1,y1
      incx=x2>x1 ? +1 : -1
      incy=y2>y1 ? +1 : -1

      covering << Coord.new(x,y)
      while x!=x2 and y!=y2
        x+=incx
        y+=incy
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

def draw_grid counter_h
  maxx=counter_h.keys.map{|pos| pos.first}.max
  maxy=counter_h.keys.map{|pos| pos.last}.max
  grid=Array.new(maxy+1){Array.new(maxx+1){"."}}
  counter_h.each do |pos,val|
    grid[pos.last][pos.first]=val
  end
  for y in 0..maxy
    for x in 0..maxx
      val=grid[y][x]
      print val
    end
    puts
  end
  puts %{
1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111....
  }

end


datafile=ARGV.first || "input.txt"

paths=parse(datafile)
puts "\t#path..............#{paths.size}"

subset=vertical_and_horizontal_and_diagonal_lines(paths)
puts "\t#subset............#{subset.size}"

covering=compute_covering(subset)
puts "\t#covering..........#{covering.size}"

count_h=counting_overlaps(covering)
puts "\t#overlaps..........#{count_h.size}"

#draw_grid(count_h)


danger=compute_danger(count_h)
puts "\t#dangers points....#{danger}"
