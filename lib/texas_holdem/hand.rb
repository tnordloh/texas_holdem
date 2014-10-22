require_relative "./card"
module TexasHoldem
  class Hand
    include Comparable
    HAND_LIST = {
    :folded => 0,
    :high_carD=>1,
    :pair=>2,
    :two_pair=>3,
    :three_of_a_kind=>4,
    :straighT=>5,
    :flush=>6,
    :full_house=>7,
    :four_of_a_kind=>8,
    :straight_flush=>9,
    :royal_flush=>10
    }

    def initialize cards
      check_for_duplicates cards
      @cards = cards.map {|card| 
        TexasHoldem::Card.new(*card.split("")) 
      }
      @current_best_hand = []
    end

    def hand_name
      return nil if @hand_name==nil
      @hand_name.to_s.split(/_/).map { |word| word.capitalize }.join(" ")
    end
    def folded?
      !(@cards.size==7)
    end

    def get_best_hand
      if folded?
        hand_name=:FOLDED
        return (hand_name)
      end
      inverted_list=TexasHoldem::Hand::HAND_LIST.invert
      inverted_list.keys.sort.reverse.each {|key|
        @hand_name=inverted_list[key]
        if (best_hand = self.send "find_#{@hand_name.downcase}").size >=1
          @current_best_hand=best_hand.max {|hand|
            high_card_value(hand)*100 + get_kicker_value(hand)
          }
          return TexasHoldem::Hand::HAND_LIST[@hand_name]*100 +
            high_card_value(@current_best_hand)
        end
      }
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
      x=find_cards_with_same_face_value(2)
      return x if x.size>=2
      return []
    end

    def find_pair
      find_cards_with_same_face_value(2)
    end

    def find_full_house
      @cards.combination(5).select {|list| 
        list.sort!
        all_same_value?(list[0..1]) && all_same_value?(list[2..-1])
      }
    end

    def find_royal_flush
      find_straight_flush.select {|list| list[0].value==10}
    end

    def find_straight_flush
      find_straight.select {|list| all_same_suit?(list) }
    end

    def find_flush 
      @cards.combination(5).select {|list| all_same_suit?(list) }
    end

    def find_high_card
      @cards.combination(5)
    end

    def find_straight
      potential_straights=@cards.combination(5).to_a
      aces_first = create_aces_first_list(potential_straights)
      (potential_straights + aces_first).select { |list| 
        all_in_order?(list)
      }
    end

    def create_aces_first_list potential_straights
      ace_first = []
      potential_straights.each {|list|
        list.sort!
        if list[-1].value==14
          temp = list.dup
          temp.unshift(temp.pop)
          ace_first << temp
        end
      }
      ace_first
    end

    def high_pair
      pairs = find_two_of_a_kind
      biggest_pair=pairs.shift
      pairs.each {|pair| biggest_pair = pair if pair[0]>biggest_pair[0]}
      @current_best_hand = biggest_pair 
      TexasHoldem::Hand.new(biggest_pair.map {|card| card.to_s})
    end

    def high_card_value cards=@cards
      @cards.max.value
    end

    def sort!
      @cards.sort!
    end

    def to_s list=@cards
      return list.join(" ") {|card| card.to_s}
    end

    def get_kicker_value hand=@cards
      return 0 unless hand.size<5
      kicker_pool = @cards.reject {|card| hand.include?(card) }
      high_card_value(kicker_pool)
    end
    private

    def all_same_suit? list
      suit=list[0].suit
      list[1..-1].all? {|card| card.suit==suit}
    end

    def all_in_order? list
      starting_value=list[0].value ==14 ? 1 : list[0].value
      list[1..-1].all?  {|card| 
        starting_value = starting_value + 1
        starting_value == card.value 
      }
    end

    def check_for_duplicates cards
      duplicates = cards.detect {|card| cards.count(card)>1 }
      raise "duplicate card(s) found: #{duplicates}" if duplicates != nil
    end

    def all_same_value? list
      first_card = list[0]
      list[1..-1].all?  {|card| first_card.face==card.face }
    end

    def find_cards_with_same_face_value count=2
      @cards.combination(count).select { |list| 
        all_same_value?(list)
      }
    end

  end

end

