require 'game'

function love.load()

	Game:init()

end

function love.update(dt)

	Game:update(dt)

end

function love.draw()

	Game:draw()
	
end

function love.focus(f)

	if not f then
		-- print("LOST FOCUS")
	else
		-- print("GAINED FOCUS")
	end

end

function love.keypressed(key, scancode, isrepeat)

	Game:keypressed(key, scancode, isrepeat)

end