def count_easy_digits(filename)
  IO.readlines(filename).map do |line|
    output = line.split(' | ')[1]
    output.split(' ').select{|x| [2,3,4,7].include?(x.length)}.length
  end.sum
end

puts count_easy_digits('input-test.txt')
puts count_easy_digits('input.txt')

VALID_NUMS = %w|abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg|
CHARS = %w|a b c d e f g|
PERMUTATIONS = CHARS.permutation.to_a.map{|perm| perm.join('')}

def find_output(inputs, outputs)
  PERMUTATIONS.each do |perm|
    return calc_output(outputs, perm) if sensible?(inputs + outputs, perm)
  end
  nil
end

def num_for_perm(val, perm)
  VALID_NUMS.index(val.tr('abcdefg',perm).split('').sort.join(''))
end

def sensible?(nums, perm)
  nums.all?{|num| num_for_perm(num, perm)}
end

def calc_output(nums, perm)
  nums.map{|num| num_for_perm(num, perm)}.join('').to_i
end

def find_outputs(filename)
  IO.readlines(filename).map do |line|
    inputs, outputs = line.split(' | ').map{|part| part.split(' ')}
    find_output(inputs, outputs)
  end.sum
end

puts find_outputs('input-test.txt')
puts find_outputs('input.txt')
