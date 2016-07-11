require 'oystercard'
describe Oystercard do
  subject(:card){described_class.new}

  it 'freshly initialized card has 0 balance' do
    expect(card.balance). to eq 0
  end

  it 'tops up the card' do
    random_number = rand(1000)
    card.top_up(random_number)
    expect(card.balance).to eq random_number
  end

end
