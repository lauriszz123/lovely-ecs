local class = require("middleclass")

---@class Component: Object
local Component = class("Component")

function Component:initialize()
	---@type Entity
	self.entity = nil
end

---@param entity Entity
function Component:setEntity(entity)
	self.entity = entity
end

--- Placholder, called after adding the component
function Component:onAdd() end

--- Placholder, called before removing the component
function Component:onRemove() end

return Component
