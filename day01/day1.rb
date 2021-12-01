def count_increases(filename)
  last_num = 10000000
  count = 0
  IO.readlines(filename).map(&:to_i).each do |num|
    count += 1 if num > last_num
    last_num = num
  end
  count
end

puts count_increases('input.txt')

def count_sliding(filename)
  last_total = 100000000
  nums = IO.readlines(filename).map(&:to_i)
  count = 0
  0.upto(nums.length - 3) do |i|
    total = nums[i] + nums[i+1] + nums[i+2]
    count += 1 if total > last_total
    last_total = total
  end
  count
end

puts count_sliding('test-input.txt')
puts count_sliding('input.txt')
