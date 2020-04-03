class PokerRanking < ActiveRecord::Base

	#the ranks in desc order
	scope :pokerrankings, lambda {PokerRanking.order(rank_order: :desc)}

	#holds the hands group 1 and 2
	def hgroup1=(hgroup1)
    	@hgroup1 = hgroup1
  	end
  	def hgroup1
    	@hgroup1
  	end

  	def hgroup2=(hgroup2)
    	@hgroup2 = hgroup2
  	end
  	def hgroup2
    	@hgroup2
  	end

	def hgroup1Plural=(hgroup1Plural)
    	@hgroup1Plural = hgroup1Plural
  	end
  	def hgroup1Plural
    	@hgroup1Plural
  	end

  	def hgroup2Plural=(hgroup2Plural)
    	@hgroup2Plural = hgroup2Plural
  	end
  	def hgroup2Plural
    	@hgroup2Plural
  	end

  	def hHighCard=(hHighCard)
    	@hHighCard = hHighCard
  	end
  	def hHighCard
    	@hHighCard
  	end

  	def c1=(c1)
    	@c1 = c1
  	end
  	def c1
    	@c1
  	end

  	def c2=(c2)
    	@c2 = c2
  	end
  	def c2
    	@c2
  	end

	def c3=(c3)
    	@c3 = c3
  	end
  	def c3
    	@c3
  	end

	def c4=(c4)
    	@c4 = c4
  	end
  	def c4
    	@c4
  	end

	def c5=(c5)
    	@c5 = c5
  	end
  	def c5
    	@c5
  	end

	def details=(details)
    	@details = details
  	end
  	def details
    	@details
  	end

  	#gets calculated 
	def tieBreaker=(tieBreaker)
    	@tieBreaker = tieBreaker
  	end
  	def tieBreaker
    	@tieBreaker
  	end

  	#init
	def initialize
		@rank = 0  
		@hgroup1 = Array.new
		@hgroup2 = Array.new
		@hgroup2Plural = ""
		@hgroup1Plural = ""
		@tieBreaker = 0

		@c1 = 0
		@c2 = 0
		@c3 = 0
		@c4 = 0
		@c5 = 0

		#call the base class constructor/initialize
    	super
	end

	#loops over cards and return them in sequence desc
	def self.sortcardsdesc(pokercards)
		#cardArray = Array.new
		#pokercards.each do |card|
		#	cardArray.push(card)
		#end

		#sort is not descructive so origianl list stays the same
		#cardArray = pokercards.sort { |a,b| b.card_value <=> a.card_value }
		
		return pokercards.sort { |a,b| b.card_value <=> a.card_value }
	end

	#loops over cards and return them in sequence asc
	def self.sortcardsasc(pokercards)
		cardArray = Array.new
		pokercards.each do |card|
			cardArray.push(card)
		end

		#sort! is descructive, original list is changed
		cardArray.sort! { |a,b| a.card_value <=> b.card_value }

		return cardArray
	end

	def self.debug(something)
		
		rankings = PokerRanking.pokerrankings
	  	
	  	str = ""

	  	rankings.each do |rank|

	  		if rank.only_cards.to_s.length > 0

	  			if rank.only_cards == "14,13,12,11,10,"
	  			
	  				str += "RFFF "
	  			
	  			end 
	  		else

	  			str += " NOT "
	  		end


		end

		return str


	end



	#look at the ranks and pull highest rank
	#todo: this will be optimized lare :)
	def self.rankcards(pokercards)
			
		#always sort the cards desc for compares
		hand = pokercards.sort { |a,b| b.card_value <=> a.card_value }

		#check for A,5,4,3,2,
		chklow = ""
		hand.each do |c|
			chklow += c.card_face + ","
		end

		if chklow == "A,5,4,3,2,"
			hand.each do |c|
				if c.card_value == 14
					c.card_value = 1
				end	
			end
			
			#resort the hand with the adjusted ace
			hand = hand.sort { |a,b| b.card_value <=> a.card_value }
		end


		#arrays that hold groups of mathing cards ie. 3 and 2 for full house
		g1 = Array.new
		g2 = Array.new
		g3 = Array.new #would only happen if we had more than 5 cards
		isFlush = false
		isStraight = false

		#prev card for compare, starts as dummy
		prev = PokerCard.new
		prev.id = 0
		prev.poker_suite_id = 0
		prev.card_value = 0
		prev.card_description = "x"
		prev.card_face = "X"
		prev.card_name = "X"
		prev.card_plural = "X"

		#which group are we loading 5 cards so only 2 max
		lvl = 1

		suitCount = 0
		straightCount = 0
		suit = 0
		prevCardVal = 0
		
		hasKQJor10 = false
		hasAce = false

		debug = " "# + hand.to_s
		g1plural = ""
		g2plural = ""

		highcard = PokerCard.new
		highcard.id = 0
		highcard.poker_suite_id = 0
		highcard.card_value = 0
		highcard.card_description = "x"
		highcard.card_face = "X"
		highcard.card_name = "X"
		highcard.card_plural = "X"

		onlyCards = ""

		tbg1 = 0
		tbg2 = 0
		
		#gathering some general values for compares etc...
		i = 0
		hand.each do |c|

			onlyCards += c.card_value.to_s + ","

			#this whole big decimal oracle number etc.. thing sucks!
			#will re-work it later so that values and ids are integers
			onlyCards = onlyCards.gsub! '.0', ''

			#used to determine if A is high or low in a straight
			if c.card_value > 9 and c.card_value < 14
				hasKQJor10 = true
			end

			if c.card_value == 14 or c.card_value == 1 
				hasAce = true
			end

			#keep the absolute high card
			if c.card_value > highcard.card_value
				highcard.id = c.id
				highcard.poker_suite_id = c.poker_suite_id
				highcard.card_value = c.card_value
				highcard.card_description = c.card_description
				highcard.card_face = c.card_face
				highcard.card_name = c.card_name
				highcard.card_plural = c.card_plural
			end

			#counter
			i += 1

			#keep each card value for compares
			if i == 1
				@c1 = c.card_value
			end
			if i == 2
				@c2 = c.card_value
			end
			if i == 3
				@c3 = c.card_value
			end
			if i == 4
				@c4 = c.card_value
			end
			if i == 5
				@c5 = c.card_value
			end


			#the only way suitCount and straightCount 
			#get to 5 is if all cards are same suit and in order
			if i == 1

				#first pass so start with current card
				#note we sort descending above...
				suit =  c.poker_suite_id
				suitCount = 1

				prevCardVal = c.card_value
				straightCount = 1

			else
				
				#if thecurrent card value + 1 = prev value then its in order
				#note we sort descending above...
				if (c.card_value + 1) == prevCardVal
					straightCount += 1
					prevCardVal = c.card_value
				end

				if c.poker_suite_id == suit
					suitCount += 1
				end

			end

			if suitCount >= 5 
				isFlush = true
			end

			if straightCount >= 5
				isStraight = true
			end

		end

		#reset i, its used below also
		i= 0
		
		#do the real work
		hand.each do |c|
			
			i += 1

			#compare current to prev
			if c.card_value == prev.card_value

				if lvl == 1 #first pair, 3 or 4 of a kind
				   g1plural = prev.card_plural
				   g1.push(prev);
				   tbg1 = 100000 * prev.card_value
				   if i == hand.count
				   		g1.push(c)
				   end
				end

				if lvl == 2
				   g2plural = prev.card_plural
				   g2.push(prev); #second pair
				   tbg2 = 100 * prev.card_value
				   if i == hand.count
				   		g2.push(c)
				   end
				end

				if lvl == 3
				   g3.push(prev); #third pair
				   if i == hand.count
				   		g3.push(c)
				   end
				end

			else

				#need to switch these to a case
				if lvl == 1
					if g1.count > 0
						g1plural = prev.card_plural
						g1.push(prev);
						tbg1 = 100000 * prev.card_value
						lvl = 2
					end		
				
				else

					if lvl == 2
						if g2.count > 0
							g2plural = prev.card_plural
							g2.push(prev);
							tbg2 = 100 * prev.card_value
							lvl = 3 #all done
						end		
					else
						if lvl == 3
							if g3.count > 0
								g3.push(prev);
								lvl = 4#all done
							end	
						end

					end
				end	
			end

			#last line so prev is set to current
			prev = c

		end
		
		#if not a straight or flush and no pair then use high card for g1
		if not isFlush
			if not isStraight
				if g1.count < 1
					g1.push(highcard)
					tbg1 = highcard.card_value
				end
			end
		end

		#set the order such that the 1st group 
		#is the one with the most cards
		#ie for a full house
		g1A = Array.new
		g2B = Array.new
		if g1.count >= g2.count 

			g1A = g1
			g2B = g2

		else
			
			g1A = g2
			g2B = g1

			gp1 = g1plural
			g1plural = g2plural
			g2plural = gp1

			tt = tbg1
			tbg1 = tbg2
			tbg2 = tt		

		end

		@tieBreaker = tbg1 + tbg2

		#note excluding g3 for now
		#loop over all possible rankings from top to bottom and look for a match
		rankings = PokerRanking.pokerrankings
	  	rankings.each do |rank|

	  		rank.hgroup1Plural = g1plural
	  		rank.hgroup2Plural = g2plural
	  		rank.hHighCard = highcard
	  		rank.c1 = @c1
	  		rank.c2 = @c2
	  		rank.c3 = @c3
	  		rank.c4 = @c4
	  		rank.c5 = @c5
	  		
	  		#debug
	  		#rank.rank_name += " " + tieBreaker.to_s
	  		
	  		rank.tieBreaker = @tieBreaker

 	  		if rank.only_cards.to_s.length > 1

	  			#rare case we are looking for specific cards
	  			if rank.only_cards == onlyCards

	  				#we have the cards so start off optomistic
	  				#check suite and order below
	  				ret = true

	  				if rank.same_suit == 1
	  					if not isFlush
	  						ret = false
	  					end
	  				end

	  				if rank.in_order == 1
	  					if not isStraight
	  						ret = false
	  					end
	  				end

	  				if ret
	  					rank.details = rank.rank_name
	  					return rank
	  				end

	  			end
	  		
	  		else

	  			if rank.in_order == 1 or rank.same_suit == 1
	  				#dealing with a straight or flush 

	  				if rank.same_suit == 1 and rank.in_order == 1

	  					#looking for a straight flush
	  					if isFlush and isStraight

	  						rank.details = highcard.card_face
	  						rank.details += " high "
	  						rank.details += rank.rank_name
	  						
	  						return rank
	  					end

	  				else

	  					#looking for flush
	  					if rank.same_suit == 1

	  						if isFlush
	  							rank.details = highcard.card_face
	  							rank.details += " high "
	  							rank.details += rank.rank_name
	  							return rank
	  						end

	  					end

	  					#looking for a straight
	  					if rank.in_order == 1

	  						if isStraight

	  							rank.details = highcard.card_face
	  							rank.details += " high "
	  							rank.details += rank.rank_name
	  							
	  							return rank
	  						end

	  					end
	  				end

	  			else

	  				#dealing with pairs trips etc...
					if rank.group1 == g1A.count 	#ex. 3 of a kind

	  					if rank.group2 == g2B.count #ex pair

	  						rank.hgroup1 = g1A

	  						rank.hgroup2 = g2B
	  						
	  						#to debug
	  						#rank.rank_name = g1plural

	  						#rank.details = highcard.card_face
	  						#rank.details += " high "
	  						rank.details = rank.rank_name

	  						rank.details += " " 
	  						rank.details += g1plural
	  						rank.details += " " 
	  						rank.details += g2plural

	  						return rank
	  					end

	  				end

	  			end
	  		end
	  	end

	  	#if we get here not rank was found so return a dummy
	  	#should never happen!
	  	rFail = PokerRanking.new
	  	rFail.rank_name = "Ranking for this hand is not implemented yet!"
	  	rFail.details = " "
	  	rFail.rank_name = g1A.count.to_s  + "  " + g2B.count.to_s

	  	rFail.rank_order = 0

	  	return rFail
	end

end
