# Timeframeable

Timeframeable module allows you to easily extract datetime range from request params keeping you controllers DRY.
Intended to use with Rails 3, but may be compatible or easily adaptable with/to other versions.

## Installation

Add this line to your application's Gemfile:

    gem 'timeframeable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install timeframeable

## Usage

### Controller module

    class FrontController < ApplicationController
      include Timeframeable

      # Inject dates from params[:start] and params[:end] or nils into @timeframe.start and @timeframe.end
      timeframeable

     === OR ===

      # Inject dates from params[:start] and params[:end] or their default values into @timeframe.start and @timeframe.end
      timeframeable :defaults => [:beginning_of_month, :now]

     === OR ===

      # Inject dates from params[:s] and params[:e] or their default values into @timeframe.start and @timeframe.end
      timeframeable :defaults => [:beginning_of_month, :now], :start_key => :s, :end_key => :e

     === OR ===

      # Inject dates from params[:start] and params[:end] or their default values into @timeframe.start and @timeframe.end,
      # and inject dates from params[:s] and params[:e] or their default values into @tf.start and @tf.end
      timeframeable :defaults => [:beginning_of_month, :now]
      timeframeable :defaults => [:beginning_of_month, :now], :start_key => :s, :end_key => :e, :variable => :tf

      # # #
    end

### ActiveRecord module

    class Model < ActiveRecord::Base
      include Timeframeable::Scope
    end

    Model.timeframe(:created_at, @timeframe).count

## TODO
If there will be such a need, it may be usefull to add ```:start_value``` and ```:end_value``` lambda options, which will extract appropriate values from ```params``` bypassing ```:start_key``` and ```:end_key```.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
