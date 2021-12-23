class Scanner
  attr_accessor :points, :orientation, :xoff, :yoff, :zoff, :name, :failed_aligns
  def initialize(name)
    @points = []
    @name = name
    @failed_aligns = []
  end

  def add_points(xyz)
    @points << xyz
  end

  def position=(pos)
    @orientation, @xoff, @yoff, @zoff = pos
  end

  def well_adjusted_points
    points_at_orientation(@orientation, @xoff, @yoff, @zoff)
  end

  def points_at_orientation(orientation, xoff, yoff, zoff)
    @points.map do |point|
      newx, newy, newz = point_at_orientation(orientation, *point)
      [newx + xoff, newy + yoff, newz + zoff]
    end
  end

  def point_at_orientation(orientation, x, y, z)
    case orientation
    when 0 then [x, y, z]
    when 1 then [x, z, -y]
    when 2 then [x, -y, -z]
    when 3 then [x, -z, y]
    when 4 then [-x, z, y]
    when 5 then [-x, y, -z]
    when 6 then [-x, -z, -y]
    when 7 then [-x, -y, z]
    when 8 then [y, z, x]
    when 9 then [y, x, -z]
    when 10 then [y, -z, -x]
    when 11 then [y, -x, z]
    when 12 then [-y, x, z]
    when 13 then [-y, z, -x]
    when 14 then [-y, -x, -z]
    when 15 then [-y, -z, x]
    when 16 then [z, x, y]
    when 17 then [z, y, -x]
    when 18 then [z, -x, -y]
    when 19 then [z, -y, x]
    when 20 then [-z, y, x]
    when 21 then [-z, x, -y]
    when 22 then [-z, -y, -x]
    when 23 then [-z, -x, y]
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
        @scanners[idx] = Scanner.new("Scanner #{idx}")
      elsif line.length > 2
        @scanners[idx].add_points(line.chomp.split(',').map(&:to_i))
      end
    end
  end

  def try_alignment(fixed, not_fixed)
    return if not_fixed.failed_aligns.include?(fixed)
    offsets = {}
    0.upto(23) do |ori|
      offsets = {}
      fixed.well_adjusted_points.each do |point|
        correctx, correcty, correctz = point
        not_fixed.points_at_orientation(ori, 0, 0, 0).each do |test|
          testx, testy, testz = test
          offset_point = [correctx - testx, correcty - testy, correctz - testz]
          (offsets[offset_point] ||= []) << [correctx, correcty, correctz]
        end
      end
      if winner = offsets.select{|k, v| v.uniq.length >= 12}.keys.first
        return [ori, winner[0], winner[1], winner[2]]
      end
    end
    not_fixed.failed_aligns << fixed
    nil
  end

  def count_beacons
    @scanners[0].position = [0, 0, 0, 0]
    @beacons += @scanners[0].well_adjusted_points
    @fixed_scanners = [@scanners.shift]

    loop do
      break if @scanners.empty?
      @scanners.each do |scanner|
        found = false
        @fixed_scanners.each do |fixed|
          alignment = try_alignment(fixed, scanner)
          if alignment
            scanner.position = alignment
            @beacons += scanner.well_adjusted_points
            @beacons.uniq!
            @scanners -= [scanner]
            @fixed_scanners += [scanner]
            puts "Aligned #{scanner.name}"
            found = true
            break
          end
        end
        break if found
      end
    end
    @beacons.count
  end

  def manhattan_distance(scanner1, scanner2)
    (scanner1.xoff - scanner2.xoff).abs +
      (scanner1.yoff - scanner2.yoff).abs +
      (scanner1.zoff - scanner2.zoff).abs
  end

  def max_distance
    best = 0
    0.upto(@fixed_scanners.length - 1) do |idx1|
      0.upto(@fixed_scanners.length - 1) do |idx2|
        best = [best, manhattan_distance(@fixed_scanners[idx1], @fixed_scanners[idx2])].max
      end
    end
    best
  end
end

test_scanner = BeaconScanners.new('input-test.txt')
puts test_scanner.count_beacons
puts test_scanner.max_distance

real_scanner = BeaconScanners.new('input.txt')
puts real_scanner.count_beacons
puts real_scanner.max_distance
