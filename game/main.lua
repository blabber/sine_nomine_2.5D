sn = {}
sn.coordinate = require 'sn.coordinate'
sn.player = require 'sn.player'
sn.tile = require 'sn.tile'

function love.load ()
	local levelString = [[
#####  #####  #####
#...#  #...#  #...#
#...####...####...#
#.s...............#
#...####...####...#
#...#  #...#  #...#
##.##  ##.##  ##.##
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.# ####.#### #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.#####.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#####.# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# ####.#### #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
##.##  ##.##  ##.##
#...#  #...#  #...#
#...####...####...#
#.................#
#...####...####...#
#...#  #...#  #...#
#####  #####  #####
]]

	level = { }
	for l in levelString:gmatch('([^\n]+)') do
		local line = { }
		level[#level+1] = line
		for c in l:gmatch('(.)') do
			line[#line+1] = c
		end
	end

	local f = love.graphics.setNewFont('font/PressStart2P-vaV7.ttf', 40)

	tiles = {}
	for y = 1, #level do
		for x = 1, #level[y] do
			local g = level[y][x]
			local c = sn.coordinate.new(x, y, f:getWidth('#'), f:getHeight('#'))

			if g == ' ' then
				goto continue
			elseif g == 's' then
				g = '.'
				player = sn.player.new(c:clone())
			end

			local h = g == '#' and 5 or 1

			tiles[#tiles+1] = sn.tile.new(c:clone(), g, h)

			::continue::
		end
	end
end

function love.update (dt)
	player:update(dt)
end

function love.keypressed (key)
	player:keypressed(key)
end

function love.draw ()
	love.graphics.translate(
		love.graphics.getWidth() / 2 - player.position:getScreenX(),
		love.graphics.getHeight() / 2 - player.position:getScreenY())

	for l = 0, 4 do
		for _, t in pairs(tiles) do
			t:draw(l)
		end
	end

	player:draw()
end
