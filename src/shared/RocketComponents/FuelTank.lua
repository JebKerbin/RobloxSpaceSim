local Constants = require(game.ReplicatedStorage.Shared.Constants)

local FuelTank = {}

function FuelTank.new(properties)
    local self = {
        capacity = properties.capacity or 100,
        currentFuel = properties.capacity or 100,
        weight = properties.weight or 50,
        dryWeight = properties.dryWeight or 10
    }
    
    function self.getCurrentWeight()
        return self.dryWeight + (self.currentFuel / self.capacity) * (self.weight - self.dryWeight)
    end
    
    function self.consumeFuel(amount)
        local fuelConsumed = math.min(self.currentFuel, amount)
        self.currentFuel = self.currentFuel - fuelConsumed
        return fuelConsumed
    end
    
    return self
end

return FuelTank
