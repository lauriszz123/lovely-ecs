local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Input: Component
local Input = class("Input", Component)

function Input:initialize()
	self.keysPressed = {}
	self.keysReleased = {}
	self.keysDown = {}
	self.mousePressed = {}
	self.mouseReleased = {}
	self.mouseDown = {}
	self.mouseX = 0
	self.mouseY = 0
end

function Input:isKeyDown(key)
	return self.keysDown[key] or false
end

function Input:isKeyPressed(key)
	return self.keysPressed[key] or false
end

function Input:isKeyReleased(key)
	return self.keysReleased[key] or false
end

function Input:isMouseDown(button)
	return self.mouseDown[button] or false
end

function Input:clearFrameEvents()
	self.keysPressed = {}
	self.keysReleased = {}
	self.mousePressed = {}
	self.mouseReleased = {}
end

return Input
