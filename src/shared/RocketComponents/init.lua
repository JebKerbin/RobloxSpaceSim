-- Main module for rocket components
local RocketComponents = {}

RocketComponents.Engine = require(script.Engine)
RocketComponents.FuelTank = require(script.FuelTank)
RocketComponents.CommandModule = require(script.CommandModule)
RocketComponents.Parachute = require(script.Parachute)

return RocketComponents
