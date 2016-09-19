require 'test_helper'

module Exchange
  module Rates
    class EuropeanCentralBankRatesTest < MiniTest::Test

      XML_DATA = <<-EOS
        <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01">
          <Cube>
            <Cube time="2016-09-14">
              <Cube currency="USD" rate="1.1218"/>
              <Cube currency="GBP" rate="0.85078"/>
            </Cube>
          </Cube>
        <gesmes:Envelope>
      EOS

      def setup
        @rates = EuropeanCentralBankRates.parse(XML_DATA)
      end

      def test_parse_nil_data
        assert_raises ArgumentError do
          EuropeanCentralBankRates.new.parse(nil)
        end
      end

      def test_extract_rates_from_xml
        assert_equal 1.1218, @rates.lookup("2016-09-14", "USD")
        assert_equal 0.85078, @rates.lookup("2016-09-14", "GBP")        
      end

      def test_lookup_unknown_rate
        assert_raises NoRateError do
          @rates.lookup("2016-09-14", "JUNK")
        end
      end

      def test_lookup_with_date
        assert_equal 1.1218, @rates.lookup(Date.parse("2016-09-14"), "USD")
      end

      def test_list_currencies
        assert_equal ["GBP", "USD"], @rates.currencies
      end
    end
  end
end
