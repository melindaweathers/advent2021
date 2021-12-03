def sub_position(filename)
  depth_horiz = [0,0]
  IO.readlines(filename).each do |line|
    depth_horiz = new_coords(line, depth_horiz)
  end
  depth_horiz.inject(:*)
end

def new_coords(line, old)
  dir, amount = line.split(' ')
  if dir == 'forward'
    [old[0], old[1] + amount.to_i]
  elsif dir == 'down'
    [old[0] + amount.to_i, old[1]]
  elsif dir == 'up'
    [old[0] - amount.to_i, old[1]]
  end
end

puts sub_position('input-test.txt')
puts sub_position('input.txt')

def sub_position_aim(filename)
  depth_horiz_aim = [0,0,0]
  IO.readlines(filename).each do |line|
    depth_horiz_aim = new_coords_aim(line, depth_horiz_aim)
  end
  depth_horiz_aim[0]*depth_horiz_aim[1]
end

def new_coords_aim(line, old)
  dir, amount = line.split(' ')
  if dir == 'forward'
    [old[0] + amount.to_i * old[2], old[1] + amount.to_i, old[2]]
  elsif dir == 'down'
    [old[0], old[1], old[2] + amount.to_i]
  elsif dir == 'up'
    [old[0], old[1], old[2] - amount.to_i]
  end
end

puts sub_position_aim('input-test.txt')
puts sub_position_aim('input.txt')
