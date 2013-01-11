require_relative '../spec_helper'
require 'timeframeable'
require 'timecop'

describe Timeframeable do

  it 'has dedicated data structure' do
    data = Timeframeable::Timeframe.new(1, 2)
    data.start.should == 1
    data.end.should   == 2
  end

  describe 'Timeframeable.parse_date' do

    it 'uses DateTime.parse for strings' do
      data = DateTime.now.change(:usec => 0)
      Timeframeable.parse_date(data.to_s).should == data
    end

    it 'suppress exceptions on invalid strings' do
      Timeframeable.parse_date('trololo').should be_nil
    end

    it 'accepts composite param' do
      Timeframeable.parse_date({:year => 2013, :month => 1, :day => 15}).should == DateTime.new(2013, 1, 15)
    end

    it 'extrapolates range to its end' do
      Timeframeable.parse_date({:year => 2013, :month => 1, :day => 15}, :end).should == DateTime.new(2013, 1, 15).end_of_day
      Timeframeable.parse_date({:year => 2013, :month => 1}, :end).should == DateTime.new(2013, 1, 1).end_of_month.end_of_day
    end
  end

  context 'controller' do
    let(:controller) { Class.new.new }
    let(:default_options) {
      {
        :start_key => :start,
        :end_key => :end,
        :variable => :timeframe,
        :defaults => [DateTime.now.beginning_of_month, DateTime.now]
      }
    }

    before do
      controller.class.class_eval do
        include Timeframeable
      end
    end

    describe 'Controller.timeframeable' do

      before do
        mock(controller.class).before_filter() {|block| controller.instance_eval(&block) }
      end

      it 'timeframes with default options' do
        options_given = {:defaults => default_options[:defaults]}
        options_got = default_options
        mock(controller).set_timeframe(options_got)
        controller.class.timeframeable(options_given)
      end

      it 'timeframes with symbol options' do
        Timecop.freeze(DateTime.now) do
          options_given = {:defaults => [:beginning_of_month, :now]}
          options_got = default_options.merge(:defaults => [DateTime.now.beginning_of_month, DateTime.now])
          mock(controller).set_timeframe(options_got)
          controller.class.timeframeable(options_given)
        end
      end

      it 'timeframes with custom options' do
        Timecop.freeze(DateTime.now) do
          options_given = {:defaults => [:beginning_of_month, :now], :start_key => :s, :end_key => :e, :variable => :'@tf'}
          options_got = default_options.merge(options_given).merge(:defaults => [DateTime.now.beginning_of_month, DateTime.now])
          mock(controller).set_timeframe(options_got)
          controller.class.timeframeable(options_given)
        end
      end
    end

    describe 'Controller#set_timeframe' do
      it 'falls back to default values' do
        stub(controller).params{ {} }
        controller.send :set_timeframe, default_options
        controller.instance_variable_get(:"@#{default_options[:variable]}").should ==
          Timeframeable::Timeframe.new(*default_options[:defaults])
      end

      it 'uses actual params' do
        dates = default_options[:defaults].map{|d| d.prev_month.utc.change(:usec => 0) }
        stub(controller).params{ Hash[[:start, :end].zip(dates.map(&:to_s))] }
        controller.send :set_timeframe, default_options
        controller.instance_variable_get(:"@#{default_options[:variable]}").should ==
          Timeframeable::Timeframe.new(*dates)
      end

      it 'allows multiple timeframes to be set' do
        stub(controller).params{ {} }
        other_options = default_options.merge(:variable => :test, :defaults => default_options[:defaults].map(&:prev_month))
        controller.send :set_timeframe, default_options
        controller.send :set_timeframe, other_options
        controller.instance_variable_get(:"@#{default_options[:variable]}").should ==
          Timeframeable::Timeframe.new(*default_options[:defaults])
        controller.instance_variable_get(:"@#{other_options[:variable]}").should ==
          Timeframeable::Timeframe.new(*other_options[:defaults])
      end
    end
  end
end