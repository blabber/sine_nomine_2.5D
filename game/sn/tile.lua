local sn = { }
sn.constants = require "sn.constants"

local M = { }

local Tile = { }

function M.new(position, glyph, font, heightLevels)
	local t = {
		position = position,
		glyph = glyph,
		font = font,
		heightLevels = heightLevels,
		color = { 1, 1, 1 },
		drawable = love.graphics.newText(font, glyph)
	}
	Tile.__index = Tile
	setmetatable(t, Tile)

	return t
end

function Tile:getWidth()
	return self.font:getWidth(self.glyph)
end

function Tile:getHeight()
	return self.font:getHeight()
end

function Tile:draw(heightLevel, vanishingPoint, overrideColor)
	local c =
		overrideColor or
		{
			self.color[1],
			self.color[2],
			self.color[3]
		}

	if heightLevel >= self.heightLevels then
		return
	end

	love.graphics.setFont(self.font)

	if heightLevel == 0 then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle(
			"fill",
			self.position:getScreenX(),
			self.position:getScreenY(),
			self.font:getWidth(self.glyph),
			self.font:getHeight())
	end

	local a = self.position:screenAngle(vanishingPoint)
	local d = self.position:screenDistance(vanishingPoint)

	local dx = -(math.cos(a) * (d / sn.constants.PERSPECTIVEDIVISOR)) * heightLevel
	local dy = -(math.sin(a) * (d / sn.constants.PERSPECTIVEDIVISOR)) * heightLevel

	for i, v in ipairs(c) do
		c[i] =
			v - (sn.constants.MAXHEIGHTLEVELS - heightLevel) *
				(1 / (sn.constants.MAXHEIGHTLEVELS * 1.5))
	end

	love.graphics.setColor(c[1], c[2], c[3])
	love.graphics.draw(
		self.drawable,
		self.position:getScreenX() + dx,
		self.position:getScreenY() + dy,
		0,
		1 + heightLevel / sn.constants.PERSPECTIVEDIVISOR)
end

function Tile:setColor(r, g, b)
	self.color = { r, g, b }
end

return M
