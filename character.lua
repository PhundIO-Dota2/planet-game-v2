Character = {}
Character.__index = Character

function Character:new(x, y, world)

	local character = {}
	setmetatable(character, Character)

	character.movementOrigin = { x = 0, y = 0 }
	character.body = love.physics.newBody(world, x, y, "dynamic")
	character.shape = love.physics.newRectangleShape(32, 64)
	character.fixture = love.physics.newFixture(character.body, character.shape, 1)
	character.fixture:setFriction(1)
	character.fixture:setGroupIndex(-1)
	character.body:setMass(8)
	character.body:setFixedRotation(true)

	character.feetShape = love.physics.newRectangleShape(0, 32, 24, 6, 0)
	character.feetFixture = love.physics.newFixture(character.body, character.feetShape, 1)
	character.feetFixture:setSensor(true)
	character.feetFixture:setGroupIndex(-1)

	return character

end

function Character:update(dt)

	self:updateMovementOrigin()
	self:handleMovement()
	self:keepUpRight()

end

function Character:updateMovementOrigin()

	local planet = self:findClosestPlanet()
	if planet then
		self.movementOrigin = { x = planet.body:getX(), y = planet.body:getY() }
	end

end

function Character:handleMovement()

	if self.jumping and love.timer.getTime() > self.jumpTime + 0.2 then
		self.jumping = false
	end

	local dirX, dirY = self:rightVector()
	local moveDirectionX, moveDirectionY = 0, 0
	if love.keyboard.isScancodeDown("a") then
		moveDirectionX = moveDirectionX - dirX
		moveDirectionY = moveDirectionY - dirY
	end
	if love.keyboard.isScancodeDown("d") then
		moveDirectionX = moveDirectionX + dirX
		moveDirectionY = moveDirectionY + dirY
	end
	local force = 10 * love.physics.getMeter()
	if not self.jumping and self:isGrounded() then
		self.body:setLinearVelocity(moveDirectionX * force, moveDirectionY * force)
	end

end

function Character:keepUpRight()

	local dirX, dirY = self:rightVector()
	self.body:setAngle(math.atan(dirY / dirX))

end

function Character:draw()

	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	love.graphics.setColor(0, 255, 0)
	love.graphics.circle("line", 0, -32, 16)
	love.graphics.polygon("line", self.shape:getPoints())
	love.graphics.polygon("line", self.feetShape:getPoints())
	love.graphics.pop()

end

function Character:jump()

	if not self:isGrounded() then return end
	local dirX, dirY = self:upVector()
	local force = 10 * love.physics.getMeter()
	self.body:applyLinearImpulse(dirX * force, dirY * force)
	self.jumping = true
	self.jumpTime = love.timer.getTime()

end

function Character:findClosestPlanet()

	local closestPlanet = nil
	local minDistance = nil
	for _, planet in pairs(Game.planets) do
		local deltaX, deltaY = self.body:getX() - planet.body:getX(), self.body:getY() - planet.body:getY()
		local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
		if not closestPlanet or distance < minDistance then
			minDistance = distance
			closestPlanet = planet
		end 
	end
	return closestPlanet

end

function Character:isGrounded()

	local contacts = self.body:getContactList()
	for _, contact in pairs(contacts) do
		fixtureA, fixtureB = contact:getFixtures()
		if (fixtureA == self.feetFixture or fixtureB == self.feetFixture) and contact:isTouching() then
			return true
		end
	end
	return false

end

function Character:upVector()

	local deltaX, deltaY = self.body:getX() - self.movementOrigin.x, self.body:getY() - self.movementOrigin.y
	local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
	local dirX, dirY = deltaX / distance, deltaY / distance
	return dirX, dirY

end

function Character:rightVector()

	local upX, upY = self:upVector()
	local rightX, rightY = -upY, upX
	return rightX, rightY

end

function Character:position()

	return self.body:getX(), self.body:getY()

end

function Character:angle()

	return self.body:getAngle()

end

return Character