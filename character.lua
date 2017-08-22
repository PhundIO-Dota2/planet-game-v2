Character = {}
Character.__index = Character

function Character:new(x, y, world)

	local character = {}
	setmetatable(character, Character)

	character.x = x
	character.y = y
	character.body = love.physics.newBody(world, x, y, "dynamic")
	character.shape = love.physics.newRectangleShape(10, 20)
	character.fixture = love.physics.newFixture(character.body, character.shape, 1)
	character.body:setMass(80)

	return character

end

function Character:update(dt)



end

function Character:draw()

	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("line", -5, -10, 10, 20)
	love.graphics.pop()

end

return Character