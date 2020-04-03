class HomeController < ApplicationController
  
  
  def test
    @royalflush = PokerCard.royalflush
    @fourofakind = PokerCard.fourofakind
    @flush = PokerCard.flush
    @threeofakind = PokerCard.threeofakind
    @twopair = PokerCard.twopair
    @onepair = PokerCard.onepair
    @highcard  = PokerCard.highcard
    @acelowstraight  = PokerCard.acelowstraight
    @fullhouse  = PokerCard.fullhouse
    @straightflush = PokerCard.straightflush
    @lowstraight = PokerCard.lowstraight
    @acehighstraight = PokerCard.acehighstraight
  end

  def index

    session[:hello] = "Rails Poker!" 

  end
  
  def new

    session[:hello] = "Rails Poker!" 

    
    if not session[:dwins]
      session[:dwins] = 0
    end

    if not session[:pwins]
      session[:pwins] = 0
    end

    @playerWon = 0
    @dealerWon = 0
    @playerRank = ""
    @playerR = ""
    
    @dcd = Array.new


    #dealers card using scope, get the dealers cards here
    #get the players cards in deal to offset processing some
    @dc = PokerCard.dealercards

    dcRank = PokerRanking.rankcards(@dc)

    if dcRank.rank_order > 2
      #has 2 pair of better so leave hand as is
      #this dealer never tries to get a straight or flush :)
      #he is conservative (for now)...

    else

      if dcRank.hgroup1.count > 1

        #keep any pair the dealer has, dont need to look at
        #second pair as they would already be held above ie. rank > 2
        dcRank.hgroup1.each do |crd|
          @dcd.push(crd)
        end

        #todo: keep remaining face cards from the deal
        nc = 0
        @dc.each do |crd|
          if crd.card_value > 9
            
            bKeep = true
            
            #exclude if we already have it
            @dcd.each do |crd2|
              if crd2.id == crd.id
                bKeep = false
                break
              end
            end

            #only keep 1 card!
            if bKeep
              if nc == 0
                @dcd.push(crd)
                nc+=1
              end
            end

          end

        end

        #get some draw cards
        #I guess it would be possible for the player to get the dealers
        #throw aways, but not a concern of mine right now :)
        dcount = 5 - @dcd.count
        drawc = PokerCard.drawcards(@dc, @dc, dcount)

        #add the draw cards
        drawc.each do |pc|
          @dcd.push(pc)
        end

        #new dealers cards
        @dc = @dcd
        @dc.shuffle!


      else

         #just keep first 2 face cards for now
          nc = 0
          bKeep = true
          @dc.each do |crd|
            if crd.card_value > 9

              if nc < 2
            
               @dcd.push(crd)
               nc+=1
            
              end
          
             end
          end

          #get some draw cards
          #I guess it would be possible for the player to get the dealers
          #throw aways, but not a concern of mine right now :)
          dcount = 5 - @dcd.count
          drawc = PokerCard.drawcards(@dc, @dc, dcount)

          #add the draw cards
          drawc.each do |pc|
            @dcd.push(pc)
          end

          #new dealers cards
          @dc = @dcd
          @dc.shuffle!


      end

    end


    #cache the dealers cards for use throughout the game 
    #probably a better way but Im using this as a learning tool...  
    #note: now caching in db!
    
    #cache the dealers cards in the database
    #1 insert per game, update players cards below
    ps = PokerSession.find_by(session_id: request.session_options[:id])
    if ps.nil?
      ps = PokerSession.new
      ps.session_id = request.session_options[:id]
    end
    ps.dealers_cards = PokerCard.ids(@dc)
    ps.players_cards = ""
    ps.save

  end

  def deal

    session[:hello] = "Rails Poker!" 

    @playerWon = 0
    @dealerWon = 0
    @playerWon = 0
    @dealerWon = 0
    @playerRank = ""
    @playerR = ""

    #dealers cards from session   
    #@dc = PokerCard.fromhash(session[:dcards])
   
    #players cards excluding dealers cards
    #@pc = PokerCard.playercards(@dc)
        
    #returns the first one or nil
    ps = PokerSession.find_by(session_id: request.session_options[:id])
    if not ps.nil? 
      #@dc = PokerCard.fromhash()
      @dc = PokerCard.sessioncards(ps.dealers_cards)
      @pc = PokerCard.playercards(@dc)

      ps.players_cards =  PokerCard.ids(@pc)
      ps.save
    end

    #cache the players cards for use throughout the game 
    #probably a better way but Im using this as a learning tool...  
    #session[:pcards] = @pc

  end
  
  def draw

    session[:hello] = "Rails Poker!" 

    #build arrays of PokerCards from the session hash
    #@dcFromHash = PokerCard.fromhash(session[:dcards])
    #note now pulling from the db
    ps = PokerSession.find_by(session_id: request.session_options[:id])
    if not ps .nil?
    
      @dcFromHash = PokerCard.sessioncards(ps.dealers_cards)
      @pcFromHash = PokerCard.sessioncards(ps.players_cards)
    
    else

      #todo no session so redirect home

    end

    #get from db now
    #@pcFromHash = PokerCard.fromhash(session[:pcards])
    #pcKeys = @pcFromHash.keys

    #TODO ifs below not very elegant...
    @holdcount = 0
    if params['hold1'] == "1"
      @holdcount += 1
      @pcFromHash[0].hold = true
    end
    if params['hold2'] == "1"
      @holdcount += 1
      @pcFromHash[1].hold = true
    end
    if params['hold3'] == "1"
      @holdcount += 1
      @pcFromHash[2].hold = true
    end
    if params['hold4'] == "1"
      @holdcount += 1
      @pcFromHash[3].hold = true
    end
    if params['hold5'] == "1"
      @holdcount += 1
      @pcFromHash[4].hold = true
    end

    @drwCount = 5 - @holdcount

    #five card and you choose to hold
    #@drawcount = 5 - @drawcount

    #get up to 5 draw cards excluding the dealer and player cards
    @drawcards = PokerCard.drawcards(@dcFromHash, @pcFromHash, @drwCount)

    #loop over the held cards and mix in the draw cards
    #this is the players final hand
    @fcardArray = Array.new
    i = 0
    @pcFromHash.each do |pcard|

      @pcc = pcard
      
      if pcard.hold
         @fcardArray.push(pcard)
      else
        #@drawcards.at(i).hold = false
        @fcardArray.push(@drawcards.at(i))
        i += 1;
      end
    end

    @dealerRank = PokerRanking.rankcards(@dcFromHash)
    @dealerR = @dealerRank.rank_name

    @playerRank = PokerRanking.rankcards(@fcardArray)
    @playerR = @playerRank.rank_name

    @originalRank = PokerRanking.rankcards(@pcFromHash)

    @playerWon = 0
    @dealerWon = 0
    if @playerRank.rank_order > @dealerRank.rank_order
      @playerWon = 1
      @dealerWon = 0
    end    
    if @dealerRank.rank_order > @playerRank.rank_order
      @dealerWon = 1
      @playerWon = 0
    end    
    if @dealerRank.rank_order == @playerRank.rank_order
      
      
      if @dealerRank.tieBreaker >  @playerRank.tieBreaker

         @dealerWon = 1
         @playerWon = 0

      end

      if @playerRank.tieBreaker >  @dealerRank.tieBreaker

         @dealerWon = 0
         @playerWon = 1

      end

      #messy messy... will come back to this, concept works though
      bDone = false
      if @playerRank.tieBreaker == @dealerRank.tieBreaker

        if not bDone 
          if @dealerRank.c1 > @playerRank.c1
            @dealerWon = 1
            @playerWon = 0
            bDone = true
          elsif @dealerRank.c1 < @playerRank.c1
            @playerWon = 1
            @dealerWon = 0
            bDone = true
          end
        end

      
        if not bDone 
          if @dealerRank.c2 > @playerRank.c2
            @dealerWon = 1
            @playerWon = 0
            bDone = true
          elsif @dealerRank.c2 < @playerRank.c2
            @playerWon = 1
            @dealerWon = 0
            bDone = true
          end
        end
        
        if not bDone 
          if @dealerRank.c3 > @playerRank.c3
            @dealerWon = 1
            @playerWon = 0
            bDone = true
          elsif @dealerRank.c3 < @playerRank.c3
            @playerWon = 1
            @dealerWon = 0
            bDone = true
          end
        end
        
        if not bDone 
          if @dealerRank.c4 > @playerRank.c4
            @dealerWon = 1
            @playerWon = 0
            bDone = true
          elsif @dealerRank.c4 < @playerRank.c4
            @playerWon = 1
            @dealerWon = 0
            bDone = true
          end
        end
        
        if not bDone 
          if @dealerRank.c5 > @playerRank.c5
            @dealerWon = 1
            @playerWon = 0
            bDone = true
          elsif @dealerRank.c5 < @playerRank.c5
            @playerWon = 1
            @dealerWon = 0
            bDone = true
          end
        end
        
      end

    end

    if  @playerWon == 1 
      session[:pwins] += 1
    end

    if  @dealerWon == 1 
      session[:dwins] += 1
    end


    #######################################################
    #log the game to the database for statistical analysis
    pokerstat = PokerStat.new
    pokerstat.id = 1
    
    pokerstat.dealer_deal = PokerCard.statcards(@dcFromHash)
    #no draw for dealer at this time
    pokerstat.dealer_final = PokerCard.statcards(@dcFromHash)
    
    pokerstat.player_deal = PokerCard.statcards(@pcFromHash)
    
    if @drwCount > 0
      pokerstat.player_draw = PokerCard.statcards(@drawcards)
    else
      pokerstat.player_draw = "";
    end

    pokerstat.winner = 0

    if @playerWon == 1
      pokerstat.winner = 1
    end

    if @dealerWon == 1
      pokerstat.winner = 2
    end
      
    pokerstat.player_final = PokerCard.statcards(@fcardArray)

    pokerstat.save
    ##########################################################



    #cache the draw cards for use throughout the game 
    #probably a better way but Im using this as a learning tool...  
    #I get a cookie overflow below :) TODO: go back and research the best way
    #to cache the cards, I really dont need to cache the drawcards anyway
    #as the game is over at this point...
    #session[:drawcards] = @drawcards
  end

end
