require 'forwardable'

class PryAutopilot
  class Input
    extend Forwardable

    def initialize(pilot)
      @pilot = pilot
    end

    def_delegator :@pilot, :pry

    def <<(value)
      Fiber.yield(value)
    end

    def interactive!
      pry.input = Readline
      Fiber.yield("")
    end
  end
end
