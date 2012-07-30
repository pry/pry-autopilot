require 'forwardable'

class PryAutopilot
  class Input
    extend Forwardable

    def initialize(pilot)
      @pilot = pilot
      @array = []
    end

    def_delegator :@pilot, :_pry_

    def <<(value)
      @array << "#{value}\n"
      self
    end

    def empty?
      @array.empty?
    end

    def shift
      @array.shift
    end

    def interactive!
      @array << "_pry_.input = Readline"
    end
  end
end
