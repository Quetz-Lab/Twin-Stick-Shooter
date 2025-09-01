local love = require "love"
local bullet = require "bullet"
local enemy = require "enemy"
local button = require "Button"
-- player module
player = {
    x = 400,
    y = 300,
    speed = 200,
    radius = 20,
    aimX = 0,
    aimY = 0
}

local bullets = {}
local enemies = {}
local buttons = {
    menuState = {}
}
local game = {
    level = 1,
    state = {
        menu = true,
        pause = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {
        5,10,15,20
    }
}

local function StartGame()
    game.state["menu"] = false
    game.state["running"]=true
    enemies = {
        enemy(1)
    }
end

-- Disparar
function shoot()
    local dirX = player.aimX - player.x
    local dirY = player.aimY - player.y
    table.insert(bullets, bullet:new(player.x, player.y, dirX, dirY))
end

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

 

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.mouse.setVisible(false)
    love.window.setTitle("TwinStickShooter")
    table.insert(enemies,1,enemy())
    buttons.menuState.playeGame = Button("Play", StartGame,nil,120,40)
    buttons.menuState.quitGame = Button("Quit",love.event.quit,nil,120,40)

end

function love.update(dt)
    if game.state["running"]then
        -- Movimiento con teclado
        local moveX, moveY = 0, 0
    

        if love.keyboard.isDown("w") then moveY = moveY - 1 end
        if love.keyboard.isDown("s") then moveY = moveY + 1 end
        if love.keyboard.isDown("a") then moveX = moveX - 1 end
        if love.keyboard.isDown("d") then moveX = moveX + 1 end
    --if love.mousepressed.isDown("right") then shoot() end




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


        for i = 1, #enemies do
            enemies [i] : move(player.x, player.y)
            for i = 1, #game.levels do
                if math.floor(game.points) == game.levels[i] then
                    table.insert(enemies,1,enemy(game.level*(i+1)))
                    game.points = game.points+1
                end
            end
        end
            game.points = game.points + dt
 
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
    
    if game.state["menu"] then
        player.x,player.y = love.mouse.getPosition()
    end
end

    


-- Detectar click derecho para disparar
function love.mousepressed(mx, my, button, touch)
    if button == 2 then -- botón derecho
        shoot()
    end
     if not game.state["running"]then
        if button == 1 then
            if game.state["menu"]then
                for index in pairs(buttons.menuState) do
                    buttons.menuState[index]:checkPress(mx,my,player.radius)
                end
            end
        end
    end
end


function love.draw()
   
    -- Dibujar balas
    for _, b in ipairs(bullets) do
        b:draw()
    end
     love.graphics.printf("Points: " ..game.points,love.graphics.newFont(16),10,love.graphics.getHeight()-60,love.graphics.getWidth())
     love.graphics.printf("FPS: " ..love.timer.getFPS(),love.graphics.newFont(16),10,love.graphics.getHeight()-30,love.graphics.getWidth())
     --love,graphics.setColor(1,1,1)
    if game.state["running"]then
         -- Dibujar jugador
        love.graphics.setColor(0.8, 0.2, 0.2)
        love.graphics.circle("fill", player.x, player.y, player.radius)

    -- Dibujar línea de apuntado
        love.graphics.setColor(1, 1, 1)
        love.graphics.line(player.x, player.y, player.aimX, player.aimY)

        for i = 1, #enemies do
            enemies[i]:draw()
        end
        --love.graphics.circle("fill",player.x,player.y,player.radius)
    
    elseif game.state["menu"]then
    buttons.menuState.playeGame:draw(10,20,17,10)
    buttons.menuState.quitGame:draw(80,80,51,10)
    end
     if not game.state["running"] then
        love.graphics.circle("fill",player.x,player.y,player.radius/2)
    end
    
end