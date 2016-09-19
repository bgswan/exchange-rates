require 'test_helper'
require 'date'

module Exchange
  module Rates
    class ExchangeRateTest < Minitest::Test
      FEED_XML = File.join(File.dirname(__FILE__), "../fixtures/feed_data.xml")

      def setup
        ::Exchange::Rates.configure do |config|
          config.rate_source = EuropeanCentralBankRates.parse(File.read(FEED_XML))
        end
      end

      def test_exchange_rate_at
        assert_equal 1.5, ExchangeRate.at(Date.parse("2016-09-14"), "GBP", "USD")
      end

      def test_no_rate_data
        assert_raises NoRateError do
          ExchangeRate.at(Date.parse("2016-01-01"), "GBP", "USD")          
        end
      end

      def test_list_currencies
        assert_equal ["GBP", "USD"], ExchangeRate.currencies
      end
    end
  end
end
