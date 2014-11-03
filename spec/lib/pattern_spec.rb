require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Pattern" do

  let( :pattern ){ Sm808::Pattern.new(grid: [1,1,0,0,0,1,1,0], instrument: "Drum Kick")}

  it "should have one instrument" do
    expect(pattern.instrument).to be_an_instance_of Sm808::Instrument
  end

  it "should create 8 steps" do
    expect( pattern.steps.size ).to be == 8
  end

  it "should create steps with on/off" do
    expect( pattern.steps[0] ).to be_on
    expect( pattern.steps[1] ).to be_on
    expect( pattern.steps[2] ).to be_off
  end

  it "next step should return first step when " do
    first_step = pattern.steps.first
    last_step = nil
    9.times do
      last_step = pattern.next_step
    end
    expect(first_step).to be == last_step
  end

end
