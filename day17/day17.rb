class TrickShot
  def initialize(target)
    _, @minx, @maxx, @miny, @maxy = target.split(/=|\.\./).map(&:to_i)
  end

  def target_status(x, y)
    if x > @maxx || y < @miny
      :past
    elsif x.between?(@minx, @maxx) && y.between?(@miny, @maxy)
      :hit
    end
  end

  def tick(x, y, velx, vely)
    new_velx = if velx > 0
      velx - 1
    elsif velx < 0
      velx + 1
    else
      0
    end
    [x + velx, y + vely, new_velx, vely -= 1]
  end

  def try_velocity(velx, vely)
    highest_y = 0
    status = nil
    x = y = 0
    loop do
      break if status = target_status(x, y)
      x, y, velx, vely = tick(x, y, velx, vely)
      highest_y = y if y > highest_y
    end
    [status, highest_y]
  end

  def find_highest_y
    best_y = 0
    num_hits = 0
    0.upto(@maxx) do |x|
      @miny.upto(1000) do |y|
        status, this_y = try_velocity(x, y)
        best_y = this_y if status == :hit && this_y > best_y
        num_hits += 1 if status == :hit
      end
    end
    [best_y, num_hits]
  end
end

test_target = 'target area: x=20..30, y=-10..-5'
star_target = 'target area: x=124..174, y=-123..-86'

puts TrickShot.new(test_target).try_velocity(7,2)
puts TrickShot.new(test_target).try_velocity(6,3)
puts TrickShot.new(test_target).try_velocity(9,0)
puts TrickShot.new(test_target).try_velocity(7,7)

puts TrickShot.new(test_target).find_highest_y
puts TrickShot.new(star_target).find_highest_y
