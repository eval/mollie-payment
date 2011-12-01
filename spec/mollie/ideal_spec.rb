require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mollie::Ideal do
  context "#banks" do
    it "returns an array with hashes containing keys :id and :name" do
      banks = described_class.banks
      banks.class.should == Array
      banks.first.keys.should =~ [:id, :name]
    end
  end
end

