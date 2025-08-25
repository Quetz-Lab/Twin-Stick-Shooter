local love = require "love"

-- bullet.lua
local Bullet = {}


function bullet.new(x, y, dirX, dirY, speed, lifetime)
    local b = setmetatable({}, Bullet)
    b.x = x
    b.y = y
    b.vx = dirX * speed
    b.vy = dirY * speed
    b.radius = 3
    b.t = 0
    b.lifetime = lifetime or 1.2
    return b
end

function bullet:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    self.t = self.t + dt
end

function bullet:isDead()
    return self.t > self.lifetime
end

function bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return bullet
