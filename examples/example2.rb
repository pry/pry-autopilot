$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

Pry.config.auto_indent = false

class MyPilot < PryAutopilot
  # on ->(frame) { frame.locals.include?(:x) && frame.var("x") == 20 } do |input|
  #   puts "x was found equal to 20"
  #   input << "ls"
  #   input.interactive!
  # end

  on ->(frame) { true } do |input|
    input << "show-source"
    input << "next"
  end

end

Pry.config.input = MyPilot.new

def alpha
  x = "hello"
  binding.pry
  beta
end

def beta
  gamma
end

def gamma
  x = 20
  bing
end

def bing
  y = 33
  john = "carl"
end

alpha
