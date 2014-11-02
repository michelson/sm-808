$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'debugger' if Gem.ruby_version < Gem::Version.new('2.0')
require File.join(File.dirname(__FILE__), '../lib', 'sm808')

require "pry"