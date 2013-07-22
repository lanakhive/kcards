-- Klootzak game

--generate hands for all players
function genDeck(players)
	local deck = genCards()
	shuffle(deck)
	local hands = {}
	local deckindex = 1
	for i = 1, players do
		local hand = {}
		for j = 1, 6 do
			hand[#hand+1] = deck[deckindex]
			deckindex = deckindex + 1
		end
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

--find the index of a card in a group of cards
function hasCardNum(cards, cardnum)
	for i,j in ipairs(cards) do
		if j.num == cardnum then return i end
	end
end
--[[
function trimHighest(cards, max)
	for i,j in ipairs(cards) do
		if (j.num == max) then table.remove(cards, i) end
	end
end

function Card(num,suit) return {num, suit} end

function checkPlay(lastCards, checkCards, max=0)
	if lastCards == nil then error("checkPlay nil lastCards") end
	if checkCards ==nil then error("checkPlay nil checkCards") end

	trimHighest(lastCards,max)

	if hasCardNum(check, max) then
	--pass
	if next(checkCards) == nil then return false, "pass" end
	--Check all cards are same value
	if (#checkCards > 1) then
		for i = 2, #checkCards do
			if checkCards[i].num ~= checkCards[1].num then return false, "match" end
		end
	end
	--Check if first round
	if next(lastCards) == nil then return true end
	-- Check for same number of cards
	if (#lastCards ~= #checkCards) then return false, "count" end
	-- Check for increasing value
	if (checkCards[1].num <= lastCards[1].num) then return false, "value" end
	return true
end

function gameTest()
	hands = genDeck(9)
	local b = doOp(1, hands[1], {{num=5, suit="H"}})
	print(b)
end


function doOp(player, hand, last)
	local plays;
	print("---Player " .. player .. "'s hand---")
	for i,j in ipairs(hand) do
		print("("..i.."): ".. cardString(j))
	end
	while true do
		print("\nWhat to do?")
		local actions = io.read()
		local actionst = {}
		for action in actions:gmatch("%w+") do table.insert(actionst, action) end
		if actionst[1] == "pass" then return nil
		elseif actionst[1] == "play" then 
			table.remove(actionst,1)
			for i,j in ipairs(actionst) do
				if hasCardNum(hand, {num = j}) then
					table.insert(plays, hand[i])
				else
					print("Don't have those cards")
					plays = nil
					break
				end
			end
			if (checkPlay(last, plays)) then return plays
			else print("Invalid play") end
		else print("Invalid action") end
	end
end
	
-- d = genCards()
-- shuffle(d)
-- for i,k in ipairs(d) do print(i, cardString(k)) end
--
q = genDeck(9)
for i=1, #q do
	hand = q[i]
	print("---Player " .. i .. "---")
	sortHand(hand)
	for j=1, #hand do
		print(cardString(hand[j]))
	end
	h = hasCardNum({{num=4, suit="H"}}, {num = 4})
end
--gameTest();

--]]


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
function ruleC(lastCards, currCards, max)
	max = max or 14
	lastNum, lastCount, lastHighCount = checkPairs(lastCards, max)
	currNum, currCount, currHighCount = checkPairs(currCards, max)
	-- mismatch
	if currNum == nil then return false end
	if lastNum == nil then error("Invalid history in rule check!") end
	-- pass
	if currNum == 0 and currHighCount == 0 then return true end
	--only ace
	if lastHighCount > 0 and lastNum == 0 then 
		return false
	end
	-- typical play
	if currNum > lastNum and lastCount == currCount then
		return true
	end
	-- ace 
	if currHighCount >= lastCount then 
		return true
	end
	return false
end

function ruleCheck(current, play, correct, msg, max)
	max = max or 14
	t_cur = {}
	t_play = {}
	for i,k in ipairs(current) do table.insert(t_cur, {num = k, suit="H"}) end
	for i,k in ipairs(play) do table.insert(t_play, {num = k, suit="H"}) end
	assert(correct == ruleC(t_cur, t_play, max),
		msg .. " (should be ".. string.format("%s", correct) .. ")")
end

function runRuleChecks()
	ruleCheck({}, {4}, true, "Inital one")
	ruleCheck({}, {4,4}, true, "Inital two same")
	ruleCheck({}, {4,5}, false, "Inital two different")
	ruleCheck({3}, {4}, true, "Higher single")
	ruleCheck({4}, {3}, false, "Lower single")
	ruleCheck({7,7}, {9,9}, true, "Higher double")
	ruleCheck({7,7}, {5,5}, false, "Lower double")
	ruleCheck({2,2,2,2}, {9,9,9,9}, true, "Higher quad")
	ruleCheck({7,7,7,7}, {5,5,5,5}, false, "Lower quad")
	ruleCheck({2,2,2,2}, {9,8,9,9}, false, "Higher mismatched quad")
	ruleCheck({7,7,7,7}, {3,5,5,5}, false, "Lower mismatched quad")
	ruleCheck({3}, {4,4}, false, "Different count 1to2")
	ruleCheck({3,3}, {4,4,4}, false, "Different count 2 to 3")
	ruleCheck({3}, {4,4,4}, false, "Different count 1 to 3")
	ruleCheck({3}, {4,4,4,4}, false, "Different count 1 to 4")
	ruleCheck({}, {}, true, "Successive pass")
	ruleCheck({5}, {}, true, "Pass on one")
	ruleCheck({5,5}, {}, true, "Pass on two")
	ruleCheck({5}, {14,3}, true, "Ace and single")
	ruleCheck({5}, {14,3,3}, true, "Ace and double")
	ruleCheck({5}, {14,3,4}, false, "Ace and mismatched double")
	ruleCheck({14},{14,14}, false, "One ace vs two")
	ruleCheck({3},{14}, true, "Single vs one ace")
	ruleCheck({3},{14,14}, true, "Single vs two ace")
	ruleCheck({14,14}, {14}, false, "Two ace to one Fail")
	ruleCheck({14,14}, {14,3}, false, "Two ace to one ace and single")
	ruleCheck({14,14,9}, {10}, true, "Higher single after two prev ace")
	ruleCheck({14,14,9}, {8}, false, "Two ace and single vs lower")
	ruleCheck({14,14,9}, {10}, true, "Two ace and single vs higher")
	ruleCheck({14,14,9}, {8,14}, true, "Two ace and single vs lower")
	ruleCheck({14,14,9}, {10,14}, true, "Two ace and single vs higher and ace")
	ruleCheck({14,14,9}, {8,14}, true, "Two ace and single vs higher and ace")
	print("All rule checks pass.")
end
runRuleChecks()
