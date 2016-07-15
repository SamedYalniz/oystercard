require_relative 'journey'

class JourneyLog

  attr_reader :journey_class, :instantiated_class, :journeys

  def initialize(journey_class)
    @journey_class = journey_class
    @journeys = []
  end

  def starting_journey(start_point = "Unknown")
    @instantiated_class = @journey_class.new(start_point)
  end

  def ending_journey(end_point = "Unknown")
    current_journey.finish_journey(end_point)
    journey_builder
  end


private
  def journey_builder
    @journeys << @instantiated_class
  end

  def current_journey()
    if @instantiated_class.complete?
      starting_journey(start_point = "")
    else
      @instantiated_class
    end
  end
end
