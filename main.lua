
cg = require('cardgen')
cs = require('cardspinner')
hm = require('handmanager')
pm = require('pilemanager')
sm = require('statemanager')

floater = require('titlefloat')


global = {}
global.resourcedir = "resources"
cplayer = ""

function love.load()
	love.graphics.setCaption("Klootzak!");

	cg.cardPrecache()
	mainfont = love.graphics.newFont(42)

	scx = love.graphics.getWidth()
	scy = love.graphics.getHeight()

	spinner = cs.create(scx-80,scy-80,0.1)
	title = floater.create(400,650)

	global.bg = love.graphics.newImage(global.resourcedir .. "/" .. "bg" .. ".png")

	hand = hm.create(400,scy-50)
	pile = pm.create(400,200)
	stat = sm.create(hand,pile)
end

function love.update(dt)
	spinner:update(dt)
	title:update(dt)
	stat:update(dt)

	hand:checkMouse(love.mouse.getX(),love.mouse.getY())
	hand:update(dt)
	pile:update(dt)
	cplayer = stat:getPlayer()

end

function love.mousepressed(x,y, button)
	if button == 'l' then
		hand:clickAction()
		local d = pile:clickAction(x,y)
		if d then sm:trigger() end
	end
end

function love.draw()
	love.graphics.draw(global.bg,0,0);
	spinner:draw()
	title:draw()
	pile:draw()
	hand:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(mainfont)
	love.graphics.print("Player: " .. cplayer,10,550,0)
	love.graphics.reset()
end

