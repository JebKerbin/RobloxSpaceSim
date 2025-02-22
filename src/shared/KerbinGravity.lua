local KerbinGravity = {}

-- Constants
local GRAVITY = 9.81 -- m/s²
local WORLD_SIZE = 16384 -- studs

function KerbinGravity.initialize()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    
    -- Create gravity field
    local gravityField = Instance.new("Part")
    gravityField.Anchored = true
    gravityField.Size = Vector3.new(WORLD_SIZE, 1, WORLD_SIZE)
    gravityField.Position = Vector3.new(0, -1, 0)
    gravityField.Parent = workspace
    
    -- Apply gravity to objects
    RunService.Heartbeat:Connect(function(deltaTime)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and not v.Anchored then
                local force = Vector3.new(0, -GRAVITY * v:GetMass(), 0)
                v.Velocity = v.Velocity + force * deltaTime
            end
        end
    end)
end

function KerbinGravity.getGravityAtHeight(height)
    -- Simple linear gravity falloff with height
    local factor = math.max(0, 1 - (height / WORLD_SIZE))
    return GRAVITY * factor
end

return KerbinGravity
