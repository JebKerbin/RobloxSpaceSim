local RocketBuilder = {}

local RocketParts = require(script.Parent.RocketParts)

function RocketBuilder.new()
    local self = {}
    self.parts = {}
    self.totalMass = 0
    self.centerOfMass = Vector3.new(0, 0, 0)
    
    function self:addPart(partType, position)
        local part = RocketParts.createPart(partType)
        if part then
            part.Position = position
            table.insert(self.parts, part)
            self:recalculateProperties()
            return part
        end
        return nil
    end
    
    function self:removePart(part)
        for i, p in ipairs(self.parts) do
            if p == part then
                table.remove(self.parts, i)
                part:Destroy()
                self:recalculateProperties()
                break
            end
        end
    end
    
    function self:recalculateProperties()
        self.totalMass = 0
        local weightedPosition = Vector3.new(0, 0, 0)
        
        for _, part in ipairs(self.parts) do
            self.totalMass = self.totalMass + part:GetMass()
            weightedPosition = weightedPosition + (part.Position * part:GetMass())
        end
        
        if self.totalMass > 0 then
            self.centerOfMass = weightedPosition / self.totalMass
        end
    end
    
    function self:assemble()
        -- Create physical connections between parts
        for i = 1, #self.parts - 1 do
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = self.parts[i]
            weld.Part1 = self.parts[i + 1]
            weld.Parent = self.parts[i]
        end
    end
    
    return self
end

return RocketBuilder
