class Edge
  attr_accessor :from, :to, :small_cave_visits
  def initialize(str, small_cave_visits)
    @from, @to = str.chomp.split('-')
    @small_cave_visits = small_cave_visits
  end

  def take(path)
    if path.last == from
      to if can_visit?(to, path)
    elsif path.last == to
      from if can_visit?(from, path)
    end
  end

  def can_visit?(point, path)
    return !path.include?(point) if ['start', 'end'].include?(point)
    point.upcase == point || path.count(point) < remaining_small_cave_visits(path)
  end

  def remaining_small_cave_visits(path)
    return 1 if small_cave_visits == 1
    path.any?{|point| point.upcase != point && path.count(point) > 1} ? 1 : 2
  end

  def contains?(point)
    point == from || point == to
  end
end

class Graph
  def initialize(filename, small_cave_visits = 1)
    @edges = IO.readlines(filename).map{|line| Edge.new(line, small_cave_visits)}
  end

  def count_paths
    starting_paths = @edges.select{|edge| edge.contains?('start')}.map{|edge| ['start', edge.take(['start'])]}
    all_paths(starting_paths).length
  end

  def print_paths(paths)
    paths.each{|path| puts path.join('-')}
  end

  def all_paths(paths, complete_paths = [])
    loop do
      new_paths = []
      paths.each do |path|
        new_paths += path_steps(path)
      end
      paths = new_paths
      break if paths.all? {|path| path.last == 'end'}
    end
    paths
  end

  def path_steps(path)
    return [path] if path.last == 'end'
    @edges.map do |edge|
      point = edge.take(path)
      path + [point] if point
    end.compact
  end
end

puts Graph.new('input-test1.txt').count_paths
puts Graph.new('input-test2.txt').count_paths
puts Graph.new('input-test3.txt').count_paths
puts Graph.new('input.txt').count_paths

puts Graph.new('input-test1.txt', 2).count_paths
puts Graph.new('input-test2.txt', 2).count_paths
puts Graph.new('input-test3.txt', 2).count_paths
puts Graph.new('input.txt', 2).count_paths
