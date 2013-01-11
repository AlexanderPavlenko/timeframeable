module Timeframeable
  module Controller
    extend ActiveSupport::Concern

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

  private

    def set_timeframe(options)
      start_date = Timeframeable.parse_date(params[options[:start_key]]) || options[:defaults][0]
      end_date   = Timeframeable.parse_date(params[options[:end_key]], :end) || options[:defaults][1]
      instance_variable_set :"@#{options[:variable]}", Timeframe.new(start_date, end_date)
    end
  end
end