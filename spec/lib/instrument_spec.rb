require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Instrument" do


  it "Check included utils" do
    #pending #"we should be able to spec fork status of play sound"
    sound = Sm808::Instrument.new(name: "Drum", sound: "bass" )
    #pending "we should be able to spec fork status of play sound"
    #expect(sound.play).to be > 0
  end

end
