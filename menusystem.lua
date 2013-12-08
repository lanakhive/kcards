require("lib.loveframes")

MenuSystem = {}
MenuSystem.__index = MenuSystem

lastpcount = 6

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
	mm.startButton.OnClick = function ()
		MenuSystem.pItemRefresh(menu.sm)
		loveframes.SetState("startmenu")
	end
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
	mm.dbgButton.OnClick = function () fade:cardout(50,100,function() score:activate(true) loveframes.SetState("score") end) if not menu.dm then menu.dm = MenuSystem.debug() end end 
	mm.parentFrame:SetState("mainmenu")
	
	menu.om = MenuSystem.createOptions()
	menu.sm = MenuSystem.createStart()
	menu.cm = MenuSystem.createScore()
	loveframes.SetState("mainmenu")
	setmetatable(menu,MenuSystem)
	return menu
end

function MenuSystem:isActive()
	return self.active
end

function MenuSystem:setActive(val,state)
	self.active = val
	loveframes.SetState(state or "none")
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

function MenuSystem.createStart()
	local sm = {}
	sm.list = {}
	sm.parentFrame = loveframes.Create("frame")
	sm.parentFrame:SetName("Start Game")
	sm.parentFrame:SetScreenLocked(true)
	sm.parentFrame:SetDraggable(false)
	sm.parentFrame:ShowCloseButton(false)
	sm.parentFrame:SetWidth(350)
	sm.parentFrame:CenterX()
	sm.parentFrame:SetY(350)
	sm.okButton = loveframes.Create("button", sm.parentFrame)
	sm.okButton:SetPos(5,95)
	sm.okButton:SetText("Start")
	sm.okButton:SetWidth(100)
	sm.okButton.OnClick = function () 
		local pcount = sm.pnumChoice:GetChoice()
		lastpcount = pcount
		local aitable = {}
		for i=1, pcount do
			 aitable[i] = sm.list[i].ai and sm.list[i].ai:GetChoice() or "Default"
		 end
		fade:fadeout(function() menu:setActive(false) stat:createGame(pcount, aitable) end) 
	end
	sm.CancelButton = loveframes.Create("button", sm.parentFrame)
	sm.CancelButton:SetPos(110,95)
	sm.CancelButton:SetText("Cancel")
	sm.CancelButton:SetWidth(100)
	sm.CancelButton.OnClick = function () loveframes.SetState("mainmenu") end
	sm.pnumText = loveframes.Create("text", sm.parentFrame)
	sm.pnumText:SetText("Players")
	sm.pnumText:SetPos(5,35)
	sm.pnumChoice = loveframes.Create("multichoice", sm.parentFrame)
	sm.pnumChoice:SetPos(60,30)
	sm.pnumChoice:SetWidth(40)
	for i=2,9 do sm.pnumChoice:AddChoice(i) end
	sm.pnumChoice:SetChoice(6)
	sm.pnumChoice.OnChoiceSelected = function()
		MenuSystem.pItemRefresh(sm)
	end
	sm.parentFrame:SetState("startmenu")
	return sm
end

function MenuSystem.pItemRefresh(parent)
	local players = parent.pnumChoice:GetChoice()
	local list = parent.list
	
	for i in ipairs(list) do for k,l in pairs(list[i]) do l:Remove() end end
	for i=1, players do
		list[i] = {}
		local item = list[i]
		item.pnum = loveframes.Create("text", parent.parentFrame)
		item.pnum:SetText("" .. i)
		item.pnum:SetPos(5, i*30 + 40)
		item.pname = loveframes.Create("text", parent.parentFrame)
		item.pname:SetText(global.playerName[i] or ("Player " .. i))
		item.pname:SetPos(40, i*30 + 40)
		if i > 1 then
			item.ai = loveframes.Create("multichoice", parent.parentFrame)
			item.ai:SetPos(180, i*30 + 35)
			item.ai:SetWidth(160)
			item.ai:AddChoice("Default")
			for k,l in pairs(master:list()) do
				item.ai:AddChoice(l)
			end
			item.ai:SetChoice("Default")
			item.ai.OnChoiceSelected = function ()
				local name = master:getName(item.ai:GetChoice(), i)
				item.pname:SetText(name)
				global.playerName[i] = name
			end
		end
	end
	parent.okButton:SetY(players*30 + 75)
	parent.CancelButton:SetY(players*30 + 75)
	parent.parentFrame:SetHeight(players*30 + 105)
	parent.parentFrame:SetY(350 - (players/2)*30)
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
	om.parentFrame:SetHeight(160)
	om.parentFrame:SetScreenLocked(true)
	om.parentFrame:SetDraggable(false)
	om.parentFrame:ShowCloseButton(false)
	om.parentFrame:CenterX()
	om.parentFrame:SetY(350)
	om.nameText = loveframes.Create("text", om.parentFrame)
	om.nameText:SetText("Name")
	om.nameText:SetPos(5,35)
	om.nameInput = loveframes.Create("textinput", om.parentFrame)
	om.nameInput:SetPos(80,30)
	om.nameInput:SetWidth(140)
	om.nameInput:SetLimit(10)
	om.nameInput:SetText(global.playerName[1])
	om.resText = loveframes.Create("text", om.parentFrame)
	om.resText:SetText("Resolution")
	om.resText:SetPos(5,65)
	om.resChoice = loveframes.Create("multichoice", om.parentFrame)
	om.resChoice:SetPos(80,60)
	om.resChoice:SetWidth(140)
	for i,j in pairs(modes) do
		om.resChoice:AddChoice("" .. j.width .. "x" .. j.height)
	end
	om.resChoice:SetChoice("" .. currentMode.width .. "x" .. currentMode.height)
	om.fullCheck = loveframes.Create("checkbox", om.parentFrame)
	om.fullCheck:SetPos(5,95)
	om.fullCheck:SetText("Fullscreen")
	om.fullCheck:SetChecked(currentMode.fullScreen)
	om.okButton = loveframes.Create("button", om.parentFrame)
	om.okButton:SetPos(5,125)
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
		global.playerName[1] = om.nameInput:GetText()
		loveframes.SetState("mainmenu")
	end
	om.CancelButton = loveframes.Create("button", om.parentFrame)
	om.CancelButton:SetPos(110,125)
	om.CancelButton:SetText("Cancel")
	om.CancelButton:SetWidth(100)
	om.CancelButton.OnClick = function () loveframes.SetState("mainmenu") end
	om.parentFrame:SetState("options")
	return om
end

function MenuSystem.createScore()
	local cm = {}
	cm.parentFrame = loveframes.Create("frame")
	cm.parentFrame:SetName("What now?")
	cm.parentFrame:SetWidth(150)
	cm.parentFrame:SetHeight(100)
	cm.parentFrame:SetScreenLocked(true)
	cm.parentFrame:SetDraggable(false)
	cm.parentFrame:ShowCloseButton(false)
	cm.parentFrame:CenterX()
	cm.parentFrame:SetY(450)
	cm.startButton = loveframes.Create("button", cm.parentFrame)
	cm.startButton:SetPos(5,35)
	cm.startButton:SetText("Replay")
	cm.startButton:SetWidth(140)
	cm.startButton.OnClick = function () 
		fade:fadeout(function()
			menu:setActive(false)
			score:activate(false)
			stat:createGame(lastpcount)
		end)
	end
	cm.optionsButton = loveframes.Create("button", cm.parentFrame)
	cm.optionsButton:SetPos(5,65)
	cm.optionsButton:SetText("Main Menu")
	cm.optionsButton:SetWidth(140)
	cm.optionsButton.OnClick = function ()
		fade:fadeout(function ()
			score:activate(false)
			loveframes.SetState("mainmenu") 
		end)
	end
	cm.parentFrame:SetState("score")
	return cm
end



function MenuSystem:mouseIsMenu()
	if not self.active then return false end
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
