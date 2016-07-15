require "oystercard"


describe Oystercard do
  let(:entry_station) { double :station, zone: 1}
  let(:exit_station) {double :station, zone: 1}
  let(:second_station) { double :station, zone: 1}

  let(:journey) {double Journey, entry_station: entry_station , exit_station: exit_station}

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

    it "second touch in charges penalty fare" do
      subject.top_up(20)
      expect{subject.touch_in(second_station)}.to change{subject.balance}.by -Oystercard::PENALTY_FARE
    end
    it 'touch out' do
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq false
    end

    it "second touch out charges penalty fare" do
      subject.touch_out(exit_station)
      expect{subject.touch_out(second_station)}.to change {subject.balance}.by -Oystercard::PENALTY_FARE
    end
    it 'charge balance on touch out' do
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by -Oystercard::MINIMUM_FARE
    end


  
  end

end
