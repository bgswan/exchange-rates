$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'exchange/rates'

require 'minitest/autorun'

# Used in tests for stubbing config
class DummyRateSource
  def lookup(date, ccy)
  end
end
