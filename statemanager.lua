kz = require('klootzak')
dumbai = require('dumbai')

StateManager = {}
StateManager.__index = StateManager

function StateManager.create(hm, pm, plm)
	sm = {}
	sm.state = 'player'
	--sm.kstate = kz.genGameState(5)
	sm.hm = hm
	sm.pm = pm
	sm.plm = plm
	sm.counter = 0
	sm.gameactive = false
	setmetatable(sm,StateManager)
	--sm:createGame(8)
	return sm
end

function StateManager:createGame(players)
	self.state = 'player'
	self.kstate = kz.genGameState(players)
	self.gameactive = true
	self.counter = 0
	self.hm:clear()
	self.pm:clear()
	for i,j in ipairs(sm.kstate.hands[1]) do
		self.hm:addCard(j.num,j.suit)
	end
	self.plm:reset(players, #self.kstate.hands[1])
end

function StateManager:trigger()
	if kz.checkPlay(self.kstate.lastPlay,self.hm:getSelected(),self.kstate.highcardnum) then
		local playernum = self.kstate.currPlayer
		kz.gameUpdate(self.kstate, self.hm:getSelected())
		players:setCardStatus(playernum,#kz.getHand(self.kstate,playernum))
		self.hm:commit(pile)
		self.hm:setEnabled(false)
		self.state = 'other'
		self.counter = 20
	else
		self.hm:clearSelection()
	end
end


function StateManager:getState()
	return self.state
end

function StateManager:getPlayer()
	if not self.kstate then return 0 end
	if not self.kstate.gameInProgress then return 0 end
	return self.kstate.currPlayer
end

function StateManager:update(dt)
	if not self.kstate then return end
	if self.gameactive and not self.kstate.gameInProgress then 
		self.counter = self.counter - dt*10
		if self.counter > 0 then return end
		score:setPlayers("Player " .. self.kstate.president, "Player " .. self.kstate.klootzak)
		self.gameactive = false
		local x,y = self.plm:findLoserCard()
		fade:cardout(x, y, function() 
			score:activate(true)
			menu:setActive(true, "score")
		end)	
		return 
	end
	if self.kstate.currPlayer == 1 then self.state = 'player'
	else self.state = 'other' end


	if self.state == 'player' then
		hm:setEnabled(true)
	end

	self.counter = self.counter - dt*10
	if self.counter > 0 then return end

	if self.state == 'other' then
		local actionst = dumbai.think(
		kz.getHand(self.kstate,self.kstate.currPlayer),
		self.kstate.lastPlay,self.kstate.currPlayer)
		for i,j in ipairs(actionst) do
			pm:addCard(j.num,j.suit,400,-200,0,.1)
		end
		local playernum = self.kstate.currPlayer
		kz.gameUpdate(self.kstate,actionst)
		players:setCardStatus(playernum,#kz.getHand(self.kstate,playernum))
		self.counter = 20
	end
end
		
return StateManager
