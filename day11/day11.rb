SIZE = 10
ADJS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
class Cavern
  def initialize(filename)
    @flashes = 0
    @round = 0
    @octo = IO.readlines(filename).map do |line|
      line.chomp.split('').map(&:to_i)
    end
  end

  def print
    @octo.each { |line| puts line.join(' ') }
    puts
  end

  def tick
    flashes = increment_octos
    run_flashes(flashes)
    new_flashes = set_zeros
    @flashes += new_flashes
    @round += 1
    @all_flashed = true if new_flashes == 100
  end

  def ticks(num)
    num.times { tick }
    @flashes
  end

  def find_all_flash
    tick until @all_flashed
    @round
  end

  def increment_octos
    flashes = []
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        @octo[row][col] += 1
        flashes << [row, col] if @octo[row][col] > 9
      end
    end
    flashes
  end

  def adjacents(pos)
    ADJS.map do |adj|
      point = [pos[0] + adj[0], pos[1] + adj[1]]
      point unless point.any?{|val| val < 0 || val >= SIZE}
    end.compact
  end

  def set_zeros
    flashes_this_round = 0
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        if @octo[row][col] > 9
          @octo[row][col] = 0
          flashes_this_round += 1
        end
      end
    end
    flashes_this_round
  end

  def run_flashes(flashes)
    until flashes.empty? do
      flash = flashes.pop
      adjacents(flash).each do |adj|
        row, col = adj[0], adj[1]
        if @octo[row][col] < 9
          @octo[row][col] += 1
        elsif @octo[row][col] == 9
          flashes << [row, col]
          @octo[row][col] += 1
        end
      end
    end
  end
end

puts Cavern.new('input-test.txt').ticks(100)
puts Cavern.new('input.txt').ticks(100)

puts Cavern.new('input-test.txt').find_all_flash
puts Cavern.new('input.txt').find_all_flash
