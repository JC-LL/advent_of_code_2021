require_relative "../hit_a_key"

class Node
  attr_accessor :name
  attr_accessor :neighbours
  def initialize name
    @name=name
    @neighbours=[]
  end

  def big_cave?
    @name.upcase==@name
  end

  def small_cave?
    @name.downcase==@name
  end

  def << neigh
    @neighbours << neigh
    @neighbours.uniq!
  end

  def is_end?
    @name=="end"
  end

  def to_s
    @name
  end
end

class Graph
  attr_accessor :edges
  attr_accessor :nodes

  def initialize
    @nodes=[]
  end

  def build_from filename
    print "building graph"
    IO.readlines(filename).each do |line|
      line.chomp!
      n1,n2=line.split('-')
      unless node1=contains_node?(n1)
        @nodes << node1=Node.new(n1)
      end
      unless node2=contains_node?(n2)
        @nodes << node2=Node.new(n2)
      end
      @start=node1 if n1=="start"
      @start=node2 if n2=="start"
      @end  =node1 if n1=="end"
      @end  =node2 if n2=="end"
      node1 << node2
      node2 << node1
    end
    puts "\t# nodes #{@nodes.size}"
  end

  def contains_node? str
    @nodes.find{|node| node.name==str}
  end

  def visitable?(node,path)
    return false if (node.small_cave? and path.include?(node))
    return true
  end

  def path_str path
    path.map{|node| node.to_s}.join("-")
  end

  def build_paths
    puts "=> building paths"
    @paths=[]
    build_paths_rec(path=[],@start)
    puts @paths.size
  end

  def build_paths_rec path,n1
    path_next=path.clone
    puts "build_paths_rec [#{path.map{|e| e.name}.join("-")}] then #{n1.name}"
    if n1.is_end?
      @paths << (path_next << n1)
    elsif visitable?(n1,path_next)
      n1.neighbours.each do |n2|
        build_paths_rec(path_next << n1,n2)
      end
    end
  end

end

filename=ARGV.first || "input.txt"

g=Graph.new
g.build_from filename
g.build_paths
