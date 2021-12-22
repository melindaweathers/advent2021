Player = Struct.new(:pos, :score)
class PracticeGame
  def initialize(p1, p2)
    @p1 = Player.new(p1 - 1, 0)
    @p2 = Player.new(p2 - 1, 0)
    @die = 1
    @die_rolls = 0
  end

  def play_round
    run_player @p1
    return @p2.score * @die_rolls if @p1.score >= 1000

    run_player(@p2)
    return @p1.score * @die_rolls if @p2.score >= 1000

    nil
  end

  def play
    loop do
      score = play_round
      break score if score
    end
  end

  def roll
    @die_rolls += 1
    @die += 1
    @die - 1
  end

  def run_player(player)
    player.pos = (player.pos + roll + roll + roll) % 10
    player.score += player.pos + 1
  end
end

puts PracticeGame.new(4, 8).play
puts PracticeGame.new(6, 1).play

FINAL_ROLLS = { 3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1 }
class DiracGame
  def initialize(p1, p2)
    @possibilities = {[0, p1 - 1, 0, p2 - 1] => 1}
    @p1_wins = 0
    @p2_wins = 0
  end

  def play_round
    new_possibilities = Hash.new(0)
    @possibilities.each do |state, num|
      p1_score, p1_pos, p2_score, p2_pos = state
      FINAL_ROLLS.each do |offset, num_for_offset|
        new_p1_pos = (p1_pos + offset) % 10
        new_p1_score = p1_score + new_p1_pos + 1
        if new_p1_score >= 21
          @p1_wins += num_for_offset * num
        else
          FINAL_ROLLS.each do |p2_offset, p2_num_for_offset|
            new_p2_pos = (p2_pos + p2_offset) % 10
            new_p2_score = p2_score + new_p2_pos + 1
            if new_p2_score >= 21
              @p2_wins += p2_num_for_offset * num * num_for_offset
            else
              new_possibilities[[new_p1_score, new_p1_pos, new_p2_score, new_p2_pos]] += num * num_for_offset * p2_num_for_offset
            end
          end
        end
      end
    end
    @possibilities = new_possibilities
  end

  def play
    21.times { play_round }
    [@p1_wins, @p2_wins].max
  end
end

puts DiracGame.new(4, 8).play
puts DiracGame.new(6, 1).play
