-- main.lua (MOD sobre tus archivos)
local love = require "love"
local bullet = require "bullet"
local enemy = require "enemy"
local button = require "Button"
local Pickup = require "pickup"

-- Estados del juego
local STATE_MENU = "menu"
local STATE_PLAY = "playing"
local STATE_OVER = "gameover"
local gameState = STATE_MENU

-- Jugador
player = {
    x = 400, y = 300,
    speed = 220,
    radius = 20,
    ammo = 20,
    lives = 3,
    invuln = 0,
    fireCD = 0.12,
    fireT = 0
}

-- Pools
local bullets = {}
local enemies = {}
local pickups = {}

local score = 0
local timeAlive = 0
local spawnTimer = 0
local spawnEvery = 1.0

-- UI
local startBtn = button({ x = 300, y = 360, w = 200, h = 40, text = "Empezar",
    onClick = function() love.keypressed("return") end
})
local restartBtn = button({ x = 300, y = 400, w = 200, h = 40, text = "Reiniciar",
    onClick = function() love.keypressed("return") end
})

local function len(x,y) return math.sqrt(x*x + y*y) end
local function clamp(v, lo, hi) if v<lo then return lo elseif v>hi then return v>hi and hi or v end end

local function getInactive(tbl, factory)
    for i=1,#tbl do
        if not tbl[i].active then return tbl[i] end
    end
    local obj = factory()
    table.insert(tbl, obj)
    return obj
end

local function resetGame()
    player.x, player.y = 400, 300
    player.ammo = 20
    player.lives = 3
    player.invuln = 0
    player.fireT = 0
    score = 0
    timeAlive = 0
    spawnTimer = 0
    spawnEvery = 1.0
    for _,b in ipairs(bullets) do b.active = false end
    for _,e in ipairs(enemies) do e.active = false end
    for _,p in ipairs(pickups) do p.active = false end
end

local function startGame()
    resetGame()
    gameState = STATE_PLAY
end

local function circleOverlap(ax,ay,ar, bx,by,br)
    local dx,dy = ax-bx, ay-by
    return dx*dx + dy*dy <= (ar+br)*(ar+br)
end

local function spawnEnemy()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    local side = love.math.random(4)
    local ex,ey
    if side==1 then ex,ey = -20, love.math.random(0,H) -- izq
    elseif side==2 then ex,ey = W+20, love.math.random(0,H) -- der
    elseif side==3 then ex,ey = love.math.random(0,W), -20 -- arriba
    else ex,ey = love.math.random(0,W), H+20 end -- abajo
    local e = getInactive(enemies, function() return enemy() end)
    e:reset(ex,ey)
    e.active = true
end

local function shoot(mx,my)
    if player.ammo<=0 or player.fireT>0 then return end
    local bx,by = player.x, player.y
    local dx,dy = mx-bx, my-by
    local l = len(dx,dy)
    if l==0 then return end
    dx,dy = dx/l, dy/l
    local b = getInactive(bullets, function() return bullet(0) end)
    b:reset(bx,by,dx,dy)
    b.active = true
    player.ammo = player.ammo - 1
    player.fireT = player.fireCD
end

function love.load()
    love.window.setMode(800,600)
    love.window.setTitle("Twin-Stick Shooter")
end

function love.update(dt)
    if gameState ~= STATE_PLAY then return end

    if player.fireT>0 then player.fireT = math.max(0, player.fireT - dt) end
    if player.invuln>0 then player.invuln = math.max(0, player.invuln - dt) end

    timeAlive = timeAlive + dt
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnEvery then
        spawnTimer = 0
        spawnEvery = math.max(0.35, spawnEvery * 0.98)
        spawnEnemy()
        if math.random()<0.5 then spawnEnemy() end
    end

    -- Movimiento
    local mx,my = 0,0
    if love.keyboard.isDown("w") then my = my - 1 end
    if love.keyboard.isDown("s") then my = my + 1 end
    if love.keyboard.isDown("a") then mx = mx - 1 end
    if love.keyboard.isDown("d") then mx = mx + 1 end
    local l = len(mx,my)
    if l>0 then mx,my = mx/l, my/l end
    player.x = player.x + mx * player.speed * dt
    player.y = player.y + my * player.speed * dt

    -- Disparo continuo con mouse
    if love.mouse.isDown(1) then
        local x,y = love.mouse.getPosition()
        shoot(x,y)
    end

    -- Bullets
    local W,H = love.graphics.getWidth(), love.graphics.getHeight()
    for _,b in ipairs(bullets) do
        if b.active then b:update(dt,W,H) end
    end

    -- Enemigos y colisiones
    for _,e in ipairs(enemies) do
        if e.active then
            e:update(dt, player.x, player.y)
            -- choque con jugador
            if circleOverlap(e.x,e.y,e.radius, player.x,player.y,player.radius) and player.invuln<=0 then
                player.lives = player.lives - 1
                player.invuln = 1.0
                if player.lives <= 0 then
                    gameState = STATE_OVER
                end
            end
            -- choque bala/enemigo
            for _,b in ipairs(bullets) do
                if b.active and circleOverlap(e.x,e.y,e.radius, b.x,b.y,b.radius) then
                    e.active = false
                    b.active = false
                    score = score + 10
                    -- drop pickup
                    local p = getInactive(pickups, function() return Pickup() end)
                    p:reset(e.x, e.y)
                    p.active = true
                    break
                end
            end
        end
    end

    -- Pickups
    for _,p in ipairs(pickups) do
        if p.active then
            p:update(dt)
            if circleOverlap(p.x,p.y,p.radius, player.x,player.y,player.radius) then
                p.active = false
                player.ammo = player.ammo + p.amount
            end
        end
    end
end

function love.draw()
    local W,H = love.graphics.getWidth(), love.graphics.getHeight()
    if gameState == STATE_MENU then
        love.graphics.printf("Twin-Stick Shooter", 0, H/2 - 60, W, "center")
        love.graphics.printf("WASD: mover\nClick izquierdo: disparar\nEnter: empezar", 0, H/2 - 10, W, "center")
        startBtn:draw()
        return
    elseif gameState == STATE_OVER then
        love.graphics.printf("GAME OVER", 0, H/2 - 60, W, "center")
        love.graphics.printf(("Puntaje: %d   Tiempo: %ds"):format(score, math.floor(timeAlive)), 0, H/2 - 20, W, "center")
        love.graphics.printf("Enter para reiniciar", 0, H/2 + 10, W, "center")
        restartBtn:draw()
        return
    end

    -- Draw pickups
    for _,p in ipairs(pickups) do if p.active then p:draw() end end
    -- Draw enemies
    for _,e in ipairs(enemies) do if e.active then e:draw() end end
    -- Draw bullets
    for _,b in ipairs(bullets) do if b.active then b:draw() end end

    -- Player (blink if invulnerable)
    if player.invuln>0 then
        local a = 0.4 + 0.6 * math.cos(love.timer.getTime()*20)
        love.graphics.setColor(1,1,1, math.abs(a))
    else
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.circle("line", player.x, player.y, player.radius)
    love.graphics.setColor(1,1,1,1)

    -- HUD
    love.graphics.print(("Puntaje: %d"):format(score), 10, 10)
    love.graphics.print(("Tiempo: %ds"):format(math.floor(timeAlive)), 10, 28)
    love.graphics.print(("Balas: %d"):format(player.ammo), 10, 46)
    love.graphics.print(("Vidas: %d"):format(player.lives), 10, 64)
end

function love.mousepressed(x,y,button)
    if gameState == STATE_MENU then
        startBtn:mousepressed(x,y,button)
    elseif gameState == STATE_OVER then
        restartBtn:mousepressed(x,y,button)
    elseif gameState == STATE_PLAY and button==1 then
        shoot(x,y)
    end
end

function love.keypressed(key)
    if key == "return" then
        if gameState == STATE_MENU or gameState == STATE_OVER then
            startGame()
        end
    elseif key == "escape" and gameState == STATE_PLAY then
        gameState = STATE_MENU
    end
end
