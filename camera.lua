Camera = {}
Camera.__index = Camera

function Camera:new(x, y)

	local camera = {}
	setmetatable(camera, Camera)
	camera.x = x
	camera.y = y
	camera.scale = 1
	love.graphics.setLineWidth(1 / camera.scale)
	return camera

end

function Camera:push()

	love.graphics.push()
	love.graphics.setLineWidth(1 / self.scale)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.translate(w * 0.5 - self.x, h * 0.5 - self.y)
	love.graphics.scale(self.scale)
	if self.target then
		local x, y = self.target:position()
		love.graphics.rotate(-self.target:angle())
		love.graphics.translate(-x, -y)
	end

end

function Camera:pop()

	love.graphics.pop()

end

function Camera:setTarget(target)

	self.target = target

end

function Camera:setScale(scale)

	self.scale = scale

end

return Camera