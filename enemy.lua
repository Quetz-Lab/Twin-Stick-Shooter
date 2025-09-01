local love = require "love"

function enemy()
    local dice = math.random(1,4)
    local eX, eY
    local eRadius = 20

    if dice == 1 then
        eX = math.random(eRadius,love.graphics.getWidth())
        eY = eRadius * 4
    elseif dice == 2 then
        eX = eRadius * 4
        eY = math.random(eRadius,love.graphics.getHeight())
    elseif dice == 3 then 
        eX = math.random(eRadius,love.graphics.getWidth())
        eY = love.graphics.getHeight()+(eRadius*4)
    else 
        eX = love.graphics.getWidth()+(eRadius*4)
        eY = math.random(eRadius,love.graphics.getHeight())
    end

    return {
        radius = eRadius,
        level = 1,
        x = eX,
        y = eY,

        move = function(self,playerX,playerY)
            if playerX -self.x > 0 then
                self.x = self.x+self.level
            elseif playerX-self.x < 0 then
                self.x = self.x-self.level
            end
             if playerY -self.y > 0 then
                self.y = self.y+self.level
            elseif playerY-self.y < 0 then
                self.y = self.y-self.level
            end
        end,

        draw = function(self)
            love.graphics.setColor(1,.3,.5)
            love.graphics.circle("fill",self.x,self.y,self.radius)
            love.graphics.setColor(1,1,1)
        end,

    }
end

return enemy