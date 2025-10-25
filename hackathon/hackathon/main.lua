function love.load()
    bossspawn = false
    bossdead = false
    score = 0
    speed = 0
    collisionDist = 40
    playerhealth = 100
    timer, timer2, timer3, timer4, timer5, timer6, timer7, timer8, timer9, timer10, timer11, timer12 = 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0
    dev = 0
    enemies, bullets, healths, InfAmmos, fastEnemies, SpeedUp = {}, {}, {}, {}, {}, {}
    playerx, playery = 400, 300
    ammo = 500
    width, height = love.window.getDesktopDimensions(1)
    love.window.setMode(width, height)
    grass = love.graphics.newImage( "/assets/grassenemy.png")
    coffee = love.graphics.newImage ( "/assets/Untitled.png")
    playerimg = love.graphics.newImage ("/assets/tuxcircle.png")
    ammoinf = love.graphics.newImage( "/assets/infammo.png")
    soap = love.graphics.newImage( "/assets/soap.png")
    background = love.graphics.newImage("/assets/bg.jpg")
    speedpower = love.graphics.newImage("/assets/monster.png")
    music = love.audio.newSource("/assets/hackathonmusicslowed.wav", 'stream')
    sam = love.graphics.newImage( "/assets/sf.png")
    music:setLooping( true )
    music:play()

    -- Game states: "start", "play", "gameover"
    gamestate = "start"
end

--I support palestine

function love.draw()
    love.graphics.origin()

    if gamestate == "start" then
        drawStartScreen()
    elseif gamestate == "play" then
        drawGame()
    elseif gamestate == "gameover" then
        drawGameOver()
    end
end

function drawStartScreen()
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("AVOID TOUCHING THE GRASS", 0, height/2 - 50, width/2, "center", 0, 2, 2)
    love.graphics.printf("Press SPACE to start", 0, height/2 + 10, width/2, "center", 0, 2, 2)
end

function drawGameOver()
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 0, height/2 - 50, width/2, "center", 0, 2, 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Final Score: " .. score, 0, height/2, width/2, "center", 0, 2, 2)
    love.graphics.printf("Press R to restart or ESC to quit", 0, height/2 + 40, width/2, "center", 0, 2, 2)
end

function drawGame()

    love.graphics.setColor( 0.5, 0.5, 0.5)
    love.graphics.draw(background, 0, 0, 0, 0.5, 0.5)
    -- Player
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw ( playerimg, playerx, playery, 0, 2, 2)

    -- Enemies
    love.graphics.setColor(1 , 1 , 1)
    for _, e in ipairs(enemies) do
        love.graphics.draw(e.image, e.x, e.y, 0, 2, 2)
    end

    love.graphics.setColor(1,1,0)
    if bossspawn == true then
        love.graphics.draw(boss.image, boss.x, boss.y, 0, 0.4, 0.4)
    end

    -- Bullets
    love.graphics.setColor(0, 0, 1)
    for _, B in ipairs(bullets) do
        love.graphics.circle("fill", B.x, B.y, 7.5)
    end

    -- Health pickups
    love.graphics.setColor(1, 1, 1)
    for _, h in ipairs(healths) do
        love.graphics.draw(coffee, h.x, h.y, 0, 2, 2)
    end

    love.graphics.setColor(1, 1, 0)
    for i, Ia in ipairs(InfAmmos) do
        love.graphics.draw(ammoinf, Ia.x, Ia.y, 0, 0.1, 0.1)
    end

    love.graphics.setColor(1, 1, 0)
    for i, Ia in ipairs(fastEnemies) do
        love.graphics.draw(Ia.image, Ia.x, Ia.y, 0, 2, 2)
    end

    love.graphics.setColor(1, 1, 0)
    for i, Ia in ipairs(SpeedUp) do
        love.graphics.draw(speedpower, Ia.x, Ia.y, 0, 2, 2)
    end

    -- HUD
    love.graphics.setColor(0, 0 , 0)
    love.graphics.print("Score: " .. score, 10, 10, 0, 2, 2)
    love.graphics.print("Health: " .. playerhealth, 10, 40, 0, 2, 2)
    love.graphics.print("Ammo: " .. ammo, 10, 70, 0, 2, 2)

    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)
    if gamestate == "start" or gamestate == "gameover" then return end

    timer11 = score
    if timer11 >= 300 and bossdead == false then
        bossdead = true
        for ei = #enemies, 1, -1 do
            table.remove(enemies, ei)
        end
        spawnBoss()
    end

    if timer7 > 0 then timer7 = timer7 - 1 end
    if timer7 == 0 then
        ammo = 100
        timer7 = -1
    end

    if timer10 > 0 then timer10 = timer10 - 1 end
    if timer10 == 0 then
        speedup = false
        timer10 = -1
    end

    -- Health spawn timer
    if timer5 > 300 then
        spwnhealth()
        timer5 = 0
        playerhealth = playerhealth + 1
    end
    timer5 = timer5 + 1

    if timer9 > 1000 then
        spawnSpeed()
        timer9 = 0
    end
    timer9 = timer9 + 1

    if timer8 > 150 and dev ~= 1 and bossspawn == false then
        spawnFastEnemy()
        timer8 = 0
    end
    timer8 = timer8 + 1

    if timer6 > 1000 then
        spawninfAmmo()
        timer6 = 0
    end
    timer6 = timer6 + 1

    -- Ammo regeneration
    if timer4 > 300 then
        ammo = ammo + 15
        timer4 = 0
    end
    timer4 = timer4 + 1

    mx, my = love.mouse.getPosition()

    -- Enemy spawn timer
    if timer > 15 and dev ~= 1 and bossspawn == false then
        spawnEnemy()
        timer = 0
    end


    timer = timer + 1

    -- Collect health pickups
    for _, h in ipairs(healths) do
        local dx, dy = playerx - h.x, playery - h.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 35 then
            playerhealth = playerhealth + 10
            h.x, h.y = 100000, 100000
        end
    end

    for _, h in ipairs(InfAmmos) do
        local dx, dy = playerx - h.x, playery - h.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 35 then
            ammo = 100000000000
            timer7 = 1200
            h.x, h.y = 100000, 100000
        end
    end

    for i, h in ipairs(SpeedUp) do
        local dx, dy = playerx - h.x, playery - h.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 35 then
            speedup = true
            timer10 = 1200
            h.x, h.y = 100000, 100000
        end
    end

    -- Movement
    if speedup == true then
        speed = 400 * dt
    else
        speed = 200 * dt
    end
    if love.keyboard.isDown("w") then playery = playery - speed end
    if love.keyboard.isDown("s") then playery = playery + speed end
    if love.keyboard.isDown("a") then playerx = playerx - speed end
    if love.keyboard.isDown("d") then playerx = playerx + speed end

    -- Prevent player from moving outside the window
    local playerRadius = 20  -- roughly matches your tux image scaled by 2
    if playerx < playerRadius then playerx = playerRadius end
    if playerx > width - playerRadius then playerx = width - playerRadius end
    if playery < playerRadius then playery = playerRadius end
    if playery > height - playerRadius then playery = height - playerRadius end


    -- Developer mode
    if love.keyboard.isDown("k") then dev = 1 end

    -- Shooting
    if love.mouse.isDown(1) and timer3 > 10 and ammo > 0 then
        spawnBulletsWithSpread()
        ammo = ammo - 5
        timer3 = 0
    end
    timer3 = timer3 + 1

    -- Enemy behaviour
    for _, e in ipairs(enemies) do
        local dx, dy = playerx - e.x, playery - e.y
        local dist = math.sqrt(dx * dx + dy * dy)
        e.x = e.x + (dx / dist) * e.speed * dt
        e.y = e.y + (dy / dist) * e.speed * dt

        if timer2 > 10 then
            if dist < collisionDist then
                playerhealth = playerhealth - 8
            end
            timer2 = 0
        end
        timer2 = timer2 + 1
    end

    for _, fe in ipairs(fastEnemies) do
        local dx, dy = playerx - fe.x, playery - fe.y
        local dist = math.sqrt(dx * dx + dy * dy)
        fe.x = fe.x + (dx / dist) * fe.speed * dt
        fe.y = fe.y + (dy / dist) * fe.speed * dt

        if timer8 > 10 then
            if dist < collisionDist then
                playerhealth = playerhealth - 16
            end
            timer8 = 0
        end
        timer8 = timer8 + 1
    end

    if bossspawn == true then
        local dx, dy = playerx - boss.x, playery - boss.y
        local dist = math.sqrt(dx * dx + dy * dy)
        boss.x = boss.x + (dx / dist) * boss.speed * dt
        boss.y = boss.y + (dy / dist) * boss.speed * dt

        if timer12 > 10 then
            if dist < collisionDist then
                playerhealth = playerhealth - 50
            end
            timer12 = 0
        end
        timer12 = timer12 + 1
    end

        -- Bullet update and collision
    for bi = #bullets, 1, -1 do
        local b = bullets[bi]
        b.x = b.x + b.vx * b.speed * dt
        b.y = b.y + b.vy * b.speed * dt

        -- Check collision with regular enemies
        for ei = #enemies, 1, -1 do
            local e = enemies[ei]
            local dx, dy = e.x - b.x, e.y - b.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < 15 then
                table.remove(enemies, ei)
                table.remove(bullets, bi)
                score = score + 1
                break
            end
        end

        -- Check collision with fast enemies
        for fei = #fastEnemies, 1, -1 do
            local fe = fastEnemies[fei]
            local dx, dy = fe.x - b.x, fe.y - b.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < 15 then
                table.remove(fastEnemies, fei)
                table.remove(bullets, bi)
                score = score + 1
                break
            end
        end

        if bossspawn == true then
            local dx, dy = boss.x - b.x, boss.y - b.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < 40 then
                table.remove(bullets, bi)
                boss.health = boss.health - 1
                if boss.health <= 0 then
                    bossspawn = false
                    bossdead = true
                    boss.x = 10000000
                    boss.y = 10000000
                end
            end
        end

        -- Remove bullets off-screen
        if b.x < 0 or b.x > width or b.y < 0 or b.y > height then
            table.remove(bullets, bi)
        end
    end

    -- Death condition
    if playerhealth <= 0 then
        gamestate = "gameover"
    end
end

-- Restart / Start controls
function love.keypressed(key)
    if gamestate == "start" and key == "space" then
        gamestate = "play"
    elseif gamestate == "gameover" then
        if key == "r" then
            love.load()
            gamestate = "play"
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

function spawnEnemy()
    local radius = 2000
    local angle = math.random() * math.pi * 2
    local num = math.random(2)
    if num == 1 then
        img = grass
    else 
        img = soap
    end
    local enemy = {
        image = img,
        x = playerx + math.cos(angle) * radius,
        y = playery + math.sin(angle) * radius,
        speed = 200
    }
    table.insert(enemies, enemy)
end

function spawnFastEnemy()
    local radius = 2000
    local angle = math.random() * math.pi * 2
    local fastenemy = {
        image = soap,
        x = playerx + math.cos(angle) * radius,
        y = playery + math.sin(angle) * radius,
        speed = 400
    }
    table.insert(fastEnemies, fastenemy)
end

function spawnBoss()
    local radius = 1000
    local angle = math.random() * math.pi * 2
    bossspawn = true
    boss = {
        image = sam,
        x = playerx + math.cos(angle) * radius,
        y = playery + math.sin(angle) * radius,
        speed = 300,
        health = 50
    }
end

function spawnBulletsWithSpread()
    local mx, my = love.mouse.getPosition()
    local dx, dy = mx - playerx, my - playery
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist == 0 then return end

    local baseAngle = math.atan2(dy, dx)
    for i = 1, 5 do
        local spread = (math.random() - 0.5) * math.rad(20)
        local angle = baseAngle + spread
        local bullet = {
            x = playerx + 10,
            y = playery + 10,
            vx = math.cos(angle),
            vy = math.sin(angle),
            speed = 400
        }
        table.insert(bullets, bullet)
    end
end

function spwnhealth()
    local hx = width * love.math.random()
    local hy = height * love.math.random()
    local health = { x = hx, y = hy }
    table.insert(healths, health)
end

function spawninfAmmo()
    local ax = width * love.math.random()
    local ay = height * love.math.random()
    local InfAmmo = { x = ax, y = ay }
    table.insert(InfAmmos, InfAmmo)
end

function spawnSpeed()
    local sx = width * love.math.random()
    local sy = height * love.math.random()
    local Speed = { x = sx, y = sy }
    table.insert(SpeedUp, Speed)
end
