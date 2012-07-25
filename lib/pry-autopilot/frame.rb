class PryAutopilot
  class Frame
    def initialize(binding)
      @binding = binding
    end

    def method_name
      @binding.eval("__method__")
    end

    def class_name
      @binding.eval("self.class")
    end

    def eval(*args)
      @binding.eval(*args)
    end
    alias var eval

  end
end
