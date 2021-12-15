class Polymer
  def initialize(filename)
    template_line, steps_lines = File.read(filename).split("\n\n")
    @template = template_line.chomp
    @steps = steps_lines.split("\n").map{|line| line.chomp.split(' -> ')}.to_h
    @template_hash = Hash.new(0)
    0.upto(@template.length - 2) do |pos|
      @template_hash[@template[pos..pos+1]] += 1
    end
    @template_hash[@template[-1]] = 1
  end

  def run_once
    new_hash = Hash.new(0)
    @template_hash.each do |k, v|
      insert_letter = @steps[k]
      if insert_letter
        new_hash["#{k[0]}#{insert_letter}"] += v
        new_hash["#{insert_letter}#{k[1]}"] += v
      else
        new_hash[k] = v
      end
    end
    @template_hash = new_hash
  end

  def run_steps(num)
    num.times { run_once }
    counts = Hash.new(0)
    @template_hash.each do |k, v|
      counts[k[0]] += v
    end
    sorted_counts = counts.values.sort
    sorted_counts.last - sorted_counts.first
  end
end

puts Polymer.new('input-test.txt').run_steps(10)
puts Polymer.new('input.txt').run_steps(10)

puts Polymer.new('input-test.txt').run_steps(40)
puts Polymer.new('input.txt').run_steps(40)
