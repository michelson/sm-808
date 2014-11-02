module Sm808
  class Pattern

    attr_accessor :grid, :instrument
    attr_reader :steps

    def initialize( opts={})
      @steps = []
      @grid = opts[:grid] ||= []
      @instrument = Instrument.new(name: opts[:instrument]) if opts[:instrument]
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

  end
end