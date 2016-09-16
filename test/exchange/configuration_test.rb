require 'test_helper'

module Exchange
  module Rates
    class ConfigurationTest < Minitest::Test

      def setup
        @config = Configuration.new
      end

      def test_default_rate_source
        assert_instance_of EuropeanCentralBankRates, @config.rate_source
      end

      def test_set_new_rate_source
        dummy_rate_source = DummyRateSource.new
        @config.rate_source = dummy_rate_source
        
        assert_equal dummy_rate_source, @config.rate_source
      end

      def test_rating_source_must_implement_lookup
        assert_raises InvalidRateSourceError do
          @config.rate_source = "JUNK"
        end
      end
    end
  end
end