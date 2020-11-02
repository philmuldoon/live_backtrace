# LiveBacktrace

An initial prototype for a live backtrace server. Proof of concept. To use:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'live_backtrace
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install live_backtrace

## Usage

in pry, do something like

```ruby
$LOAD_PATH << (ENV['GEM_HOME'] + "/gems/live_backtrace-0.1.0/lib")
require "live_backtrace"
Trace.trace!
```

To start tracing when a pry session is entered. Or you can just start the code from wherever, in your code, with

```ruby
require "live_backtrace"
Trace.trace!
```

I've not create binaries yet so you can start the server with backtrace recieving server with something like:

```bash
ruby $GEM_HOME/gems/live_backtrace-0.1.0/lib/live_backtrace/server.rb
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LiveBacktrace project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/live_backtrace/blob/master/CODE_OF_CONDUCT.md).
