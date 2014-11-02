module Sm808
  class Instrument

    attr_accessor :name

    def initialize(opts={})
      @name = opts[:name] if opts[:name]
    end

  end
end