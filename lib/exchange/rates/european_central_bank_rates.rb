require 'rexml/parsers/sax2parser'
require 'rexml/sax2listener'
require 'set'

module Exchange
  module Rates
    class EuropeanCentralBankRates
      include REXML::SAX2Listener

      def self.parse(xml_data)
        new.parse(xml_data)
      end

      def parse(xml_data)
        raise ArgumentError, "xml data cannot be nil" if xml_data.nil?

        @data = []
        @currencies = Set.new
        parser = REXML::Parsers::SAX2Parser.new(xml_data)
        parser.listen(self)
        parser.parse
        self
      end

      def lookup(date, currency)        
        rate = @data.find{|r| r[:date] == convert_date(date) && r[:currency] == currency}
        raise NoRateError, "No rate for #{currency} at #{date}" if rate.nil?
        Float(rate[:rate])
      end

      def currencies
        @currencies.to_a.sort
      end

      # XML parser methods
      def start_element(uri, localname, qname, attributes)
        if localname.downcase == "cube"
          if attributes.key?("time")
            @time = attributes["time"]
          elsif attributes.key?("currency") && attributes.key?("rate")
            @data << {date: @time, currency: attributes["currency"], rate: attributes["rate"]}
            @currencies << attributes["currency"]
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