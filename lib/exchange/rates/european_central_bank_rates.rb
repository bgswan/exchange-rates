require 'rexml/parsers/sax2parser'
require 'rexml/sax2listener'
require 'net/http'

module Exchange
  module Rates
    class FeedData
      def self.get
        new("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml").get
      end

      def initialize(feed_url)
        @url = URI(feed_url)
      end

      def get
        response = Net::HTTP.get_response(@url)
        case response
        when Net::HTTPSuccess
          response.body    
        else
          response.value # raises HTTP error as defined by the response type 
        end
      rescue Errno::ECONNREFUSED
        raise RuntimeError, "Unable to connect to feed endpoint [#{@url}]"
      end
    end

    class EuropeanCentralBankRates
      include REXML::SAX2Listener

      def initialize(data=nil)
        @data = data
      end

      def parse(xml_data)
        raise ArgumentError, "xml data cannot be nil" if xml_data.nil?

        @data = []
        parser = REXML::Parsers::SAX2Parser.new(xml_data)
        parser.listen(self)
        parser.parse
        self
      end

      def lookup(date, currency)        
        rate = all.find{|r| r[:date] == convert_date(date) && r[:currency] == currency}
        raise NoRateError, "No rate for #{currency} at #{date}" if rate.nil?
        Float(rate[:rate])
      end

      def all
        if @data.nil?
          parse(FeedData.get)
        end
        @data
      end

      # XML parser methods
      def start_element(uri, localname, qname, attributes)
        if localname.downcase == "cube"
          if attributes.key?("time")
            @time = attributes["time"]
          elsif attributes.key?("currency") && attributes.key?("rate")
            @data << {date: @time, currency: attributes["currency"], rate: attributes["rate"]}
          end
        end
      end

      private 

      def convert_date(date)
        case date
        when String
          date
        when Date
          date.strftime("%F")
        end
      end
    end
  end
end