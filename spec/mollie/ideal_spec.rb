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

    it "should return a hash with the correct keys and values" do
      VCR.use_cassette('request_transaction') do
        t = subject.request_transaction(:amount => 12345,
                                        :bank_id => '0031',
                                        :description => 'description goes here',
                                        :report_url => 'http://example.org/report',
                                        :return_url => 'http://example.org/return')
        t.class.should == Hash
        expected_keys_with_values = {:transaction_id => nil, :amount => 12345, :currency => 'EUR', :url => nil}
        check_hash_keys_and_values(t, expected_keys_with_values)
      end
    end
  end

  context "#verify_transaction" do
    subject{ Mollie::Ideal.new('123456')}

    it "should return a hash with the correct keys and values" do
      VCR.use_cassette('verify_transaction') do
        t = subject.verify_transaction(:transaction_id => 'e0be830d5e46289e7da9636beb84729e')

        t.class.should == Hash
        expected_keys_with_values = {:transaction_id => 'e0be830d5e46289e7da9636beb84729e',
                                      :amount => 12345,
                                      :currency => 'EUR',
                                      :payed => false,
                                      :status => 'CheckedBefore'}
        check_hash_keys_and_values(t, expected_keys_with_values)
      end
    end
  end

  protected
  # Checks target for:
  # - existance of supplied keys
  # - value for given key if supplied
  #
  # @example passing example
  #   check_hash_keys_and_values({:a => 1, :b => 'anything'}, {:a => 1, :b => nil})
  def check_hash_keys_and_values(target, keys_and_values)
    keys_and_values.each do |key, value|
      if value
        target[key].should == value
      else
        target.keys.should include(key)
      end
    end
  end
end

