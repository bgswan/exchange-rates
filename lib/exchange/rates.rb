require "exchange/rates/version"
require "exchange/rates/configuration"
require "exchange/rates/exchange_rate"
require "exchange/rates/european_central_bank_rates"


module Exchange
  module Rates
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
