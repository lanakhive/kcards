
cg = require('cardgen')
cs = require('cardspinner')
cf = require ('cardfall')
hm = require('handmanager')
pm = require('pilemanager')
sm = require('statemanager')
plm = require('playermanager')
ms = require('menusystem')
mf = require('massfader')
es = require('endscreen')
ai = require('aimaster')

floater = require('titlefloat')


global = {}
global.resourcedir = "resources"
global.w = 800
global.h = 600
global.ws = 1
global.hs = 1
global.playerName = {"Player 1"}
global.buf = ""
cplayer = ""

printo = print
function print(s) global.buf = global.buf .. s .. " \n " printo(s) end

function love.load()
	print("--- Kz Game by Lanak Hive ---\n")

	master = ai.create()
	master:dirload()

	cg.cardPrecache()
	smallfont = love.graphics.newFont(global.resourcedir .. "/main.ttf", 15)
	mainfont = love.graphics.newFont(global.resourcedir .. "/main.ttf", 18)
	mainfontlarge = love.graphics.newFont(global.resourcedir .. "/main.ttf", 32)
	defaultfont = love.graphics.newFont(10)

	global.w = love.graphics.getWidth()
	global.h = love.graphics.getHeight()
	global.ws = global.w / 800
	global.hs = global.h / 600

	spinner = cs.create(global.w-80,global.h-80,0.1)
	title = floater.create(400,175)
	falls = cf.create()
	fade = mf.create()

	global.bg = love.graphics.newImage(global.resourcedir .. "/" .. "bg" .. ".png")
	global.panel = love.graphics.newImage(global.resourcedir .. "/panel.png")
	global.lh  = love.graphics.newImage(global.resourcedir .. "/lh.png")

	hand = hm.create(global.w/2,global.h-50)
	pile = pm.create(400,200)
	players = plm.create(5,8)
	stat = sm.create(hand, pile, players, master)
	score = es.create()
	menu = ms.create()
end

function love.update(dt)
	if menu:isActive() then
		title:update(dt)
		falls:update(dt)
	else
		spinner:update(dt)
		stat:update(dt)

		hand:update(dt)
		hand:checkMouse(love.mouse.getX(),love.mouse.getY())
		pile:update(dt)
		cplayer = stat:getPlayer()
		players:setPlayer(cplayer)
		players:update(dt)
	end
	menu:update(dt)
	fade:update(dt)
	score:update(dt)

end

function love.mousepressed(x,y, button)
	if not menu:mouseIsMenu() then
		if button == 'l' then
			hand:clickAction()
			local d = pile:clickAction(x,y)
			if d then stat:trigger() end
		end
	end
	menu:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
	menu:mousereleased(x,y,button)
end

function love.keypressed(key,unicode)
	menu:keypressed(key,unicode)
	if key == 'escape' then
      love.event.quit()
   end
end

function love.keyreleased(key)
	menu:keyreleased(key)
end

function love.textinput(text)
	menu:textinput(text)
end

function love.draw()

	love.graphics.draw(global.bg,0,0,0,global.ws,global.hs);
	if menu:isActive() then
		falls:draw()
		title:draw()
		love.graphics.setColor(0,0,0,255)
		love.graphics.draw(global.lh, global.w-20, global.h-10, 0, .35, .35, 398, 94)
		love.graphics.reset()
	else
		pile:draw()
		hand:draw()
		players:draw(0,0)
		love.graphics.setColor(0,0,0,255)
		love.graphics.setFont(mainfontlarge)
		love.graphics.print("Player: " .. cplayer,25,global.h-60,0)
		love.graphics.reset()
	end
	score:draw()
	menu:draw()
	fade:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(defaultfont)
	love.graphics.print("Kz game v0.3",10,global.h - 13,0)
	love.graphics.reset()
end

