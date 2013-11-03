floater = {}
floater.__index = floater

function floater.create(x,y)
	local f = {}
	f.titleimg = love.graphics.newImage(global.resourcedir .. "/ktitle.png")
	f.x = x
	f.y = y
	f.px = 0
	f.py = 0
	f.cnt = 0
	f.rcnt = 0
	f.zcnt = 0
	f.rot = 0
	f.zom = 0
	setmetatable(f,floater)
	return f
end

function floater:update(dt)
	self.cnt = self.cnt + dt*0.5
	self.rcnt = self.rcnt + dt*0.2
	self.zcnt = self.zcnt + dt*0.3
	self.zom = math.cos(self.zcnt)*0.05 + 0.95
	self.rot = math.rad(math.sin(self.rcnt)*5)
	self.py = math.sin(self.cnt)*10 + self.y 
	self.px = self.x
end

function floater:draw()
	love.graphics.draw(self.titleimg,self.px*global.ws,self.py*global.hs,self.rot,self.zom*global.hs,self.zom*global.hs,325,100)
	love.graphics.draw(imageGet('tcg'), self.px*global.ws, (self.y + 80)*global.hs, 0, 1*global.hs, 1*global.hs, 150, 0)
end

return floater
