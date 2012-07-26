$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

Pry.config.auto_indent = false

class MyPilot < PryAutopilot
  # on ->(frame) { frame.method_name == :bing } do
  #   input << "ls"
  #   input << "cd 1/2/3/4/5"
  #   input << "ls -m"
  #   input << "puts 'odelay!'"
  #   interactive!
  # end

  # on ->(frame) { true } do
  #   input << "ls"
  #   input << "step"
  # end

  on ->(frame) { frame.class_name == :Pry } do |input|
    input << "puts you're in Pry lol\n"
    input << "doing an ls!\n"
    input << "ls\n"
    puts "hey baby 1"
    input << "ls"
    input << "cd-ing into your mom\n"
    puts "love bum 2"
    input << "cd :your_mom\n"
    puts "tricky malone 3"
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
