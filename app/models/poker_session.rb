class PokerSession < ActiveRecord::Base
	#override the default rails id pk
	self.primary_key = "session_id"
	serialize :preferences, Hash
end