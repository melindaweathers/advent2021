class SmokeBasin
  def initialize(filename)
    @map = IO.readlines(filename).map { |line| line.chomp.split('').map(&:to_i) }
    @height = @map.length
    @width = @map[0].length
  end

  def lavatubes
    0.upto(@height - 1).map do |row|
      0.upto(@width - 1).map { |col| lavatube?(row, col) ? 1 + @map[row][col] : 0 }.sum
    end.sum
  end

  def lavatube?(row, col)
    point = @map[row][col]
    up = @map[row][col - 1] if col > 0
    down = @map[row][col + 1] if col < @width - 1
    left = @map[row - 1][col] if row > 0
    right = @map[row + 1][col] if row < @height - 1
    [up, down, left, right].compact.min > point
  end

  def basin_points(point)
    points = []
    row, col = point[0], point[1]
    points << [row, col - 1] if col > 0
    points << [row, col + 1] if col < @width - 1
    points << [row - 1, col] if row > 0
    points << [row + 1, col] if row < @height - 1
    points.reject{|row, col| @map[row][col] == 9}
  end

  def basins
    basin_sizes = []
    0.upto(@height - 1).map do |row|
      0.upto(@width - 1).map do |col|
        basin_sizes << basin_size([[row, col]], []) if lavatube?(row, col)
      end
    end
    basin_sizes.sort.last(3).inject('*')
  end

  def basin_size(frontier, points)
    return points.length if frontier.empty?
    point = frontier.first
    new_points = basin_points(point) - points
    basin_size((frontier - [point] + new_points).uniq, (points + [point]).uniq)
  end
end

puts SmokeBasin.new('input-test.txt').lavatubes
puts SmokeBasin.new('input.txt').lavatubes

puts SmokeBasin.new('input-test.txt').basins
puts SmokeBasin.new('input.txt').basins
