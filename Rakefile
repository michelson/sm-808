require "bundler/gem_tasks"
require "sm808"

namespace :sm808 do

  desc 'Plays tha tune'
  task :play do
    song = Sm808::Song.new(bpm: 128 , title: "Animal Rights")
    song.add_pattern([1,0,0,0,1,0,0,0], "Kick")
    song.add_pattern([0,0,0,0,1,0,0,0], "Snare")
    song.add_pattern([0,0,0,0,1,0,0,0], "Bass")
    song.add_pattern([0,0,1,0,0,0,1,0], "Hi-Hat")
    Thread.new do
      song.play()
    end
    sleep 10 #it will stop in 10 seconds
    song.stop

  end
end