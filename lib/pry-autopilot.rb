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

  def initialize
    @input = []
  end

  def set_pry(_pry_)
    @pry = _pry_
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
    return if !predicates
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

Pry.config.correct_indent = true

Pry.config.hooks.add_hook(:when_started, :init_autopilot) do |_, _, _pry_|
  _pry_.input.set_pry(_pry_) if _pry_.input.is_a?(PryAutopilot)
end
