module Timeframeable
  module Scope
    extend ActiveSupport::Concern

    included do
      class_eval do
        scope :timeframe, lambda {|field, timeframe|
          scope = scoped
          scope = scope.where(arel_table[field].gteq(timeframe.start)) if timeframe.start
          scope = scope.where(arel_table[field].lteq(timeframe.end))   if timeframe.end
          scope
        }
      end
    end
  end
end