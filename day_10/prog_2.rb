filename=ARGV.first || "input.txt"

COUNTERPART={
  '(' => ')',
  '[' => ']',
  '<' => '>',
  '{' => '}',
}

SCORE={
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

error_kind=[')',']','>','}'].map{|char| [char,0]}.to_h

scores=[]

uncompleted=IO.readlines(filename).reject.each_with_index do |line,y|
  line=line.chomp
  stack=[]
  corrupted=false
  line.chars.each_with_index do |char,x|
    case char
    when '(','[','<','{'
      stack << COUNTERPART[char]
    when ')',']','>','}'
      if (top=stack.pop)!=char
        puts "error line #{y} at #{x} : expecting #{top}. Got #{char}"
        puts "#{line}"
        puts "-"*x+"^"
        error_kind[char]+=1
        corrupted=true
        break
      end
    end
  end
  if !corrupted and stack.any?
    score=stack.reverse.inject(0) do |accu,char|
      accu*=5
      accu+=SCORE[char]
      accu
    end
    puts "line #{y} uncomplete. Competion = #{completion=stack.join}. score #{score}. "
    puts "#{line} #{completion}"
    scores << score
  end
end

scores.sort!
pos=scores.size/2
puts "result = #{scores[pos]}"
