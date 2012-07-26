class PryAutopilot
  class Input
    def <<(value)
      Fiber.yield(value)
    end
  end
end
