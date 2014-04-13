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

describe Hand do

  let(:deck) { Deck.new }
  let(:hand) { Hand.new(deck.deal) }

  describe '#initialize' do
    it 'should contain five cards' do
      expect(hand.cards.count).to eq(5)
    end
  end

  describe 'recognizes hands' do

      it "should recognize a royal flush" do
        hand = Hand.new([
          Card.new(:heart, :ace),
          Card.new(:heart, :king),
          Card.new(:heart, :queen),
          Card.new(:heart, :jack),
          Card.new(:heart, :ten)
          ])
        expect(hand.royal_flush?).to be true
      end

      it "should recognize four of a kind" do
        hand = Hand.new([
          Card.new(:heart,   :ace),
          Card.new(:club,    :ace),
          Card.new(:spade,   :ace),
          Card.new(:diamond, :ace),
          Card.new(:heart,   :ten)
          ])
        expect(hand.four_of_kind?).to be true
      end

      it "should recognize a full house" do
        hand = Hand.new([
          Card.new(:heart, :ace),
          Card.new(:spade, :ace),
          Card.new(:heart, :four),
          Card.new(:club,  :four),
          Card.new(:spade, :four)
          ])
        expect(hand.full_house?).to be true
      end

      it "should recognize a straight flush" do
        hand = Hand.new([
          Card.new(:heart, :ten),
          Card.new(:heart, :nine),
          Card.new(:heart, :eight),
          Card.new(:heart, :seven),
          Card.new(:heart,  :six)
          ])
        expect(hand.straight_flush?).to be true
      end


      it "should recognize a flush" do
        hand = Hand.new([
          Card.new(:heart, :jack),
          Card.new(:heart, :king),
          Card.new(:heart, :two),
          Card.new(:heart, :five),
          Card.new(:heart,  :four)
          ])
        expect(hand.flush?).to be true
      end

      it "should recognize a straight without an ace" do
        hand = Hand.new([
          Card.new(:heart, :eight),
          Card.new(:heart, :seven),
          Card.new(:heart, :six),
          Card.new(:heart, :five),
          Card.new(:spade, :four)
          ])
        expect(hand.straight?).to be true
      end

      it "should recognize a straight with a low ace" do
        hand = Hand.new([
          Card.new(:heart, :ace),
          Card.new(:heart, :two),
          Card.new(:heart, :three),
          Card.new(:heart, :four),
          Card.new(:spade, :five)
          ])
        expect(hand.straight?).to be true
      end

      it "should recognize a straight with a high ace" do
        hand = Hand.new([
          Card.new(:heart, :ten),
          Card.new(:heart, :jack),
          Card.new(:heart, :queen),
          Card.new(:heart, :king),
          Card.new(:spade, :ace)
          ])
        expect(hand.straight?).to be true
      end

      it "should recognize three of a kind" do
        hand = Hand.new([
          Card.new(:heart, :ace),
          Card.new(:spade, :ace),
          Card.new(:club,  :ace),
          Card.new(:heart, :nine),
          Card.new(:spade, :ten)
          ])
        expect(hand.three_of_kind?).to be true
      end

      it "should recognize two pair" do
        hand = Hand.new([
          Card.new(:heart, :ace),
          Card.new(:spade, :ace),
          Card.new(:heart, :seven),
          Card.new(:spade, :seven),
          Card.new(:spade, :ten)
          ])
        expect(hand.two_pair?).to be true
      end


      it "should recognize one pair" do
        hand = Hand.new([
          Card.new(:spade, :ace),
          Card.new(:heart, :ace),
          Card.new(:heart, :four),
          Card.new(:heart, :six),
          Card.new(:spade, :ten)
          ])
        expect(hand.one_pair?).to be true
      end
  end

  describe "returns relative hand value" do

    it "should return 8 for royal flush (low value wins)" do
      hand = Hand.new([
        Card.new(:heart, :ace),
        Card.new(:heart, :king),
        Card.new(:heart, :queen),
        Card.new(:heart, :jack),
        Card.new(:heart, :ten)
        ])
      expect(hand.evaluate_hand).to eq(9)
    end

    it "should return 0 if there are no 'winning' hands" do
      hand = Hand.new([
        Card.new(:heart, :ace),
        Card.new(:heart, :king),
        Card.new(:heart, :four),
        Card.new(:spade, :jack),
        Card.new(:heart, :ten)
        ])
      expect(hand.evaluate_hand).to eq(0)
    end
  end

    it "should know when a jack high straight beats a ten high straight" do
      hand1 = Hand.new([
        Card.new(:heart, :jack),
        Card.new(:heart, :ten),
        Card.new(:heart, :nine),
        Card.new(:spade, :eight),
        Card.new(:heart, :seven)
        ])

      hand2 = Hand.new([
        Card.new(:heart, :ten),
        Card.new(:spade, :nine),
        Card.new(:heart, :eight),
        Card.new(:club,  :seven),
        Card.new(:heart, :six)
        ])
      expect(hand1.beats?(hand2)).to be true
    end

    it "should know when a king high beats a ten high" do
      hand1 = Hand.new([
        Card.new(:heart, :jack),
        Card.new(:heart, :ten),
        Card.new(:heart, :nine),
        Card.new(:spade, :king),
        Card.new(:heart, :two)
        ])

      hand2 = Hand.new([
        Card.new(:heart, :ten),
        Card.new(:spade, :nine),
        Card.new(:heart, :five),
        Card.new(:club,  :four),
        Card.new(:heart, :two)
        ])
      expect(hand1.beats?(hand2)).to be true
    end

  describe '#beats' do

    it "should know when a straight beats two pair" do
      hand1 = Hand.new([
        Card.new(:heart, :nine),
        Card.new(:heart, :eight),
        Card.new(:heart, :seven),
        Card.new(:spade, :six),
        Card.new(:heart, :five)
        ])

        hand2 = Hand.new([
        Card.new(:heart, :eight),
        Card.new(:spade, :seven),
        Card.new(:heart, :jack),
        Card.new(:club,  :jack),
        Card.new(:heart, :seven)
        ])
      expect(hand1.beats?(hand2)).to be true
    end

    it "should know when a higher full house beats a lower full house" do
      hand1 = Hand.new([
        Card.new(:heart, :nine),
        Card.new(:club,  :nine),
        Card.new(:spade, :nine),
        Card.new(:spade, :four),
        Card.new(:heart, :four)
        ])

        hand2 = Hand.new([
        Card.new(:heart, :eight),
        Card.new(:club,  :eight),
        Card.new(:spade, :eight),
        Card.new(:spade, :seven),
        Card.new(:heart, :seven)
        ])
      expect(hand1.beats?(hand2)).to be true
    end




  end

  describe '#convert_to_string' do

    it "should convert hand value to a sorted string" do
      hand1 = Hand.new([
        Card.new(:heart, :ace),
        Card.new(:heart, :ten),
        Card.new(:heart, :jack),
        Card.new(:spade, :king),
        Card.new(:heart, :queen)
        ])

      expect(hand1.convert_to_string).to eq('1413121110')
    end

    it "should check for ace low straight and switch to low ace conversion" do
      hand1 = Hand.new([

        Card.new(:heart, :five),
        Card.new(:heart, :four),
        Card.new(:heart, :three),
        Card.new(:spade, :two),
        Card.new(:heart, :ace)
        ])

      expect(hand1.convert_to_string).to eq('0504030201')
    end
  end

    # it "should know when a full house beats another full house" do
    #   hand1 = Hand.new([
    #     Card.new(:heart, :nine),
    #     Card.new(:club,  :nine),
    #     Card.new(:spade, :nine),
    #     Card.new(:spade, :four),
    #     Card.new(:heart, :four)
    #     ])
    #
    #     hand2 = Hand.new([
    #     Card.new(:heart, :eight),
    #     Card.new(:club,  :eight),
    #     Card.new(:spade, :eight),
    #     Card.new(:spade, :seven),
    #     Card.new(:heart, :seven)
    #     ])
    #   expect(hand1.beats?(hand2)).to be true
    # end


end

# describe Player do
#
#   let(:player) { Player.new }
#   let(:hand) { Hand.new(deck.deal) }
#   let(:deck) { Deck.new }
#
#   describe '#initialize' do
#     it 'should be a player' do
#       expect(player).to be_a(Player)
#     end
#   end
#
#   describe '#pot' do
#     it 'should have a pot' do
#       expect(player.pot).to_not be_nil
#     end
#   end
#
#   describe '#new_hand' do
#     it 'should deal a new hand to the player' do
#       expect(player.new_hand(hand)).to be_a(Hand)
#     end
#   end
#
#   # describe '#get_cards_to_discard' do
#   #   it 'should receive array of cards from the user' do
#   #     expect(player.get_cards_to_discard(cards)).to be_a(Array)
#   #   end
#   #
#   #   it 'should receive array of cards from the user' do
#   #     expect(player.get_cards_to_discard(cards)).to be_a(Array)
#   #   end
#   # end
#
#
#   # describe '#discard' do
#   #   old_hand = hand
#   #   it 'should return a new hand when called' do
#   #     expect(player.discard).to_not eq(old_hand)
#   #   end
#   # end
#
#
# end
#
