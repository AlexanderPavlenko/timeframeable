require_relative '../../spec_helper'
require 'timeframeable'
require 'active_record'

describe Timeframeable::Scope do

  before :all do
    module App end
    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => ':memory:'
    )
  end

  before do
    App.send(:remove_const, :Model) if App.const_defined?(:Model)
    class App::Model < ActiveRecord::Base
      include Timeframeable::Scope
    end
  end

  it 'has scope that accepts timeframe' do
    timeframe = Timeframeable::Timeframe.new(DateTime.parse('2013-01-01 00:00:00'), DateTime.parse('2013-01-31 23:59:59'))
    timeframe_r = timeframe.clone
    timeframe_r.start = nil
    timeframe_l = timeframe.clone
    timeframe_l.end = nil
    App::Model.timeframe(:date, timeframe).to_sql.should ==
      %(SELECT "models".* FROM "models"  WHERE ("models"."date" >= '2013-01-01 00:00:00') AND ("models"."date" <= '2013-01-31 23:59:59'))
    App::Model.timeframe(:date, timeframe_r).to_sql.should ==
      %(SELECT "models".* FROM "models"  WHERE ("models"."date" <= '2013-01-31 23:59:59'))
    App::Model.timeframe(:date, timeframe_l).to_sql.should ==
      %(SELECT "models".* FROM "models"  WHERE ("models"."date" >= '2013-01-01 00:00:00'))
  end
end