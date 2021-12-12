require_relative "../hit_a_key"

def parse filename
  mat=IO.readlines(filename).map(&:chomp).map(&:chars).map{|l| l.map(&:to_i)}
  $dims=[mat.size,mat.first.size]

  mat
end

def print mat
  puts "=> printing"
  mat.each do |line|
    line=line.map{|e| "#{e}".rjust(3)}
    puts line.join
  end
end

def increase_by_one mat
  puts "increase_by_one"
  mat.each do |line|
    line.each_with_index do |e,idx|
      line[idx]+=1
    end
  end
end

DELTA={
  n: [ 0,-1],
  s: [ 0,+1],
  w: [-1, 0],
  e: [+1, 0],
  nw:[-1,-1],
  ne:[+1,-1],
  sw:[-1,+1],
  se:[+1,+1],
}

def valid? coord
  x,y=coord
  dimx,dimy=$dims
  (x>=0 and x < dimx) && (y>=0 and (y < dimy))
end

def propagate flashables,mat
  puts "propagate"
  #hit_a_key
  flashables.each do |pos|
    x,y=pos
    @has_flashed << pos
    DELTA.each do |dir,delta|
      dx,dy=delta
      neighbour=[x+dx,y+dy]
      if valid?(neighbour)
        nx,ny=neighbour
        mat[ny][nx]+=1
      end
    end
  end
end

def reset mat
  puts "reset"
  @has_flashed.each do |pos|
    x,y=pos
    mat[y][x]=0
  end
end

def step t,mat
  puts "step #{t+1}".center(40,"-")
  #hit_a_key
  @has_flashed=[]
  increase_by_one(mat)
  print mat
  flashables=detect_flashables(mat)
  while flashables.any?
    propagate(flashables,mat)
    print mat
    flashables=detect_flashables(mat)
  end
  reset mat
  print mat
end

def detect_flashables mat
  puts "detect_flashables"
  ret=[]
  mat.each_with_index do |line,y|
    line.each_with_index do |e,x|
      if e>=10 and !@has_flashed.include?([x,y])
        ret << [x,y]
        @flashes+=1
      end
    end
  end
  puts "\tfound #{ret.size}"
  ret
end

filename=ARGV.first || "input.txt"

matrix=parse(filename)

print matrix
puts "start".center(40,'-')
@flashes=0

100.times do |t|
  step(t,matrix)
end

puts "#flashes = #{@flashes}"
