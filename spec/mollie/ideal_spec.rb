require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mollie::Ideal do
  context "#banks" do
    it "returns an array with hashes containing keys :id and :name" do
      VCR.use_cassette('banks') do
        banks = described_class.banks
        banks.class.should == Array
        banks.first.keys.should =~ [:id, :name]
      end
    end
  end
  context "#request_transaction" do
    subject{ Mollie::Ideal.new('123456')}
    it "should return a hash with the correct keys" do
      VCR.use_cassette('request_transaction') do
        t = subject.request_transaction(:amount => 12345, 
                                        :bank_id => '0031',
                                        :description => 'description goes here',
                                        :report_url => 'http://example.org/report',
                                        :return_url => 'http://example.org/return')
        t.class.should == Hash
        t.keys.should =~ [:transaction_id, :amount, :currency, :url]
      end
    end
  end
end

