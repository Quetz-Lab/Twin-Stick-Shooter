local love = require "love"
local bullet = require "bullet"
-- Player module
player = {
    x = 400,
    y = 300,
    speed = 200,
    radius = 20,
    aimX = 0,
    aimY = 0
}

local bullets = {}

function shoot()
    bullets = {
        bullet(10)
    }


end

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
    -- Movimiento con teclado
    local moveX, moveY = 0, 0
    if love.keyboard.isDown("w") then moveY = moveY - 1 end
    if love.keyboard.isDown("s") then moveY = moveY + 1 end
    if love.keyboard.isDown("a") then moveX = moveX - 1 end
    if love.keyboard.isDown("d") then moveX = moveX + 1 end

    -- Normalizar dirección
    local length = math.sqrt(moveX^2 + moveY^2)
    if length > 0 then
        moveX = moveX / length
        moveY = moveY / length
    end

    -- Aplicar movimiento
    player.x = player.x + moveX * player.speed * dt
    player.y = player.y + moveY * player.speed * dt

    -- Dirección de disparo (stick derecho simulado con mouse)
    player.aimX = love.mouse.getX()
    player.aimY = love.mouse.getY()
end

function love.draw()
    -- Dibujar jugador
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- Dibujar línea de apuntado
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(player.x, player.y, player.aimX, player.aimY)
end