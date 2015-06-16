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

Full API documentation can be found: [here](https://github.com/tick/tick-api).

### Authentication

If you already know your subscription ID and API Token, create a new connection like so:

```ruby
Tockspit::Connection.new(1234, "my-api-token")
# => #<Tockspit::Connection:0x007fdbe48730f8 @subscription_id=1234, @api_token="my-api-token">
```

But if you don't you could totally call `Tockspit.login` instead:

```ruby
Tockspit.login('username', 'password')
# => [#<Tockspit::Role:0x007f9f8a943258 @attributes={"subscription_id"=>1234, "company"=>"Dunder Mifflin", "api_token"=>"my-api-token"}>]
```

You'll get back an array of roles (one for each company your accout has access to) so you could either stash the details for later or just call `#connection` on the role of your choosing... and you're away!

### Clients

Clients eh? everybody's got em... errr or something like that!

**Getting a list:**

```ruby
connection.clients.all
# => #<Enumerator: #<Enumerator::Generator:0x007fbf8a14a978>:each>
```

As you can see this returns an [Enumerator](http://ruby-doc.org/core-2.2.0/Enumerator.html) object which you can call all the usual [Enumerable](http://ruby-doc.org/core-2.2.0/Enumerable.html) methods on (i.e. `#each`, `#map` or `#first`) and under the hood it'll deal with pagination automatically... pretty cool, no?

**Getting a client:**

```ruby
connection.clients.find(client_id)
# => #<Tockspit::Client:0x007fa6b4b7a220 @attributes={"id"=>1234, "name"=>"Dunder Mifflin", "archive"=>false, "url"=>"https://www.tickspot.com/1234/api/v2/clients/1234.json", "updated_at"=>"2015-06-16T14:54:11.000-04:00", "projects"=>{"count"=>0, "url"=>"https://www.tickspot.com/1234/api/v2/clients/1234/projects.json", "updated_at"=>nil}}>
```

Oh, I forgot to mention! Tockspit gives you nice accessors for the attributes too:

```ruby
client.name # => "Dunder Mifflin"
client.id # => 1234
```

**Creating a client:**

```ruby
connection.clients.create(
  name: "Dunder Mifflin",
  archive: false
)

# => #<Tockspit::Client:0x007fbf8a0ef668 @attributes={"id"=>1234, "name"=>"Dunder Mifflin", "archive"=>false, "url"=>"https://www.tickspot.com/1234/api/v2/clients/1234.json", "updated_at"=>"2015-06-16T14:54:11.241-04:00"}>
```

**Deleting a client:**

If you love them, let them go :'(

```ruby
connection.clients.delete(client_id)
```

## Handling Errors

All API level errors (i.e. unhappy HTTP status codes) will raise a decendent of `Tockspit::TockspitError`, popular choices include `Tockspit::BadCredentials` and `Tockspit::RecordNotFound` but there are some more exotic ones too... for a full list check out [errors.rb](lib/tockspit/errors.rb).

Remember to also cater for network level errors (i.e. `Errno::ECONNRESET`).

## To be continued...

This is a work in progress - it's quite incomplete and I'm still trying to figure out the API design etc.

## Contributing

1. Fork it ( https://github.com/boxofrad/tockspit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
