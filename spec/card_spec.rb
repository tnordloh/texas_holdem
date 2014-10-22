require "minitest/autorun"

require_relative "../lib/texas_holdem/card"

describe TexasHoldem::Card do
  it "prints a card " do
    card=TexasHoldem::Card.new("A","h")
    card.to_s.must_equal("Ah")
  end
  it "sorts cards" do 
    card = []
    card  << TexasHoldem::Card.new("A", "h")
    card  << TexasHoldem::Card.new("K","h")
    (card[0]>card[1]).must_equal(true)
    (card[0]>=card[1]).must_equal(true)
    (card[0]==card[1]).must_equal(false)
    (card[0]<card[1]).must_equal(false)
  end
end
