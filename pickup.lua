-- pickup.lua (nuevo): suma balas al recogerlo y se apaga
local Pickup = {}
Pickup.__index = Pickup

setmetatable(Pickup, { __call = function(_, ...) return Pickup:new(...) end })

function Pickup:new()
    return setmetatable({
        x = 0, y = 0,
        radius = 8,
        amount = 3,
        active = false,
        life = 0, maxLife = 8.0,
        bob = 0
    }, self)
end

function Pickup:reset(x,y)
    self.x, self.y = x, y
    self.active = true
    self.life = 0
    self.bob = 0
end

function Pickup:update(dt)
    if not self.active then return end
    self.life = self.life + dt
    self.bob = self.bob + dt
    if self.life >= self.maxLife then self.active = false end
end

function Pickup:draw()
    if not self.active then return end
    local r = self.radius + math.sin(self.bob*6)*1.5
    love.graphics.setColor(0.2,1.0,0.4)
    love.graphics.circle("fill", self.x, self.y, r)
    love.graphics.setColor(1,1,1)
end

return Pickup
