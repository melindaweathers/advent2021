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

puts Reactor.new(-50, 50).reboot('input-test1.txt')
puts Reactor.new(-50, 50).reboot('input-test2.txt')
puts Reactor.new(-50, 50).reboot('input.txt')



