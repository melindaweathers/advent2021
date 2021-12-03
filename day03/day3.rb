def find_rates(filename, bits)
  nums = IO.readlines(filename).map{|n| n.to_i(2)}
  gamma = 0
  0.upto(bits - 1) do |bit|
    gamma |= 2**bit if popular_bit?(bit, nums)
  end
  gamma_times_epsilon(gamma, bits)
end

def gamma_times_epsilon(gamma, bits)
  epsilon = gamma ^ (2**bits - 1)
  epsilon * gamma
end

def popular_bit?(bit, nums)
  half = (nums.length / 2.0).ceil
  mask = 2 ** bit
  nums.map{|num| (num & mask) >> bit}.sum >= half
end

puts find_rates('input-test.txt', 5)
puts find_rates('input.txt', 12)


def find_life_support_rate(filename, bits)
  nums = IO.readlines(filename).map{|n| n.to_i(2)}
  o2_nums = nums
  co2_nums = nums

  (bits - 1).downto(0) do |bit|
    o2_nums = filter_nums(o2_nums, popular_bit?(bit, o2_nums) ? 1 : 0, bit)
    co2_nums = filter_nums(co2_nums, popular_bit?(bit, co2_nums) ? 0 : 1, bit)
  end
  o2_nums.first * co2_nums.first
end

def filter_nums(nums, val, bit)
  return nums if nums.length == 1
  nums.select{|num| (num & (2**bit)) >> bit == val}
end

puts find_life_support_rate('input-test.txt', 5)
puts find_life_support_rate('input.txt', 12)
