Camera = {}
Camera.__index = Camera

function Camera:new(x, y)

	local camera = {}
	setmetatable(camera, Camera)
	camera.x = x
	camera.y = y
	camera.scale = 1
	return camera

end

function Camera:push()

	love.graphics.push()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.translate(w * 0.5 - self.x, h * 0.5 - self.y)
	love.graphics.scale(self.scale)

end

function Camera:pop()

	love.graphics.pop()

end

return Camera