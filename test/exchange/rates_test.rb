require 'test_helper'

class Exchange::RatesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Exchange::Rates::VERSION
  end

  def test_configure
    dummy_rate_source = DummyRateSource.new

    ::Exchange::Rates.configure do |config|
      config.rate_source = dummy_rate_source
    end

    assert_equal dummy_rate_source, ::Exchange::Rates.configuration.rate_source
  end
end
