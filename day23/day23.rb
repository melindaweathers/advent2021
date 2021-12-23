ENERGIES = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }
HOMES = { 'A' => [7, 8], 'B' => [9, 10], 'C' => [11, 12], 'D' => [13, 14] }
CRAPPY_HACK = { 7 => 1.5, 8 => 1.5, 9 => 2.5, 10 => 2.5, 11 => 3.5, 12 => 3.5, 13 => 4.5, 14 => 4.5 }
DISTS = [
  [0, 1, 3, 5, 7, 9, 10, 3, 4, 5, 6, 7, 8, 9, 10],
  [1, 0, 2, 4, 6, 8, 9,  2, 3, 4, 5, 6, 7, 8, 9],
  [3, 1, 0, 2, 4, 6, 7,  2, 3, 2, 3, 4, 5, 6, 7],
  [5, 4, 2, 0, 2, 4, 5,  4, 5, 2, 3, 2, 3, 4, 5],
  [7, 6, 4, 2, 0, 2, 3,  6, 7, 4, 5, 2, 3, 2, 3],
  [9, 8, 6, 4, 2, 0, 1,  8, 9, 6, 7, 4, 5, 2, 3],
  [10,9, 7, 5, 3, 1, 0,  9,10, 7, 8, 5, 6, 3, 4],
  [3, 2, 2, 4, 6, 8, 9,  0, 1, 4, 5, 6, 7, 8, 9],
  [4, 3, 3, 5, 7, 9, 10, 1, 0, 5, 6, 7, 8, 9, 10],
  [5, 4, 2, 2, 4, 6, 7,  4, 5, 0, 1, 4, 5, 6, 7],
  [6, 5, 3, 3, 5, 7, 8,  5, 6, 1, 0, 5, 6, 7, 8],
  [7, 6, 4, 2, 2, 4, 5,  6, 7, 4, 5, 0, 1, 4, 5],
  [8, 7, 5, 3, 3, 5, 6,  7, 8, 5, 6, 1, 0, 5, 6],
  [9, 8, 6, 4, 2, 2, 3,  8, 9, 6, 7, 4, 5, 0, 1],
  [10,9, 7, 5, 3, 3, 4,  9,10, 7, 8, 5, 6, 1, 0]
]
class Amphipod
  attr_accessor :letter
  def initialize(letter)
    @letter = letter
  end

  def to_s
    letter
  end

  def energy
    ENERGIES[letter]
  end

  def homes
    HOMES[letter]
  end

  def at_home?(burrow, pos)
    (homes[0] == pos && burrow[pos - 1]&.letter == letter) ||
      (homes[1] == pos && (burrow[pos - 1].nil? || burrow[pos - 1].letter == letter))
  end

  def moves(burrow, pos)
    if pos.between?(0, 6)
      occupants = homes.map{|home| burrow[home]}
      if occupants.any?{|occ| occ && occ.to_s != letter}
        []
      elsif occupants.compact.length == 0
        [homes[1]]
      else
        [homes[0]]
      end
    elsif at_home?(burrow, pos)
      []
    else
      [0, 1, 2, 3, 4, 5, 6].map do |pos|
        burrow[pos] ? nil : pos
      end.compact
    end.select{|to| path_is_clear?(burrow, pos, to)}
  end

  def path_is_clear?(burrow, from, to)
    if [8, 10, 12, 14].include?(from)
      return false if burrow[from - 1]
      from = from - 1
    end

    from = CRAPPY_HACK[from] if from > 6
    to = CRAPPY_HACK[to] if to > 6
    from, to = [from, to].min.floor + 1, [from, to].max.ceil - 1

    from.upto(to) do |pos|
      return false if burrow[pos]
    end
    true
  end
end

class Burrow
  attr_accessor :map
  def initialize(str)
    @map = Array.new(15)
    @pods = []
    str.split('').each_with_index do |letter, idx|
      pos = idx + 7
      @map[pos] = Amphipod.new(letter)
      @pods << @map[pos]
    end
  end

  def at(map, pos)
    (map[pos] || '.').to_s
  end

  def print(m)
    puts '#############'
    puts "##{at m, 0}#{at m, 1}.#{at m, 2}.#{at m, 3}.#{at m, 4}.#{at m, 5}#{at m, 6}#"
    puts "####{at m, 7}##{at m, 9}##{at m, 11}##{at m, 13}###"
    puts "####{at m, 8}##{at m, 10}##{at m, 12}##{at m, 14}###"
    puts '  #########'
  end

  def possible_moves(map)
    non_home_moves = []
    home_moves = []
    map.each_with_index do |pod, idx|
      next unless pod
      pod.moves(map, idx).each do |to|
        info = [idx, to, pod.energy * DISTS[idx][to]]
        to > 6 ? home_moves << info : non_home_moves << info
      end
    end
    #moves.each{|move|puts move.join(' -> ')}
    home_moves.length > 0 ? home_moves : non_home_moves
  end

  #def complete?(map)
    #map[7]&.letter == 'A' && map[8]&.letter == 'A' &&
      #map[9]&.letter == 'B' && map[10]&.letter == 'B' &&
      #map[11]&.letter == 'C' && map[12]&.letter == 'C' &&
      #map[13]&.letter == 'D' && map[14]&.letter == 'D'
  #end
  def complete?(map)
    HOMES.each do |letter, vals|
      vals.each{|val| return false unless map[val]&.letter == letter}
    end
    true
  end

  def take_move(map, move)
    new_map = map.clone
    from, to, _cost = move
    pod = new_map[from]
    new_map[from] = nil
    new_map[to] = pod
    new_map
  end

  def find_best_path
    @best_costs = Hash.new(100000000)
    best_path(@map, 0, [])
  end

  def best_path(map, cost, past_states)
    if complete?(map)
      #puts cost
      cost
    elsif @best_costs[map] < cost
      nil
    else
      @best_costs[map] = cost
      possible_moves(map).map do |move|
        from, to, new_cost = move
        new_map = take_move(map, move)
        #print new_map
        if past_states.include?(new_map)
          nil
        else
          best_path(new_map, cost + new_cost, past_states + [map])
        end
      end.compact.min
    end
  end

end

test = Burrow.new('BACDBCDA')
puts test.find_best_path

burrow = Burrow.new('DCACABDB')
puts burrow.find_best_path
