require 'nokogiri'
require 'open-uri'

module Mollie
  class Ideal
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
      Nokogiri(open('https://secure.mollie.nl/xml/ideal?a=banklist')).xpath('//bank').map do |bank|
        {
         :id => (bank/'bank_id').inner_html, 
         :name => (bank/'bank_name').inner_html
        }
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
      options_query_params_mapping = [[:amount], [:bank_id], [:description], [:report_url, :reporturl], [:return_url, :returnurl]]
      selected_options = options_query_params_mapping.inject({}) do |res, (ours, theirs)|
        res.send(:[]=, (theirs || ours), options[ours])
        res
      end
      selected_options.merge!(:a => 'fetch', :partnerid => self.partner_id)
      selected_options.merge!(:testmode => 'true') unless self.production?
      url = "https://secure.mollie.nl/xml/ideal?%s" % [URI.encode_www_form(selected_options)]
      doc = Nokogiri(open(url))

      keys = %w(transaction_id amount currency url).map(&:to_sym)
      Hash[keys.zip(keys.map{|k| doc.xpath("//response/order/#{k}")})]
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
    #   #                     and this is the first time you check it.'
    #   #      }
    # TODO: docs mention 'status' instead of 'message'
    # 
    # @note Once a transaction is payed, only the next time you verify the
    #   transaction will the value of 'payed' be 'true'. 
    #   Else it will be 'false'.
    # @return [Hash] the status of the transaction (see example)
    def verify_transaction(options);end
  end
end
