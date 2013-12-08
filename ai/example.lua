-- Example AI lua script

-- Create a table that will contain all of the AI functions
local aitable = {}

-- Init function
-- Should return a string containing the name of the AI
aitable.init = function () return "Example AI" end

-- Name function
-- Should return a name to be shown ingame as the AI players name
aitable.name = function (index) return "Example " .. index end

-- Think function
-- Called during the players turn
-- player = index of the current player (this ai)
-- hand = table containing the players current cards
-- lastplay = table containing the cards the previous player played
-- lastplayer = index of the last player that played cards (didn't pass)
-- cardcount = table containing card counts for each player
-- function should return a table of the index of cards in hand to play
aitable.think = function (player, hand, lastplayer, lasthand, cardcount)
	return {{num = 4, suit = "S"}}
end

-- Return the AI table to the game
return aitable
