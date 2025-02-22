-- Load ServerRunner
local ServerRunner = require(script.Parent.ServerRunner)

print("Starting server initialization...")

-- Initialize RemoteEvents
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remotes folder if it doesn't exist
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    print("Creating Remotes folder...")
    Remotes = Instance.new("Folder")
    Remotes.Name = "Remotes"
    Remotes.Parent = ReplicatedStorage
end

-- Create or get Events folder
local Events = Remotes:FindFirstChild("Events")
if not Events then
    print("Creating Events folder...")
    Events = Instance.new("Folder")
    Events.Name = "Events"
    Events.Parent = Remotes
end

-- Create RemoteEvents for various game events
local remoteEvents = {
    "EngineFailure",
    "ReentryFailure",
    "AsteroidImpact",
    "MissionComplete",
    "StageActivated",
    "WeatherChanged",
    "OrbitAchieved",
    "RocketBuilt",
    "PartsConnected",
    "FuelUpdated",
    "TemperatureWarning"
}

print("Creating RemoteEvents...")
for _, eventName in ipairs(remoteEvents) do
    if not Events:FindFirstChild(eventName) then
        local event = Instance.new("RemoteEvent")
        event.Name = eventName
        event.Parent = Events
        print("Created RemoteEvent:", eventName)
    end
end

-- Load necessary modules
local KerbinGravity = require(ReplicatedStorage.Modules.Physics.KerbinGravity)
local EnvironmentalHazards = require(ReplicatedStorage.Modules.Environment.EnvironmentalHazards)
local WeatherSystem = require(ReplicatedStorage.Modules.Environment.WeatherSystem)

-- Initialize server systems
print("Initializing server systems...")
ServerRunner.initialize()
KerbinGravity.initialize()
EnvironmentalHazards.new()
WeatherSystem.new("Kerbin")

print("Server initialization complete")