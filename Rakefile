require "bundler/gem_tasks"
require "sm808"

def stop_song
  Thread.new do
    @song.play()
  end
  sleep 10 #it will stop in 10 seconds
  @song.stop
end

namespace :sm808 do

  @song = Sm808::Song.new(bpm: 128 , title: "Animal Rights")

  desc 'Plays tha tune'
  task :play do
    @song.add_pattern([1,0,0,0,1,0,0,0], "Kick")
    @song.add_pattern([0,0,0,0,1,0,0,0], "Snare")
    @song.add_pattern([0,0,0,0,1,0,0,0], "Bass")
    @song.add_pattern([0,0,1,0,0,0,1,0], "Hi-Hat")
    stop_song
  end

  desc 'Plays tha tune with different pattern lengths'
  task :play2 do
    @song.add_pattern([1,0,0,0,1,0,0,0], "Kick")
    @song.add_pattern([0,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0], "Bass")
    @song.add_pattern([0,1], "Snare")
    stop_song
  end
end