require "bundler/gem_tasks"
require "sm808"

namespace :sm808 do

  task :play do
    @song = Sm808::Song.new(bpm: 128 , title: "Animal Rights")
    @song.add_pattern([1,0,0,0,1,0,0,0], "Kick")
    @song.add_pattern([0,0,0,0,1,0,0,0], "Snare")
    @song.add_pattern([0,0,1,0,0,0,1,0], "HiHat")
    @song.play()

    sleep 10 #it will stop in 10 seconds
    @song.stop
  end
end