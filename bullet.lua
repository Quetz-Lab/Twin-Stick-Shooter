local love = require "love"

-- bullet.lua
local Bullet = {}
Bullet.__index = Bullet

-- Constructor de la bala
function Bullet:new(x, y, dirX, dirY)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.radius = 5
    self.speed = 400
    self.isActive = true

    -- Normalizar dirección
    local len = math.sqrt(dirX^2 + dirY^2)
    if len > 0 then
        self.dirX = dirX / len
        self.dirY = dirY / len
    else
        self.dirX, self.dirY = 0, -1
    end

    return self
end

-- Actualizar la posición de la bala
function Bullet:update(dt)
    if self.isActive then
        self.x = self.x + self.dirX * self.speed * dt
        self.y = self.y + self.dirY * self.speed * dt
    end
end

-- Dibujar la bala
function Bullet:draw()
    if self.isActive then
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius)
    end
end

return Bullet