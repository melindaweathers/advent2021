class Polymer
  def initialize(filename)
    template_line, steps_lines = File.read(filename).split("\n\n")
    @template = template_line.chomp
    @steps = steps_lines.split("\n").map{|line| line.chomp.split(' -> ')}.to_h
  end

  def run_once
    result = ""
    0.upto(@template.length - 2) do |pos|
      result << @template[pos]
      insertion = @steps[@template[pos..pos+1]]
      result << insertion if insertion
    end
    result << @template[-1]
    @template = result
  end

  def run_steps(num)
    num.times { run_once }
    counts = @template.split('').uniq.map{|el| @template.count(el)}.sort
    counts.last - counts.first
  end
end

puts Polymer.new('input-test.txt').run_steps(10)
puts Polymer.new('input.txt').run_steps(10)
