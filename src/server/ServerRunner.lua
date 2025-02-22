local ServerRunner = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Load core modules
local KerbinGravity = require(ReplicatedStorage.Modules.Physics.KerbinGravity)
local EnvironmentalHazards = require(ReplicatedStorage.Modules.Environment.EnvironmentalHazards)
local WeatherSystem = require(ReplicatedStorage.Modules.Environment.WeatherSystem)

function ServerRunner.initialize()
    print("Starting server initialization...")

    -- Initialize core systems
    local success, err = pcall(function()
        print("Initializing KerbinGravity system...")
        KerbinGravity.initialize()

        print("Creating EnvironmentalHazards system...")
        local hazards = EnvironmentalHazards.new()

        print("Creating WeatherSystem for Kerbin...")
        local weather = WeatherSystem.new("Kerbin")

        -- Store references to prevent garbage collection
        ServerRunner.systems = {
            hazards = hazards,
            weather = weather
        }
    end)

    if not success then
        warn("Error during system initialization:", err)
        return
    end

    -- Create periodic task for autosaving and state management
    local lastUpdate = tick()
    RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate >= 30 then -- Run every 30 seconds
            -- Execute Git sync process
            if RunService:IsStudio() then
                print("Attempting Git sync...")
                pcall(function()
                    -- Use os.execute for Git operations
                    local result = os.execute("git add . && git commit -m 'Auto-sync: Game state update' && git push")
                    if result then
                        print("Git sync successful")
                    else
                        warn("Git sync failed")
                    end
                end)
            end
            lastUpdate = currentTime
        end
    end)

    print("Server systems initialized successfully")
end

return ServerRunner