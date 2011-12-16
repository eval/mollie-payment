require 'httparty'

module Mollie
  class Ideal
    include HTTParty
    base_uri 'https://secure.mollie.nl/xml/ideal'

    attr_reader :partner_id, :production
    # Create a new Ideal object
    #
    # @param [String] partner_id your Mollie partner id
    # @param [Hash] options
    # @option options [Boolean] :production (false) whether or not to operate
    #   in production-mode
    def initialize(partner_id, options={:production => false})
      @partner_id = partner_id
      @production = options[:production]
    end

    alias :production? :production

    # All supported banks.
    #
    # @visibility public
    #
    # @example
    #   Mollie::Ideal.banks
    #   # => [{:id => '0031', :name => 'ABN AMRO'}, ...]
    #
    # @return [Array<Hash{Symbol => String}>] the list of banks.
    def self.banks
      resp = get('', :query => {:a => 'banklist'}).parsed_response
      resp["response"]["bank"].map do |b|
        {:id => b["bank_id"], :name => b["bank_name"]}
      end
    end
    class << self
      alias :banklist :banks
    end

    # Request a transaction.
    #
    # @visibility public
    #
    # @param [Hash] opts
    # @option opts [Fixnum] :amount the amount in cents.
    # @option opts [String] :bank_id the id of the bank (see {banks}).
    # @option opts [String] :description description of the transaction
    #   (max. 30 characters).
    # @option opts [String] :report_url address where the result of the
    #   transaction is sent (POSTed?).
    # @option opts [String] :return_url address where the visitor is sent.
    # @option opts [String] :profile_key (nil) the profile this transaction
    #   should be linked to.
    #
    # @example
    #
    #   mi = Mollie::Ideal.new('12345')
    #   mi.request_transaction(:amount => 1465,
    #                           :bank_id => '0721',
    #                           :description => "Charlie Brown's Tree",
    #                           :report_url => 'http://example.org/report',
    #                           :return_url => 'http://example.org/return')
    #   # => {
    #   #        :transaction_id => '482d599bbcc7795727650330ad65fe9b',
    #   #        :amount => 1465,
    #   #        :currency => 'EUR',
    #   #        :url => 'https://mijn.postbank.nl/...',
    #   #      }
    #
    # @return [Hash] the transaction (see example)
    def request_transaction(options={})
      query_options = options_to_query_options(options)

      query_options.merge!(:a => 'fetch', :partnerid => self.partner_id)
      query_options.merge!(:testmode => 'true') unless self.production?

      resp = self.class.get('', :query => query_options).parsed_response
      order = resp["response"]["order"]

      %w(transaction_id amount currency url).map(&:to_sym).inject({}) do |res, k|
        v = order[k.to_s] || order[k.to_s.upcase]
        v = v.to_i if k == :amount

        res[k] = v
        res
      end
    end

    # Verify the status of a transaction.
    #
    # @visibility public
    #
    # @param [Hash] options
    # @option options [String] :transaction_id the transaction to verify.
    #
    # @example
    #   mi = Mollie::Ideal.new('12345')
    #   mi.verify_transaction(:transaction_id => '482d599bbcc7795727650330ad65fe9b')
    #   # => {
    #   #        :transaction_id => '482d599bbcc7795727650330ad65fe9b',
    #   #        :amount => 1465,
    #   #        :currency => 'EUR',
    #   #        :payed => true,
    #   #        :consumer => {
    #   #          :name => 'Hr J Janssen',
    #   #          :account => 'P001234567',
    #   #          :city => 'Amsterdam'
    #   #        },
    #   #        :message => 'This iDEAL-order has successfuly been payed for,
    #   #                     and this is the first time you check it.',
    #   #        :status => 'Expired'
    #   #      }
    #
    # @note Once a transaction is payed, only the next time you verify the
    #   transaction will the value of 'payed' be 'true'.
    #   Else it will be 'false'.
    # @return [Hash] the status of the transaction (see example)
    def verify_transaction(options={})
      query_options = options_to_query_options(options)
      query_options.merge!(:a => 'check', :partnerid => self.partner_id)
      query_options.merge!(:testmode => 'true') unless self.production?

      resp = self.class.get('', :query => query_options).parsed_response
      order = resp["response"]["order"]

      result = %w(transaction_id amount currency payed status message).map(&:to_sym).inject({}) do |res, k|
        v = order[k.to_s]
        v = v.to_i if k == :amount
        v = (v == 'true') if k == :payed

        res[k] = v
        res
      end

      if consumer = order["consumer"]
        consumer = {'consumerName' => 'name', 'consumerAccount' => 'account', 'consumerCity' => 'city'}.inject({}) do |res, (theirs, ours)|
          res[ours.to_sym] = consumer[theirs]
          res
        end
        result[:consumer] = consumer
      end
      result
    end

    protected
    # Convert our naming to their naming
    def options_to_query_options(options)
      {
        :bank_id => :bank_id,
        :amount => :amount,
        :return_url => :returnurl,
        :report_url => :reporturl,
        :description => :description,
        :transaction_id => :transaction_id
      }.inject({}) do |result, (ours, theirs)|
        result[theirs] = options[ours] if options[ours]
        result
      end
    end
  end
end
