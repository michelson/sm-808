module Sm808
  class Step

    attr_accessor :active

    def initialize(opts={})
      @active = opts[:active] ||= false
    end

    def sound!
      true if on?
    end

    def on?
      @active
    end

    def off?
      !on?
    end

  end
end