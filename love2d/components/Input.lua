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

--- Is a key currently held down?
---@param key string Key name
---@return boolean true if down
function Input:isKeyDown(key)
	return self.keysDown[key] or false
end

--- Was a key pressed this frame?
---@param key string Key name
---@return boolean true if pressed this frame
function Input:isKeyPressed(key)
	return self.keysPressed[key] or false
end

--- Was a key released this frame?
---@param key string Key name
---@return boolean true if released this frame
function Input:isKeyReleased(key)
	return self.keysReleased[key] or false
end

--- Is a mouse button currently held down?
---@param button number Mouse button (1=left, 2=right, 3=middle)
---@return boolean true if down
function Input:isMouseDown(button)
	return self.mouseDown[button] or false
end

--- Clear the frame-specific input events.
function Input:clearFrameEvents()
	self.keysPressed = {}
	self.keysReleased = {}
	self.mousePressed = {}
	self.mouseReleased = {}
end

return Input
