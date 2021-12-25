class Trench
  def initialize(filename)
    @grid = IO.readlines(filename).map do |line|
      line.chomp.split('')
    end
    @width = @grid.first.length
    @height = @grid.length
  end

  def print
    puts
    puts
    @grid.each do |line|
      puts line.join('')
    end
  end

  def move
    new_grid = Array.new(@height)
    has_moved = false
    0.upto(@height - 1) do |y|
      new_grid[y] = Array.new(@width, '.')
      0.upto(@width - 1) do |x|
        if @grid[y][x] == '>'
          if @grid[y][(x+1) % @width] == '.'
            has_moved = true
            new_grid[y][(x+1) % @width] = '>'
          else
            new_grid[y][x] = '>'
          end
        end
      end
    end
    0.upto(@height - 1) do |y|
      0.upto(@width - 1) do |x|
        if @grid[y][x] == 'v'
          if @grid[(y+1) % @height][x] != 'v' && new_grid[(y+1) % @height][x] == '.'
            has_moved = true
            new_grid[(y+1) % @height][x] = 'v'
          else
            new_grid[y][x] = 'v'
          end
        end
      end
    end
    @grid = new_grid
    has_moved
  end

  def move_until_done
    moves = 0
    loop do
      moves += 1
      has_moved = move
      break unless has_moved
    end
    moves
  end
end

trench = Trench.new('input-test.txt')
puts trench.move_until_done

puts Trench.new('input.txt').move_until_done
