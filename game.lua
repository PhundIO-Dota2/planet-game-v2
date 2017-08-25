require "camera"
require "character"
require "planet"
require "rocket"

Game = {}

function Game:init()

	love.physics.setMeter(32)
	love.graphics.setLineStyle("rough")

	self.world = love.physics.newWorld(0, 0, true)
	self.entities = {}
	self.planets = {}
	
	self:addPlanet(Planet:new(0, 0, 3000, 10, self.world))
	self:addPlanet(Planet:new(0, -20000, 1000, 3, self.world))

	self.localPlayer = Character:new(100, -100, self.world)
	-- self:addEntity(self.localPlayer)
	local rocket = Rocket:new(-2500, -2500, self.world)
	rocket.body:setLinearVelocity(-650, 650)
	self:addEntity(rocket)
	rocket:setDriver(self.localPlayer)

	self.camera = Camera:new(0, -50)
	self.camera:setTarget(rocket)
	self.zoomOutCam = Camera:new(0, 0)
	self.zoomOutCam:setScale(0.025)
	self.activeCamera = self.zoomOutCam
end

function Game:update(dt)

	self.world:update(1/60)
	for _, ent in pairs(self.entities) do
        ent:update(dt)
    end

end

function Game:draw()

	self.activeCamera:push()
	for _, ent in pairs(self.entities) do
        ent:draw()
    end
    self.zoomOutCam:pop()

    love.graphics.print(tostring(love.timer.getFPS( )) .. " fps", 10, 10)

end

function Game:keypressed(key, scancode, isrepeat)

	if scancode == "space" then
		self.localPlayer:jump()
	end
	if scancode == "tab" then
		if self.activeCamera == self.camera then
			self.activeCamera = self.zoomOutCam
		else
			self.activeCamera = self.camera
		end
	end

end

function Game:addEntity(ent)

	table.insert(self.entities, ent)

end

function Game:addPlanet(planet)

	table.insert(self.planets, planet)
	self:addEntity(planet)

end

return Game