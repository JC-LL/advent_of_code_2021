def hit_a_key
  $stdin.gets
end

class Board
  def initialize rows
    @rows=rows
  end

  def mark num
    for y in 0..4
      for x in 0..4
        if @rows[y][x]==num
          @rows[y][x]=-1
          puts "#{num} marked at row,col=#{y},#{x}"
          break # WARN : verify that only a single number may appear on a board ???
        end
      end
    end
  end

  def any_row_completed?
    for y in 0..4
      return true if @rows[y].all?(-1)
    end
    false
  end

  def any_col_completed?
    for x in 0..4
      col=@rows[0..4].collect{|row| row[x]}
      return true if col.all?(-1)
    end
    false
  end

  def winner?
    any_row_completed? or any_col_completed?
  end

  def compute_score
    score=0
    for row in 0..4
      for col in 0..4
        if (val=@rows[row][col])!=-1
          score+=val
        end
      end
    end
    score
  end
end


def init_game
  @lines=IO.readlines("input.txt")

  # parsing
  @list=@lines.shift.split(',').map(&:to_i)
  @lines.shift

  @boards=[]
  while @lines.any?
    rows=[]
    5.times{rows << @lines.shift.split.map(&:to_i)}
    @lines.shift
    @boards << Board.new(rows)
  end

  puts "number of boards : #{@boards.size}"
end

def play_game
  winner_found=false
  @list.each do |num|
    puts "marking #{num}"
    @boards.each_with_index do |board,idx|
      board.mark(num)
      if board.winner?
        puts "board #{idx} wins !"
        board_score=board.compute_score
        puts "score = #{num*board_score}"
        winner_found=true
        break if winner_found
      end
    end
    break if winner_found
  end
end

def play_game2
  winning_boards=[]
  @list.each do |num|
    puts "marking #{num}"
    @boards.each_with_index do |board,idx|
      unless winning_boards.include?(board)
        board.mark(num)
        if board.winner?
          puts "board #{idx} wins !"
          board_score=board.compute_score
          puts "score = #{num*board_score}"
          winning_boards << board
        end
      end
    end
  end
end


puts "first part".center(40,'=')
hit_a_key
init_game
play_game

puts "second part".center(40,'=')
hit_a_key
init_game
play_game2
