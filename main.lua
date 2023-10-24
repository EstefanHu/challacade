function love.load()
    -- animatin
    anim8 = require "lib/anim8"
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- map
    sti = require 'lib/sti'
    gameMap = sti('maps/testMap.lua')

    -- camera
    camera = require 'lib/camera'
    cam = camera()

    player = {}
    player.x = 400
    player.y = 200
    player.speed = 5
    player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.left

    background = love.graphics.newImage("sprites/background.png")
end

function love.update(dt)
    local isMoving = false
    
    if love.keyboard.isDown("right") then
        isMoving = true
        player.anim = player.animations.right
        player.x = player.x + player.speed
    end
    
    if love.keyboard.isDown("left") then
        isMoving = true
        player.anim = player.animations.left
        player.x = player.x - player.speed 
    end
    
    if love.keyboard.isDown("down") then
        isMoving = true
        player.anim = player.animations.down
        player.y = player.y + player.speed
    end
    
    if love.keyboard.isDown("up") then
        isMoving = true
        player.anim = player.animations.up
        player.y = player.y - player.speed 
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end

    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end

    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["trees"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
    cam:detach()
    love.graphics.print("hello", 10, 10)
end
