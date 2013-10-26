
cg = require('cardgen')
cs = require('cardspinner')
hm = require('handmanager')
pm = require('pilemanager')
sm = require('statemanager')
plm = require('playermanager')

floater = require('titlefloat')


global = {}
global.resourcedir = "resources"
cplayer = ""

function love.load()
	love.graphics.setCaption("Klootzak!");

	cg.cardPrecache()
	mainfont = love.graphics.newFont(18)

	scx = love.graphics.getWidth()
	scy = love.graphics.getHeight()

	spinner = cs.create(scx-80,scy-80,0.1)
	title = floater.create(400,650)

	global.bg = love.graphics.newImage(global.resourcedir .. "/" .. "bg" .. ".png")
	global.panel = love.graphics.newImage(global.resourcedir .. "/panel.png")

	hand = hm.create(400,scy-50)
	pile = pm.create(400,200)
	players = plm.create(5,8)
	stat = sm.create(hand,pile,players)
end

function love.update(dt)
	spinner:update(dt)
	title:update(dt)
	stat:update(dt)

	hand:checkMouse(love.mouse.getX(),love.mouse.getY())
	hand:update(dt)
	pile:update(dt)
	cplayer = stat:getPlayer()
	players:setPlayer(cplayer)
	players:update(dt)

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
	love.graphics.draw(global.panel,0,0,0,.6,.6);
	spinner:draw()
	--title:draw()
	pile:draw()
	hand:draw()
	players:draw(0,0)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(mainfont)
	love.graphics.print("Player: " .. cplayer,10,550,0)
	love.graphics.reset()
end

