def best_alignment(positions, part2 = false)
  nums = positions.split(',').map(&:to_i)
  0.upto(nums.max).map{|pos| check_position(nums, pos, part2)}.min
end

def check_position(nums, pos, part2)
  if part2
    nums.map do |num|
      moves = (pos - num).abs
      (moves + 1)*(moves/2.0)
    end.sum.to_i
  else
    nums.map{|num| (pos - num).abs}.sum
  end
end

puts best_alignment('16,1,2,0,4,2,7,1,2,14')
puts best_alignment(IO.read('input.txt'))

puts best_alignment('16,1,2,0,4,2,7,1,2,14', true)
puts best_alignment(IO.read('input.txt'), true)
