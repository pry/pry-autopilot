$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

Pry.hooks.clear(:before_session)

my_pilot = PryAutopilot.new do
  on ->(frame) { frame.var("@i") == frame.var("x") } do
    puts "fizz (@i == x) x is #{frame.var("x")}"
  end

  on ->(frame) { frame.var("@i") == frame.var("y") } do
    puts "buzz (@i == y) y is #{frame.var("y")}"
  end

  on ->(frame) { frame.var("@i") == (frame.var("y") + frame.var("x")) } do
    puts "fizzbuzz (@i == (x + y)), (x + y) is #{frame.eval("x+y")}"
    run "exit-all"
  end

  # on ->(frame) { true } do
  #   run "step"
  # end
end

Pry.config.input = my_pilot

def fizzbuzz(x, y)
  binding.pry
  @i = 0
  1.upto(13) { |i| @i = i }
end

fizzbuzz(3, 5)

