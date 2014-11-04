require "sm808/utils"

module Sm808
  class Instrument

    extend Sm808::Utils

    attr_accessor :name

    def initialize(opts={})
      @name  = opts[:name] if opts[:name]
      @sound = opts[:sound] if opts[:sound]
    end

    def play
      #LOGGER.info "play #{self.class.sound_file(@sound)}"
      self.class.play_sound(@sound)
    end

  end
end