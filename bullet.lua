-- bullet.lua
local love = require "love"

-- bullet.lua
local function Bullet()
    return {
        x = 0, y = 0,
        radius = 4,
        dx = 0, dy = 0,
        speed = 480,
        life = 0, maxLife = 2.0,
        active = false,

        reset = function(self, x, y, dx, dy)
            self.x, self.y = x, y
            self.dx, self.dy = dx, dy
            self.life = 0
            self.active = true
        end,

        update = function(self, dt, W, H)
            if not self.active then return end
            self.x = self.x + self.dx * self.speed * dt
            self.y = self.y + self.dy * self.speed * dt
            self.life = self.life + dt
            if self.life >= self.maxLife or self.x<-10 or self.y<-10 or self.x>W+10 or self.y>H+10 then
                self.active = false
            end
        end,

        draw = function(self)
            if not self.active then return end
            love.graphics.setColor(1,1,0.3)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1,1,1)
        end
    }
end

return Bullet
