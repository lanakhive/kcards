
local AIMaster = {}
AIMaster.__index = AIMaster

function AIMaster.create()
	local ai = {}
	ai.bots = {}

	setmetatable(ai, AIMaster)
	return ai
end

function AIMaster:dirload()
	print("-- Loading ai...")
	-- list the files in the ai folder
	local files = love.filesystem.getDirectoryItems("ai")
	-- try to load each file
	for i,j in pairs(files) do
		local ok, chunk, aitable, ainame
		-- load the ai chunk from the file
		ok, chunk = pcall(love.filesystem.load, "ai/" .. j)
		if not ok then
			print("Failed to load \"" .. j .. "\". \n" .. chunk)
			break
			--goto restart
		end
		-- execute the chunk as a function, should return the ai table
		ok, aitable = pcall(chunk)
		if not ok then
			print("Failed to execute \"" .. j .. "\". \n" .. aitable)
			break
			-- goto restart
		end
		-- check that a table was returned
		if not (type(aitable) == 'table') then
			self:printError(j, "AI did not return a table.")
			break
		end
		if type(aitable.init) ~= "function" then 
			self:printError(j, "AI table does not contain an init function.")
			break 
		end
		-- call the init function to identify the ai
		ok, ainame = pcall(aitable.init)
		if not ok then
			print("Could not init \"" .. j .. "\". \n" .. ainame)
			self:printError(j, "AI init failed.")
			break
			-- goto restart
		end
		-- check that ai identifies itself properly
		if not (type(ainame) == 'string') then
			self:printError(j, "AI init did not return a string.")
			break
			-- goto restart
		end
		if ainame:len() > 16 then
			self:printError(j, "AI name was too long. Should be 16 or less.")
			break
		end
		-- add the ai to the guest list
		print("Hello " .. ainame .. "!")
		--table.insert(self.bots, {name = ainame, table = aitable})
		self.bots[ainame] = aitable

		-- ::restart::
	end
end

function AIMaster:think(ai, player, hand, lastplayer, lasthand, cardcount)
	local aitable = self.bots[ai]
	-- check that ai table exists
	if not aitable then
		print("AItable missing for " .. ai)
		return {}
	end
	-- check that ai has a think function
	if type(aitable.think) ~= 'function' then
		self:printError(ai, "AI does not have a think function.")
		return {}
	end
	-- perform the ai think call
	local ok, cards = pcall(aitable.think, player, hand, lastplayer, lasthand, cardcount)
	-- check that think call did not have errors
	if not ok then
		self:printError(ai, "AI think failed with error:\n" .. cards)
		return {}
	end
	-- check that ai returned a table
	if type(cards) ~= 'table' then
		self:printError(ai, "AI think did not return a table.")
		return {}
	end
	-- check that all items in table are numbers
	for i,j in ipairs(cards) do
		if type(j) ~= 'table' then
			self:printError(ai, "AI think did not return a number, type was "..type(j))
			return {}
		end
		if type(j.num) ~= 'number' or type(j.suit) ~= 'string' then
			self:printError(ai, "AI return table does not contain valid cards")
			return {}
		end
	end
	return cards
end



function AIMaster:printError(ai, msg)
	print("In \"" .. ai .. "\": " .. msg)
end

function AIMaster:list()
	local names = {}
	for i,j in pairs(self.bots) do
		table.insert(names, i)
	end

	return names
end

function AIMaster:getName(ai, index)
	local aitable = self.bots[ai]
	if aitable and type(aitable.name) == 'function' then
		local ok, name = pcall(aitable.name, index)
		if ok and type(name) == 'string' then
			return name
		end
	end
	if aitable and type(aitable.name) ~= 'function' then
		self:printError(ai, "AI table does not have a name function.")
	end

	return "Player " .. index
end


return AIMaster
