require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Slot" do

  it "check 60 bpm should be a 1 sec delay" do
    Sm808::Clock.tempo = 60
    expect( Sm808::Clock.delay ).to be 1.0
  end


  it "check 120 bpm should be a 0.5 delay" do
    Sm808::Clock.tempo = 120
    expect( Sm808::Clock.delay ).to be 0.5
  end


end

