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
	mm.optionsButton.OnClick = function () loveframes.SetState("options") end
	mm.quitButton = loveframes.Create("button", mm.parentFrame)
	mm.quitButton:SetPos(5,95)
	mm.quitButton:SetText("Quit")
	mm.quitButton:SetWidth(140)
	mm.quitButton.OnClick = function () love.event.quit() end
	mm.dbgButton = loveframes.Create("button", mm.parentFrame)
	mm.dbgButton:SetPos(5, 125)
	mm.dbgButton:SetText("President")
	mm.dbgButton.OnClick = function () fade:cardout(50,100) if not menu.dm then menu.dm = MenuSystem.debug() end end 
	mm.parentFrame:SetState("mainmenu")
	
	menu.om = MenuSystem.createOptions()
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

function MenuSystem.debug()
	local textlist = "Cmd ready"
	local dm = {}
	dm.parentFrame = loveframes.Create("frame")
	dm.parentFrame:SetName("Horan Console")
	dm.parentFrame:SetWidth(300)
	dm.parentFrame:SetHeight(200)
	dm.fpsText = loveframes.Create("text", dm.parentFrame)
	dm.fpsText:SetPos(5,35)
	dm.fpsText:SetText(tostring("fps: " .. love.timer.getFPS()))
	dm.list = loveframes.Create("list", dm.parentFrame)
	dm.list:SetPos(5,65)
	dm.list:SetSize(290,100)
	dm.list:SetPadding(5)
	dm.list:SetAutoScroll(true)
	dm.text = loveframes.Create("text")
	dm.text:SetText("Cmd ready")
	dm.list:AddItem(dm.text)
	dm.input = loveframes.Create("textinput", dm.parentFrame)
	dm.input:SetPos(5,170)
	dm.input:SetWidth(290)
	dm.input.OnEnter = 
	function()
		local cmd = dm.input:GetText()
		if cmd == "clear" then textlist = "" dm.text:SetText(textlist) dm.input:Clear() return end
		local cfunc, cerror = loadstring(cmd)
		textlist = textlist .. " \n >" .. dm.input:GetText()
		if not cfunc then textlist = textlist .. " \n <Compile Fail: \n " .. cerror 
		else 
			local s1, s2 = pcall(cfunc)
			if not s1 then
				textlist = textlist .. " \n <Execute Fail: \n " .. s2
			else
				textlist = textlist .. " \n <" .. tostring(s2)
			end
		end
		dm.text:SetText(textlist)
		dm.input:Clear()
	end

	dm.parentFrame:SetVisible(true)
	dm.parentFrame:SetState("mainmenu")
	return dm
end

function MenuSystem.createOptions()
	local modes = love.graphics.getModes()
	local currentMode = {}
	currentMode.width, currentMode.height, currentMode.fullScreen = love.graphics.getMode()
	table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)
	local om = {}
	om.parentFrame = loveframes.Create("frame")
	om.parentFrame:SetName("Options")
	om.parentFrame:SetWidth(250)
	om.parentFrame:SetScreenLocked(true)
	om.parentFrame:SetDraggable(false)
	om.parentFrame:ShowCloseButton(false)
	om.parentFrame:CenterX()
	om.parentFrame:SetY(350)
	om.resText = loveframes.Create("text", om.parentFrame)
	om.resText:SetText("Resolution")
	om.resText:SetPos(5,40)
	om.resChoice = loveframes.Create("multichoice", om.parentFrame)
	om.resChoice:SetPos(80,35)
	om.resChoice:SetWidth(140)
	for i,j in pairs(modes) do
		om.resChoice:AddChoice("" .. j.width .. "x" .. j.height)
	end
	om.resChoice:SetChoice("" .. currentMode.width .. "x" .. currentMode.height)
	om.fullCheck = loveframes.Create("checkbox", om.parentFrame)
	om.fullCheck:SetPos(5,65)
	om.fullCheck:SetText("Fullscreen")
	om.fullCheck:SetChecked(currentMode.fullScreen)
	om.okButton = loveframes.Create("button", om.parentFrame)
	om.okButton:SetPos(5,95)
	om.okButton:SetText("Apply")
	om.okButton:SetWidth(100)
	om.okButton.OnClick = 
	function ()
		local currentMode = {}
		currentMode.width, currentMode.height, currentMode.fullScreen = love.graphics.getMode()
		local resChoice = om.resChoice:GetChoice()
		local fsChoice = om.fullCheck:GetChecked()
		for i,j in pairs(modes) do
			if resChoice == (j.width .. "x" .. j.height) then
				if j.width ~= currentMode.width or j.height ~= currentMode.height then
					love.graphics.setMode(j.width, j.height, fsChoice)
					global.w = j.width
					global.h = j.height
					global.ws = j.width / 800
					global.hs = j.height / 600
					currentMode.fullScreen = fsChoice
					cardPrecache()
				end
			end
		end
		if currentMode.fullScreen ~= fsChoice then
			love.graphics.toggleFullscreen()
			cardPrecache()
		end
		loveframes.SetState("mainmenu")
	end
	om.CancelButton = loveframes.Create("button", om.parentFrame)
	om.CancelButton:SetPos(110,95)
	om.CancelButton:SetText("Cancel")
	om.CancelButton:SetWidth(100)
	om.CancelButton.OnClick = function () loveframes.SetState("mainmenu") end
	om.parentFrame:SetState("options")
	return om
end

function MenuSystem:mouseIsMenu()
	return loveframes.util.GetHover()
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
