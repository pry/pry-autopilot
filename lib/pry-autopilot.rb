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
  attr_accessor :pry

  def initialize(fallback_input=Readline)
    @input = Input.new(self)
    @fallback_input = fallback_input
    @fibers = []
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
end

Pry.config.correct_indent = true

Pry.config.hooks.add_hook(:when_started, :init_autopilot) do |_, _, _pry_|
  _pry_.input.pry = _pry_ if _pry_.input.is_a?(PryAutopilot)
end
