cg = require('cardgen')

local HandManager = {}
HandManager.__index = HandManager

local function lerp(c,d,t) return c + (d - c) * t end

function HandManager.create(x,y)
	local hm = {}
	hm.hand = {}
	hm.scl = 0.25
	hm.x = x
	hm.y = y
	hm.hoverindex = 0
	hm.hover = false
	hm.enabled = false

	setmetatable(hm,HandManager)
	return hm
end

function HandManager:update(dt)
	self:setFan()
	if dt > 1 then dt = 0 end
	for i,j in ipairs(self.hand) do
		j.x = lerp(j.x, j.tx, 4.0*dt)
		j.y = lerp(j.y, j.ty, 4.0*dt)
		j.r = lerp(j.r, j.tr, 4.0*dt)
	end

end

function HandManager:setFan()
	-- determine spacing between cards
	local xinterval = 20
	local rinterval = math.rad(5)
	-- spacing is larger during mouse hover
	if self.hover then
		xinterval = 40
		rinterval = math.rad(15)
	end
	-- determine initial offsets for first card
	local xoffset = self.x - xinterval * #self.hand / 2
	local roffset = -rinterval * #self.hand/2
	-- iterate cards and set fan position
	for i,j in ipairs(self.hand) do
		j.tx = xoffset
		j.ty = self.y
		j.tr = roffset
		-- insert a peek for current hovered card
		if i == self.hoverindex then
			xoffset = xoffset + 60
			roffset = roffset + math.rad(10)
		end
		-- selected cards are popped up
		if j.selected then
			j.ty =j.ty - 50
		end
		-- hand is retracted when disabled
		if not self.enabled then
			j.ty = j.ty + 100
		end
		-- update offset for next card
		xoffset = xoffset + xinterval
		roffset = roffset + rinterval
	end
end

function HandManager:addCard(num,suit)
	table.insert(self.hand,{num = num,suit = suit,x = self.x, y = self.y+300, r=0})
	self:setFan()
end

function HandManager:clear()
	self.hand = {}
end

function HandManager:clearSelection()
	for i,j in ipairs(self.hand) do
		j.selected = false
	end
end


function HandManager:setEnabled(en)
	self.enabled = en
	self:setFan()
end

function HandManager:getSelected()
	local h = {}
	for i,j in ipairs(self.hand) do
		if j.selected then
			table.insert(h, {num = j.num, suit = j.suit})
		end
	end
	return h
end

function HandManager:commit(pile)
	for i=#self.hand,1,-1 do
		local j = self.hand[i]
		if j.selected then
			pile:addCard(j.num,j.suit,j.x,j.y,j.r,self.scl)
			table.remove(self.hand, i)
		end
	end
end

function HandManager:draw()
	local panel = imageGet('handpanel')
	love.graphics.draw(panel, global.w/2, global.h+20, 0, 1, 1, 256, 512)
	for i,j in ipairs(self.hand) do
		local cardface = cardGet(j.num, j.suit)
		love.graphics.draw(cardface,j.x,j.y,j.r,self.scl,self.scl,512,512)
	end
end

function HandManager:clickAction()
	if self.hoverindex > 0 then
		local card = self.hand[self.hoverindex]
		card.selected = not card.selected
	end
end

function HandManager:checkMouse(x,y)
	local val = 0
	self.hover = false
	self.hoverindex = 0
	if not self.enabled then return 0 end
	for i,j in ipairs(self.hand) do
		local cx = x - j.x
		local cy = y - j.y
		local px = cx * math.cos(-j.r) - cy * math.sin(-j.r)
		local py = cx * math.sin(-j.r) + cy * math.cos(-j.r)
		if (math.abs(px) < 96) and (math.abs(py) < 128) then
			val = i
			self.hover = true
			self.hoverindex = i
		end
	end
	return val
end

return HandManager
