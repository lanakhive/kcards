kz = require("klootzak")
dumbai = require("dumbai")

function clearScreen()
	os.execute("cls")
end

function play()
	--determine player count
	print("How many players?")
	local pcount
	repeat
		pcount = tonumber(io.read())
		if not pcount then print("Enter a number!") end
		if pcount > 9 or pcount < 2 then print("Wrong Number!") pcount = nil end
	until pcount
	--create game
	local state = kz.genGameState(pcount)
	-- local state = kz.gameUpdate()
	local player = 1
	local play = {}
	local valid = true
	--start game
	clearScreen()
	print("------------------KLOOTZAK GAME---------------")
	while true do 
		--show players hand
		local hand = kz.getHand(state,player)
		print("\n---Player " .. player .. "'s hand---")
		for i,j in ipairs(hand) do
			print("("..i.."): ".. cardString(j))
		end
		local actionst = {}
		if player == 1 then
			--get play and update state
			print("What to play?")
			input = io.read()
			for action in input:gmatch("%w+") do 
				table.insert(actionst, hand[tonumber(action)])
			end
		else
			actionst = dumbai.think(hand, play, player)
		end
		player, play, valid = kz.gameUpdate(state,actionst)
		--determine klootzak
		if (player == -1) then
			clearScreen()
			print("--------------------GAME OVER-----------------")
			print("President: Player " .. state.president)
			print("Klootzak:  Player " .. state.klootzak)
			os.exit(0)
		end
		--check if play was correct and start next round
		clearScreen()
		print("------------------KLOOTZAK GAME---------------")
		if not valid then print("Can't play that!!!!!") end
		if state.lastPlayerPlay and state.lastPlayerPlay ~= player then
			print("\n---Player " .. state.lastPlayerPlay .. " played---")
		end
		for i,j in ipairs(play) do
			print(kz.cardString(j));
		end
	end
end

play()
