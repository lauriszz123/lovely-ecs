local class = require("middleclass")

---@class System: Object
local System = class("System")

function System:initialize()
	---@type World
	self.world = nil
end

--- Override to update things in the system.
---@param dt number Delta time since last update.
function System:update(dt)
	-- override in subclass
end

--- Override to draw things to the screen.
function System:draw()
	-- override in subclass
end

--- Override to handle when an entity is added to the system.
---@param entity Entity The entity that was added.
function System:onEntityAdded(entity)
	-- override in subclass
end

--- Override to handle when an entity is removed from the system.
function System:onApplicationClose()
	-- override in subclass
end

return System
