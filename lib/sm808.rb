require "core_ext/integer.rb"

module Sm808
  # Your code goes here...
end


module Sm808

  autoload  :VERSION,   'sm808/version.rb'
  autoload  :Clock,     'sm808/clock.rb'
  autoload  :Instrument,'sm808/instrument.rb'
  autoload  :Pattern,   'sm808/pattern.rb'
  autoload  :Step,      'sm808/step.rb'
  autoload  :Song,      'sm808/song.rb'
end
