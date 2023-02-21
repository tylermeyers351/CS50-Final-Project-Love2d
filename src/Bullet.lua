Bullet = Class{}

function Bullet:init(x, y)
    self.x = x
    self.y = y
    self.width = 3

    self.speed = 500
    self.dead = false
end