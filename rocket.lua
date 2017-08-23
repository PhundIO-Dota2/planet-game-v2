Rocket = {}
Rocket.__index = Rocket

function Rocket:new(x, y, world)

	local rocket = {}
	setmetatable(rocket, Rocket)

	rocket.body = love.physics.newBody(world, x, y, "dynamic")
	rocket.shape = love.physics.newRectangleShape(64, 128)
	rocket.fixture = love.physics.newFixture(rocket.body, rocket.shape, 1)
	rocket.fixture:setFriction(1)
	rocket.body:setMass(10)

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
		local force = 120 * love.physics.getMeter()
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

	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	love.graphics.setColor(0, 255, 0)
	love.graphics.polygon("line", -32, -64, 32, -64, 0, -96)
	love.graphics.polygon("line", self.shape:getPoints())
	love.graphics.pop()

	-- DEBUG
	local angle = self.body:getAngle()
	local upX, upY = math.sin(angle), -math.cos(angle)
	local rightX, rightY = -upY, upX
	love.graphics.line(self.body:getX(), self.body:getY(), self.body:getX() + upX * 100, self.body:getY() + upY * 100)
	love.graphics.setColor(0, 0, 255)
	love.graphics.line(self.body:getX(), self.body:getY(), self.body:getX() + rightX * 100, self.body:getY() + rightY * 100)

end

function Rocket:position()

	return self.body:getX(), self.body:getY()

end

function Rocket:angle()

	return self.body:getAngle()

end

return Rocket