local sn = {}
sn.level = require 'sn.level'

local level

function love.load()
	local f = love.graphics.setNewFont('font/PressStart2P-vaV7.ttf', 40)
	level = sn.level.fromString(f, [[
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
]])
end

function love.update(deltaTime)
	level:update(deltaTime)
end

function love.keypressed(key)
	level:keypressed(key)
end

function love.mousepressed(x, y)
	level:movePlayerTowards(x, y)
end

function love.touchpressed(_, x, y)
	level:movePlayerTowards(x, y)
end

function love.draw()
	level:draw()
end
