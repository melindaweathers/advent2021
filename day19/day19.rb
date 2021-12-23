class Scanner
  attr_accessor :points, :orientation, :xoff, :yoff, :zoff, :parent, :name, :failed_aligns
  def initialize(name)
    @points = []
    @parent = nil
    @name = name
    @failed_aligns = []
  end

  def add_points(xyz)
    @points << xyz
  end

  def position=(pos)
    @orientation, @xoff, @yoff, @zoff = pos
  end

  def adjusted_points
    points_at_orientation(@orientation, 0, 0, 0)
    #points_at_orientation(0, 0, 0, 0)
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
    #puts "Trying to align #{not_fixed.name} with #{fixed.name}"
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
        #puts "CORRECT POINTS"
        #offsets[winner].each {|p| puts p.join(',')}
        #@beacons += offsets[winner]
        #@beacons.uniq!
        #puts @beacons.length
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
      #puts @scanners.length
      @scanners.each do |scanner|
        found = false
        @fixed_scanners.each do |fixed|
          alignment = try_alignment(fixed, scanner)
          if alignment
            #puts alignment
            scanner.position = alignment
            scanner.parent = fixed
            @beacons += scanner.well_adjusted_points
            @beacons.uniq!
            #scanner.well_adjusted_points.map{|p| p.join(',')}.sort.each{|x| puts x}
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

  #def count_beacons_temp
    #@scanners[0].position = [0, 0, 0, 0]
    #alignment = try_alignment(@scanners[0], @scanners[1])
    #if alignment
      #puts alignment
      #@scanners[1].position = alignment
      #@scanners[1].parent = @scanners[0]
      #puts "ADJUSTED POINTS"
      #@scanners[1].well_adjusted_points.map{|p| p.join(',')}.sort.each{|x| puts x}
    #end


    #puts
    #puts "Trying scanner 4"
    #alignment = try_alignment(@scanners[1], @scanners[4])
    #if alignment
      #puts alignment
      #@scanners[4].position = alignment
      #@scanners[4].parent = @scanners[1]
      #puts "ADJUSTED POINTS"
      #@scanners[4].well_adjusted_points.map{|p| p.join(',')}.sort.each{|x| puts x}
    #end
  #end
end

puts BeaconScanners.new('input-test.txt').count_beacons
puts BeaconScanners.new('input.txt').count_beacons

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
