module Exchange
  module Rates
    class InvalidRateSourceError < StandardError; end

    class Configuration

      attr_accessor :rate_source

      def initialize
        @rate_source = EuropeanCentralBankRates.new
      end

      def rate_source=(source)
        raise InvalidRateSourceError, "source must implement #lookup" unless source.respond_to?(:lookup)

        @rate_source = source
      end
    end
  end
end