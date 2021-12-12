class Node
  attr_accessor :name, :neighbours
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
  attr_accessor :nodes

  def initialize filename
    @nodes=[]
    print "building graph"
    IO.readlines(filename).each do |line|
      n1,n2=line.split('-').map(&:chomp)
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
    return false if (node.name=="start" and path.find{|n| n.name=="start"})
    return false if (node.name=="end"   and path.find{|n| n.name=="end"})
    if node.small_cave?
      case path.count(node)
      when 2
        return false
      when 1
        small_caves=path.reject{|n| n.big_cave?}
        # check no other small cave doubled previously :
        return false if (small_caves.uniq.size!=small_caves.size) and small_caves.size>0
      when 0
        return true
      end
    end
    return true
  end

  def path_str path
    "["+path.map{|node| node.to_s}.join("-")+"]"
  end

  def build_paths
    @paths=[]
    build_paths_rec(path=[],@start)
    puts @paths.size
  end

  def build_paths_rec path,n1
    path_next=path.clone
    if n1.is_end?
      @paths << (path_next << n1)
      puts "found path : #{path_str(@paths.last)}"
    else
      if visitable?(n1,path_next)
        path_next << n1
        n1.neighbours.each do |n2|
          build_paths_rec(path_next,n2)
        end
      end
    end
  end
end

filename=ARGV.first || "input.txt"
g=Graph.new(filename)
g.build_paths
