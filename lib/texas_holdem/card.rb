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
      if @face.to_i !=0
        face=@face.to_i
      elsif @face == "T"
        @value=10
      elsif @face == "J"
        @value=11
      elsif @face == "Q"
        @value=12
      elsif @face == "K"
        @value=13
      elsif @face == "A"
        @value=14
      end
    end
    def <=>(other)
      self.value <=> other.value
    end
    def include?(other)
      self.face <=> other.face && self.suit <=> other.suit
    end
  end
end
