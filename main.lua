--[[
    Zombie Invasion 2nite
    Author: Tyler Meyers
]]

require 'src/Dependencies'

function love.load()
    -- love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Zombie Invasion 2nite')
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('libraries/font.ttf', 8)
    largeFont = love.graphics.newFont('libraries/font.ttf', 16)
    scoreFont = love.graphics.newFont('libraries/font.ttf', 32)
    love.graphics.setFont(largeFont)

    gSounds = {
        ['chain'] = love.audio.newSource('sounds/chain.wav', 'static'),
        ['laugh'] = love.audio.newSource('sounds/laugh.wav', 'static'),
        ['gunshot'] = love.audio.newSource('sounds/gunshot.ogg', 'static'),
        ['distantshooting'] = love.audio.newSource('sounds/distantshooting.mp3', 'static'),
        ['reload'] = love.audio.newSource('sounds/reload.wav', 'static'),
        ['zombies'] = love.audio.newSource('sounds/zombies.wav', 'static'),
        ['splatter'] = love.audio.newSource('sounds/splatter.wav', 'static'),
        ['empty'] = love.audio.newSource('sounds/empty shot.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/piano.wav', 'static')
    }

    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.survivor = love.graphics.newImage('sprites/survivor-idle_rifle_9.png')
    sprites.zombie = love.graphics.newImage('sprites/skeleton-move_4.png')
    sprites.bullet = love.graphics.newImage('sprites/shotThin.png')
    sprites.blood = love.graphics.newImage('sprites/blood.png')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- game characters
    hero = Hero()
    bullets = {}
    enemies = {}
    splatters = {}

    -- game features
    score = 0
    ammo = 20
    ammoCap = ammo
    reserveAmmo = 100

    --timers
    spawnTimer = 2
    spawnDelay = 1
    speechTimer = 0
    soundTimer = 0

    gameState = 1

    -- play music
    gSounds['music']:play()
    gSounds['music']:setLooping(true)


    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    hero:update(dt)
    
    -- update logic for each bullet in bullets table (changing x, and despawning after past screen)
    for i, b in ipairs(bullets) do
        b.x = b.x + b.speed * dt
    end
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.x > (VIRTUAL_WIDTH + 100) then
            table.remove(bullets, i)
        end
    end

    -- update enemy movement
    if gameState == 2 then
        for i, e in ipairs(enemies) do
            e.x = e.x + (math.cos( zombiePlayerAngle(e) ) * e.speed * dt)
            e.y = e.y + (math.sin( zombiePlayerAngle(e) ) * e.speed * dt)
        end
    elseif gameState == 3 then
        for i, e in ipairs(enemies) do
            e.x = e.x - e.speed * dt
        end
    end


    if gameState == 2 then
        --spawn enemies
        spawnTimer = spawnTimer + dt
        if spawnTimer > spawnDelay then
            enemy = Enemy()
            table.insert(enemies, enemy)
            spawnTimer = 0
            spawnDelay = spawnDelay * .99
        end
    end

    --collision detection of enemies/bullets
    for i, e in ipairs(enemies) do
        for i, b in ipairs(bullets) do
            if distance(b.x, b.y, e.x, e.y) < 15 then
                b.dead = true
                e.dead = true
                score = score + 1
                splatter = {}
                splatter.x = e.x 
                splatter.y = e.y
                table.insert(splatters, splatter)
                gSounds['splatter']:setVolume(5.0)
                if gSounds['splatter']:isPlaying() then
                    gSounds['splatter']:stop()
                    gSounds['splatter']:play()
                else
                    gSounds['splatter']:play()
                end
            end
        end
    end

    -- remove enemies and bullets that collided
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end
    for i=#enemies, 1, -1 do
        local e = enemies[i]
        if e.dead == true then
            table.remove(enemies, i)
        end
        if e.x < -15 then
            table.remove(enemies, i)
        end
    end

    -- right here bitch
    for i, e in ipairs(enemies) do
        if distance(hero.x, hero.y, e.x, e.y) < 15 then
            --for i=#enemies, 1, -1 do
                --table.remove(enemies, i)
            --end
            gameState = 3
        end
    end
            

    if gameState == 2 then
        if reserveAmmo == 0 then
            speechTimer = speechTimer + dt
        end

        soundTimer = soundTimer + dt
        if soundTimer > 3 then
            gSounds['chain']:setVolume(0.3)
            gSounds['chain']:play()
        end
    end

    distantshooting(1, 2)
    distantshooting(8, 9)
    distantshooting(19, 20)
    distantshooting(22, 23)
    distantshooting(30, 31)
    distantshooting(30, 31)

    if gameState == 2 then
        gSounds['zombies']:setVolume(0.12)
        gSounds['zombies']:play()
        gSounds['zombies']:setLooping(true)
    end

end

function love.draw()
    push:start()

    love.graphics.setColor(200/255, 150/255, 150/255, 255/255)
    love.graphics.draw(sprites.background, -50, -220, nil, 1.05, 1.05)
    love.graphics.setColor(255, 255, 255, 255)
    
    -- print UI
    displayFPS()
    love.graphics.print('Ammo: ' .. tostring(ammo) .. ' / ' ..  tostring(reserveAmmo), 10, 20)
    love.graphics.print('Killed: ' .. tostring(score), 10, 30)

    --draw hero and draw each bullet
    hero:render()
    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, 1.5708, 0.20, 0.20, 12, 50)
    end 

    for i, s in ipairs(splatters) do
        love.graphics.draw(sprites.blood, s.x, s.y, nil, 0.1, 0.1, 300, 100)
    end

    if gameState == 2 then
        for i, e in ipairs(enemies) do
            --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
            love.graphics.draw(sprites.zombie, e.x, e.y, zombiePlayerAngle(e), 0.13, 0.13, nil, 311/2)
        end
    else
        for i, e in ipairs(enemies) do
            --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
            love.graphics.draw(sprites.zombie, e.x, e.y, -3.14, 0.13, 0.13, nil, 311/2)
        end
    end

    -- dialogue
    if reserveAmmo == 0 then
        if speechTimer < 2 then
            love.graphics.print('Low on ammo!', hero.x  + 10, hero.y - 22)
        elseif speechTimer < 4 then
            love.graphics.print('There\'s too many!', hero.x  + 10, hero.y - 22)
        end
    end

    love.graphics.printf('[r] for reload', VIRTUAL_WIDTH - 110, 10, 100, 'right')
    love.graphics.printf('[w] for up', VIRTUAL_WIDTH - 110, 20, 100, 'right')
    love.graphics.printf('[s] for down', VIRTUAL_WIDTH - 110, 30, 100, 'right')
    love.graphics.printf('[space] to shoot', VIRTUAL_WIDTH - 110, 40, 100, 'right')

    if gameState == 1 then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Zombies are everywhere, you\'re group needs you to hold them off as long as possible', 207, 150, 150, 'center')
        love.graphics.printf('Press spacebar to begin', 207, 190, 150, 'center')
    end

    if gameState == 3 then
        love.graphics.setFont(smallFont)
        love.graphics.printf('You killed '.. tostring(score) .. ' zombies, before they got to your friends', 207, 155, 150, 'center')
    end

    push:finish()
end


-- keyboard inputs
function love.keypressed( key )
    if gameState == 2 then
        if key == "space" and ammo > 0 then
            if gSounds['gunshot']:isPlaying() then
                gSounds['gunshot']:stop()
                gSounds['gunshot']:play()
                bullet = Bullet(hero.x, hero.y)
                table.insert(bullets, bullet)
                ammo = ammo - 1
            else
                gSounds['gunshot']:play()
                bullet = Bullet(hero.x, hero.y)
                table.insert(bullets, bullet)
                ammo = ammo - 1
            end
        elseif key == "space" and ammo == 0 then
            if gSounds['empty']:isPlaying() then
                gSounds['empty']:stop()
                gSounds['empty']:play()
            else
                gSounds['empty']:play()
            end
        end
    elseif gameState == 1 then
        if key == "space" then
            gameState = 2
            gSounds['laugh']:play()
        end
    end

    -- reloading logic
    if key == "r" and ammo < ammoCap and reserveAmmo > ammoCap then
        gSounds['reload']:play()
        difference = ammoCap - ammo
        ammo = ammoCap
        reserveAmmo = reserveAmmo - difference
    elseif key == "r" and ammo < ammoCap and reserveAmmo > 0 then
        gSounds['reload']:play()
        if (ammo + reserveAmmo) >= ammoCap then
            difference = ammoCap - ammo
            ammo = ammoCap
            reserveAmmo = reserveAmmo - difference
        elseif (ammo + reserveAmmo) < ammoCap then
            ammo = ammo + reserveAmmo
            reserveAmmo = 0
        end
    end

    --quitting logic
    if key == 'escape' then
        love.event.quit()
    end
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2) 
end

function distantshooting(num1, num2)
    if soundTimer > num1 and soundTimer < num2 then
        gSounds['distantshooting']:setVolume(2)
        gSounds['distantshooting']:play()
    end
end

function zombiePlayerAngle(enemy)
    return math.atan2( hero.y - enemy.y, hero.x - enemy.x )
end