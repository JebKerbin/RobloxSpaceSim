local PhysicsCalculator = {}

function PhysicsCalculator.calculateDrag(velocity, altitude, crossSectionalArea)
    local Constants = require(game.ReplicatedStorage.Shared.Constants)
    local atmosphericDensity = math.max(0, 1 - (altitude / Constants.ATMOSPHERE_HEIGHT))
    return 0.5 * atmosphericDensity * Constants.DRAG_COEFFICIENT * crossSectionalArea * (velocity * velocity)
end

function PhysicsCalculator.calculateThrust(enginePower, atmosphericPressure)
    local Constants = require(game.ReplicatedStorage.Shared.Constants)
    return enginePower * math.max(0.7, atmosphericPressure)
end

function PhysicsCalculator.calculateGravityForce(mass, altitude)
    local Constants = require(game.ReplicatedStorage.Shared.Constants)
    return Vector3.new(0, -Constants.GRAVITY * mass, 0)
end

return PhysicsCalculator
