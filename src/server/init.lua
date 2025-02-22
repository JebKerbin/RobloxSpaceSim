-- ServerScriptService initialization
local ServerScripts = {}

-- Initialize all server-side systems
local function init()
    require(script.KerbinGravity).init()
    -- Add other system initializations here
end

game:GetService("Players").PlayerAdded:Connect(init)

return ServerScripts
