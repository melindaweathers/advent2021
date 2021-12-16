ADJS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
Point = Struct.new(:risk, :distance, :x, :y)

class Grid
  def initialize(filename)
    @unvisited = []
    @grid = IO.readlines(filename).map.with_index do |line, y|
      line.chomp.split('').map.with_index do |val, x|
        point = Point.new(val.to_i, 100000000, x, y)
        @unvisited << point
        point
      end
    end
    @grid[0][0].distance = 0
    @unvisited.sort_by{|point| point.distance}
  end

  def neighbors(curpoint)
    ADJS.map do |adj|
      point = [curpoint.x + adj[0], curpoint.y + adj[1]]
      @grid[point[1]][point[0]] unless point[0] < 0 || point[1] < 0 || point[0] >= width || point[1] >= height
    end.compact
  end

  def height
    @height ||= @grid.length
  end

  def width
    @width ||= @grid.first.length
  end

  def print_distances
    @grid.each do |row|
      puts row.map(&:distance).join(' ')
    end
  end

  def lowest_risk_path
    loop do
      break if @unvisited.empty?
      u = @unvisited.min_by{|point| point.distance}
      @unvisited.delete(u)
      neighbors(u).each do |neighbor|
        alt = u.distance + neighbor.risk
        if alt < neighbor.distance
          neighbor.distance = alt
        end
      end
    end
    @grid[height - 1][width - 1].distance
  end
end

puts Grid.new('input-test.txt').lowest_risk_path
puts Grid.new('input.txt').lowest_risk_path
