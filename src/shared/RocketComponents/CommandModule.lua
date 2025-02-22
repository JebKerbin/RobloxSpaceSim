local CommandModule = {}

function CommandModule.new(properties)
    local self = {
        weight = properties.weight or 25,
        crewCapacity = properties.crewCapacity or 1,
        hasParachute = properties.hasParachute or false
    }
    
    return self
end

return CommandModule
