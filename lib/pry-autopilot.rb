# pry-autopilot.rb

require "pry-autopilot/version"
require "pry-autopilot/frame"
require "pry-autopilot/input"

class PryAutopilot
  class << self
    attr_reader :predicates

    def on(predicate, &block)
      @predicates ||= []
      @predicates << [predicate, block]
    end
  end

  attr_accessor :input

  def initialize(fallback_input=Readline)
    @input = Input.new
    @fallback_input = fallback_input
    @fibers = []
  end

  def set_pry(_pry_)
    @pry = _pry_
  end

  def readline(prompt)
    if @fibers.empty?
      process_predicates
    end

    if @fibers.any?
      @current_fiber = @fibers.shift if !@current_fiber || !@current_fiber.alive?
      @current_fiber.resume(input)
    else
      @fallback_input.readline(prompt)
    end
  end

  private
  def frame
    Frame.new(@pry.current_context)
  end

  def process_predicates
    return if !predicates
    predicates.each do |predicate, block|
      if predicate.call(frame)
        @fibers << Fiber.new(&block)
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
