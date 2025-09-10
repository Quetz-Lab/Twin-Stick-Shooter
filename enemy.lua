-- enemy.lua (MOD pooling)
local love = require "love"

function enemy()
    return {
        x = 100, y = 100,
        radius = 14,
        level = 2,
        speed = 90,
        active = false,

        reset = function(self, x, y)
            self.x, self.y = x, y
            self.speed = 90 + love.math.random()*60
            self.active = true
        end,

        update = function(self, dt, playerX, playerY)
            if not self.active then return end
            local dx, dy = playerX - self.x, playerY - self.y
            local l = math.sqrt(dx*dx + dy*dy)
            if l>0 then dx, dy = dx/l, dy/l end
            self.x = self.x + dx * self.speed * dt
            self.y = self.y + dy * self.speed * dt
        end,

        draw = function(self)
            if not self.active then return end
            love.graphics.setColor(1,.3,.5)
            love.graphics.circle("fill",self.x,self.y,self.radius)
            love.graphics.setColor(1,1,1)
        end,
    }
end

return enemy
