cs = require('cardspinner')

MassFader = {}
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

function MassFader:draw()
	if self.state == 0 then return end
	if self.state == -1 then
		love.graphics.setColor(255,255,255,self.wop)
		love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
		love.graphics.reset()
	end
	if self.state > 0 then
		love.graphics.setColor(0,6,10,self.op)
		love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
		love.graphics.reset()
		love.graphics.setColor(255,255,255,self.spinop)
		self.spin:draw()
		love.graphics.reset()
	end
end

function MassFader:update(dt)
	if dt > 1 or self.state == 0 then return end
	if self.state == -1 then
		self.wop = self.wop - 300 * dt
		if self.wop < 0 then self.wop = 0 self.state = 0 end
	end
	if self.state == 1 then
		self.op = self.op + 300 * dt
		if self.op > 255 then self.op = 255 self.state = 2 end
	end
	if self.state == 2 then 
		self.spin:update(dt)
		self.spinop = self.spinop + 400 * dt
		self.count = self.count + 10 * dt
		if self.spinop > 255 then self.spinop = 255 fade.func() end
		if self.count > 20 then self.count = 0 self.state = 3 end
	end
	if self.state == 3 then 
		self.spin:update(dt)
		self.spinop = self.spinop - 600 * dt
		if self.spinop < 0 then self.spinop = 0  self.state = 4 end
	end
	if self.state == 4 then
		self.op = self.op - 300 * dt
		if self.op < 0 then self.op = 0 self.state = 0 end
	end
end

return MassFader
