filename=ARGV.first || "input.txt"

COUNTERPART={
  '(' => ')',
  '[' => ']',
  '<' => '>',
  '{' => '}',
}

SCORE={
  ')' => 3,
  ']' => 57,
  '>' => 25137,
  '}' => 1197,
}

error_kind=[')',']','>','}'].map{|char| [char,0]}.to_h

IO.readlines(filename).each_with_index do |line,y|
  puts "analyzing line #{y+1} : #{line}"
  line=line.chomp
  stack=[]
  line.chars.each_with_index do |char,x|
    case char
    when '(','[','<','{'
      stack << COUNTERPART[char]
    #-----------
    when ')',']','>','}'
      if (top=stack.pop)!=char
        puts "error line #{y+1} at #{x} : expecting #{top}. Got #{char}"
        puts "#{line}"
        puts "-"*x+"^"
        error_kind[char]+=1
        break
      end
    end
  end
end

result=error_kind.map{|char,nb| SCORE[char]*nb}.sum
puts "result = #{result}"
