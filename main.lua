local love = require "love"
local Bullet = require "bullet"
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

-- Disparar
function shoot()
    local dirX = player.aimX - player.x
    local dirY = player.aimY - player.y
    table.insert(bullets, Bullet:new(player.x, player.y, dirX, dirY))
end

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
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
    if love.mousepressed.isDown("right") then shoot() end

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

        -- Actualizar balas
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b:update(dt)

        -- Si la bala se sale de la pantalla, eliminarla
        if b.x < 0 or b.x > love.graphics.getWidth() or b.y < 0 or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end

-- Detectar click derecho para disparar
function love.mousepressed(mx, my, button)
    if button == 2 then -- botón derecho
        shoot()
    end
end


function love.draw()
    -- Dibujar jugador
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- Dibujar línea de apuntado
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(player.x, player.y, player.aimX, player.aimY)

    -- Dibujar balas
    for _, b in ipairs(bullets) do
        b:draw()
    end
end