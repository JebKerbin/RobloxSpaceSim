local ServerRunner = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Load core modules
local KerbinGravity = require(ReplicatedStorage.Modules.Physics.KerbinGravity)
local EnvironmentalHazards = require(ReplicatedStorage.Modules.Environment.EnvironmentalHazards)
local WeatherSystem = require(ReplicatedStorage.Modules.Environment.WeatherSystem)

function ServerRunner.initialize()
    -- Initialize core systems
    KerbinGravity.initialize()
    local hazards = EnvironmentalHazards.new()
    local weather = WeatherSystem.new("Kerbin")

    -- Create periodic task for autosaving and state management
    local lastUpdate = tick()
    RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate >= 30 then -- Run every 30 seconds
            -- Perform state saving or any periodic tasks here
            lastUpdate = currentTime

            -- Execute GitHub sync process using os.execute
            if RunService:IsStudio() then
                pcall(function()
                    os.execute("git add . && git commit -m 'Auto-sync: Game state update' && git push")
                end)
            end
        end
    end)

    print("Server systems initialized successfully")
end

return ServerRunner