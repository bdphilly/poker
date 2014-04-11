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

class Hand

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def royal_flush?
    suit = cards[0].suit

    cards.each do |card|
      return false unless [:ace, :king, :queen, :jack, :ten].include?(card.value)
      return false if card.suit != suit
    end

    true
  end

  def four_of_kind?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.has_value?(4)
  end

  def full_house?
    three_of_kind? && two_of_kind?
  end

  def flush?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.suit] += 1
    end

    occurences.has_value?(5)
  end

  def straight?
    sort_hash = {}
    Card::VALUES.each_with_index do |each, index|
      sort_hash[each] = index
    end

    array_of_indicies = []

    cards.each do |card|
      array_of_indicies << sort_hash[card.value]
    end

    array_of_indicies.sort!

    ((array_of_indicies.last - array_of_indicies.first) == 4) ||
    ((array_of_indicies.last - array_of_indicies.first) == 12 ) &&
    (array_of_indicies.uniq.count == 5)

  end

  def three_of_kind?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.has_value?(3)
  end

  def two_pair?
    occurences = Hash.new(0)
    pairs = []

    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.each do |k, v|
      pairs << k if v == 2
    end

    pairs.length == 2
  end

  def two_of_kind?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.has_value?(2)
  end
end


