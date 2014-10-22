require "minitest/autorun"

require_relative "../lib/texas_holdem/hand"

describe TexasHoldem::Hand do

  it "outputs a hand" do
    hands = [
      %w[9c Ah Ks Kd 9d 3c 6d]
    ] 
    hands.map! { |hand| TexasHoldem::Hand.new(hand) }
    hands[0].sort!.reverse!
    hands[0].to_s.must_equal("Ah Kd Ks 9c 9d 6d 3c")
  end

  it "finds the best combination of cards" do
    cards=  %w[Ah Kh Qh Jh Th 4s 8d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(1014)
    cards=  %w[2c 2s 3h 3d 3c 4s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(709)
    cards=  %w[2c 2s 2h 2d 6c 7s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(809)
    cards=  %w[2c 3c 4c 5c 6c 7s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(909)
    cards=  %w[2c 4c 6c 8c Tc 7s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(610)
    cards=  %w[2c Ah 3s 4d 5d 7s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(514)
    cards=  %w[Kc Ah Qs Jd Td 6s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(514)
    cards=  %w[9c Ah Ks Kd 7d 9s 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(714)
    cards=  %w[9c Ah Ks Kd 7d 3c 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(314)
    cards=  %w[8c Ah Ks Kd 7d 3c 9d]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(214)
    cards=  %w[Ac Qh Ts 8d 6c 4s 2h]
    hand = TexasHoldem::Hand.new(cards) 
    hand.get_best_hand.must_equal(114)
  end

  it "returns the more valuable hand" do
    cards=  %w[Ah Kh Qh Jh Th 4s 8d]
    royal_flush = TexasHoldem::Hand.new(cards)
    cards=  %w[2c 2s 3h 3d 3c 4s 9d]
    straight_flush = TexasHoldem::Hand.new(cards) 
    cards=  %w[Ah Kh Qh Jh Th 4s 8d]
    royal_flush_eight_kicker = TexasHoldem::Hand.new(cards)
    cards=  %w[Ad Kd Qd Jd Td 5s 9d]
    royal_flush_nine_kicker = TexasHoldem::Hand.new(cards) 
    (royal_flush_nine_kicker>straight_flush).must_equal(true)
  end
  it "raises an error if duplicate card appears in hand" do
    hands = [
      %w[9c Ah Ks Kd 9d 3c 9d]
    ] 
    ->do
      hands.map! { |hand| TexasHoldem::Hand.new(hand) }
    end.must_raise(RuntimeError)
  end

end
