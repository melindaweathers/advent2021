class Machine
  attr_accessor :state
  def initialize(filename)
    @instructions = []
    IO.readlines(filename).each do |line|
      @instructions << line.chomp.split(' ')
    end
    @lowest_result = 414120
  end

  def init_state
    @state = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
  end

  def run(input)
    return false if input.include?('0')
    init_state
    input_arr = input.to_s.split('').map(&:to_i)
    @instructions.each do |ins, reg1, reg2|
      case ins
      when 'add' then s(reg1, g(reg1) + g(reg2))
      when 'mul' then s(reg1, g(reg1) * g(reg2))
      when 'div' then s(reg1, g(reg1) / g(reg2))
      when 'mod' then s(reg1, g(reg1) % g(reg2))
      when 'eql' then s(reg1, g(reg1) == g(reg2) ? 1 : 0)
      when 'inp' then s(reg1, input_arr.shift)
      end
    end
    res = g('z')
    if res < @lowest_result
      puts res, input
      @lowest_result = res
    end
    g('z') == 0
  end

  def eql(reg1, reg2)
    getval(reg1) == getval(reg2) ? setval(reg1, 1) : setval(reg1, 0)
  end

  def g(reg)
    @state[reg] || reg.to_i
  end

  def s(reg, val)
    @state[reg] = val
  end
end

#96929949996989
#414120
#96929949995989
#414120
#96929949994989
#414120
#96929949993989
#414120
#96929949992989
#414120

#machine = Machine.new('input.txt')
#9_999_999.downto(1_111_111) do |num|
  #digs = num.to_s.split('')
  #input = "#{digs[0]}#{digs[1]}#{digs[2]}#{digs[3]}99#{digs[4]}999#{digs[5]}9#{digs[6]}9"
  #result = machine.run(input)
  #if result
    #puts input
    #break
  #end
#end

#machine = Machine.new('input.txt')
#999_999.downto(111_111) do |num|
  #digs = num.to_s.split('')
  #input = "#{digs[0]}#{digs[1]}929#{digs[2]}#{digs[3]}#{digs[4]}9#{digs[5]}9389"
  #result = machine.run(input)
  #if result
    #puts input
    #break
  #end
#end
#15
#94929995999389
#14
#94929995989389
#13
#94929995979389
#12
#94929995969389
#11
#94929995959389
#10
#94929995949389
#9
#94929995939389
#8
#94929995929389
#7
#94929995919389
#0
#74929995999389
#74929995999389

machine = Machine.new('input.txt')
111_111.upto(999_999) do |num|
  digs = num.to_s.split('')
  11118151639389
  11118151639389
  11118151637189
  11118151637112
  input = "1111#{digs[0]}1#{digs[1]}1#{digs[2]}#{digs[3]}#{digs[4]}112"
  #input = "1412#{digs[0]}#{digs[1]}#{digs[2]}5#{digs[3]}#{digs[4]}9389"
  result = machine.run(input)
  if result
    puts input
    break
  end
end
