local MissionControlUI = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function MissionControlUI.new()
    local self = {}
    
    -- Create main UI frame
    local gui = Instance.new("ScreenGui")
    gui.Name = "MissionControl"
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.2, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.8, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.Parent = gui
    
    -- Mission list
    local missionList = Instance.new("ScrollingFrame")
    missionList.Size = UDim2.new(1, -10, 0.9, 0)
    missionList.Position = UDim2.new(0, 5, 0.1, 0)
    missionList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    missionList.Parent = mainFrame
    
    local missions = {
        {
            name = "First Flight",
            description = "Launch a rocket above 1000m altitude",
            reward = 100,
            checkCompletion = function(height)
                return height >= 1000
            end
        },
        {
            name = "Orbit Achieved",
            description = "Achieve stable orbit around Kerbin",
            reward = 500,
            checkCompletion = function(velocity, height)
                return velocity >= 7800 and height >= 70000
            end
        }
    }
    
    function self:showMissions()
        for i, mission in ipairs(missions) do
            local missionButton = Instance.new("TextButton")
            missionButton.Size = UDim2.new(1, -10, 0, 50)
            missionButton.Position = UDim2.new(0, 5, 0, (i-1) * 55)
            missionButton.Text = mission.name .. "\n" .. mission.description
            missionButton.Parent = missionList
            
            missionButton.MouseButton1Click:Connect(function()
                self:selectMission(mission)
            end)
        end
    end
    
    function self:selectMission(mission)
        -- Set active mission and update UI
        self.activeMission = mission
        -- Update mission tracker
    end
    
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return self
end

return MissionControlUI
