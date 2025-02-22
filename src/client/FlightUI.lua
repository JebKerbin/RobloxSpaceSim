local FlightUI = {}

local Constants = require(game.ReplicatedStorage.Shared.Constants)

function FlightUI.new()
    local self = {}
    
    local flightGui = Instance.new("ScreenGui")
    local mainPanel = Instance.new("Frame")
    local altitudeLabel = Instance.new("TextLabel")
    local velocityLabel = Instance.new("TextLabel")
    local fuelLabel = Instance.new("TextLabel")
    local throttleSlider = Instance.new("Frame")
    
    function self.init()
        flightGui.Name = "FlightUI"
        
        mainPanel.Size = UDim2.new(0.2, 0, 1, 0)
        mainPanel.Position = UDim2.new(0.8, 0, 0, 0)
        mainPanel.BackgroundColor3 = Constants.UI_COLORS.BACKGROUND
        
        -- Set up altitude display
        altitudeLabel.Size = UDim2.new(1, 0, 0.1, 0)
        altitudeLabel.Position = UDim2.new(0, 0, 0, 0)
        altitudeLabel.Text = "Altitude: 0m"
        altitudeLabel.TextColor3 = Constants.UI_COLORS.TEXT
        
        -- Set up velocity display
        velocityLabel.Size = UDim2.new(1, 0, 0.1, 0)
        velocityLabel.Position = UDim2.new(0, 0, 0.1, 0)
        velocityLabel.Text = "Velocity: 0m/s"
        velocityLabel.TextColor3 = Constants.UI_COLORS.TEXT
        
        -- Set up fuel display
        fuelLabel.Size = UDim2.new(1, 0, 0.1, 0)
        fuelLabel.Position = UDim2.new(0, 0, 0.2, 0)
        fuelLabel.Text = "Fuel: 100%"
        fuelLabel.TextColor3 = Constants.UI_COLORS.TEXT
        
        -- Set up throttle control
        throttleSlider.Size = UDim2.new(0.1, 0, 0.8, 0)
        throttleSlider.Position = UDim2.new(0.9, 0, 0.1, 0)
        throttleSlider.BackgroundColor3 = Constants.UI_COLORS.BUTTON
        
        mainPanel.Parent = flightGui
        altitudeLabel.Parent = mainPanel
        velocityLabel.Parent = mainPanel
        fuelLabel.Parent = mainPanel
        throttleSlider.Parent = mainPanel
        
        flightGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    function self.updateDisplay(altitude, velocity, fuel)
        altitudeLabel.Text = string.format("Altitude: %.1fm", altitude)
        velocityLabel.Text = string.format("Velocity: %.1fm/s", velocity)
        fuelLabel.Text = string.format("Fuel: %.0f%%", fuel)
    end
    
    return self
end

return FlightUI
