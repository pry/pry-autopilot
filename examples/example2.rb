$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

my_pilot = PryAutopilot.new do
  on ->(frame) { frame.method_name == :gamma } do |input|
    input << "puts 'welcome to gamma!'"
    input.interactive!
  end

  on ->(frame) { true } do |input|
    input << "ls"
    input << "step"
  end
end

Pry.config.input = my_pilot

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
