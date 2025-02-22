local LaunchMechanics = {}

local PhysicsConstants = require(game:GetService("ReplicatedStorage").Modules.Physics.PhysicsConstants)
local WeatherSystem = require(game:GetService("ReplicatedStorage").Modules.Environment.WeatherSystem)

-- Constants for engine performance
local ENGINE_CONSTANTS = {
    ATMOSPHERE_CURVE = {
        [0] = 1.0,    -- Vacuum performance
        [0.5] = 0.85, -- Mid-atmosphere
        [1.0] = 0.7   -- Sea level
    },
    MAX_TEMPERATURE = 1200, -- Kelvin
    COOLING_RATE = 50 -- Kelvin per second
}

function LaunchMechanics.new(rocket)
    local self = {}
    self.rocket = rocket
    self.currentStage = 1
    self.engineTemp = 293 -- Start at room temperature (20°C)
    self.throttle = 0
    
    -- Initialize stage configuration
    self.stages = {}
    for _, part in ipairs(rocket.parts) do
        if part:FindFirstChild("Configuration") then
            local config = part.Configuration
            if config:FindFirstChild("stage") then
                local stageNum = config.stage.Value
                self.stages[stageNum] = self.stages[stageNum] or {
                    engines = {},
                    fuelTanks = {},
                    decouplers = {}
                }
                
                if config:FindFirstChild("thrust") then
                    table.insert(self.stages[stageNum].engines, part)
                elseif config:FindFirstChild("fuelCapacity") then
                    table.insert(self.stages[stageNum].fuelTanks, part)
                elseif config:FindFirstChild("decoupleForce") then
                    table.insert(self.stages[stageNum].decouplers, part)
                end
            end
        end
    end
    
    function self:calculateAtmosphericDensity(altitude)
        local pressure = PhysicsConstants.SEA_LEVEL_PRESSURE * 
            math.exp(-altitude / PhysicsConstants.ATM_SCALE_HEIGHT)
        return pressure / PhysicsConstants.SEA_LEVEL_PRESSURE
    end
    
    function self:calculateThrust(engine, atmosphericDensity)
        local config = engine.Configuration
        local baseThrust = config.thrust.Value
        
        -- Apply atmospheric performance curve
        local atmPerformance = ENGINE_CONSTANTS.ATMOSPHERE_CURVE[1]
        for density, performance in pairs(ENGINE_CONSTANTS.ATMOSPHERE_CURVE) do
            if math.abs(atmosphericDensity - density) < 0.1 then
                atmPerformance = performance
                break
            end
        end
        
        -- Apply throttle and temperature effects
        local tempEffect = 1 - math.max(0, (self.engineTemp - ENGINE_CONSTANTS.MAX_TEMPERATURE) / 500)
        return baseThrust * atmPerformance * self.throttle * tempEffect
    end
    
    function self:updateEngineTemperature(dt)
        -- Temperature increases with thrust
        local heatGeneration = self.throttle * 100 -- Kelvin per second at full throttle
        self.engineTemp = self.engineTemp + (heatGeneration * dt)
        
        -- Cooling effect
        local cooling = ENGINE_CONSTANTS.COOLING_RATE * dt
        self.engineTemp = math.max(293, self.engineTemp - cooling)
        
        -- Check for engine failure
        if self.engineTemp > ENGINE_CONSTANTS.MAX_TEMPERATURE then
            self:handleEngineFailure()
        end
    end
    
    function self:handleEngineFailure()
        -- Create explosion effect
        local explosion = Instance.new("Explosion")
        explosion.Position = self.rocket.parts[1].Position
        explosion.BlastRadius = 10
        explosion.BlastPressure = 500000
        explosion.Parent = workspace
        
        -- Disable engines
        self.throttle = 0
        
        -- Notify mission control
        if game:GetService("ReplicatedStorage"):FindFirstChild("Events") then
            game:GetService("ReplicatedStorage").Events.EngineFailure:FireServer()
        end
    end
    
    function self:activateStage()
        local stage = self.stages[self.currentStage]
        if not stage then return end
        
        -- Activate engines
        for _, engine in ipairs(stage.engines) do
            engine.CanCollide = true
            engine.Anchored = false
        end
        
        -- Decouple previous stage if it exists
        if self.currentStage > 1 and self.stages[self.currentStage - 1] then
            for _, decoupler in ipairs(self.stages[self.currentStage - 1].decouplers) do
                local force = decoupler.Configuration.decoupleForce.Value
                local direction = decoupler.CFrame.LookVector
                
                -- Apply decouple force
                for _, part in ipairs(self.stages[self.currentStage - 1].engines) do
                    part.Velocity = part.Velocity + direction * force
                    -- Break welds
                    for _, weld in ipairs(part:GetChildren()) do
                        if weld:IsA("WeldConstraint") then
                            weld:Destroy()
                        end
                    end
                end
            end
        end
        
        self.currentStage = self.currentStage + 1
    end
    
    -- Update loop
    game:GetService("RunService").Heartbeat:Connect(function(dt)
        if self.throttle > 0 then
            local altitude = self.rocket.parts[1].Position.Y
            local atmosphericDensity = self:calculateAtmosphericDensity(altitude)
            
            -- Update each active engine
            for stageNum = 1, self.currentStage do
                local stage = self.stages[stageNum]
                if stage then
                    for _, engine in ipairs(stage.engines) do
                        local thrust = self:calculateThrust(engine, atmosphericDensity)
                        local thrustForce = engine.CFrame.LookVector * thrust
                        engine.Velocity = engine.Velocity + thrustForce * dt / engine:GetMass()
                    end
                end
            end
            
            self:updateEngineTemperature(dt)
        end
    end)
    
    return self
end

return LaunchMechanics