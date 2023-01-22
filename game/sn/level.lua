local sn = { }
sn.position = require "sn.position"
sn.global = require "sn.global"
sn.player = require "sn.player"
sn.tile = require "sn.tile"

bresenham = require "bresenham"

local M = { }

local VISIBILITYRANGE = 6.5

local function createTile(position, glyph, font)
	local h = 1
	if glyph == '#' then
		h = sn.global.MAXHEIGHTLEVELS
	end

	t = sn.tile.new(position, glyph, font, h)
	
	if t.glyph ~= '#' and t.glyph ~= '.' then
		t:setColor(1, 0, 0)
	end

	return t
end


local private = { }
setmetatable(private, { __mode = 'k' })

local function conditionallyDrawDungeonTile(self, tile, heightLevel)
	local p = private[self].player.tile.position:clone()

	p:setX(math.floor(p:getX()))
	p:setY(math.floor(p:getY()))

	local c = {
		tile.color[1],
		tile.color[2],
		tile.color[3]
	}

	local cl = tile.heightLevels
	if self:checkVisibility(p, tile.position) then
		c = { 1, 1, 0 }
		tile.known = true
	else
		cl = 0
	end

	if tile.known and heightLevel <= cl then
		tile:draw(heightLevel, p, c)
	end
end

local Level = { }

function M.fromString(font, levelString)
	local newLevel = { }
	Level.__index = Level
	setmetatable(newLevel, Level)

	local tiles = { }
	private[newLevel] = {
		tiles = tiles,
		font = font
	}

	for l in levelString:gmatch('([^\n]+)') do
		tilesRow = { }
		tiles[#tiles+1] = tilesRow
		for g in l:gmatch('(.)') do
			local x = #tilesRow + 1
			local y = #tiles
			local w = font:getWidth('#')
			local h = font:getHeight()

			local c = sn.position.new(x, y, w, h)

			if g == 's' then
				g = '.'

				local pt = createTile(c:clone(), '@', font)

				pt:setColor(1, 1, 0)
				private[newLevel].player = sn.player.new(pt)
			end

			tilesRow[#tilesRow+1] = createTile(c:clone(), g, font)
		end
	end

	return newLevel
end

function Level:checkVisibility(position1, position2)
	if position1:distance(position2) >= VISIBILITYRANGE then
		return false
	end

	local l =
		bresenham.line(
			position1:getX(), position1:getY(),
			position2:getX(), position2:getY())
	if #l <= 2 then
		return true
	end

	local tiles = private[self].tiles

	for i = 2, #l-1 do
		local x = l[i][1]
		local y = l[i][2]

		if not tiles[y][x] or tiles[y][x].glyph == '#' then
			return false
		end
	end

	return true
end

function Level:keypressed(key)
	local p = private[self].player.tile.position
	local t = p:clone()

	if key == "up" then
		p:setY(p:getY() - 1)
	elseif key =="down" then
		p:setY(p:getY() + 1)
	elseif key =="left" then
		p:setX(p:getX() - 1)
	elseif key =="right" then
		p:setX(p:getX() + 1)
	end

	local tiles = private[self].tiles
	local g = tiles[p:getY()][p:getX()].glyph
	if g == '#' then
		private[self].player.tile.position = t
	end
end

function Level:movePlayerTowards(x, y)
	local a = math.deg(
		math.atan2(
			y - love.graphics.getHeight() / 2,
			x - love.graphics.getWidth() / 2))

	if a < 0 then
		a = a + 360
	end

	if (a > 45) and (a <= 135) then
		self:keypressed("down")
	elseif (a > 135) and (a <= 225) then
		self:keypressed("left")
	elseif (a > 225) and (a <= 315) then
		self:keypressed("up")
	else
		self:keypressed("right")
	end
end

function Level:draw()
	local player = private[self].player

	love.graphics.translate(
		love.graphics.getWidth() / 2 - player.tile.position:getScreenX(),
		love.graphics.getHeight() / 2 - player.tile.position:getScreenY())

	local tiles = private[self].tiles
	for l = 0, sn.global.MAXHEIGHTLEVELS-1 do
		for _, r in pairs(tiles) do
			for _, t in pairs(r) do
				conditionallyDrawDungeonTile(self, t, l)
			end
		end
	end

	player:draw(0, player.tile.position)
end

return M
