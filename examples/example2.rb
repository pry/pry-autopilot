$:.unshift File.expand_path '../../lib', __FILE__
require 'pry'
require 'pry-autopilot'

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
