cg = require('cardgen')

PileManager = {}
PileManager.__index = PileManager

function lerp(c,d,t) return c + (d - c) * t end

function PileManager.create(x,y)
	pm = {}
	pm.pile = {}
	pm.scl = 0.20
	pm.x = x
	pm.y = y

	setmetatable(pm,PileManager)
	return pm
end

function PileManager:draw()
	for i,j in ipairs(self.pile) do
		local cardface = cardGet(j.num, j.suit)
		love.graphics.draw(cardface,j.x,j.y,j.r,j.s,j.s,512,512)
	end
end

function PileManager:clear()
	self.pile = {}
end

function PileManager:addCard(num,suit,x,y,r,s)
	table.insert(self.pile,{
		num = num,
		suit = suit,
		x = x,
		y = y,
		r = r,
		s = s,
		tx = self.x * global.ws + (math.random(200) - 100),
		ty = self.y * global.hs + (math.random(200) - 100),
		tr = math.rad(math.random(360)) - math.rad(180),
		ts = self.scl
	})
	local maxpile = 10
	if #self.pile > maxpile then
		for i=1,#self.pile-maxpile,1 do
			rem = self.pile[i]
			rem.tx = self.x * global.ws
			rem.ty = self.y * global.hs
			rem.ts = 0.15
			rem.rem = true
		end
	end
end

function PileManager:update(dt)
	if dt > 1 then dt = 0 end
	for i = #self.pile,1,-1 do
		j = self.pile[i]
		local speed = 4
		if j.rem then speed = 1 end
		j.x = lerp(j.x, j.tx, speed*dt)
		j.y = lerp(j.y, j.ty, speed*dt)
		j.r = lerp(j.r, j.tr, speed*dt)
		j.s = lerp(j.s, j.ts, speed*dt)
		if j.rem  and math.abs(rem.x - self.x) < 5 and math.abs(rem.y - self.y) < 5 then
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
