class Point
  attr_accessor :x, :y, :z
  def initialize(points)
    @x, @y, @z = points
  end

  def orientations
    @orientations ||= [
      [x, y, z],
      [x, z, -y],
      [x, -y, -z],
      [x, -z, y],

      [-x, z, y],
      [-x, y, -z],
      [-x, -z, -y],
      [-x, -y, z],

      [y, z, x],
      [y, x, -z],
      [y, -z, -x],
      [y, -x, z],

      [-y, x, z],
      [-y, z, -x],
      [-y, -x, -z],
      [-y, -z, x],

      [z, x, y],
      [z, y, -x],
      [z, -x, -y],
      [z, -y, x],

      [-z, y, x],
      [-z, x, -y],
      [-z, -y, -x],
      [-z, -x, y],
    ]
  end

  def to_s
    [x, y, z].join(',')
  end

  def at_orientation(ori, xoff, yoff, zoff)
    #orientations(x + xoff, y + yoff, z + zoff)[ori]
    x, y, z = orientations[ori]
    [x + xoff, y + yoff, z + zoff]
  end
end
class Scanner
  attr_accessor :points, :orientation, :xoff, :yoff, :zoff
  def initialize
    @points = []
  end

  def add_points(points)
    @points << Point.new(points)
  end

  def position=(pos)
    @orientation, @xoff, @yoff, @zoff = pos
  end

  def adjusted_points
    points_at_orientation(@orientation, @xoff, @yoff, @zoff)
  end

  def points_at_orientation(orientation, x, y, z)
    @points.map do |point|
      point.at_orientation(orientation, x, y, z)
    end
  end
end

class BeaconScanners
  attr_accessor :scanners
  def initialize(filename)
    @scanners = []
    @beacons = []
    idx = 0
    IO.readlines(filename).each do |line|
      if line[0..2] == '---'
        idx = line.split(' ')[2].to_i
        @scanners[idx] = Scanner.new
      elsif line.length > 2
        @scanners[idx].add_points(line.chomp.split(',').map(&:to_i))
      end
    end
  end

  def print_scanners
    @scanners.each_with_index do |scanner, idx|
      puts idx
      puts scanner.inspect
    end
  end

  def try_alignment(fixed, not_fixed)
    offsets = {}
    0.upto(23) do |ori|
      offsets = {}
      fixed.adjusted_points.each do |point|
        correctx, correcty, correctz = point
        not_fixed.points_at_orientation(ori, 0, 0, 0).each do |test|
          testx, testy, testz = test
          offset_point = [correctx - testx, correcty - testy, correctz - testz]
          (offsets[offset_point] ||= []) << [correctx, correcty, correctz]
        end
      end
      if winner = offsets.select{|k, v| v.uniq.length >= 12}.keys.first
        #offsets[winner].each {|p| puts p.join(',')}
        @beacons += offsets[winner]
        @beacons.uniq!
        puts @beacons.length
        return [ori, winner[0], winner[1], winner[2]]
      end
    end
    nil
  end

  def count_beacons
    @scanners[0].position = [0, 0, 0, 0]
    @fixed_scanners = [@scanners.shift]

    loop do
      break if @scanners.empty?
      puts @scanners.length
      puts @fixed_scanners.length
      @scanners.each do |scanner|
        found = @fixed_scanners.each do |fixed|
          alignment = try_alignment(fixed, scanner)
          if alignment
            puts alignment
            scanner.position = alignment
            scanner.adjusted_points.map{|p| p.join(',')}.sort.each{|x| puts x}
            @scanners -= [scanner]
            @fixed_scanners += [scanner]
            break true
          end
        end
        break if found
      end
    end
    @beacons.count
  end
end

puts BeaconScanners.new('input-test.txt').count_beacons

#test = Scanner.new
#test.add_points([-1, -1, 1])
#test.add_points([-2, -2, 2])
#test.add_points([-3, -3, 3])
#test.add_points([-2, -3, 1])
#test.add_points([5, 6, -4])
#test.add_points([8, 0, 7])
#0.upto(24) do |ori|
  #test.points_at_orientation(ori)
#end
