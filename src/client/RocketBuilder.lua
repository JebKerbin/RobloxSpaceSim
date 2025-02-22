local RocketBuilder = {}

local Constants = require(game.ReplicatedStorage.Shared.Constants)

function RocketBuilder.new()
    local self = {}
    
    local builderUI = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local partsList = Instance.new("ScrollingFrame")
    local buildSpace = Instance.new("ViewportFrame")
    
    function self.init()
        -- Set up UI
        builderUI.Name = "RocketBuilder"
        mainFrame.Size = UDim2.new(1, 0, 1, 0)
        mainFrame.BackgroundColor3 = Constants.UI_COLORS.BACKGROUND
        
        partsList.Size = UDim2.new(0.2, 0, 1, 0)
        partsList.Position = UDim2.new(0, 0, 0, 0)
        partsList.BackgroundColor3 = Constants.UI_COLORS.BACKGROUND
        
        buildSpace.Size = UDim2.new(0.8, 0, 1, 0)
        buildSpace.Position = UDim2.new(0.2, 0, 0, 0)
        buildSpace.BackgroundColor3 = Constants.UI_COLORS.BACKGROUND
        
        -- Add parts buttons
        self.createPartButton(Constants.PART_TYPES.COMMAND_MODULE)
        self.createPartButton(Constants.PART_TYPES.ENGINE)
        self.createPartButton(Constants.PART_TYPES.FUEL_TANK)
        
        mainFrame.Parent = builderUI
        partsList.Parent = mainFrame
        buildSpace.Parent = mainFrame
        builderUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    function self.createPartButton(partType)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 40)
        button.Position = UDim2.new(0, 5, 0, #partsList:GetChildren() * 45)
        button.Text = partType
        button.BackgroundColor3 = Constants.UI_COLORS.BUTTON
        button.TextColor3 = Constants.UI_COLORS.TEXT
        button.Parent = partsList
        
        button.MouseButton1Click:Connect(function()
            self.addPart(partType)
        end)
    end
    
    function self.addPart(partType)
        -- Implementation for adding parts to the rocket
        local part = Instance.new("Part")
        part.Name = partType
        -- Set part properties based on type
        -- This would be expanded based on part specifications
    end
    
    return self
end

return RocketBuilder
