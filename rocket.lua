Rocket = {}
Rocket.__index = Rocket

function Rocket:new(x, y, world)

	local rocket = {}
	setmetatable(rocket, Rocket)

	rocket.body = love.physics.newBody(world, x, y, "dynamic")
	rocket.shape = love.physics.newRectangleShape(64, 128)
	rocket.fixture = love.physics.newFixture(rocket.body, rocket.shape, 1)
	rocket.fixture:setFriction(1)
	rocket.body:setMass(1000)

	return rocket

end

function Rocket:update(dt)

	self:handleMovement()

end

function Rocket:handleMovement()

	local angle = self.body:getAngle()
	local upX, upY = math.sin(angle), -math.cos(angle)
	local rightX, rightY = -upY, upX
	if love.keyboard.isScancodeDown("w") then
		local worldX, worldY = self.body:getWorldPoint(0, 64)
		local force = 12000 * love.physics.getMeter()
		self.body:applyForce(upX * force, upY * force, worldX, worldY)
	end
	local lateralForce = 10 * love.physics.getMeter()
	if love.keyboard.isScancodeDown("a") then
		local topX, topY = self.body:getWorldPoint(-32, -64)
		local downX, downY = self.body:getWorldPoint(32, 64)
		self.body:applyForce(rightX * -lateralForce, rightY * lateralForce, topX, topY)
		self.body:applyForce(rightX * lateralForce, rightY * lateralForce, downX, downY)
	end
	if love.keyboard.isScancodeDown("d") then
		local topX, topY = self.body:getWorldPoint(32, -64)
		local downX, downY = self.body:getWorldPoint(-32, 64)
		self.body:applyForce(rightX * lateralForce, rightY * -lateralForce, topX, topY)
		self.body:applyForce(rightX * -lateralForce, rightY * -lateralForce, downX, downY)
	end

end

function Rocket:setDriver(character)

	self.driver = character

end

function Rocket:draw()

	-- DEBUG
	local angle = self.body:getAngle()
	local upX, upY = math.sin(angle), -math.cos(angle)
	local rightX, rightY = -upY, upX
	love.graphics.line(self.body:getX(), self.body:getY(), self.body:getX() + upX * 100, self.body:getY() + upY * 100)
	love.graphics.setColor(0, 0, 255)
	love.graphics.line(self.body:getX(), self.body:getY(), self.body:getX() + rightX * 100, self.body:getY() + rightY * 100)

	self:drawTrajectory(50000)

	-- ROCKET
	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	love.graphics.setColor(0, 255, 0)
	love.graphics.polygon("line", -32, -64, 32, -64, 0, -96)
	love.graphics.polygon("line", self.shape:getPoints())
	love.graphics.pop()

end

function Rocket:drawTrajectory(maxDistance)

	-- TRAJECTORY
	local hit = false
	local distance = 0
	local step = 6/60
	local i = 0
	local x, y = self.body:getPosition()
	local vX, vY = self.body:getLinearVelocity()
	local points = {x, y}
	while distance < maxDistance and not hit do
		x, y = x + vX * step, y + vY * step
		segmentLength = math.sqrt(vX * step * vX * step + vY * step * vY * step)
		distance = distance + segmentLength
		for _, planet in pairs(Game.planets) do
			local gX, gY = planet:getGravityForceAtPoint(x, y)
			vX, vY = vX + gX * step, vY + gY * step
			if planet.shape:testPoint(0, 0, 0, x, y) then
				hit = true
			end
		end
		table.insert(points, x)
		table.insert(points, y)
	end
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(points)

end

function Rocket:position()

	return self.body:getX(), self.body:getY()

end

function Rocket:angle()

	return self.body:getAngle()

end

return Rocket