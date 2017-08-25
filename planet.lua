Planet = {}
Planet.__index = Planet

function Planet:new(x, y, radius, gravity, world)

	local planet = {}
	setmetatable(planet, Planet)

	planet.radius = radius
	planet.gravity = gravity * love.physics.getMeter()
	planet.body = love.physics.newBody(world, x, y)
	planet.shape = love.physics.newCircleShape(planet.radius)
	planet.fixture = love.physics.newFixture(planet.body, planet.shape, 1)

	return planet

end

function Planet:update(dt)

	for _, ent in pairs(Game.entities) do
		if ent.body ~= nil and ent.body:getType() ~= "static" then
			local forceX, forceY = self:getGravityForceAtPoint(ent.body:getX(), ent.body:getY())
			local mass = ent.body:getMass()
			ent.body:applyForce(forceX * mass, forceY * mass)
		end
	end

end

function Planet:draw()

	love.graphics.push()
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
	love.graphics.pop()

	-- DEBUG
	love.graphics.setColor(255, 0, 0)
	for _, ent in pairs(Game.entities) do
		if ent.body ~= nil and ent.body:getType() ~= "static" then
			local x, y = ent.body:getX(), ent.body:getY()
			local forceX, forceY = self:getGravityForceAtPoint(x, y)
			local mass = ent.body:getMass()
			love.graphics.line(x, y, x + forceX, y + forceY)
		end
	end

end

function Planet:getGravityForceAtPoint(x, y)

	local deltaX, deltaY = self.body:getX() - x, self.body:getY() - y
	local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
	local dirX, dirY = deltaX / distance, deltaY / distance
	local force = self.gravity * (self.radius / distance) * (self.radius / distance)
	return dirX * force, dirY * force

end

function Planet:position()

	return self.body:getX(), self.body:getY()

end

function Planet:angle()

	return self.body:getAngle()

end

return Planet