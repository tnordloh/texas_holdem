module TexasHoldem
  class Card
    def initialize(face,suit)
      @face,@suit=face,suit
    end
    attr_reader :face, :suit
    def to_s
      return "#{@face.to_s}#{@suit.to_s}"
    end
    include Comparable
    def value
      alpha_cards= {
        "T" => 10,
        "J" => 11,
        "Q" => 12,
        "K" => 13,
        "A" => 14
      }
      @value = @face.to_i !=0 ? @face.to_i : alpha_cards[@face]
    end
    def <=>(other)
      self.value <=> other.value
    end
    def include?(other)
      self.face <=> other.face && self.suit <=> other.suit
    end
  end
end
