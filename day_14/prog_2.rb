require_relative "../hit_a_key"

def implied paire,rules
  char=rules[paire]
  p1,p2=paire[0]+char,char+paire[1]
  [p1,p2]
end

def step tal,rules
  new_tal={}
  tal.each do |pair,qty|
    ary=implied(pair,rules)
    new_tal[ary.first]||=0
    new_tal[ary.last] ||=0
    new_tal[ary.first]+=qty
    new_tal[ary.last] +=qty
  end
  new_tal
end


lines=IO.readlines(ARGV.first).map(&:chomp)
template=lines.shift
puts "template : #{@template}"
lines.shift
rules=lines.map{|l| l.split(" -> ")}.to_h

tal={}
template.chars.each_cons(2) do |two_chars|
  pair=two_chars.join
  tal[pair]||=0
  tal[pair]+=1
end
pp tal
hit_a_key

40.times do |t|
  tal=step(tal,rules)
  puts "end of step #{t+1}"
  pp tal
  #hit_a_key
end

pp tal
letters=rules.keys.join.chars.uniq
letters_h=letters.map{|l| [l,0]}.to_h

tal.each do |pair,qty|
  letters_h[pair[0]]+=qty
end

#last char of template is missing !!!!!
letters_h[template.chars.last]+=1

pp letters_h

min,max=letters_h.values.minmax
puts "result = #{max-min}"
