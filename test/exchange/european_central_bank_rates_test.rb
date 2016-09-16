require 'test_helper'

module Exchange
  module Rates
    class EuropeanCentralBankRatesTest < MiniTest::Test

      XML_DATA = <<-EOS
        <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01">
          <Cube>
            <Cube time="2016-09-15">
              <Cube currency="AUD" rate="1.5022"/>
            </Cube>
          </Cube>
        <gesmes:Envelope>
      EOS

      RATE_DATA = [{date: "2016-09-14", currency: "USD", rate: "1.1218"},
                   {date: "2016-09-14", currency: "GBP", rate: "0.85078"}]

      def setup
        @rates = EuropeanCentralBankRates.new(RATE_DATA)
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

      def test_get_all_rates
        assert_equal RATE_DATA, @rates.all
      end

      def test_lookup_fetches_rates_from_feed_if_no_data_provided
        rates = EuropeanCentralBankRates.new
        Net::HTTP.stub :get_response, valid_response do
          assert_equal 1.5022, rates.lookup("2016-09-15", "AUD")
        end
      end

      private

      def valid_response
        response = Net::HTTPSuccess.new('', '200', '')
        response.body = XML_DATA
        response.instance_variable_set(:@read, true)
        response
      end
    end
  end
end
