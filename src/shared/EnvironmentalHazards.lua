local EnvironmentalHazards = {}

-- Constants for asteroid generation
local ASTEROID_CONFIG = {
    MIN_SIZE = 10, -- studs
    MAX_SIZE = 50,
    MIN_SPEED = 5,
    MAX_SPEED = 20,
    SPAWN_RADIUS = 2000, -- Distance from planet center
    MAX_ASTEROIDS = 50
}

-- Debris field configurations for different regions
local DEBRIS_FIELDS = {
    LowOrbit = {
        height = {min = 100, max = 500},
        density = 0.5, -- particles per cubic stud
        damage = 0.2 -- damage per hit
    },
    AsteroidBelt = {
        height = {min = 1000, max = 2000},
        density = 2.0,
        damage = 0.8
    }
}

function EnvironmentalHazards.new()
    local self = {}
    self.asteroids = {}
    self.debris = {}
    
    function self:generateAsteroid()
        local asteroid = Instance.new("Part")
        -- Random size between MIN_SIZE and MAX_SIZE
        local size = ASTEROID_CONFIG.MIN_SIZE + 
            math.random() * (ASTEROID_CONFIG.MAX_SIZE - ASTEROID_CONFIG.MIN_SIZE)
        
        asteroid.Size = Vector3.new(size, size, size)
        asteroid.Shape = Enum.PartType.Ball
        asteroid.Material = Enum.Material.Rock
        asteroid.Color = Color3.fromRGB(120, 120, 120)
        
        -- Random position in orbit
        local angle = math.random() * math.pi * 2
        local radius = ASTEROID_CONFIG.SPAWN_RADIUS
        asteroid.Position = Vector3.new(
            math.cos(angle) * radius,
            math.sin(angle) * radius,
            0
        )
        
        -- Add velocity for orbital movement
        local speed = ASTEROID_CONFIG.MIN_SPEED + 
            math.random() * (ASTEROID_CONFIG.MAX_SPEED - ASTEROID_CONFIG.MIN_SPEED)
        asteroid.Velocity = Vector3.new(
            -math.sin(angle) * speed,
            math.cos(angle) * speed,
            0
        )
        
        -- Collision handling
        asteroid.Touched:Connect(function(hit)
            self:handleCollision(asteroid, hit)
        end)
        
        table.insert(self.asteroids, asteroid)
        asteroid.Parent = workspace
        return asteroid
    end
    
    function self:handleCollision(asteroid, hit)
        -- Check if hit object is a rocket part
        local isRocketPart = hit:FindFirstAncestor("Rocket")
        if isRocketPart then
            -- Calculate damage based on relative velocity and mass
            local relativeVelocity = (asteroid.Velocity - hit.Velocity).Magnitude
            local damage = relativeVelocity * asteroid:GetMass() / 1000
            
            -- Emit explosion effect
            local explosion = Instance.new("Explosion")
            explosion.Position = asteroid.Position
            explosion.BlastRadius = asteroid.Size.X
            explosion.BlastPressure = damage
            explosion.Parent = workspace
            
            -- Notify mission control of impact
            if game:GetService("ReplicatedStorage"):FindFirstChild("Events") then
                game:GetService("ReplicatedStorage").Events.AsteroidImpact:FireServer(damage)
            end
        end
    end
    
    function self:generateDebrisField(region)
        local config = DEBRIS_FIELDS[region]
        if not config then return end
        
        -- Create debris particles
        local debris = Instance.new("ParticleEmitter")
        debris.Rate = 50 * config.density
        debris.Lifetime = NumberRange.new(5, 10)
        debris.Speed = NumberRange.new(10, 30)
        debris.Size = NumberRange.new(0.1, 0.5)
        debris.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180))
        
        -- Position debris field
        local field = Instance.new("Part")
        field.Anchored = true
        field.Transparency = 1
        field.CanCollide = false
        field.Position = Vector3.new(0, (config.height.min + config.height.max) / 2, 0)
        field.Size = Vector3.new(100, config.height.max - config.height.min, 100)
        
        debris.Parent = field
        field.Parent = workspace
        
        table.insert(self.debris, field)
        return field
    end
    
    -- Initialize system
    local function init()
        -- Generate initial asteroids
        for i = 1, ASTEROID_CONFIG.MAX_ASTEROIDS do
            self:generateAsteroid()
        end
        
        -- Create debris fields
        for region, _ in pairs(DEBRIS_FIELDS) do
            self:generateDebrisField(region)
        end
        
        -- Update loop for asteroid movement
        game:GetService("RunService").Heartbeat:Connect(function(dt)
            for _, asteroid in ipairs(self.asteroids) do
                -- Apply simple orbital physics
                local pos = asteroid.Position
                local dist = pos.Magnitude
                local gravityStrength = 9.81 * (600000 / dist) ^ 2
                local gravityDir = -pos.Unit
                
                asteroid.Velocity = asteroid.Velocity + gravityDir * gravityStrength * dt
            end
        end)
    end
    
    init()
    return self
end

return EnvironmentalHazards
