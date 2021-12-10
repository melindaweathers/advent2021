MATCHES = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
CLOSER_SCORE = { ')' => 3, ']' =>  57, '}'  => 1197, '>' => 25137 }
INC_SCORE = { ')' => 1, ']' =>  2, '}'  => 3, '>' => 4 }

def score_corrupted(filename)
  IO.readlines(filename).map do |line|
    corrupt_line_score(line.chomp).to_i
  end.sum
end

def corrupt_line_score(line)
  stack = []
  line.each_char do |char|
    if MATCHES.keys.include?(char)
      stack.push(char)
    elsif MATCHES.values.include?(char)
      return CLOSER_SCORE[char] unless MATCHES[stack.pop] == char
    end
  end
  0
end

puts score_corrupted('input-test.txt')
puts score_corrupted('input.txt')

def score_incomplete(filename)
  scores = IO.readlines(filename).map do |line|
    corrupt_line_score(line.chomp) > 0 ? nil : incomplete_line_score(line.chomp)
  end.compact.sort
  scores[scores.length / 2]
end

def incomplete_line_score(line)
  stack = []
  line.each_char do |char|
    if MATCHES.keys.include?(char)
      stack.push(char)
    elsif MATCHES.values.include?(char)
      stack.pop
    end
  end
  score = 0
  stack.reverse.each do |opener|
    score = score * 5 + INC_SCORE[MATCHES[opener]]
  end
  score
end

puts score_incomplete('input-test.txt')
puts score_incomplete('input.txt')
