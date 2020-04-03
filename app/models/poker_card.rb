class PokerCard < ActiveRecord::Base

	#poker card belongs to a poker suite
	#a poker suite has many poker cards
	#foreign key goes on the poker cards table
	belongs_to :poker_suite

	#set when the user holds the card
	#setter
  	def hold=(hold)
    	@hold = hold
  	end
  	#
  	#getter
  	def hold
    	@hold
  	end

  	#used for sorting etc.. when we want to esclude cards
  	def exclude=(exclude)
    	@exclude = exclude
  	end
  	def exclude
    	@exclude
  	end

  	#init - like a ctr except is called after the object is already created
	def initialize
		@hold = true  
		@exclude = false


		#call the base class constructor/initialize
    	super
	end

	def self.ids(pokercards)

		ret = ""

		pokercards.each do |card| 

			#remove the decimal with floor
			ret += card.id.floor.to_s + ","

		end

		#remove the last comma, ! makes it destructive 
		#slice: pick a starting point to slice 
		#       pick a number of items to slice
		ret.slice!(ret.length-1, ret.length)

		return ret

	end

	#build session card list from cardids cached in database
	def self.sessioncards(cardids)

		#order by decode(id,39,1,25,2,24,3,36,4,45)
		# so the cards stay in order from then they whers saved
		sql = "select * from poker_cards where id in ("
		sql += cardids
		sql += ") order by decode(id,"

		#sort by the order of the ids listed in the in clause
		i=0
		idArray = cardids.split(',')
		idArray.each do |val|
			i+=1
			sql += val.to_s + "," + i.to_s + ","

		end

		sql.slice!(sql.length-1, sql.length)
		sql += ")"

		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = false

			cardArray.push(pcard)
		end

		return cardArray
	end

	#gets 5 cards same suite used for testing and play views
	def self.flush
		cardArray = Array.new
		pokercards = PokerCard.all.sample(30)

 		bfirst = true
		nCount = 0
		nSuite = 0

		pokercards.each do |card|

			if bfirst
				nSuite = card.poker_suite_id
				bfirst = false;
			end

			if card.poker_suite_id == nSuite
				card.hold = true
				cardArray.push(card)
				nCount += 1
				if nCount == 5
					return cardArray
				end
			end
		end

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }
	end

	#gets 4 of a kind hand, used for testing and play views
	def self.fourofakind

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where card_value = 14 or id = 2"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

		#another way
		#cardArray = Array.new
		#cards = PokerCard.all
 		#cards.each do |card|
 		#	if card.card_value == 14
 		#		cardArray.push(card)
		#	end 
		#end
		#
		#return cardArray
	end

	#gets 3 of a kind hand, used for testing and play views
	def self.threeofakind

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (48,35,22,40,43)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

	end

	#gets 3 of a kind hand, used for testing and play views
	def self.getHandbyIds(inStringofIds)

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (" + inStringofIds + ")"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		return cardArray.sort

	end

	#gets 3 of a kind hand, used for testing and play views
	def self.fullhouse

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards t where id in (7,20,33,31,18)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

	
		return cardArray.sort

	end


	#gets 3 of a kind hand, used for testing and play views
	def self.straightflush

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards t where id in (20,21,22,23,24)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

	
		return cardArray.sort

	end


	#gets royal flush, used for testing and play views
	def self.royalflush

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (1,13,12,11,10) order by card_value desc"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

	end

	#gets low straight, used for testing and play views
	def self.lowstraight

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards t where id in (5,6,20,34,48) order by card_value desc"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		return cardArray

	end

	#gets low straight, used for testing and play views
	def self.acelowstraight

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (27,15,29,4,18) order by card_value desc"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.card_value = key['card_value']

			pcard.poker_suite_id = key['poker_suite_id']
			
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		return cardArray
	end


	#gets low straight, used for testing and play views
	def self.highstraight

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (13,12,24,36,48) order by card_value desc"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

	end

	#gets low straight, used for testing and play views
	def self.acehighstraight

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (27,26,12,50,23)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		return cardArray

	end

	#todo:
	#acehighstraight
	#acelowstraight
	#royalflush
	#straightflush


	#gets 2 pair testing and play views
	def self.twopair

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (41,36,23,31,18)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

	end

	#gets 1 pair testing and play views
	def self.onepair

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (47,34,40,31,46)"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#cardArray.shuffle!

		return cardArray.sort! { |a,b| b.card_value <=> a.card_value }

	end

	#gets high card hand testing and play views
	def self.highcard

		#just wanted to know how to exucute raw sql in rails
		sql = "select * from poker_cards where id in (47,37,41,25,16) order by card_value desc"
		recArray = ActiveRecord::Base.connection.exec_query sql 

		#turn the array into a hash of cards
		#todo: might be a better way
		cardArray = Array.new
		recArray.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = true

			cardArray.push(pcard)
		end

		#sorting above in query
		#cardArray.shuffle!

		#cardArray.sort! { |a,b| b.card_value <=> a.card_value }

		#cardArray.sort_by { |h| h[:card_value] }.reverse!

		return cardArray;
	end

	#named scopes - custom queries defined in a model
	#rails 4 requires rubys lambda syntax
	#lambda is an anonomous functon in ruby
	#they are evaluated when they are called not when they are deined

	#the 5 dealer cards
	scope :dealercards, lambda {PokerCard.all.shuffle.sample(5)}

	#the 5 palayers cards excluding dealers cards
    scope :playercards, lambda {|dealerscards| where.not(id: dealerscards).shuffle.sample(5)}

	#the 5 possible draw cards excluding dealer and player cards
    #Using a class method is the preferred way to accept arguments for scopes
	def self.drawcards(dcards, pcards, drawcount)
	    drwcards = PokerCard.where.not(id: dcards)
	    drwcards = drwcards.reject{ |e| pcards.include? e }
	    drwcards = drwcards.shuffle.sample(5)

	    #limit the array of hold cards to the number of cards they seclected
	    #sample is 5 cards, we get passed how many they want to draw
	    #so we need to pop those to get the draw sample 0 to 5 possible
	    drwcards.pop(drawcount)
	end

	#builds stat text from cards passed in
	def self.statcards(cards)
	    stat = "";

	    cards.each do |card|

	    	#remove the decimal with floor
			stat += card.id.floor.to_s + ","
		end

		#remove the last comma, ! makes it destructive 
		#slice: pick a starting point to slice 
		#       pick a number of items to slice
		stat.slice!(stat.length-1, stat.length)

		return stat;
	end

	#builds an array of cards from a hash
	def self.fromhash(cardhash)
		cardArray = Array.new
		cardhash.each do |key, array|
			pcard = PokerCard.new
			pcard.id = key['id']
			pcard.poker_suite_id = key['poker_suite_id']
			pcard.card_value = key['card_value']
			pcard.card_description = key['card_description']
			pcard.card_face = key['card_face']
			pcard.card_name = key['card_name']
			pcard.card_plural = key['card_plural']
			pcard.hold = false

			cardArray.push(pcard)
		end
		return cardArray
	end

	#builds an array of cards from a hash
	#todo
	def self.fromSerial(serialhashdata)
		
		return serialhashdata
		
		h = Hash.new
		
		cardArray = Array.new
		
		h.each do |key, value|
			pcard = PokerCard.new
			#pcard.id = key['id']
			#pcard.poker_suite_id = key['poker_suite_id']
			#pcard.card_value = key['card_value']
			#pcard.card_description = key['card_description']
			#pcard.card_face = key['card_face']
			#pcard.card_name = key['card_name']
			#pcard.card_plural = key['card_plural']
			#pcard.hold = false

			cardArray.push(pcard)
		end
		return cardArray
	end

end
