require 'test_helper'
require 'date'

module Exchange
  module Rates
    class ExchangeRateTest < Minitest::Test
      RATE_DATA = [{date: "2016-09-14", currency: "USD", rate: "3.0"},
                   {date: "2016-09-14", currency: "GBP", rate: "2.0"}]

      def setup
        ::Exchange::Rates.configure do |config|
          config.rate_source = EuropeanCentralBankRates.new(RATE_DATA)
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
    end
  end
end
