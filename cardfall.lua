cg = require('cardgen')

local CardFall = {}
CardFall.__index = CardFall

function CardFall.create()
	local cf = {}
	cf.cards = {}
	-- generate initial cards
	for i=1, 20 do
		local card, suit = CardFall.randomCard()
		table.insert(cf.cards, 
		{
			num = math.random(2,14),
			suit = suit,
			x=math.random(global.w),
			y=math.random(global.h) - global.h,
			r=math.rad(math.random(360)),
			spy = math.random(100)+50,
			spr = math.rad(math.random(20)+20) * (math.random(0,1) * 2 - 1),
			back = math.random(1,20) == 1
		})
	end
	setmetatable(cf, CardFall)
	return cf
end

-- get a random card
function CardFall.randomCard()
	local suit
	local card = math.random(2,13)
	local stemp = math.random(1,4)
	if stemp == 1 then suit = "H"
	elseif stemp == 2 then suit = "D"
	elseif stemp == 3 then suit = "S"
	elseif stemp == 4 then suit = "C"
	end
	return card, suit
end

function CardFall:draw()
	for i,j in ipairs(self.cards) do
		local cardface = cardGet(j.num, j.suit)
		if j.back then cardface = imageGet('bb') end
		love.graphics.draw(cardface, j.x, j.y, j.r, 0.1, 0.1, 512, 512)
	end
end

function CardFall:update(dt)
	if (dt > 1) then return end
	for i,j in ipairs(self.cards) do
		j.y = j.y + j.spy * dt
		j.r = j.r + j.spr * dt
		j.spy = j.spy + 20 * dt
		-- check if card has fallen below screen and rerandomize it
		if j.y > global.h + 150 then
			j.y = -100
			j.x = math.random(global.w)
			j.spy = math.random(100)+50
			j.num, j.suit = self.randomCard()
			j.back = math.random(1,20) == 1
		end
	end
end

return CardFall

