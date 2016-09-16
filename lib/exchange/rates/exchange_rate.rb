

module Exchange
  module Rates
    class NoRateError < StandardError; end

    class ExchangeRate

      def self.at(date, base_ccy, counter_ccy)
        new(::Exchange::Rates.configuration.rate_source).at(date, base_ccy, counter_ccy)
      end

      def initialize(rate_source)
        @rates = rate_source
      end

      def at(date, base_ccy, counter_ccy)
        base_ccy_rate = @rates.lookup(date, base_ccy)
        counter_ccy_rate = @rates.lookup(date, counter_ccy)

        # Calculates the cross rate of the two currencies
        1 / (base_ccy_rate/counter_ccy_rate)
      end

    end
  end
end