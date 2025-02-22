-- Remote events for client-server communication
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = {
    -- Rocket building events
    RocketUpdate = Instance.new("RemoteEvent"),
    SaveRocket = Instance.new("RemoteEvent"),
    LoadRocket = Instance.new("RemoteEvent"),
    
    -- Flight control events
    UpdateThrottle = Instance.new("RemoteEvent"),
    LaunchRocket = Instance.new("RemoteEvent"),
    StageRocket = Instance.new("RemoteEvent"),
    
    -- Physics sync events
    SyncPhysics = Instance.new("RemoteEvent"),
    UpdateTelemetry = Instance.new("RemoteEvent")
}

-- Parent all events to ReplicatedStorage
for name, event in pairs(Events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

return Events
