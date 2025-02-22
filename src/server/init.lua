-- Load ServerRunner
local ServerRunner = require(script.Parent.ServerRunner)

-- Initialize RemoteEvents
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Remotes.Events

-- Create RemoteEvents for various game events
local remoteEvents = {
    "EngineFailure",
    "ReentryFailure",
    "AsteroidImpact",
    "MissionComplete",
    "StageActivated",
    "WeatherChanged"
}

for _, eventName in ipairs(remoteEvents) do
    local event = Instance.new("RemoteEvent")
    event.Name = eventName
    event.Parent = Events
end

-- Load necessary modules
local KerbinGravity = require(ReplicatedStorage.Modules.Physics.KerbinGravity)
local EnvironmentalHazards = require(ReplicatedStorage.Modules.Environment.EnvironmentalHazards)
local WeatherSystem = require(ReplicatedStorage.Modules.Environment.WeatherSystem)

-- Initialize server systems
ServerRunner.initialize()
KerbinGravity.initialize()
EnvironmentalHazards.new()
WeatherSystem.new("Kerbin")

print("Server initialization complete")