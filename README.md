# Timeframeable

Timeframeable module allows you to easily extract datetime range from request params keeping you controllers DRY.
Intended to use with Rails 3, but may be compatible or easily adaptable with/to other versions.

![Travis CI](https://api.travis-ci.org/AlexanderPavlenko/timeframeable.png "Travis CI")

## Installation

Add this line to your application's Gemfile:

    gem 'timeframeable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install timeframeable

## Usage

### Controller module

Typical usage:

```ruby
class FrontController < ApplicationController
  include Timeframeable::Controller
  timeframeable
```

This will inject dates from `params[:start]` and `params[:end]` into `@timeframe.start` and `@timeframe.end`. `nil` will be used if parameter was not found. You can specify default values to avoid this:

```ruby
  timeframeable :defaults => [:beginning_of_month, :now]
```

You can specify keys to seek at params hash:

```ruby
  timeframeable :defaults => [:beginning_of_month, :now],
    :start_key => :s,
    :end_key   => :e
```

Or even specify instance variable to fill:

```ruby
  timeframeable :defaults => [:beginning_of_month, :now],
    :start_key => :s,
    :end_key   => :e,
    :variable  => :tf
```

### ActiveRecord module

```ruby
class Model < ActiveRecord::Base
  include Timeframeable::Scope
end

Model.timeframe(:created_at, @timeframe).count
```

## TODO

It might be usefull to add `:start_value` and `:end_value` lambda options, which will extract appropriate values from `params` bypassing `:start_key` and `:end_key`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
