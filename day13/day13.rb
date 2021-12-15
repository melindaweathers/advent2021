class Paper
  def initialize(filename)
    points_list, folds_list = File.read(filename).split("\n\n")
    arr_size = points_list.split("\n").map{|val| val.split(',').map(&:to_i).max}.max + 1
    @folds = folds_list.split("\n")
    @grid = Array.new(arr_size){ Array.new(arr_size, '.') }
    points_list.split("\n").each do |points|
      x, y = points.split(',').map(&:to_i)
      @grid[y][x] = '#'
    end
  end

  def print
    puts
    puts
    @grid.each do |line|
      puts line.join('')
    end
  end

  def fold_first
    fold(@folds.first)
    @grid.map { |line| line.count('#') }.sum
  end

  def fold_all
    @folds.each{|ins| fold(ins)}
    print
  end

  def fold(instruction)
    dir, val = instruction[11..-1].split('=')
    val = val.to_i
    @grid = dir == 'y' ? fold_horiz(val, @grid) : fold_horiz(val, @grid.transpose).transpose
  end

  def fold_horiz(val, grid)
    folded = grid[0..val - 1]
    (val+1).upto(grid.length - 1) do |y|
      grid[y].each_with_index do |char, i|
        folded[2*val - y][i] = '#' if char == '#'
      end
    end
    folded
  end
end

puts Paper.new('input-test.txt').fold_first
puts Paper.new('input.txt').fold_first

Paper.new('input-test.txt').fold_all
Paper.new('input.txt').fold_all
