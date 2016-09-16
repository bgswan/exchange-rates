# Exchange::Rates

Provides currency conversion rates at a specified date.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exchange-rates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exchange-rates

## Usage

The `Exchange::Rates::ExchangeRate` class provides a method to lookup the conversion rate between two given currencies at a specified date, e.g.

```ruby
include Exchange::Rates

ExchangeRate.at(Date.today, "USD", "GBP") #=> 0.75
```

If no rate data is available a `Exchange::Rates::NoRateError` will be raised.

## Configuration

By default the rates are provided by 90­day European Central Bank (ECB) feed, https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml implemented as the `Exchange::Rates::EuropeanCentralBankRates` class.

The rate source can be configured by supplying an object that responds to the `lookup(date, currency_code)` method and configured as follows:

```ruby
class MyRateSource
  
  def self.lookup(date, ccy)
  	# implement lookup
  end
end

Exchange::Rates.configure |config| do
  config.rate_source = MyRateSource
end
```





