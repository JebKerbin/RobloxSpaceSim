local KerbinGravity = {}

local Constants = require(game.ReplicatedStorage.Shared.Constants)
local PhysicsCalculator = require(game.ReplicatedStorage.Shared.PhysicsCalculator)

function KerbinGravity.init()
    local function onPlayerAdded(player)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Set up gravity for character
        game:GetService("RunService").Heartbeat:Connect(function(dt)
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local altitude = rootPart.Position.Y
                local mass = 1 -- Base mass for character
                local gravityForce = PhysicsCalculator.calculateGravityForce(mass, altitude)
                rootPart.CFrame = rootPart.CFrame + gravityForce * dt
            end
        end)
    end
    
    game.Players.PlayerAdded:Connect(onPlayerAdded)
end

return KerbinGravity
