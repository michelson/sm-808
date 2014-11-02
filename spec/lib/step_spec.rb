require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe "Slot" do

  let( :step ){ Sm808::Step.new(active: true)}

  it "check" do
    expect( step ).to be_on
  end

end


