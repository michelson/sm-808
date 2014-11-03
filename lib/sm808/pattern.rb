module Sm808
  class Pattern

    attr_accessor :grid, :instrument
    attr_reader :current_step_index

    def initialize( opts={})
      @steps = []
      @grid = opts[:grid] ||= []

      if opts[:instrument]
        sound_name = opts[:instrument].downcase
        @instrument = Instrument.new(name: opts[:instrument], sound: sound_name )
      end

      self.build_steps unless @grid.empty?
    end

    def steps
      @steps ||= []
    end

    def build_steps
      @grid.each do |step|
        @steps << Step.new(active: step.to_b? )
      end
    end

    def next_step
      @current_step_index ||= 0
      step = @steps[@current_step_index]
      @current_step_index == @steps.size - 1 ? @current_step_index = 0 : @current_step_index += 1
      step
    end

  end
end