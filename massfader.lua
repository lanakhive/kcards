cs = require('cardspinner')

local MassFader = {}
MassFader.__index = MassFader

function MassFader.create()
	local fade = {}
	fade.state = -1
	fade.op = 0
	fade.spin = cs.create(800-80, 600-80, 0.1)
	fade.spinop = 0
	fade.wop = 255
	fade.count = 0
	fade.func = function() return end
	fade.cardx = 0
	fade.cardy = 0
	fade.cards = 1
	fade.cardsv = 0
	fade.cardr = 0
	setmetatable(fade, MassFader)
	return fade
end

function MassFader:fadeout(func)
	self.state = 1
	self.func = func
end

function MassFader:fadein(func)
	self.state = 3
end

function MassFader:cardout(x,y,func)
	self.state = 5
	self.wop = 0
	self.cardx = x
	self.cardy = y
	self.cardr = 0
	self.cards = 0.03 
	self.cardsv = 0 
	self.func = func
end

function MassFader:draw()
	local cardimage = imageGet('b')
	if self.state == 0 then return end
	-- draw white out
	if self.state == -1 then
		love.graphics.setColor(255,255,255,self.wop)
		love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
		love.graphics.reset()
	end
	-- draw black out
	if self.state > 0 and self.state < 5 then
		love.graphics.setColor(0,6,10,self.op)
		love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
		love.graphics.reset()
		love.graphics.setColor(255,255,255,self.spinop)
		self.spin:draw()
		love.graphics.reset()
	end
	-- draw card out
	if self.state == 5 then
		love.graphics.draw(cardimage,self.cardx,self.cardy,math.rad(self.cardr),self.cards,self.cards,512,512)
		love.graphics.setColor(255,255,255,self.wop)
		love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
	end
end

function MassFader:update(dt)
	if dt > 1 or self.state == 0 then return end
	-- fade in from white
	if self.state == -1 then
		self.wop = self.wop - 300 * dt
		if self.wop < 0 then self.wop = 0 self.state = 0 end
	end
	-- fade out to black
	if self.state == 1 then
		self.op = self.op + 300 * dt
		if self.op > 255 then self.op = 255 self.state = 2 end
	end
	-- fade in card spinner
	if self.state == 2 then 
		self.spin:update(dt)
		self.spinop = self.spinop + 400 * dt
		self.count = self.count + 10 * dt
		if self.spinop > 255 then self.spinop = 255  end
		if self.count > 20 then self.count = 0 fade.func() self.state = 3 end
	end
	-- fade out card spinner
	if self.state == 3 then 
		self.spin:update(dt)
		self.spinop = self.spinop - 600 * dt
		if self.spinop < 0 then self.spinop = 0  self.state = 4 end
	end
	-- fade in from black
	if self.state == 4 then
		self.op = self.op - 300 * dt
		if self.op < 0 then self.op = 0 self.state = 0 end
	end
	-- spin card into screen
	if self.state == 5 then
		self.cardx = lerp(self.cardx, global.w/2, dt*0.8)
		self.cardy = lerp(self.cardy, global.h/2, dt*0.2)
		self.cardr = lerp(self.cardr,720, dt)
		self.cardsv = self.cardsv + dt * 0.05
		self.cards = self.cards + self.cardsv
		if self.cards > 3 then
			self.wop = self.wop + 200 * dt
		end
		-- fade in to white
		if self.wop > 255 then
			fade.func()
			self.wop = 255 self.state = 0
		end
	end
end

return MassFader
