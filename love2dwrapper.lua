local ECS = require("lovely-ecs")

---@class Love2DECS
local Love2DECS = {}

---@diagnostic disable-next-line: different-requires
Love2DECS.Components = {
	PhysicsBody = require("lovely-ecs.love2d.components.PhysicsBody"),
	Animation = require("lovely-ecs.love2d.components.Animation"),
	Sprite = require("lovely-ecs.love2d.components.Sprite"),
	Audio = require("lovely-ecs.love2d.components.Audio"),
	Input = require("lovely-ecs.love2d.components.Input"),
	Timer = require("lovely-ecs.love2d.components.Timer"),
}

Love2DECS.Systems = {
	Physics = require("lovely-ecs.love2d.systems.physicsSystem"),
	Animation = require("lovely-ecs.love2d.systems.animationSystem"),
	Render = require("lovely-ecs.love2d.systems.renderSystem"),
	Audio = require("lovely-ecs.love2d.systems.audioSystem"),
	Input = require("lovely-ecs.love2d.systems.inputSystem"),
	Timer = require("lovely-ecs.love2d.systems.timerSystem"),
}

-- Store the current world instance
---@type World
local currentWorld = nil

-- Internal flag to track if wrapper is active
local isActive = false

-- Store original Love2D callbacks
local originalCallbacks = {}

---@param world World
function Love2DECS.setWorld(world)
	currentWorld = world
end

---@return World|nil
function Love2DECS.getWorld()
	return currentWorld
end

-- Initialize the Love2D wrapper
function Love2DECS.start()
	if isActive then
		return -- Already active
	end

	isActive = true

	-- Store original callbacks if they exist
	originalCallbacks.update = love.update
	originalCallbacks.draw = love.draw
	originalCallbacks.quit = love.quit
	originalCallbacks.keypressed = love.keypressed
	originalCallbacks.keyreleased = love.keyreleased
	originalCallbacks.mousepressed = love.mousepressed
	originalCallbacks.mousereleased = love.mousereleased
	originalCallbacks.mousemoved = love.mousemoved
	originalCallbacks.textinput = love.textinput
	originalCallbacks.resize = love.resize

	-- Override Love2D callbacks
	---@diagnostic disable-next-line: duplicate-set-field
	love.update = function(dt)
		if currentWorld then
			currentWorld:update(dt)
		end

		-- Call original callback if it exists
		if originalCallbacks.update then
			originalCallbacks.update(dt)
		end
	end

	love.draw = function()
		if currentWorld then
			currentWorld:draw()
		end

		-- Call original callback if it exists
		if originalCallbacks.draw then
			originalCallbacks.draw()
		end
	end

	love.quit = function()
		if currentWorld then
			currentWorld:onApplicationClose()
		end

		-- Call original callback if it exists
		if originalCallbacks.quit then
			return originalCallbacks.quit()
		end
	end

	-- Input event forwarding to systems
	love.keypressed = function(key, scancode, isrepeat)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onKeyPressed then
					system:onKeyPressed(key, scancode, isrepeat)
				end
			end
		end

		if originalCallbacks.keypressed then
			originalCallbacks.keypressed(key, scancode, isrepeat)
		end
	end

	love.keyreleased = function(key, scancode)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onKeyReleased then
					system:onKeyReleased(key, scancode)
				end
			end
		end

		if originalCallbacks.keyreleased then
			originalCallbacks.keyreleased(key, scancode)
		end
	end

	love.mousepressed = function(x, y, button, istouch, presses)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onMousePressed then
					system:onMousePressed(x, y, button, istouch, presses)
				end
			end
		end

		if originalCallbacks.mousepressed then
			originalCallbacks.mousepressed(x, y, button, istouch, presses)
		end
	end

	love.mousereleased = function(x, y, button, istouch, presses)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onMouseReleased then
					system:onMouseReleased(x, y, button, istouch, presses)
				end
			end
		end

		if originalCallbacks.mousereleased then
			originalCallbacks.mousereleased(x, y, button, istouch, presses)
		end
	end

	love.mousemoved = function(x, y, dx, dy, istouch)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onMouseMoved then
					system:onMouseMoved(x, y, dx, dy, istouch)
				end
			end
		end

		if originalCallbacks.mousemoved then
			originalCallbacks.mousemoved(x, y, dx, dy, istouch)
		end
	end

	love.textinput = function(text)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onTextInput then
					system:onTextInput(text)
				end
			end
		end

		if originalCallbacks.textinput then
			originalCallbacks.textinput(text)
		end
	end

	love.resize = function(w, h)
		if currentWorld then
			for _, system in ipairs(currentWorld.systems) do
				if system.onResize then
					system:onResize(w, h)
				end
			end
		end

		if originalCallbacks.resize then
			originalCallbacks.resize(w, h)
		end
	end
end

-- Stop the wrapper and restore original callbacks
function Love2DECS.stop()
	if not isActive then
		return
	end

	isActive = false

	-- Restore original callbacks
	love.update = originalCallbacks.update
	love.draw = originalCallbacks.draw
	love.quit = originalCallbacks.quit
	love.keypressed = originalCallbacks.keypressed
	love.keyreleased = originalCallbacks.keyreleased
	love.mousepressed = originalCallbacks.mousepressed
	love.mousereleased = originalCallbacks.mousereleased
	love.mousemoved = originalCallbacks.mousemoved
	love.textinput = originalCallbacks.textinput
	love.resize = originalCallbacks.resize

	-- Clear stored callbacks
	originalCallbacks = {}
end

--- Create a new world and set it as the current world
---@return World
function Love2DECS.createWorld()
	local world = ECS.World()
	Love2DECS.setWorld(world)
	return world
end

--- Add an entity to the current world
---@param entity Entity
function Love2DECS.addEntity(entity)
	if currentWorld then
		currentWorld:addEntity(entity)
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

--- Remove an entity from the current world
---@param entity Entity
function Love2DECS.removeEntity(entity)
	if currentWorld then
		currentWorld:removeEntity(entity)
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

--- Add a system to the current world
---@param system System
function Love2DECS.addSystem(system)
	if currentWorld then
		currentWorld:addSystem(system)
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

--- Get entities with specified components from the current world
---@param ... Class<Component> Component to filter by
---@return Entity[] List of entities with the specified components
function Love2DECS.getEntitiesWith(...)
	if currentWorld then
		return currentWorld:getEntitiesWith(...)
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

---@param entityClass Class
function Love2DECS.getEntitiesByClass(entityClass)
	if currentWorld then
		return currentWorld:getEntitiesByClass(entityClass)
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

function Love2DECS.getEntityCount()
	if currentWorld then
		return #currentWorld.entities
	else
		error("No world set. Use Love2DECS.setWorld() first.")
	end
end

-- Export ECS classes for convenience
Love2DECS.Component = ECS.Component
Love2DECS.Entity = ECS.Entity
Love2DECS.System = ECS.System
Love2DECS.World = ECS.World

return Love2DECS
