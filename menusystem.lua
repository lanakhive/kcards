require("lib.loveframes")

MenuSystem = {}
MenuSystem.__index = MenuSystem

function MenuSystem.create()
	local menu = {}
	menu.active = true
	local mm = {}
	loveframes.util.SetActiveSkin("Orange")
	mm.parentFrame = loveframes.Create("frame")
	mm.parentFrame:SetName("Main Menu")
	mm.parentFrame:SetWidth(150)
	mm.parentFrame:SetScreenLocked(true)
	mm.parentFrame:SetDraggable(false)
	mm.parentFrame:ShowCloseButton(false)
	mm.parentFrame:CenterX()
	mm.parentFrame:SetY(350)
	mm.startButton = loveframes.Create("button", mm.parentFrame)
	mm.startButton:SetPos(5,35)
	mm.startButton:SetText("Start Game")
	mm.startButton:SetWidth(140)
	mm.startButton.OnClick = function () fade:fadeout(function() menu:setActive(false) end) end
	mm.optionsButton = loveframes.Create("button", mm.parentFrame)
	mm.optionsButton:SetPos(5,65)
	mm.optionsButton:SetText("Options")
	mm.optionsButton:SetWidth(140)
	mm.quitButton = loveframes.Create("button", mm.parentFrame)
	mm.quitButton:SetPos(5,95)
	mm.quitButton:SetText("Quit")
	mm.quitButton:SetWidth(140)
	mm.quitButton.OnClick = function () love.event.quit() end
	mm.parentFrame:SetState("mainmenu")
	
	loveframes.SetState("mainmenu")
	setmetatable(menu,MenuSystem)
	return menu
end

function MenuSystem:isActive()
	return self.active
end

function MenuSystem:setActive(val)
	self.active = val
	loveframes.SetState("none")
end


function MenuSystem:draw()
	loveframes.draw()
end

function MenuSystem:update(dt)
	loveframes.update(dt)
end

function MenuSystem:mousepressed(x,y,button)
	loveframes.mousepressed(x,y,button)
end

function MenuSystem:mousereleased(x,y,button)
	loveframes.mousereleased(x,y,button)
end

function MenuSystem:keypressed(key,unicode)
	loveframes.keypressed(key,unicode)
end

function MenuSystem:keyreleased(key)
	loveframes.keyreleased(key)
end

return MenuSystem
