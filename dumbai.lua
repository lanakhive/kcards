
function think(hand, lastplay, player)
	local toplay = {}
	local count
	local tobeat
	local maxes
	local any = false
	local playt
	local playv
	--find the primary pair of the last play
	count, tobeat, maxes = findpair(lastplay)
	print("Thinking: " .. count .. ", " .. tobeat .. ", " .. maxes)
	--check for only an ace played
	if maxes > 0 and count == 0 then return {} end
	if count == 0 then any = true
	else 
		playt, playv = findmultis(hand, count, tobeat + 1)
		if #playt == 0 then return {} end
		for i,j in ipairs(playt) do table.insert(toplay, j) end
		if playv == 14 then any = true end
	end
	if any then
		local tany
		tany = findmultis(hand, 4, 0, 13)
		if #tany == 0 then
			tany = findmultis(hand, 3, 0, 13)
			if #tany == 0 then
				tany = findmultis(hand, 2, 0, 13)
				if #tany == 0 then
					tany = findmultis(hand, 1, 0, 13)
				end
			end
		end
		for i,j in ipairs(tany) do table.insert(toplay, j) end
	end

	for i,j in ipairs(toplay) do print("Playing index " .. j.num) end
	return toplay
end

function findpair(lastplay, max)
	local val = 0
	local count = 0
	local aces = 0
	max = max or 14
	for i,j in ipairs(lastplay) do
		if j.num ~=14 then
			count = count + 1
			val = j.num
		else
			aces = aces + 1
		end
	end
	return count, val, aces
end

function findlowest(hand, minimum)
	local lowest = 15
	local lowindex = 0
	for i,j in ipairs(hand) do 
		if j.num < lowest and j.num >= minimum then
			lowest = j.num
			lowindex = i
		end
	end
	if lowindex > 0 then return lowindex end
end

function findmultis(hand, multival, minimum, maximum)
	maximum = maximum or 14
	local ocount = {}
	for i,j in ipairs(hand) do
		v = j.num
		if not ocount[v] then ocount[v] = 1
		else ocount[v] = ocount[v] + 1 end
	end
	local lowest = 15
	local pairnum
	for i,j in pairs(ocount) do
		if j >= multival and i < lowest and i >= minimum then
			lowest = i
			pairnum = j
		end
	end
	local rettable = {}
	if pairnum then
		local fcount = 0
		for i,j in ipairs(hand) do
			if j.num == lowest then
				table.insert(rettable, j)
				fcount = fcount + 1
			end
			if fcount >= multival then break end
		end
	end
	return rettable, lowest
end


local dumbai = {
	think = think
}

return dumbai
