class Card
  attr_reader :suit, :value

  SUITS = [ :spade, :club, :diamond, :heart]

  VALUES = [ :ace, :king, :queen, :jack, :ten,
             :nine, :eight, :seven, :six, :five,
             :four, :three, :two ]

  NUM_VALUE =   { :ace => 14, :king => 13, :queen => 12,
                  :jack => 11, :ten => 10, :nine => 9,
                  :eight => 8, :seven => 7, :six => 6,
                  :five => 5, :four => 4, :three => 3,
                  :two => 2
                }

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

  def beats?(opposing_hand)

    if self.evaluate_hand < opposing_hand.evaluate_hand
      return false
    elsif self.evaluate_hand > opposing_hand.evaluate_hand
      return true
    else
      return self.convert_to_string > opposing_hand.convert_to_string
    end
  end

  def convert_to_string
    array_of_nums = []
    cards.each do |card|
      array_of_nums << Card::NUM_VALUE[card.value]
    end

    (array_of_nums.sort!).reverse!

    string_representation = ''
    array_of_nums.each do |element|
      string_representation += element.to_s.rjust(2, '0')
    end

    if self.straight? && string_representation[-1] == '2'
      string_representation[0..1] = ''
      string_representation += '01'
    end

    string_representation

  end

  def evaluate_hand
    outcomes = [
      royal_flush?,
      four_of_kind?,
      full_house?,
      straight_flush?,
      flush?,
      straight?,
      three_of_kind?,
      two_pair?,
      one_pair?
    ]

    outcomes.each_with_index do |outcome, i|
      return 9 - i if outcome
    end

    0
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
    three_of_kind? && one_pair?
  end

  def flush?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.suit] += 1
    end

    occurences.has_value?(5)
  end

  def straight_flush?
    flush? && straight?
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

    (array_of_indicies.uniq.count == 5) &&
    (((array_of_indicies.last - array_of_indicies.first) == 4) ||
    ((array_of_indicies.last - array_of_indicies.first) == 12 ))
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

  def one_pair?
    occurences = Hash.new(0)

    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.has_value?(2)
  end

end
#
# class Player
#
#   attr_accessor :pot, :hand
#
#   def initialize(pot = 100)
#     @pot = pot
#   end
#   # hand = Hand.new(deck.deal)
#   #in Game class, to deal:   player_1.new_hand(hand)
#
#   def discard
#
#     # organize hand into sorted array of cards
#     #### METHOD
#
#     puts "here is your hand #{hand}"
#
#     puts 'what cards? you can only discard 3.'
#
#     #the player returns [2,3]
#     ##### METHOD
#
#     # find hand[2], hand[3] and remove from hand
#     ##### METHOD
#
#     # hand currently has 3 cards
#
#     # hand << deck.deal(2)
#
#     #RETURNS new hand
#
#
#     #....player1.hand = the new hand
#   end
#
#
#
# end

# class Game
#
#   attr_accessor :deck
#
#   def initialize
#     @player1 = Player.new
#     @player2 = Player.new
#   end
#
#
#   def play
#     @deck = Deck.new
#
#     @player1.hand = Hand.new(deck.deal)
#     @player2.hand = Hand.new(deck.deal)
#
#     puts 'do you want to discard, player 1?'
#     if gets.chomp == 'y'
#       @player1.hand = @player1.discard
#
#
#
#   end
# end



# Poker hand score

# relative hand value +
# needs to sort cards. suit doesn't matter.
# 14 for ace, 13 for king, 12 for queen, 11 for jack, 10 for 10, 9 for 9, etc.
#