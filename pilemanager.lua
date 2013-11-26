cg = require('cardgen')

local PileManager = {}
PileManager.__index = PileManager

function lerp(c,d,t) return c + (d - c) * t end

function PileManager.create(x,y)
	local pm = {}
	pm.pile = {}
	pm.scl = 0.20
	pm.x = x
	pm.y = y
	pm.c = love.graphics.newCanvas(1024,1024)
	pm.cxo = 0
	pm.spread = 100

	setmetatable(pm,PileManager)
	return pm
end

function PileManager:draw()
	love.graphics.draw(self.c,self.cxo)
	for i,j in ipairs(self.pile) do
		local cardface = cardGet(j.num, j.suit)
		love.graphics.draw(cardface,j.x,j.y,j.r,j.s,j.s,512,512)
	end
end

function PileManager:clear()
	self.pile = {}
	self.c:clear()
end

function PileManager:addCard(num,suit,x,y,r,s)
	table.insert(self.pile,{
		num = num,
		suit = suit,
		x = x,
		y = y,
		r = r,
		s = s,
		tx = self.x * global.ws + (math.random(self.spread*2) - self.spread),
		ty = self.y * global.hs + (math.random(self.spread*2) - self.spread),
		tr = math.rad(math.random(360)) - math.rad(180),
		ts = self.scl
	})
end

function PileManager:update(dt)
	-- determine cavas centering offset
	if global.w <= 1024 then self.cxo = 0
	else self.cxo = (global.w - 1024) / 2 end
	if dt > 1 then dt = 0 end
	-- update active card positions
	for i = #self.pile,1,-1 do
		local j = self.pile[i]
		j.x = lerp(j.x, j.tx, 4*dt)
		j.y = lerp(j.y, j.ty, 4*dt)
		j.r = lerp(j.r, j.tr, 4*dt)
		j.s = lerp(j.s, j.ts, 4*dt)
		-- determine if card has stopped moving
		if math.abs(j.x-j.tx) < 0.01 and math.abs(j.y-j.ty) < 0.01 and math.abs(j.r-j.tr) < 0.01 and math.abs(j.s-j.ts) < 0.01 and i == 1 then
			-- add card image to canvas and remove from active cards
			love.graphics.setCanvas(self.c)
			local cardface = cardGet(j.num, j.suit)
			love.graphics.draw(cardface,j.x-self.cxo,j.y,j.r,j.s,j.s,512,512)
			love.graphics.setCanvas()
			table.remove(self.pile, i)
		end
	end
end

function PileManager:clickAction(x,y)
	if math.abs(x - self.x * global.ws) < 100 and math.abs(y - self.y * global.hs) < 100 then
		return true
	end
	return false
end

return PileManager
