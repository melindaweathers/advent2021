DIRS = [[-1,-1], [0,-1], [1,-1], [-1,0], [0,0], [1,0], [-1,1], [0,1], [1,1]]
class TrenchMap
  def initialize(filename)
    algo, input_lines = IO.read(filename).split("\n\n")
    @algo = algo.chomp
    @map = Hash.new('.')
    @minx = @maxx = @miny = @maxy = 0

    input_lines.split("\n").each_with_index do |line, y|
      line.chomp.split('').each_with_index do |char, x|
        @map[[x, y]] = char
        @maxy = y if y > @maxy
        @maxx = x if x > @maxx
      end
    end
    expand
  end

  def expand
    @minx -= 1
    @miny -= 1
    @maxx += 1
    @maxy += 1
  end

  def print
    @miny.upto(@maxy).each do |y|
      puts @minx.upto(@maxx).map{|x| @map[[x, y]]}.join('')
    end
  end

  def convolve(fill)
    new_map = Hash.new(fill)
    @minx.upto(@maxx) do |x|
      @miny.upto(@maxy) do |y|
        new_map[[x,y]] = @algo[DIRS.map { |xoff, yoff| @map[[x + xoff, y + yoff]] == '#' ? 1 : 0 }.join('').to_i(2)]
      end
    end
    @map = new_map
    expand
    self
  end

  def count_lit
    @map.values.map{|val| val == '#' ? 1 : 0}.sum
  end

  def convolve_num(num, even_fill)
    num.times do |time|
      convolve(time.even? ? even_fill : '.')
    end
    count_lit
  end
end

puts TrenchMap.new('input-test.txt').convolve_num(2, '.')
puts TrenchMap.new('input.txt').convolve_num(2, '#')

puts TrenchMap.new('input-test.txt').convolve_num(50, '.')
puts TrenchMap.new('input.txt').convolve_num(50, '#')
