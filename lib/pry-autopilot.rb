# pry-autopilot.rb

require "pry-autopilot/version"
require "pry-autopilot/frame"

class PryAutopilot
  class << self
    attr_reader :predicates

    def on(predicate, &block)
      @predicates ||= []
      @predicates << [predicate, block]
    end
  end

  attr_accessor :input

  def initialize(_pry_)
    @pry = _pry_
    @input = []
  end

  def readline(prompt)
    process_predicates if input.empty?
    input.shift || Readline.readline(prompt)
  end

  private
  def frame
    Frame.new(@pry.current_context)
  end

  def process_predicates
    predicates.each do |predicate, block|
      if predicate.call(frame)
        instance_exec(&block)
      end
    end
  end

  def predicates
    self.class.predicates
  end

  def interactive!
    input << "_pry_.input = Readline"
  end
end

class MyPilot < PryAutopilot
  on ->(frame) { frame.method_name == :bing } do
    input << "ls"
    input << "cd 1/2/3/4/5"
    input << "ls -m"
    input << "puts 'odelay!'"
    interactive!
  end

  on ->(frame) { true } do
    input << "ls"
    input << "step"
  end
end

Pry.config.auto_indent = false
Pry.config.hooks.add_hook(:when_started, :autopilot) do |_, _, _pry_|
  _pry_.input = MyPilot.new(_pry_)
end
