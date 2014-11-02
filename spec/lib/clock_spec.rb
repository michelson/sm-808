require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Slot" do


  it "check" do
    Sm808::Clock.tempo = 128
    expect( Sm808::Clock.tempo ).to be 128
  end

  it "check 60 bpm" do
    Sm808::Clock.tempo = 60
    expect( Sm808::Clock.delay ).to be 1
  end

  it "check 60 bpm" do
    Sm808::Clock.tempo = 60
    expect( Sm808::Clock.delay ).to be 1
  end

end

