require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6
  attr_accessor :balance, :journey_history_array, :journey_log

  def initialize
    @balance = 0
    @journey_history_array = []
    @journey_log = JourneyLog.new(Journey)
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    self.balance += amount
  end

  def touch_in(station)
    sufficient_balance_check?
      if journey_log.instantiated_class                    
        journey_log.ending_journey
        deduct(journey_log.instantiated_class.fare)
      end
      journey_log.starting_journey(station)
  end

  def touch_out(station)
    journey_log.starting_journey if journey_log.instantiated_class == nil || journey_log.instantiated_class.complete?
    journey_log.ending_journey(station)
    deduct(journey_log.instantiated_class.fare)
  end

def in_journey?
  !!(journey_log.instantiated_class != nil && !journey_log.instantiated_class.complete?)
end

private
  def deduct(amount)
    self.balance -= amount
  end

  def sufficient_balance_check?
    raise "insufficient funds" if balance < MINIMUM_FARE
  end
end
