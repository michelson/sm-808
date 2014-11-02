module Sm808
  class Clock

    def self.tempo
      @@tempo ||= 60
    end

    def self.tempo=(tempo)
      @@tempo = tempo
    end

    def self.delay
      60 / self.tempo
    end

    def self.delay_ms
      self.delay * 1000
    end

  end
end