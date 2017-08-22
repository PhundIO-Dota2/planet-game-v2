require "camera"
require "character"
require "planet"

Game = {}

function Game:init()

	love.physics.setMeter(32)
	love.graphics.setLineStyle("rough")

	self.world = love.physics.newWorld(0, 0, true)
	self.entities = {}
	self.planets = {}
	
	self:addPlanet(Planet:new(0, 3200, 3200, 9.81, self.world))
	self:addPlanet(Planet:new(0, -4000, 2000, 9.81, self.world))

	self.localPlayer = Character:new(0, -100, self.world)
	self:addEntity(self.localPlayer)
	-- self:addEntity(Character:new(0, -130, self.world))

	self.camera = Camera:new(0, -50)
end

function Game:update(dt)

	self.world:update(1/60)
	for _, ent in pairs(self.entities) do
        ent:update(dt)
    end

end

function Game:draw()

	self.camera:push()
	for _, ent in pairs(self.entities) do
        ent:draw()
    end
    self.camera:pop()

    love.graphics.print(tostring(love.timer.getFPS( )) .. " fps", 10, 10)

end

function Game:keypressed(key, scancode, isrepeat)

	if scancode == "space" then
		self.localPlayer:jump()
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