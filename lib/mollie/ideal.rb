module Mollie
  class Ideal
    # Public: Initialize Ideal
    #
    # partner_id - String your Mollie partner id
    # options - Hash options:
    #           :test - Boolean use testmode? (default: true)
    #
    # Examples
    #
    #   mi = Mollie::Ideal.new('123456', :test => false)
    #
    def initialize(partner_id, options={:test => true});end

    # Public: All supported banks.
    #
    # Examples
    #
    #   Mollie::Ideal.banklist
    #   # => [{:id => '0031', :name => 'ABN AMRO'}, ...]
    #
    # Returns an Array of Hash representing banks (keys: String id, 
    #   String name).
    def self.banklist;end
    def self.banks
      banklist
    end

    def banklist
      self.class.banklist
    end
    alias :banks :banklist

    # Public: Request a payment.
    #
    # options - Hash options:
    #           :amount - Fixnum the amount *in cents*
    #           :bank_id - String id of the bank
    #           :description - String description of the transaction (max. 30 
    #                          characters)
    #           :report_url - String url where the result of the transaction 
    #                         is sent
    #           :return_url - String url where the visitor is sent
    #           :profile_key - String profile this transaction should be linked
    #                          to (default: nil)
    #
    # Examples
    #
    #   mi = Mollie::Ideal.new('12345')  
    #   mi.fetch(:amount => 1465, :bank_id => '0721',
    #             :description => "Charlie Brown's Tree", 
    #             :report_url => 'http://example.org/report',
    #             :return_url => 'http://example.org/return')
    #   # => {
    #           :transaction_id => '482d599bbcc7795727650330ad65fe9b',
    #           :amount => 1465,
    #           :currency => 'EUR',
    #           :url => 'https://mijn.postbank.nl/...',
    #         }
    #
    # Returns a Hash representing the transaction (keys: Fixnum amount, 
    #   String currency, String transaction_id, String url).
    def fetch(options);end

    # Public: Verify the status of a transaction.
    #
    # options - Hash options:
    #           :transaction_id - String id of the transaction
    #
    # Examples
    #
    #   mi = Mollie::Ideal.new('12345')
    #   mi.check(:transaction_id => '12345')
    #   # => {
    #           :transaction_id => '482d599bbcc7795727650330ad65fe9b',
    #           :amount => 1465,
    #           :currency => 'EUR',
    #           :payed => true,
    #           :consumer => {
    #             :name => 'Hr J Janssen',
    #             :account => 'P001234567',
    #             :city => 'Amsterdam'
    #           },
    #           :message => 'This iDEAL-order has successfuly been payed for, 
    #                        and this is the first time you check it.'
    #         }
    # TODO: docs mention 'status' instead of 'message'
    #
    # Returns A Hash representing the result of the transaction (see Examples).
    def check(options);end
  end
end
