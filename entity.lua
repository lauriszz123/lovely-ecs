local class = require("modified_middleclass")

local Component = require("ecs.component")

---@class Entity: Object
local Entity = class("Entity")

function Entity:initialize()
	self.components = {}
	self.active = true
end

--- Adds a component to the entity.
---@param component Component
function Entity:addComponent(component)
	if not component:isInstanceOf(Component) then
		error("Not a component.")
	end

	local cname = component.class.name
	self.components[cname] = component
	component:setEntity(self)

	component:onAdd()
end

--- Removes a component from the entity.
---@param component Component
function Entity:removeComponent(component)
	local cname = component.class.name
	local comp = self.components[cname]
	if comp then
		if comp.onRemove then
			comp:onRemove()
		end
		self.components[cname] = nil
	end
	end

--- Override to handle collision with another entity.
---@param other Entity The other entity involved in the collision.
function Entity:onCollision(other)
	-- override in subclass
end

--- Gets a component from the entity.
---@param component Component
---@return Component
function Entity:getComponent(component)
	if not component:isSubclassOf(Component) then
		error("Not a component.")
	end

	local cname = component.name
	return self.components[cname]
end

return Entity
