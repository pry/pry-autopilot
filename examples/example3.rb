$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

my_pilot = PryAutopilot.new do
  on ->(frame) { frame.method_name == :fact && frame.var("value") == 2 } do |input|
    input << "puts 'interactive mode!'"
    input.interactive!
  end

  on ->(frame) { frame.method_name == :fact } do |input|
    input << "next"
  end
end

Pry.config.input = my_pilot

def fact(value)
  binding.pry
  if value == 0
    1
  else
    value * fact(value - 1)
  end
end

fact(5)
