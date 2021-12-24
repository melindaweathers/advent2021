ADJS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
Point = Struct.new(:risk, :distance, :x, :y)

class Grid
  def initialize(filename, full_map = false)
    @unvisited = []
    @grid = IO.readlines(filename).map.with_index do |line, y|
      line.chomp.split('').map.with_index do |val, x|
        point = Point.new(val.to_i, 10000000, x, y)
        @unvisited << point unless full_map
        point
      end
    end
    if full_map
      grid_height = @grid.length
      grid_width = @grid.first.length
      giant_grid = Array.new(grid_height * 5)
      0.upto(4) do |row_dup|
        0.upto(4) do |col_dup|
          0.upto(grid_height - 1) do |row|
            0.upto(grid_width - 1) do |col|
              x = col + col_dup * grid_width
              y = row + row_dup * grid_width
              risk = @grid[row][col].risk + col_dup + row_dup
              point = Point.new(((risk - 1) % 9) + 1, 10000000000, x, y)
              giant_grid[y] ||= Array.new(grid_width * 5)
              giant_grid[y][x] = point
              @unvisited << point
            end
          end
        end
      end
      @grid = giant_grid
    end
    @grid[0][0].distance = 0
    fix_sort
  end

  def fix_sort
    @unvisited.sort_by!{|point| -1*point.distance}
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

  def print_risks
    @grid.each do |row|
      puts row.map(&:risk).join(' ')
    end
  end

  def lowest_risk_path
    loop do
      break if @unvisited.empty?
      u = @unvisited.pop
      neighbors(u).each do |neighbor|
        alt = u.distance + neighbor.risk
        if alt < neighbor.distance
          neighbor.distance = alt
          # Move neighbor to new position
          i = @unvisited.index(neighbor)
          loop do
            break if i >= @unvisited.length - 1 || @unvisited[i + 1].distance < neighbor.distance
            @unvisited[i], @unvisited[i + 1] = @unvisited[i + 1], @unvisited[i]
            i += 1
          end
        end
      end
    end
    @grid[height - 1][width - 1].distance
  end
end

puts Grid.new('input-test.txt').lowest_risk_path
#puts Grid.new('input.txt').lowest_risk_path

#Grid.new('input-test.txt', true).print_risks
puts Grid.new('input-test.txt', true).lowest_risk_path
puts Grid.new('input.txt', true).lowest_risk_path

