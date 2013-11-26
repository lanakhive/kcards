
local EndScreen = {}
EndScreen.__index = EndScreen

function EndScreen.create()
	local screen = {}
	screen.p = {}
	screen.p.title = "President:"
	screen.p.name = "Player Awesome"
	screen.p.tx = 100
	screen.p.ty = 100
	screen.p.to = 0
	screen.p.nx = 200
	screen.p.ny = 150
	screen.p.no = 0
	screen.k = {}
	screen.k.title = "Klootzak:"
	screen.k.name = "Player Bad"
	screen.k.tx = 100
	screen.k.ty = 300
	screen.k.to = 0
	screen.k.nx = 200
	screen.k.ny = 350
	screen.k.no = 0
	screen.counter = 0
	screen.active = false
	screen.font = love.graphics.newFont(40)
	setmetatable(screen, EndScreen)
	return screen
end

function EndScreen:setPlayers(p,k)
	self.p.name = p
	self.k.name = k
end

function EndScreen:activate(yes)
	if yes then
		self.p.to = 0
		self.p.no = 0
		self.k.to = 0
		self.k.no = 0
		self.counter = 0
	end
	self.active = yes
end

function EndScreen:update(dt)
	if not self.active then return end
	if dt > 1 then return end
	self.counter = self.counter + dt * 100

	self.p.to = self.p.to + 300 * dt
	if (self.p.to > 255) then self.p.to = 255 end

	if self.counter < 50 then return end
	self.p.no = self.p.no + 300 * dt
	if (self.p.no > 255) then self.p.no = 255 end

	if self.counter < 150 then return end
	self.k.to = self.k.to + 300 * dt
	if (self.k.to > 255) then self.k.to = 255 end

	if self.counter < 200 then return end
	self.k.no = self.k.no + 300 * dt
	if (self.k.no > 255) then self.k.no = 255 end
end

function EndScreen:draw()
	if not self.active then return end
	love.graphics.setColor(255,255,255)
	love.graphics.quad("fill",0,0,global.w,0,global.w,global.h,0,global.h)
	love.graphics.setFont(self.font)

	love.graphics.setColor(0, 0, 0, self.p.to)
	love.graphics.draw(imageGet("C"), self.p.tx, self.p.ty, math.rad(-15), .12, .12,512)
	love.graphics.print(self.p.title, self.p.tx+10, self.p.ty+5, math.rad(-15))

	love.graphics.setColor(255, 0, 0, self.p.no)
	love.graphics.draw(imageGet("H"), self.p.nx, self.p.ny, math.rad(-15), .12, .12,512)
	love.graphics.print(self.p.name, self.p.nx+10, self.p.ny+5, math.rad(-15))

	love.graphics.setColor(0, 0, 0, self.k.to)
	love.graphics.draw(imageGet("S"), self.k.tx, self.k.ty, math.rad(-15), .12, .12,512)
	love.graphics.print(self.k.title, self.k.tx+10, self.k.ty+5, math.rad(-15))

	love.graphics.setColor(255, 0, 0, self.k.no)
	love.graphics.draw(imageGet("D"), self.k.nx, self.k.ny, math.rad(-15), .12, .12,512)
	love.graphics.print(self.k.name, self.k.nx+10, self.k.ny+5, math.rad(-15))

	love.graphics.reset()
end

return EndScreen
