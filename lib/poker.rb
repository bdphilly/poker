class Card
  attr_reader :suit, :value

  SUITS = [ :spade, :club, :diamond, :heart]

  VALUES = [ :ace, :king, :queen, :jack, :ten,
             :nine, :eight, :seven, :six, :five,
             :four, :three, :two ]

  def initialize(suit, value)
    @suit, @value = suit, value
  end
end

class Deck

  def initialize
    @all_cards = all_cards

  end

  def all_cards
    [].tap do |the_deck|
      Card::SUITS.each do |suit|
        Card::VALUES.each do |value|
          the_deck << Card.new(suit, value)
        end
      end
    end
  end

  def deal(num = 5)
    self.all_cards.shuffle.pop(num)
  end
end

