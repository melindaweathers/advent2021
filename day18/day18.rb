def explode(str)
  from, to, arr = fourth_nested(str)
  if from
    #puts "exploding: #{str}"
    str[from..to] = '0'
    #puts "zero replaced: #{str}"
    str = add_to_right(str, from + 1, arr[1])
    #puts "added to right: #{str}"
    str = add_to_left(str, from - 1, arr[0])
    #puts "added to left: #{str}"
    str
  else
    false
  end
end

def add(str1, str2)
  return str2 unless str1
  str = "[#{str1},#{str2}]"
  reduce(str)
end

def split(str)
  from, to, num = large_number(str)
  if from
    str[from..to] = "[#{(num/2.0).floor},#{(num/2.0).ceil}]"
    str
  else
    false
  end
end

def reduce(str)
  loop do
    did_split = nil
    did_explode = explode(str)
    if did_explode
      #puts "after explode: #{did_explode}"
      str = did_explode
    else
      did_split = split(str)
      #puts "after split: #{did_split}" if did_split
      str = did_split if did_split
    end
    break unless did_explode || did_split
  end
  str
end

def fourth_nested(str)
  nested = 0
  from = to = nil
  str.split('').each_with_index do |char, idx|
    if char == '['
      nested += 1
    elsif char == ']'
      to = idx if nested == 5
      nested -= 1
    end
    from = idx if nested == 5 && !from

    return from, to, eval(str[from..to]) if to
  end
  nil
end

def add_to_left(str, index, num)
  from = to = nil
  index.downto(0) do |idx|
    if str[idx] =~ /\d/
      from = to = idx
      from -= 1 if idx > 0 && str[idx - 1] =~ /\d/
      str[from..to] = (num.to_i + str[from..to].to_i).to_s
      break
    end
  end
  str
end

def add_to_right(str, index, num)
  from = to = nil
  index.upto(str.length - 1) do |idx|
    if str[idx] =~ /\d/
      from = to = idx
      to += 1 if str[idx + 1] =~ /\d/
      str[from..to] = (num.to_i + str[from..to].to_i).to_s
      break
    end
  end
  str
end

def large_number(str)
  prev = ''
  from = to = nil
  0.upto(str.length - 2) do |idx|
    if str[idx..idx+1] =~ /\d\d/
      from = idx
      to = idx + 1
      return idx, idx + 1, str[idx..idx+1].to_i
    end
  end
  nil
end

def add_all(filename)
  str = nil
  IO.readlines(filename).each do |line|
    str = add(str, line.chomp)
    #puts "RESULT OF ADD: #{str}"
  end
  str
end

def magnitude(str)
  magnitude_cheating(eval(str))
end

def magnitude_cheating(arr)
  if arr.is_a?(Array)
    3*magnitude_cheating(arr[0]) + 2*magnitude_cheating(arr[1])
  else
    arr
  end
end

def largest_magnitude(filename)
  snailfishes = IO.readlines(filename).map{|line| line.chomp }
  largest = 0
  0.upto(snailfishes.length - 1) do |x|
    0.upto(snailfishes.length - 1) do |y|
      largest = [largest, magnitude(add(snailfishes[x], snailfishes[y]))].max unless x == y
    end
  end
  largest
end

puts explode('[[[[[9,8],1],2],3],4]') == '[[[[0,9],2],3],4]'
puts explode('[7,[6,[5,[4,[3,2]]]]]') == '[7,[6,[5,[7,0]]]]'
puts explode('[[6,[5,[4,[3,2]]]],1]') == '[[6,[5,[7,0]]],3]'
puts explode('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]') == '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'
puts explode('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]') == '[[3,[2,[8,0]]],[9,[5,[7,0]]]]'
puts add_all('input-small.txt') == '[[[[5,0],[7,4]],[5,5]],[6,6]]'
puts add_all('input-test.txt') == '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]'
puts magnitude('[[1,2],[[3,4],5]]') == 143
puts magnitude('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]') == 1384
puts magnitude('[[[[1,1],[2,2]],[3,3]],[4,4]]') == 445
puts magnitude('[[[[3,0],[5,3]],[4,4]],[5,5]]') == 791
puts magnitude('[[[[5,0],[7,4]],[5,5]],[6,6]]') == 1137
puts magnitude('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]') == 3488
puts magnitude(add_all('input-test2.txt')) == 4140
puts largest_magnitude('input-test2.txt') == 3993

puts magnitude(add_all('input.txt'))
puts largest_magnitude('input.txt')
