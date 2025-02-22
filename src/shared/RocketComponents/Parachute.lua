local Parachute = {}

function Parachute.new(properties)
    local self = {
        isDeployed = false,
        dragCoefficient = properties.dragCoefficient or 2.0,
        weight = properties.weight or 5,
        deploymentAltitude = properties.deploymentAltitude or 1000
    }
    
    function self.deploy()
        self.isDeployed = true
    end
    
    function self.retract()
        self.isDeployed = false
    end
    
    function self.getDragForce(velocity, atmosphericDensity)
        if not self.isDeployed then return 0 end
        return 0.5 * atmosphericDensity * self.dragCoefficient * velocity * velocity
    end
    
    return self
end

return Parachute
