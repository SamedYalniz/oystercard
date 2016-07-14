require "oystercard"

describe Oystercard do
  let(:entry_station) { double :station }
  let(:exit_station) {double :station}
  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it 'checks to see if the balance is 0' do
    expect(subject.balance).to eq 0
  end

  describe "#top_up" do
    it "top up the balance" do
      expect{ subject.top_up(Oystercard::MINIMUM_FARE) }.to change{ subject.balance }.by(Oystercard::MINIMUM_FARE)
    end
    it "raises error if exceeds the limit" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up(Oystercard::MINIMUM_FARE) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe 'status of card' do

    it 'has an empty list of journeys by default' do
      expect(subject.journey_history_array).to be_empty
    end

    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end
  end

    it "checks balance on touch in" do
      subject.balance < Oystercard::MINIMUM_FARE
      expect{ subject.touch_in(entry_station) }.to raise_error "insufficient funds"
    end

  context 'card activity' do
    before(:each) do
      subject.top_up(Oystercard::MINIMUM_FARE)
      subject.touch_in(entry_station)
    end

    it 'touch in' do
      expect(subject).to be_in_journey
    end
    it 'touch out' do
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq false
    end
    it 'charge balance on touch out' do
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by -Oystercard::MINIMUM_FARE
    end

    it 'stores a journey' do
      subject.touch_out(exit_station)
      expect(subject.journey_history_array).to include journey
    end
  end
end
