-- Klootzak game


--generate hands for all players
function genDeck(players)
	local players = players or 9
	local tablelookup = {0, 12, 12, 8, 8, 8, 8, 6, 6, 4, 4, 4, 4, 4}
	local handsize = tablelookup[players] or 6
	local deck = genCards()
	while #deck > handsize*players do table.remove(deck,#deck) end
	shuffle(deck)
	local hands = {}
	local deckindex = 1
	for i = 1, players do
		local hand = {}
		for j = 1, handsize do
			hand[#hand+1] = deck[deckindex]
			deckindex = deckindex + 1
		end
		sortHand(hand)
		table.insert(hands, hand)
	end
	return hands
end

--shuffle a deck
function shuffle(cards)
	math.randomseed(os.time())
	for i=#cards, 1, -1 do
		local j = math.random(i)
		cards[j], cards[i] = cards[i], cards[j]
	end
end

--generate a complete deck
function genCards()
	local deck = {};
	for i = 14,2,-1 do
		deck[#deck+1] = {num = i, suit = "H"}
		deck[#deck+1] = {num = i, suit = "D"}
		deck[#deck+1] = {num = i, suit = "C"}
		deck[#deck+1] = {num = i, suit = "S"}
	end
	deck[#deck+1] = {num = 1, suit = "H" }
	deck[#deck+1] = {num = 1, suit = "D" }
	return deck;
end

--convert a card to a string
function cardString(card)
	local suits = {
		H = "Hearts",
		D = "Diamonds",
		C = "Clubs",
		S = "Spades"
	}
	local cards = {
		"Joker",
		"Two",
		"Three",
		"Four",
		"Five",
		"Six",
		"Seven",
		"Eight",
		"Nine",
		"Ten",
		"Jack",
		"Queen",
		"King",
		"Ace"
	}
	if card.num == 1 then return "Joker" end
	return cards[card.num] .. " of " .. suits[card.suit]
end

--sort a hand of cards
function sortHand(hand)
	table.sort(hand, function(a,b) return a.num < b.num end)
end

-- determine the value and count of pairs, and the number of high cards
function checkPairs(cards, high)
	local pairnum = 0
	local paircount = 0
	local highcount = 0
	for i,j in ipairs(cards) do
		if (j.num == high) then highcount = highcount + 1 
		else 
			if pairnum == 0 then pairnum = j.num end 
			if (j.num ~= pairnum) then return nil end
			paircount = paircount + 1
		end
	end
	return pairnum, paircount, highcount
end

-- check if a play will beat a previous play
function checkPlay(lastCards, currCards, max)
	max = max or 14
	--count the pairs and high cards of the curr and last play
	lastNum, lastCount, lastHighCount = checkPairs(lastCards, max)
	currNum, currCount, currHighCount = checkPairs(currCards, max)
	-- mismatch
	if not currNum then return false end
	-- max changed since last play
	if not lastNum then lastNum, lastCount, lastHighCount = checkPairs(lastCards, max + 1) end
	-- pass
	if currNum == 0 and currHighCount == 0 then return true end
	--only ace
	if lastHighCount > 0 and lastNum == 0 then 
		return false
	end
	-- typical play
	if currNum > lastNum and lastCount == currCount and currHighCount == 0 then
		return true
	end
	-- ace 
	if currHighCount >= lastCount then 
		return true
	end
	return false
end

--remove a subset of cards from a set
function removeCards(cards, removecards)
	for i,j in ipairs(removecards) do
		for k,l in ipairs(cards) do
			if j.num == l.num then table.remove(cards, k) break end
		end
	end
end

--check if cards are a subset of hand
function hasInHand(hand, cards)
	local findex = {}
	local found 
	for i,j in ipairs(cards) do
		found = false
		for k,l in ipairs(hand) do
			if l.num == j.num and l.suit == j.suit and not findex[k] then
				findex[k] = true 
				found = true
			end
		end
		if not found then return false end
	end
	return true
end

function updateHighest(state, play)
	for i,j in ipairs(play) do
		if not state.cardsPlayed[j.num] then state.cardsPlayed[j.num] = 1
		else state.cardsPlayed[j.num] = state.cardsPlayed[j.num] + 1 end
	end
	for i = 1, 14 do
		if not state.cardsPlayed[i] or state.cardsPlayed[i] < 4 then
			state.highcardnum = i
		end
	end
end

--generate a game state
function genGameState(players)
	players = players or 2
	state = {}
	state.currPlayer = 1
	state.maxPlayers = players
	state.remainingPlayers = players 
	state.hands = genDeck(players)
	state.out = {} --boolean table of out players
	state.lastPlay = {}
	state.lastPlayerPlay = nil --last player that played a card
	state.president = nil
	state.winner = nil
	state.gameInProgress = true
	state.highcardnum = 14
	state.cardsPlayed = {}
	return state
end

--returns a players current hand
function getHand(state, player)
	return state.hands[player]
end

--update currentplayer to the next
function advancePlayer(state)
	--advance to next player	
	state.currPlayer = state.currPlayer + 1
	--find next remaining player
	while state.out[state.currPlayer] == true do
		state.currPlayer = state.currPlayer + 1
	end
	if (state.currPlayer > state.maxPlayers) then 
		state.currPlayer = 1
	end
	while state.out[state.currPlayer] == true do
		state.currPlayer = state.currPlayer + 1
	end
end


--update the game state (call with nil to restart)
function gameUpdate(state, play)
	-- create game if no arguments
	if not state then 
		state = genGameState()
		return state
	end
	-- ensure game is in progress
	if not state.gameInProgress then return nil end

	-- check if a play is not valid or doesnt beat last hand
	if not hasInHand(getHand(state, state.currPlayer), play) or
	not checkPlay(state.lastPlay, play, state.highcardnum) then
		return state.currPlayer, state.lastPlay, false
	end

	-- if play was not a pass
	if #play ~= 0 then
		state.lastPlay = play
		state.lastPlayerPlay = state.currPlayer
		updateHighest(state, play);
		removeCards(getHand(state,state.currPlayer), play)
		--check for player out
		if #getHand(state,state.currPlayer) == 0 then
			state.out[state.currPlayer] = true
			--next player can play anything
			state.lastPlay = {}
			--assign president
			if state.remainingPlayers == state.maxPlayers then
				state.president = state.currPlayer
			end
			state.remainingPlayers = state.remainingPlayers - 1
		end
	end

	--switch to next player
	advancePlayer(state)

	-- last is klootzak
	if state.remainingPlayers == 1 then
		state.klootzak = state.currPlayer
		state.gameInProgress = false
		return -1 
	end
	-- everone passed, can play anything
	if state.lastPlayerPlay == state.currPlayer then
		state.lastPlay = {}
	end

	return state.currPlayer, state.lastPlay, true
	
end

--create library export table
local kz = {
	checkPlay = checkPlay,
	getHand = getHand,
	cardString = cardString,
	genGameState = genGameState,
	gameUpdate = gameUpdate
}

--return the library
return kz

