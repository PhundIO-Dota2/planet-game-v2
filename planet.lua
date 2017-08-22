Planet = {}
Planet.__index = Planet

function Planet:new(x, y, diameter, gravity, world)

	local planet = {}
	setmetatable(planet, Planet)

	planet.x = x
	planet.y = y
	planet.diameter = diameter
	planet.radius = planet.diameter * 0.5
	planet.gravity = gravity * love.physics.getMeter()
	planet.body = love.physics.newBody(world, x, y)
	planet.shape = love.physics.newCircleShape(planet.radius)
	planet.fixture = love.physics.newFixture(planet.body, planet.shape, 1)

	return planet

end

function Planet:update(dt)

	self.x, self.y = self.body:getX(), self.body:getY()
	for _, ent in pairs(Game.entities) do
		if ent.body ~= nil and ent.body:getType() ~= "static" then
			local x, y = ent.body:getX(), ent.body:getY()
			local deltaX, deltaY = self.x - x, self.y - y
			local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
			local dirX, dirY = deltaX / distance, deltaY / distance
			local force = ent.body:getMass() * self.gravity * (self.radius / distance) * (self.radius / distance)
			ent.body:applyForce(dirX * force, dirY * force)
		end
	end

end

function Planet:draw()

	local radius = self.diameter * 0.5
	love.graphics.push()
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle("line", self.x, self.y, radius)
	love.graphics.pop()

end

return Planet