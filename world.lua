local class = require("modified_middleclass")

local Entity = require("entity")

---@class World: Object
local World = class("World")

function World:initialize()
	---@type Entity[]
	self.entities = {}

	---@type System[]
	self.systems = {}
end

--- Adds an entity to the world and notifies systems.
---@param entity Entity
function World:addEntity(entity)
	table.insert(self.entities, entity)
	entity.world = self
	for _, sys in ipairs(self.systems) do
		sys:onEntityAdded(entity)
	end
end

--- Removes an entity from the world.
---@param entity Entity
function World:removeEntity(entity)
	local ent = nil
	for i, e in ipairs(self.entities) do
		if e == entity then
			ent = table.remove(self.entities, i)
			break
		end
	end

	if ent then
		for _, sys in ipairs(self.systems) do
			sys:onEntityRemoved(ent)
		end
	end
end

--- Adds a system to the world.
---@param system System
function World:addSystem(system)
	system.world = self
	table.insert(self.systems, system)
end

--- Gets all entities that have the specified components.
---@param ... Component
---@return Entity[]
function World:getEntitiesWith(...)
	local required = { ... }

	---@type Entity[]
	local results = {}

	for _, e in ipairs(self.entities) do
		local ok = true

		for _, comp in ipairs(required) do
			if not e:getComponent(comp) then
				ok = false
				break
			end
		end

		if ok then
			table.insert(results, e)
		end
	end

	return results
end

---@param entityClass Class
---@return Entity[]
function World:getEntitiesByClass(entityClass)
	if not entityClass:isSubclassOf(Entity) then
		error("Not an entity!")
	end

	---@type Entity[]
	local result = {}
	for _, e in ipairs(self.entities) do
		if e:isInstanceOf(entityClass) then
			table.insert(result, e)
		end
	end

	return result
end

---@param tag string What kind of entities to get?
function World:getEntitiesWithTag(tag)
	---@type Entity[]
	local result = {}
	for _, e in ipairs(self.entities) do
		if e.tag == tag then
			table.insert(result, e)
		end
	end

	return result
end

--- Updates all systems in the world.
---@param dt number Delta time.
function World:update(dt)
	for _, sys in ipairs(self.systems) do
		sys:update(dt)
	end
end

--- Draws all systems in the world.
function World:draw()
	for _, sys in ipairs(self.systems) do
		sys:draw()
	end
end

--- Notifies all systems of application close.
function World:onApplicationClose()
	for _, sys in ipairs(self.systems) do
		sys:onApplicationClose()
	end
end

return World
