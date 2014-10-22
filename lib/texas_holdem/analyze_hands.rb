require_relative "./hand"
module TexasHoldem
  class AnalyzeHands
    def initialize hands
      @hands = hands.map do |hand|
        TexasHoldem::Hand.new(hand)
      end
    end
    def sort!
      @hands.sort!
    end
    def to_s
      highest_score=0
      @hands.sort.reverse.map {|hand|
        current_score=hand.get_best_hand
        highest_score = current_score if current_score > highest_score 
        winner_string= current_score == highest_score ? "(winner)" : nil
        [hand, hand.hand_name, winner_string].compact.join(" ")
      }.join("\n")
    end
  end
end
