cg = require('cardgen')

CardSpinner = {}
CardSpinner.__index = CardSpinner

local cardback
local r = 0
local counter = 0
local snum = 1
local ssuit = "H"

function CardSpinner.create(x,y,scl)
	local cs = {
		x = x,
		y = y,
		rot = 0,
		scl = scl,
		counter = 0,
		cnum = 1,
		csuit = "H",
		cardback = cg.cardGet(1,"H")
	}
	setmetatable(cs, CardSpinner)
	return cs
end

function CardSpinner:draw()
	love.graphics.draw(self.cardback,self.x,self.y,self.rot,self.scl,self.scl, 512, 512)
end

function CardSpinner:update(dt)
	self.rot = self.rot + dt*1.2;
	self.counter = self.counter + dt
	if self.counter > 0.4 then
		self.counter = 0
		self.cnum = self.cnum + 1
		if self.cnum > 14 then 
			self.cnum = 2 
		end
		if self.csuit == "S" then self.csuit = "D" 
		elseif self.csuit == "H" then self.csuit = "S" 
		elseif self.csuit == "C" then self.csuit = "H" 
		elseif self.csuit == "D" then self.csuit = "C" end
		--genCard(snum,"S")
		self.cardback = cg.cardGet(self.cnum,self.csuit)
		--collectgarbage("collect")
	end
end

return CardSpinner
