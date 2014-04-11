require 'poker'

describe Card do

  let(:card) { Card.new(:spade, :seven) }

  describe '#initialize' do
    it 'should have a suit' do
      expect(card.suit).to eq(:spade)
    end

    it 'should have a value' do
      expect(card.value).to eq(:seven)
    end
  end
end

describe Deck do

  let(:deck) { Deck.new }

  describe '#initialize' do
    it 'should contain 52 unique cards' do
      expect(deck.all_cards.map{|card| [card.suit, card.value]}.uniq.count).to eq(52)
    end
  end

  describe '#deal' do
    it 'should deal 5 cards to each player when no number is passed' do
      expect(deck.deal.count).to eq(5)
    end
  end

  it 'should only deal 5 cards when no number is passed' do
    expect(deck.deal.count).to_not eq(4)
  end

  describe '#deal' do
    it 'should deal only card objects to each player' do
      expect((deck.deal(1)).first).to be_a(Card)
    end
  end

  describe '#deal' do
    it 'should NOT deal 5 cards to each player when number passed is not 5' do
      expect(deck.deal(3).count).to_not eq(5)
    end
  end



end