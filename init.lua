package.path = package.path .. ";./lovely-ecs/?.lua"

--- Utility function to execute a function if the value is not nil
---@param ... any Values to check, last argument is the function to execute
function _G.when(...)
	local args = { ... }
	local fn = args[#args]
	local allNil = true

	for i = 1, #args - 1 do
		if args[i] == nil then
			allNil = false
			break
		end
	end

	if allNil == true then
		fn(unpack(args, 1, #args - 1))
	end
end

---@class ECS
local ECS = {
	Component = require("component"),
	Entity = require("entity"),
	System = require("system"),
	World = require("world"),
}

return ECS
