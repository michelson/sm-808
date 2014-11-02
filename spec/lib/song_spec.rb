require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Song" do

  before :each do
    @song = Sm808::Song.new(bpm: 128 , title: "Animal Rights")
  end

  it "should create title and bpm config" do
    expect( @song.bpm.to_i ).to be 128
    expect( @song.title ).to_not be_empty
    expect( Sm808::Clock.tempo.to_i ).to be 128
  end

  describe "Add the 3 patterns" do
    before :each do
      # add the 3 patterns
      #song <- Kick   |X|_|_|_|X|_|_|_|
      #song <- Snare  |_|_|_|_|X|_|_|_|
      #song <- HiHat  |_|_|X|_|_|_|X|_|
      @song.add_pattern([1,0,0,0,1,0,0,0], "Kick")
      @song.add_pattern([0,0,0,0,1,0,0,0], "Snare")
      @song.add_pattern([0,0,1,0,0,0,1,0], "HiHat")
    end

    it "should return the pattern length" do
      expect(@song.steps_length).to be == 8
    end

    it "should add 3 pattenrs" do
      expect(@song.patterns.size).to be == 3
    end

    it "should play" do
      Thread.new do
        @song.play()
      end
      sleep 10 #it will stop in 3 seconds
      @song.stop
    end

  end

end

