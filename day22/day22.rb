class Reactor
  def initialize(minval, maxval)
    @space = Hash.new(0)
    @min = minval
    @max = maxval
  end

  def reboot(filename)
    IO.readlines(filename).each do |line|
      valstr, _, fromx, tox, _, fromy, toy, _, fromz, toz = line.split(/[ =,]|\.\./)
      toggle_cube(valstr == 'on' ? 1 : 0, fromx.to_i, tox.to_i, fromy.to_i, toy.to_i, fromz.to_i, toz.to_i)
    end
    @space.values.sum
  end

  def toggle_cube(val, fromx, tox, fromy, toy, fromz, toz)
    fromx = [fromx, @min].max
    tox = [tox, @max].min
    fromy = [fromy, @min].max
    toy = [toy, @max].min
    fromz = [fromz, @min].max
    toz = [toz, @max].min
    fromx.upto(tox) do |x|
      fromy.upto(toy) do |y|
        fromz.upto(toz) do |z|
          @space[[x, y, z]] = val
        end
      end
    end
  end
end

#puts Reactor.new(-50, 50).reboot('input-test1.txt')
#puts Reactor.new(-50, 50).reboot('input-test2.txt')
#puts Reactor.new(-50, 50).reboot('input.txt')


class BetterReactor
  def initialize
    @oncubes = []
  end

  def reboot(filename)
    IO.readlines(filename).each do |line|
      valstr, _, fromx, tox, _, fromy, toy, _, fromz, toz = line.split(/[ =,]|\.\./)
      toggle_cube(valstr == 'on', fromx.to_i, tox.to_i, fromy.to_i, toy.to_i, fromz.to_i, toz.to_i)
    end
    count_oncubes
  end

  def count_oncubes
    @oncubes.map do |fromx, tox, fromy, toy, fromz, toz|
      (tox - fromx + 1) * (toy - fromy + 1) * (toz - fromz + 1)
    end.sum
  end

  def toggle_cube(on, newfromx, newtox, newfromy, newtoy, newfromz, newtoz)
    newoncubes = []
    @oncubes.each do |onfromx, ontox, onfromy, ontoy, onfromz, ontoz|
      if intersects?(newfromx, newtox, newfromy, newtoy, newfromz, newtoz, onfromx, ontox, onfromy, ontoy, onfromz, ontoz)
        fromx = [onfromx, newfromx].max
        tox = [ontox, newtox].min
        fromy = [onfromy, newfromy].max
        toy = [ontoy, newtoy].min
        fromz = [onfromz, newfromz].max
        toz = [ontoz, newtoz].min
        [[onfromx, fromx-1], [fromx, tox], [tox+1, ontox]].each do |smallfromx, smalltox|
          [[onfromy, fromy-1], [fromy, toy], [toy+1, ontoy]].each do |smallfromy, smalltoy|
            [[onfromz, fromz-1], [fromz, toz], [toz+1, ontoz]].each do |smallfromz, smalltoz|
              unless smallfromx == fromx && smalltox == tox && smallfromy == fromy && smalltoy == toy && smallfromz == fromz && smalltoz == toz
                new_cube = [smallfromx, smalltox, smallfromy, smalltoy, smallfromz, smalltoz]
                newoncubes << new_cube if valid_cube?(*new_cube)
              end
            end
          end
        end
      else
        newoncubes << [onfromx, ontox, onfromy, ontoy, onfromz, ontoz]
      end
    end
    newoncubes << [newfromx, newtox, newfromy, newtoy, newfromz, newtoz] if on
    @oncubes = newoncubes
    #print_state
  end

  def print_state
    puts
    puts
    puts "#{count_oncubes} ON"
    @oncubes.each{|vals| puts vals.join(' ')}
  end

  def valid_cube?(fromx, tox, fromy, toy, fromz, toz)
    fromx <= tox && fromy <= toy && fromz <= toz
  end

  def intersects?(fromx, tox, fromy, toy, fromz, toz, onfromx, ontox, onfromy, ontoy, onfromz, ontoz)
    onfromx <= tox && ontox >= fromx && onfromy <= toy && ontoy >= fromy && onfromz <= toz && ontoz >= fromz
  end
end

puts BetterReactor.new.reboot('input-test1.txt')
puts BetterReactor.new.reboot('input.txt')
