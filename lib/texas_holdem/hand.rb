require_relative "./card"
module TexasHoldem
  HAND_LIST = {
    :high_card      =>1,
    :pair           =>2,
    :two_pair       =>3,
    :three_of_a_kind=>4,
    :straight       =>5,
    :flush          =>6,
    :full_house     =>7,
    :four_of_a_kind=>8,
    :straight_flush=>9,
    :royal_flush   =>10
  }
  class Hand
    include Comparable

    def initialize cards
      check_for_duplicates cards
      @cards = cards.map {|card| TexasHoldem::Card.new(*card.split("")) }
    end

    def sort!
      @cards.sort!
    end

    def to_s list=@cards
      return list.join(" ") {|card| card.to_s}
    end

    def hand_name
      return nil if @hand_name==nil
      @hand_name.to_s.split(/_/).map { |word| word.capitalize }.join(" ")
    end

    def get_best_hand
      return 0 if folded?
      inverted_list=TexasHoldem::HAND_LIST.invert
      inverted_list.keys.sort.reverse.each do |key|
        @hand_name=inverted_list[key]
        if (hands = self.send "find_#{@hand_name}").size >=1
          @current_best_hand=most_valuable_valid_hand(hands)
          return key*100 + high_card_value(@current_best_hand)
        end
      end
    end

    private

    def most_valuable_valid_hand hands
      hands.max { |hand| high_card_value(hand)*100 + get_kicker_value(hand) }
    end

    def <=>(other)
      self.get_best_hand<=>other.get_best_hand
    end

    def find_four_of_a_kind
      find_cards_with_same_face_value(4)
    end

    def find_three_of_a_kind
      find_cards_with_same_face_value(3)
    end

    def find_two_pair
      (x=find_pair).size>=2 ? x : []
    end

    def find_pair
      find_cards_with_same_face_value(2)
    end

    def find_full_house
      @cards.combination(5).select do |list| 
        list.sort!
        all_same?(list[0..1],"face") && all_same?(list[2..-1],"face") ||
          all_same?(list[0..2],"face") && all_same?(list[3..-1],"face")
      end
    end

    def find_royal_flush
      find_straight_flush.select {|list| list[0].value==10}
    end

    def find_straight_flush
      find_straight.select {|list| all_same?(list,"suit") }
    end

    def find_flush 
      @cards.combination(5).select {|list| all_same?(list,"suit") }
    end

    def find_high_card
      @cards.combination(5)
    end

    def find_straight
      potential_straights=@cards.combination(5).to_a
      aces_first = create_aces_first_list(potential_straights)
      (potential_straights + aces_first).select { |list| all_in_order?(list) }
    end

    def folded?
      @cards.size != 7
    end

    def high_card_value cards=@cards
      @cards.max.value
    end

    def get_kicker_value hand=@cards
      return 0 unless hand.size<5
      kicker_pool = @cards.reject {|card| hand.include?(card) }
      high_card_value(kicker_pool)
    end

    def all_same? list, type="suit"
      list[1..-1].all? { |card| card.send(type)==list[0].send(type) }
    end

    def all_in_order? list
      starting_value = list[0].face == "A" ? 1 : list[0].value
      list[1..-1].all? { |card| (starting_value += 1)  == card.value }
    end

    def find_cards_with_same_face_value count=2
      @cards.combination(count).select { |list| all_same?(list,"face") }
    end

    def check_for_duplicates cards
      duplicates = cards.detect {|card| cards.count(card)>1 }
      raise "duplicate card(s) found: #{duplicates}" if !!duplicates 
    end

  end

end

