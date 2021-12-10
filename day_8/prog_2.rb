require_relative "../hit_a_key"

Entry=Struct.new(:pattern,:encoded_digits)

def parse lines
  lines.collect do |line|
    pattern,digits=line.split("|")
    pattern=pattern.split(' ').map(&:chars).map(&:sort).map(&:join)
    digits=digits.split(' ')
    Entry.new(pattern,digits)
  end
end

LETTERS=('a'..'g').to_a

def discover_mapping pattern
  puts "=> discovering mapping"
  guess=(0..9).to_a.map{|v| [v,[]]}.to_h
  map={}
  k={}
  pattern.each do |code|
    case code.size
    when 2
      k[1]=guess[1] = code
    when 3
      k[7]=guess[7] = code
    when 4
      k[4]=guess[4] = code
    when 7
      k[8]=guess[8] = code
    when 5
      guess[2] << code
      guess[3] << code
      guess[5] << code
    when 6
      guess[0] << code
      guess[6] << code
      guess[9] << code
    end
  end
  
  map['a']=(guess[7].chars-guess[1].chars).first

  #----Among the 5-long codes, it is possible to find the one for number 3 :
  k[3]=guess[5].select{|g5| (g5.chars & guess[1].chars)==guess[1].chars}.first
  guess[5].reject!    {|g5| (g5.chars & guess[1].chars)==guess[1].chars}
  #---Among the 6-long codes, it is possible to find the one for number 6 :
  k[6]=guess[6].select{|g6| (g6.chars & guess[1].chars)!=guess[1].chars}.first
  guess[6].reject!     {|g6| (g6.chars & guess[1].chars)!=guess[1].chars}
  # then we can find mapping for 'c' and 'f' segments
  map['c']=(k[3].chars-k[6].chars).first
  map['f']=(guess[1].chars-[map['c']]).first
  # then Among the 5-long codes, it is possible to find the one for number 2 :
  k[2]=guess[5].select{|g5| g5.chars.include?(map['c'])}.first
  guess[5].reject!       {|g5| g5.chars.include?(map['c'])}
  # ...then k[5]
  k[5]=guess[5].first

  # the rest follows :
  map['e']=(k[2].chars-k[3].chars).first

  k[0]=guess[6].select{|g6| g6.chars.include? map['e']}.first
  guess[6].reject!    {|g6| g6.chars.include? map['e']}

  k[9]=guess[6].first

  map['d']=(LETTERS - k[0].chars).first
  map['b']=(guess[4].chars-[map['c'],map['f'],map['d']]).first
  map['g']=(LETTERS - ('a'..'f').map{|i| map[i]}).first
  map.invert
end

def decode_digits encoded_digits,map
  puts "=> decode digits '#{encoded_digits}'"
  digits=encoded_digits.map{|encoded_digit| decode_digit(encoded_digit,map)}
end

SEG={
  "cf"      => 1,
  "acdeg"   => 2,
  "acdfg"   => 3,
  "bcdf"    => 4,
  "abdfg"   => 5,
  "abdefg"  => 6,
  "acf"     => 7,
  "abcdefg" => 8,
  "abcdfg"  => 9,
  "abcefg"  => 0
}

def decode_digit enc,map
  segments=enc.chars.map{|c| map[c]}.sort.join
  res=SEG[segments]
end


#========================================================
filename=ARGV.first || "input.txt"
lines=IO.readlines(filename)

entries=parse(lines)

result=entries.sum do |entry|
  mapping=discover_mapping(entry.pattern)
  digits=decode_digits(entry.encoded_digits,mapping)
  value=digits.join.to_i
end

puts "result = #{result}"
