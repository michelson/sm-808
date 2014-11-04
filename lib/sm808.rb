require "logger"
require "json"

module Sm808

  def self.root
    File.dirname __dir__
  end

  def self.bin
    File.join root, 'bin'
  end

  def self.lib
    File.join root, 'lib'
  end

  def self.log
    File.join root, 'log'
  end

  LOGGER = Logger.new( Sm808.log + "/dev.log" )

  autoload  :VERSION,     'sm808/version.rb'
  autoload  :Clock,       'sm808/clock.rb'
  autoload  :Instrument,  'sm808/instrument.rb'
  autoload  :Pattern,     'sm808/pattern.rb'
  autoload  :Step,        'sm808/step.rb'
  autoload  :Song,        'sm808/song.rb'
  autoload  :CLI,         'sm808/cli.rb'
  autoload  :Application, 'sm808/application.rb'
end