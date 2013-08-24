floater = {}
floater.__index = floater

function floater.create(x,y)
	f = {}
	f.titleimg = love.graphics.newImage(global.resourcedir .. "/ktitle.png")
	f.px = x
	f.py = y
	f.cnt = 0
	f.rcnt = 0
	f.zcnt = 0
	rot = 0
	zom = 0
	setmetatable(f,floater)
	return f
end

function floater:update(dt)
	self.cnt = self.cnt + dt*0.5
	self.rcnt = self.rcnt + dt*0.2
	self.zcnt = self.zcnt + dt*0.3
	self.zom = math.cos(self.zcnt)*0.05 + 0.95
	self.rot = math.rad(math.sin(self.rcnt)*5)
	self.py = math.sin(self.cnt)*10 + 175 
end

function floater:draw()
	love.graphics.draw(self.titleimg,self.px,self.py,self.rot,self.zom,self.zom,325,100)
end

return floater
