local love = require "love"

function bullet ()
    local _x,_y
    local _radius = 10
    local speed = 150
    local isActive = false

    _x = love.graphics.getWidth()
    _y = love.graphics.getHeight()

    




    radius = _radius,
    x = _x,
    y =_y,

    draw = function(self)
        love.graphics.setColor(.2,.6,.5)
        love.graphics.circle("fill", self.x,self.y,self.radius)

end

return bullet