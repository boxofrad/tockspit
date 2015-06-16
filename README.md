# Tockspit

[![Build Status](https://travis-ci.org/boxofrad/tockspit.svg)](https://travis-ci.org/boxofrad/tockspit)
[![Code Climate](https://codeclimate.com/github/boxofrad/tockspit/badges/gpa.svg)](https://codeclimate.com/github/boxofrad/tockspit)

Fancy Ruby bindings for the [Tick](https://tickspot.com/) [API](https://github.com/tick/tick-api/)... a work in progress!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tockspit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tockspit

## Usage

### Authentication

If you already know your subscription ID and API Token, create a new connection like so:

```ruby
Tockspit::Connection.new(1234, "my-api-token")
# => #<Tockspit::Connection:0x007fdbe48730f8 @subscription_id=1234, @api_token="my-api-token">
```

If you don't you can find out like so:

```ruby
Tockspit.login('username', 'password')
# => [#<Tockspit::Role:0x007f9f8a943258 @attributes={"subscription_id"=>1234, "company"=>"Dunder Mifflin", "api_token"=>"my-api-token"}>]
```

## Contributing

1. Fork it ( https://github.com/boxofrad/tockspit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
