# pry-autopilot.rb

require "pry-autopilot/version"
require "pry-autopilot/frame"
require "pry-autopilot/input"

class PryAutopilot
  attr_reader :predicates
  attr_accessor :input
  attr_accessor :_pry_

  def initialize(fallback_input=Readline, &block)
    @input = Input.new(self)
    @fallback_input = fallback_input
    @blocks = []
    instance_exec(&block) if block
  end

  def readline(prompt)
    process_predicates

    if @blocks.any?
      @blocks.each { |b| instance_exec(&b) }
      ""
    else
      fallback_readline(prompt)
    end
  end

  def on(predicate, &block)
    @predicates ||= []
    @predicates << [predicate, block]
  end

  private
  def frame
    Frame.new(_pry_.current_context)
  end

  def run(command_string)
    _pry_.run_command command_string
  end

  def fallback_readline(prompt)
    if @fallback_input.method(:readline).arity == 0
      @fallback_input.readline
    else
      @fallback_input.readline(prompt)
    end
  end

  def process_predicates
    return if !predicates
    @blocks.clear

    predicates.each do |predicate, block|
      if predicate.call(frame)
        @blocks << block
      end
    end
  end
end

Pry.config.hooks.add_hook(:when_started, :init_autopilot) do |_, _, _pry_|
  _pry_.input._pry_ = _pry_ if _pry_.input.is_a?(PryAutopilot)
end
