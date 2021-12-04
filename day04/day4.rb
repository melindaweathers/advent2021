class BingoBoard
  SIZE = 5
  MARKED = 'M'
  def initialize(lines)
    @board = Array.new(SIZE)
    @marked = []
    lines.each_with_index do |line, i|
      @board[i] = line.split.map(&:to_i)
    end
  end

  def play_num(num)
    @last_num = num
    mark_num(num)
    if any_bingos?
      @had_bingo = true
      puts board_value
    end
  end

  def had_bingo?
    @had_bingo
  end

  private

  def mark_num(num)
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        if @board[row][col] == num
          @marked << num
          @board[row][col] = MARKED
        end
      end
    end
  end

  def board_value
    @board.map do |row|
      row.map(&:to_i).sum
    end.sum * @last_num
  end

  def any_bingos?
    row_bingos?(@board) || row_bingos?(@board.transpose)
  end

  def row_bingos?(board)
    board.any?{|row| row.all?{|val| val == MARKED}}
  end
end

class BingoGame
  def initialize(filename)
    contents = IO.read(filename).split("\n\n")
    @nums = contents[0].split(',').map(&:to_i)
    @boards = contents[1..-1].map do |lines|
      BingoBoard.new(lines.split("\n"))
    end
  end

  def play
    loop do
      move
      break if @boards.all?{|board| board.had_bingo?}
    end
  end

  def move
    num = @nums.shift
    @boards.each do |board|
      board.play_num(num) unless board.had_bingo?
    end
  end
end

puts "Test boards"
BingoGame.new('input-test.txt').play

puts
puts "Real boards"
BingoGame.new('input.txt').play
