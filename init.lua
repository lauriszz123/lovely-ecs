package.path = package.path .. ";./lovely-ecs/?.lua"

---@class ECS
local ECS = {
	Component = require("component"),
	Entity = require("entity"),
	System = require("system"),
	World = require("world"),
}

return ECS
