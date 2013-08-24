kz = require('klootzak')
dumbai = require('dumbai')

StateManager = {}
StateManager.__index = StateManager

function StateManager.create(hm, pm)
	sm = {}
	sm.state = 'player'
	sm.kstate = kz.genGameState(5)
	sm.hm = hm
	sm.pm = pm
	sm.counter = 0
	for i,j in ipairs(sm.kstate.hands[1]) do
		sm.hm:addCard(j.num,j.suit)
	end
	
	setmetatable(sm,StateManager)
	return sm
end

function StateManager:trigger()
	if kz.checkPlay(self.kstate.lastPlay,self.hm:getSelected(),self.kstate.highcardnum) then
		kz.gameUpdate(self.kstate, self.hm:getSelected())
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
	return self.kstate.currPlayer
end

function StateManager:update(dt)
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
		self.kstate.lastPlay,self.kstate.currplayer)
		for i,j in ipairs(actionst) do
			pm:addCard(j.num,j.suit,400,-200,0,.1)
		end
		kz.gameUpdate(self.kstate,actionst)
		self.counter = 20
	end
end
		
return StateManager
