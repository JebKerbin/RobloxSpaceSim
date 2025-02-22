local ReentrySystem = {}

local PhysicsConstants = require(game:GetService("ReplicatedStorage").Modules.Physics.PhysicsConstants)

-- Constants for reentry calculations
local REENTRY_CONSTANTS = {
    CRITICAL_TEMPERATURE = 1600, -- Kelvin
    HEAT_SHIELD_ABLATION_RATE = 0.1, -- per second at max temp
    PARACHUTE_DEPLOY_HEIGHT = 1000, -- meters
    PARACHUTE_SAFE_VELOCITY = 300, -- m/s
    DRAG_COEFFICIENT = 1.5
}

function ReentrySystem.new(spacecraft)
    local self = {}
    self.spacecraft = spacecraft
    self.heatShields = {}
    self.parachutes = {}
    
    -- Find heat shields and parachutes
    for _, part in ipairs(spacecraft.parts) do
        if part:FindFirstChild("Configuration") then
            local config = part.Configuration
            if config:FindFirstChild("heatShieldStrength") then
                table.insert(self.heatShields, part)
            elseif config:FindFirstChild("parachuteArea") then
                table.insert(self.parachutes, part)
            end
        end
    end
    
    function self:calculateReentryHeating(velocity, atmosphericDensity)
        -- Simple atmospheric heating calculation
        -- Based on velocity squared and atmospheric density
        return 0.5 * atmosphericDensity * velocity.Magnitude ^ 2 * REENTRY_CONSTANTS.DRAG_COEFFICIENT
    end
    
    function self:applyHeatDamage(heatRate, dt)
        local totalShieldStrength = 0
        local failedShields = {}
        
        -- Calculate heat distribution across shields
        for _, shield in ipairs(self.heatShields) do
            local strength = shield.Configuration.heatShieldStrength.Value
            if strength > 0 then
                totalShieldStrength = totalShieldStrength + strength
            else
                table.insert(failedShields, shield)
            end
        end
        
        -- Apply heat damage to shields
        if totalShieldStrength > 0 then
            local heatPerShield = heatRate / #self.heatShields
            for _, shield in ipairs(self.heatShields) do
                local strength = shield.Configuration.heatShieldStrength.Value
                if strength > 0 then
                    -- Ablate heat shield
                    local ablationRate = heatPerShield * REENTRY_CONSTANTS.HEAT_SHIELD_ABLATION_RATE
                    shield.Configuration.heatShieldStrength.Value = 
                        math.max(0, strength - ablationRate * dt)
                    
                    -- Create ablation effect
                    local ablation = Instance.new("ParticleEmitter")
                    ablation.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
                    ablation.Size = NumberSequence.new(0.5)
                    ablation.Lifetime = NumberRange.new(0.5, 1)
                    ablation.Rate = 50 * (heatPerShield / REENTRY_CONSTANTS.CRITICAL_TEMPERATURE)
                    ablation.Parent = shield
                end
            end
        else
            -- All heat shields failed
            self:handleReentryFailure()
        end
    end
    
    function self:handleReentryFailure()
        -- Create explosion/breakup effect
        local explosion = Instance.new("Explosion")
        explosion.Position = self.spacecraft.parts[1].Position
        explosion.BlastRadius = 20
        explosion.BlastPressure = 1000000
        explosion.Parent = workspace
        
        -- Notify mission control
        if game:GetService("ReplicatedStorage"):FindFirstChild("Events") then
            game:GetService("ReplicatedStorage").Events.ReentryFailure:FireServer()
        end
    end
    
    function self:deployParachutes()
        for _, parachute in ipairs(self.parachutes) do
            if not parachute:FindFirstChild("Deployed") then
                -- Create parachute model
                local canopy = Instance.new("Part")
                canopy.Shape = Enum.PartType.Cylinder
                canopy.Size = Vector3.new(20, 1, 20)
                canopy.CFrame = parachute.CFrame * CFrame.new(0, 10, 0)
                canopy.Anchored = false
                canopy.CanCollide = true
                
                -- Create ropes
                local rope = Instance.new("RopeConstraint")
                rope.Attachment0 = Instance.new("Attachment", parachute)
                rope.Attachment1 = Instance.new("Attachment", canopy)
                rope.Length = 10
                rope.Parent = parachute
                
                -- Mark as deployed
                local deployed = Instance.new("BoolValue")
                deployed.Name = "Deployed"
                deployed.Parent = parachute
                
                -- Create deployment effect
                local deployEffect = Instance.new("ParticleEmitter")
                deployEffect.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                deployEffect.Size = NumberSequence.new(1)
                deployEffect.Lifetime = NumberRange.new(1, 2)
                deployEffect.Rate = 100
                deployEffect.Parent = canopy
                
                canopy.Parent = workspace
            end
        end
    end
    
    -- Update loop
    game:GetService("RunService").Heartbeat:Connect(function(dt)
        local primaryPart = self.spacecraft.parts[1]
        local altitude = primaryPart.Position.Y * PhysicsConstants.STUDS_TO_METERS
        local velocity = primaryPart.Velocity
        
        -- Calculate atmospheric density
        local atmosphericDensity = PhysicsConstants.SEA_LEVEL_PRESSURE * 
            math.exp(-altitude / PhysicsConstants.ATM_SCALE_HEIGHT)
        
        -- Calculate reentry heating
        local heatRate = self:calculateReentryHeating(velocity, atmosphericDensity)
        if heatRate > 0 then
            self:applyHeatDamage(heatRate, dt)
        end
        
        -- Check parachute deployment conditions
        if altitude < REENTRY_CONSTANTS.PARACHUTE_DEPLOY_HEIGHT and
           velocity.Magnitude < REENTRY_CONSTANTS.PARACHUTE_SAFE_VELOCITY then
            self:deployParachutes()
        end
    end)
    
    return self
end

return ReentrySystem