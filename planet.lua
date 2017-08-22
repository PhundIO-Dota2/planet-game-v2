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
			local forceX, forceY = self:getGravityForceAtPoint(ent.body:getX(), ent.body:getY())
			local mass = ent.body:getMass()
			ent.body:applyForce(forceX * mass, forceY * mass)
		end
	end

end

function Planet:draw()

	local radius = self.diameter * 0.5
	love.graphics.push()
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle("line", self.x, self.y, radius)
	love.graphics.pop()

	-- DEBUG
	love.graphics.setColor(255, 0, 0)
	for _, ent in pairs(Game.entities) do
		if ent.body ~= nil and ent.body:getType() ~= "static" then
			local x, y = ent.body:getX(), ent.body:getY()
			local forceX, forceY = self:getGravityForceAtPoint(x, y)
			local mass = ent.body:getMass()
			ent.body:applyForce(forceX, forceY)
			love.graphics.line(x, y, x + forceX, y + forceY)
		end
	end

end

function Planet:getGravityForceAtPoint(x, y)

	local deltaX, deltaY = self.x - x, self.y - y
	local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
	local dirX, dirY = deltaX / distance, deltaY / distance
	local force = self.gravity * (self.radius / distance) * (self.radius / distance)
	return dirX * force, dirY * force

end

return Planet