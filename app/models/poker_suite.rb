class PokerSuite < ActiveRecord::Base
	
	#a poker suite has many poker cards
    #poker card belongs to a poker suite
    #foreign key goes on the poker cards table
	has_many :poker_cards

	
end
