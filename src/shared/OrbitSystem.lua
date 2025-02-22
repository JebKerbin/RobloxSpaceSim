local OrbitSystem = {}

local PhysicsConstants = require(script.Parent.PhysicsConstants)

-- Orbital parameters
local function calculateOrbitalVelocity(altitude, mass)
    local r = altitude + PhysicsConstants.KERBIN_RADIUS
    return math.sqrt((PhysicsConstants.G * mass) / r)
end

function OrbitSystem.new()
    local self = {}
    
    self.position = Vector3.new(0, 0, 0)
    self.velocity = Vector3.new(0, 0, 0)
    self.acceleration = Vector3.new(0, 0, 0)
    
    function self:updateOrbit(deltaTime)
        -- Simple 2D orbital mechanics
        local radius = self.position.Magnitude
        local gravityDirection = -self.position.Unit
        
        -- Calculate gravitational acceleration
        local gravityStrength = PhysicsConstants.G * PhysicsConstants.KERBIN_MASS / (radius * radius)
        self.acceleration = gravityDirection * gravityStrength
        
        -- Update velocity and position using Euler integration
        self.velocity = self.velocity + self.acceleration * deltaTime
        self.position = self.position + self.velocity * deltaTime
        
        return self.position
    end
    
    function self:setInitialConditions(pos, vel)
        self.position = pos
        self.velocity = vel
    end
    
    function self:calculateOrbitalElements()
        local r = self.position.Magnitude
        local v = self.velocity.Magnitude
        local specificEnergy = (v * v / 2) - (PhysicsConstants.G * PhysicsConstants.KERBIN_MASS / r)
        
        -- Calculate semi-major axis
        local semiMajorAxis = -PhysicsConstants.G * PhysicsConstants.KERBIN_MASS / (2 * specificEnergy)
        
        return {
            semiMajorAxis = semiMajorAxis,
            period = 2 * math.pi * math.sqrt(math.pow(semiMajorAxis, 3) / 
                (PhysicsConstants.G * PhysicsConstants.KERBIN_MASS))
        }
    end
    
    return self
end

return OrbitSystem
