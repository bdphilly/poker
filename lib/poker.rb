# -*- coding: utf-8 -*-

class Card
  attr_reader :suit, :value

  # SUITS = [ :spade, :club, :diamond, :heart]

  SUITS = {
            :club    => "♣",
            :diamond => "♦",
            :heart   => "♥",
            :spade   => "♠"
          }

  # VALUES = [ :ace, :king, :queen, :jack, :ten,
  #            :nine, :eight, :seven, :six, :five,
  #            :four, :three, :two ]

  NUM_VALUE = {
                :ace => 14, :king => 13, :queen => 12,
                :jack => 11, :ten => 10, :nine => 9,
                :eight => 8, :seven => 7, :six => 6,
                :five => 5, :four => 4, :three => 3,
                :two => 2
              }

  def self.values
    NUM_VALUE.keys
  end

  def num_value
    NUM_VALUE[self.value]
  end

  def initialize(suit, value)
    @suit, @value = suit, value
  end

  def == (other_card)
    (self.suit == other_card.suit) && (self.value == other_card.value)
  end

end

class Deck

  def initialize
    @all_cards = all_cards
  end

  def all_cards
    [].tap do |the_deck|
      Card::SUITS.each do |suit|
        Card::NUM_VALUE.each do |value|
          the_deck << Card.new(suit, value)
        end
      end
    end
  end

  def deal(num = 5)
    self.all_cards.pop(num)
  end
end

class Hand

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def discard(indicies)
    p indicies
    indicies.sort.reverse.each do |index|
      self.cards.delete_at(index)
    end
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

  def sort
    @cards = @cards.sort_by! {|card| card.num_value }.reverse
  end

  def convert_to_string

    self.sort

    string_representation = ""

    cards.each do |card|
      string_representation += card.num_value.to_s.rjust(2, '0')
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
    self.sort

    occurences = Hash.new(0)
    cards.each do |card|
      occurences[card.value] += 1
    end

    occurences.count == 5 &&
    (cards[0].num_value - cards[-1].num_value == 4 ||
    cards[0].num_value - cards[-1].num_value == 12)

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

class Player

  attr_accessor :bankroll, :hand, :name

  def initialize(bankroll = 1000)
    @bankroll = bankroll
  end

  def deal_new_hand(hand)
    self.hand = hand
  end

  def fold
    @folded = true
  end

  def unfold
    @folded = false unless bankroll.zero?
  end

  def folded?
    bankroll.zero? || @folded
  end

end

class Game

  attr_accessor :players, :pot, :deck

  def initialize
    @players, @pot, @deck = [], 0, Deck.new.shuffle
  end

  def add_player(player)
    @players << player
  end

  def deal_new_hand(hand)
    self.hand = hand
  end


  def unfold_players
    players.each do |player|
      player.unfold
    end
  end

  def deal_cards
    self.deck = Deck.new.shuffle
    players.each do |player|
      next if player.folded?
      player.deal_new_hand(deck.deal)
    end
  end

  def betting_round
    #Need to write
  end

  def discard_and_trade_cards
    players.each_with_index do |player, index|
      next if player.folded?
      puts "Player #{i + 1}:"
      puts player.hand #need to write to_s method
      puts "What cards would you like to trade?"
      puts "Please enter the indicies of your card."
      input = gets.chomp
      unless input.nil?
        player.hand.discard(input)
        player.hand.deal(input.length)
      end
      puts player.hand
    end
  end

  def end_of_round
    puts "Let's see those hands folks!"
    players.each_with_index do |player, i|
      next if player.folded?
      puts "Player #{i + 1} : #{player.hand}"
    end
  end

  def winner
    raise "We're moving onto the next round..." unless game_over?
    players.sort.last
  end

  def game_over?
    players.select { |player| !player.bankroll == 0 }.count == 1
  end

  def game_order
    # unfold players
    # deal/new deck
    # place_bets
    # fold
    # ennd round && return if game over
    # discard and trade cards
    # take bets
    # end round/winner of round
  end





  def deal

  end




end



# hand = Hand.new(deck.deal)
#in Game class, to deal:   player_1.new_hand(hand)

  # organize hand into sorted array of cards
  #### METHOD

  # puts "here is your hand #{hand}"
  #
  # puts 'what cards? you can only discard 3.'

  #the player returns [2,3]
  ##### METHOD

  # find hand[2], hand[3] and remove from hand
  ##### METHOD

  # hand currently has 3 cards

  # hand << deck.deal(2)

  #RETURNS new hand


  #....player1.hand = the new hand

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
# d = Deck.new
# h = Hand.new(d.deal)
# p h
# h = h.sort
# p h
# # h.cards.each do |card|
#   p card
# end