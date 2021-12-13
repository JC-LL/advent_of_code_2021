require_relative "../hit_a_key"

class Page

  attr_accessor :mat

  def initialize mat=[]
    @mat=mat
  end

  def parse filename
    lines=IO.readlines(ARGV.first).map(&:chomp).reject{|line| line.empty?}
    dots=lines.reject{|line| line.start_with?("fold")}
    dots=dots.map{|line| line.split(',').map(&:to_i)}
    dimx,dimy=dots.map(&:first).max+1,dots.map(&:last).max+1
    @mat=Array.new(dimy){Array.new(dimx){'.'}}
    dots.each{|dot| x,y=dot ; @mat[y][x]='#'}
    cmds=lines.select{|line| line.start_with?("fold")}
    return cmds.map{|l| l.match(/.*(y|x)\=(\d+)/) ; [$1,$2.to_i]}
  end

  def [](y,x)
    mat[y][x]
  end

  def []=(y,x,e)
    mat[y][x]=e
  end

  def display
    mat.each_with_index do |line,y|
      line.each do |e,x|
        print e
      end
      puts
    end
  end

  def count_dots
    mat.flatten.count('#')
  end

  def fold_on instruction
    axe,pos=instruction
    case axe
    when 'y'
      p1,p2=mat.partition.with_index{|line,idx| idx<pos}.map{|m| Page.new(m)}
      p2.mat.shift #suppress folding line
      p2.mat.reverse.each_with_index do |line,y|
        line.each_with_index do |e,x|
          p1[y,x]=e if p1[y,x]=='.'
        end
      end
      return p1
    when 'x'
      p1,p2=[Array.new(mat.size){[]},Array.new(mat.size){[]}].map{|m| Page.new(m)}
      mat.each_with_index do |line,y|
        line.each_with_index do |e,x|
          if x < pos
            p1.mat[y] << e
          elsif x> pos
            p2.mat[y] << e
          end
        end
      end
      p2.mat.each_with_index do |line,y|
        line.reverse.each_with_index do |e,x|
          p1[y,x]=e if p1[y,x]=='.'
        end
      end
      return p1
    end
  end
end

page=Page.new
cmds=page.parse(ARGV.first)

cmds.each do |cmd|
  page=page.fold_on(cmd)
end

page.display
