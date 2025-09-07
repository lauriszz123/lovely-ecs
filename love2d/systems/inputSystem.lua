local class = require("modified_middleclass")
local System = require("lovely-ecs").System

local Input = require("love2d.components.Input")

---@class InputSystem: System
local InputSystem = class("InputSystem", System)

function InputSystem:update(dt)
	local entities = self.world:getEntitiesWith(Input)

	-- Update mouse position
	local mx, my = love.mouse.getPosition()

	for _, entity in ipairs(entities) do
		local input = entity:getComponent(Input)
		---@cast input Input

		input.mouseX = mx
		input.mouseY = my

		-- Clear frame events from previous frame
		input:clearFrameEvents()
	end
end

function InputSystem:onKeyPressed(key, scancode, isrepeat)
	local entities = self.world:getEntitiesWith(Input)
	for _, entity in ipairs(entities) do
		local input = entity:getComponent(Input)
		---@cast input Input

		input.keysPressed[key] = true
		input.keysDown[key] = true
	end
end

function InputSystem:onKeyReleased(key, scancode)
	local entities = self.world:getEntitiesWith(Input)
	for _, entity in ipairs(entities) do
		local input = entity:getComponent(Input)

		input.keysReleased[key] = true
		input.keysDown[key] = false
	end
end

function InputSystem:onMousePressed(x, y, button, istouch, presses)
	local entities = self.world:getEntitiesWith(Input)
	for _, entity in ipairs(entities) do
		local input = entity:getComponent(Input)
		input.mousePressed[button] = true
		input.mouseDown[button] = true
	end
end

function InputSystem:onMouseReleased(x, y, button, istouch, presses)
	local entities = self.world:getEntitiesWith(Input)
	for _, entity in ipairs(entities) do
		local input = entity:getComponent(Input)
		input.mouseReleased[button] = true
		input.mouseDown[button] = false
	end
end

return InputSystem
