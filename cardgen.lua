
imagecache = {}
function imageGet(key)
	if not imagecache[key] then
		imagecache[key] = love.graphics.newImage(global.resourcedir .. "/" .. key .. ".png")
	end
	return imagecache[key]
end

cardcache = {}
function cardGet(num,suit)
	if not cardcache[num .. suit] then
		cardcache[num .. suit] = genCard(num,suit)
	end
	return cardcache[num .. suit]
end

function genCard(num,suit)
	suit = suit or "J"
	local dim = 1024
	local divs = 24
	local ds = dim/divs
	local flip = math.rad(180)
	local c = love.graphics.newCanvas(dim,dim)
	--back = love.graphics.newImage("kimage/f.png")
	--inum = love.graphics.newImage("kimage/" .. num .. ".png")
	--isuit = love.graphics.newImage("kimage/" .. suit .. ".png")
	back = imageGet("f");
	inum = imageGet(num);
	isuit = imageGet(suit);

	if num == 1 then
		isuit = imageGet("J")
	end

	love.graphics.setCanvas(c)

	--card background
	love.graphics.draw(back,0,0,0,1,1)
	
	if suit == "H" or suit == "D" then
		love.graphics.setColor(255,0,0,255)
	else
		love.graphics.setColor(0,0,0,255)
	end

	--top left
	love.graphics.draw(isuit,ds*5,ds*2,0,4/24,4/24,256,256)
	love.graphics.draw(inum,ds*5,ds*4,0,4/24,4/24,256,256)
	--bottom right
	love.graphics.draw(isuit,ds*19,ds*22,flip,4/24,4/24,256,256)
	love.graphics.draw(inum,ds*19,ds*20,flip,4/24,4/24,256,256)

	if num == 1 or num == 14 then
		love.graphics.draw(isuit,ds*12,ds*12,0,20/24,20/24,256,256)
	end

	--twogroup
	if num == 2 or num == 3 then
		love.graphics.draw(isuit,ds*12,ds*3,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*12,ds*21,flip,8/24,8/24,256,256)
	end

	--innertwogroup
	if num == 7 or num == 8  then
		love.graphics.draw(isuit,ds*12,ds*7.5,0,8/24,8/24,256,256)
	end

	if num == 8 then
		love.graphics.draw(isuit,ds*12,ds*16.5,flip,8/24,8/24,256,256)
	end

	if num == 10 then
		love.graphics.draw(isuit,ds*12,ds*6,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*12,ds*18,flip,8/24,8/24,256,256)
	end

	--centergroup
	if num == 3 or num == 5 or num == 9 then
		love.graphics.draw(isuit,ds*12,ds*12,0,8/24,8/24,256,256)
	end

	if num == 6 or num == 7 or num == 8 then
		love.graphics.draw(isuit,ds*9,ds*12,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*15,ds*12,0,8/24,8/24,256,256)
	end

	--fourgroup
	if num >=4 and num <= 10 then
		love.graphics.draw(isuit,ds*9,ds*3,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*15,ds*3,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*9,ds*21,flip,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*15,ds*21,flip,8/24,8/24,256,256)
	end

	--innerfourgroup
	if num == 9 or num == 10 then
		love.graphics.draw(isuit,ds*9,ds*9,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*15,ds*9,0,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*9,ds*15,flip,8/24,8/24,256,256)
		love.graphics.draw(isuit,ds*15,ds*15,flip,8/24,8/24,256,256)
	end

	if num == 11 then
		love.graphics.draw(inum,ds*12,ds*12,0,20/24,20/24,256,256)
	end

	if num == 12 then
		love.graphics.draw(inum,ds*12,ds*12,0,20/24,20/24,256,256)
	end

	if num == 13 then
		love.graphics.draw(inum,ds*12,ds*12,0,20/24,20/24,256,256)
	end

	love.graphics.reset()
	love.graphics.setCanvas()
	cardback = c
	return c
end

function cardPrecache()
	cardcache = {}
	for i = 14,2,-1 do
		cardGet(i,"H")
		cardGet(i,"D")
		cardGet(i,"C")
		cardGet(i,"S")
	end
	cardGet(1, "H")
	cardGet(1, "C")
end

local cardGen = {
	cardGet = cardGet,
	cardPrecache = cardPrecache
}

return cardGen

