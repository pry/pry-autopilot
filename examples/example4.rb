$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

Pry.hooks.clear(:before_session)

my_pilot = PryAutopilot.new do
  on ->(frame) { frame.var("@i") == frame.var("x") } do |input|
    input << "puts \"fizz (@i == x) x is \" + x.to_s"
  end

  on ->(frame) { frame.var("@i") == frame.var("y") } do |input|
    input << "puts \"buzz (@i == y) y is \" + y.to_s"
  end

  on ->(frame) { frame.var("@i") == (frame.var("y") + frame.var("x")) } do |input|
    input << "puts 'fizzbuzz (@i == (x + y)), (x + y) is ' + (x+y).to_s"
    input << "exit-all"
  end

  on ->(frame) { true } do |input|
    input << "step"
  end
end

Pry.config.input = my_pilot

def fizzbuzz(x, y)
  binding.pry
  @i = 0
  1.upto(100) { |i| @i = i }
end

fizzbuzz(3, 5)

