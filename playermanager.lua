cg = require('cardgen')

PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.create(players, cards)
	local pm = {}
	pm.players = players
	pm.hands = {}
	pm.arrow = {x=0,y=0,tx=0,ty=0}
	pm.outs = {}
	for i=1,players do
		table.insert(pm.hands, {})
		table.insert(pm.outs, {enabled = false, x=-100, y=0})
		for j=1,cards do
			table.insert(pm.hands[i], {x = -150, y = i*50, rem=false})
		end
	end
	setmetatable(pm,PlayerManager)
	pm:setPositions()
	return pm
end
		
function PlayerManager:setCardStatus(player,cards)
	while cards < #self.hands[player] do
		table.remove(self.hands[player],1)
		if cards == 0 then self.outs[player].enabled = true end
	end
	self:setPositions()
end

function PlayerManager:setPositions()
	for i,j in ipairs(self.hands) do
		for k,l in ipairs(j) do
			l.ty = i * 50 - 20
			l.tx = k * 15 - 0
		end
	end
	for i,j in ipairs(self.outs) do
		j.tx = -100
		if self.outs[i].enabled == true then
			j.tx = 25
		end
		j.ty = i * 50 - 38
	end


end

function PlayerManager:setPlayer(cplayer)
	local a = self.arrow
	a.tx = 5
	a.ty = cplayer * 50 - 38
end


function PlayerManager:update(dt)
	if dt > 1 then dt = 0 end
	for i,j in ipairs(self.hands) do
		for k,l in ipairs(j) do
			l.x = lerp(l.x, l.tx, 2.0*dt)
			l.y = lerp(l.y, l.ty, 2.0*dt)
		end
	end
	local a = self.arrow
	a.x = lerp(a.x, a.tx, 4.0*dt)
	a.y = lerp(a.y, a.ty, 4.0*dt)
	for i,j in ipairs(self.outs) do
		j.x = lerp(j.x, j.tx, 6.0*dt)
		j.y = lerp(j.y, j.ty, 6.0*dt)
	end
end

function PlayerManager:draw(x,y)
	local cardimage = imageGet('bs')
	local arrowimage = imageGet('rightarrow')
	local arrow = self.arrow
	local out = imageGet('out')
	love.graphics.draw(arrowimage,x+arrow.x,y+arrow.y,0,0.25,0.25)
	for i,j in ipairs(self.hands) do
		love.graphics.setFont(mainfont)
		love.graphics.print("Player " .. i, 20, i*50-40)
		for k,l in ipairs(j) do
			--love.graphics.draw(cardimage,x+l.x,y+l.y,0,0.03,0.03)
			love.graphics.draw(cardimage,x+l.x,y+l.y,0,0.5,0.5)
		end
	end
	for i,j in ipairs(self.outs) do
		if j.enabled == true then
			love.graphics.draw(out,x+j.x,y+j.y,0,0.56,0.56)
		end
	end
end

return PlayerManager