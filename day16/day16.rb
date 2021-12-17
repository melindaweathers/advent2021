class Packet
  attr_accessor :version, :type_id, :packets, :remainder, :literal
  def self.from_hex(str)
    new(str.hex.to_s(2).rjust(4*str.length, '0'))
  end

  def initialize(binary)
    @version = binary.slice(0..2).to_i(2)
    @type_id = binary.slice(3..5).to_i(2)
    @packets = []
    if @type_id == 4
      @literal, @remainder = parse_literal(binary.slice(6..-1))
    else
      parse_subpackets(binary.slice(6..-1))
    end
  end

  def parse_literal(binary)
    bits = ''
    loop do
      segment = binary.slice(0..4)
      binary = binary.slice(5..-1)
      bits << segment[1..-1]
      break if segment[0] == '0'
    end
    [bits.to_i(2), binary]
  end

  def parse_subpackets(binary)
    length_type_id = binary.slice(0)
    if length_type_id == '0'
      total_length = binary.slice(1..15).to_i(2)
      @remainder = binary.slice(total_length + 16..-1)
      binary = binary.slice(16..(total_length + 15))
      while binary.length > 0 do
        packet = Packet.new(binary)
        @packets << packet
        binary = packet.remainder
      end
    else
      num_subpackets = binary.slice(1..11).to_i(2)
      binary = binary.slice(12..-1)
      0.upto(num_subpackets - 1) do
        packet = Packet.new(binary)
        @packets << packet
        binary = packet.remainder
      end
      @remainder = binary
    end
  end

  def sum_versions
    version + packets.map(&:sum_versions).sum
  end

  def value
    case @type_id
    when 0
      @packets.map(&:value).inject(&:+)
    when 1
      @packets.map(&:value).inject(&:*)
    when 2
      @packets.map(&:value).min
    when 3
      @packets.map(&:value).max
    when 4
      @literal
    when 5
      @packets[0].value > @packets[1].value ? 1 : 0
    when 6
      @packets[0].value < @packets[1].value ? 1 : 0
    when 7
      @packets[0].value == @packets[1].value ? 1 : 0
    end
  end
end

puts 'Should be 2021:'
puts Packet.from_hex('D2FE28').literal
puts

puts Packet.from_hex('38006F45291200').sum_versions
puts Packet.from_hex('EE00D40C823060').sum_versions

puts 'Should be 16:'
puts Packet.from_hex('8A004A801A8002F478').sum_versions
puts

puts 'Should be 12:'
puts Packet.from_hex('620080001611562C8802118E34').sum_versions
puts

puts 'Should be 23:'
puts Packet.from_hex('C0015000016115A2E0802F182340').sum_versions
puts

puts 'Should be 31:'
puts Packet.from_hex('A0016C880162017C3686B18A3D4780').sum_versions
puts

puts 'First star:'
puts Packet.from_hex(File.read('input.txt').chomp).sum_versions


puts 'should be 3:'
puts Packet.from_hex('C200B40A82').value
puts

puts 'should be 54:'
puts Packet.from_hex('04005AC33890').value
puts

puts 'should be 7:'
puts Packet.from_hex('880086C3E88112').value
puts

puts 'should be 9:'
puts Packet.from_hex('CE00C43D881120').value
puts

puts 'should be 1:'
puts Packet.from_hex('D8005AC2A8F0').value
puts

puts 'should be 0:'
puts Packet.from_hex('F600BC2D8F').value

puts 'should be 0:'
puts Packet.from_hex('9C005AC2F8F0').value

puts 'should be 1'
puts Packet.from_hex('9C0141080250320F1802104A08').value

puts 'second star'
puts Packet.from_hex(File.read('input.txt').chomp).value
