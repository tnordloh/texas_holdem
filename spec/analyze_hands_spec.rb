require "minitest/autorun"

require_relative "../lib/texas_holdem/analyze_hands"

describe TexasHoldem::AnalyzeHands do
  it "prints hands" do
    hands = [ %w[Kc 9s Ks Kd 9d 3c 6d],
              %w[9c Ah Ks Kd 9d 3c 6d],
              %w[Ac Qc Ks Kd 9d 3c],
              %w[9h 5s],
              %w[4d 2d Ks Kd 9d 3c 6d],
              %w[7s Ts Ks Kd 9d]
            ]
    TexasHoldem::AnalyzeHands.new(hands).to_s.must_equal(
      "Kc 9s Ks Kd 9d 3c 6d Full House (winner)\n"+
       "4d 2d Ks Kd 9d 3c 6d Flush\n"+
       "9c Ah Ks Kd 9d 3c 6d Two Pair\n"+
       "9h 5s\n"+ 
       "Ac Qc Ks Kd 9d 3c\n"+ 
       "7s Ts Ks Kd 9d"
    )
  end
end
