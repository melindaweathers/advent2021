class Grid
  def initialize(filename, size, allow_diag = false)
    @grid = Array.new(size){Array.new(size)}
    IO.readlines(filename).each do |line|
      add_line(line, allow_diag)
    end
  end

  def add_line(line, allow_diag)
    x, y, x2, y2 = line.split(/,| -> /).map(&:to_i)
    return unless allow_diag || (x == x2 || y == y2)
    change = [sign(x2 - x), sign(y2 - y)]
    loop do
      @grid[y][x] = (@grid[y][x]).to_i + 1
      break if [x, y] == [x2, y2]
      x += change[0]
      y += change[1]
    end
  end

  def sign(x)
    return 0 if x == 0
    x < 0 ? -1 : 1
  end

  def count_overlaps
    @grid.map do |row|
      row.map{|n| n.to_i > 1 ? 1 : 0}.sum
    end.sum
  end
end

puts Grid.new('input-test.txt', 10).count_overlaps
puts Grid.new('input.txt', 1000).count_overlaps

puts Grid.new('input-test.txt', 10, true).count_overlaps
puts Grid.new('input.txt', 1000, true).count_overlaps
