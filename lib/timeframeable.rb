require 'timeframeable/version'
require 'active_support/concern'
require 'date'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/date/conversions'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/date_time/conversions'
require 'timeframeable/controller'
require 'timeframeable/scope'

module Timeframeable

  Timeframe = Struct.new(:start, :end)

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
end