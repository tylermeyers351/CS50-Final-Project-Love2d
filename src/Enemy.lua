Enemy = Class{}

function Enemy:init()
    self.x = VIRTUAL_WIDTH + 50
    self.y = love.math.random(50, VIRTUAL_HEIGHT - 50)
    self.width = 8

    self.speed = math.random(25, 85)
    self.dead = false
end