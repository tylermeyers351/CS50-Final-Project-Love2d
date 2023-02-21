Hero = Class{}

function Hero:init()
    self.x = 50
    self.y = VIRTUAL_HEIGHT / 2
    self.width = 10
    self.speed = 150
end

function Hero:update(dt)
    if love.keyboard.isDown("w") and self.y - self.width > 0 then
        self.y = self.y - self.speed*dt
    end
    if love.keyboard.isDown("s") and self.y < love.graphics.getHeight() then
        self.y = self.y + self.speed*dt
    end
end

function Hero:render()
    --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky ) 
    -- add more to go down
    love.graphics.draw(sprites.survivor, self.x, self.y, nil, 0.15, 0.15, 100 + 70, 103.5 + 62)
end