require 'timeframeable/version'
require 'active_support/concern'
require 'date'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/date/conversions'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/date_time/conversions'

module Timeframeable
  extend ActiveSupport::Concern

  Timeframe = Struct.new(:start, :end)

  module ClassMethods
    def timeframeable(options={})
      options = options.dup
      options[:start_key] ||= :start
      options[:end_key]   ||= :end
      options[:variable]  ||= :timeframe
      options[:defaults]  ||= []
      options[:defaults] = options[:defaults].map do |x|
        if x.is_a? Symbol
          if x == :now
            DateTime.now.utc
          else
            DateTime.now.send(x).utc
          end
        else
          x && x.to_datetime.utc
        end
      end

      before_filter do
        set_timeframe options
      end
    end
  end

  def self.parse_date(param, extrapolate=nil)
    return unless param

    if param.kind_of? Hash
      parts = [:year, :month, :day].map do |key|
        value = param[key].to_i
        if value == 0
          value = case key
            when :year
              Date.today.year
            else
              1
          end
        end
        value
      end

      begin
        result = DateTime.new(*parts)
      rescue
        return
      end

      case extrapolate
        when :end
          if param[:day].to_i == 0
            result = result.end_of_month
          end
          result = result.end_of_day
        else
      end

      result.utc
    else
      begin
        DateTime.parse(param.to_s).utc
      rescue
        return
      end
    end
  end

private

  def set_timeframe(options)
    start_date = Timeframeable.parse_date(params[options[:start_key]]) || options[:defaults][0]
    end_date   = Timeframeable.parse_date(params[options[:end_key]], :end) || options[:defaults][1]
    instance_variable_set :"@#{options[:variable]}", Timeframe.new(start_date, end_date)
  end
end
