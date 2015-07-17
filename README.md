# Rabbitmq::Sender

Easy ruby rabbitmq sender.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rabbitmq-sender'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rabbitmq-sender

## Usage

```ruby
require 'rabbitmq/sender'

Rabbitmq::Sender.config do |config|
      config.host 	  = '8.8.8.8'
      config.user 	  = 'superuser'
      config.password = 'superpassword'
      config.vhost    = 'supervhost'
      config.verbose  = true
end

Rabbitmq::Sender.send_to('send_queue', 'supermessage')
```

## Configuration - defaults
```
logger:     Logger.new(STDOUT)
connection: nil
host:       '8.8.8.8'
port:       5672
pool:       20
timeout:    5
user:       nil
password:   nil
vhost:      nil
prefetch:   10
verbose:    false
retry_time: 5

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rabbitmq-sender. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

