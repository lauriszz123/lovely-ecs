local class = require("modified_middleclass")

---@class System: Object
---@field world World The world the system belongs to.
local System = class("System")

--- Ovverride to handle when the system is initialized.
function System:onInitialized()
	-- override in subclass
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

--- Override to handle when key is pressed.
---@param key string The key that was pressed.
---@param scancode string The scancode of the key that was pressed.
---@param isrepeat boolean Whether the key press is a repeat.
function System:onKeyPressed(key, scancode, isrepeat)
	-- override in subclass
end

--- Override to handle when key is released.
---@param key string The key that was released.
---@param scancode string The scancode of the key that was released.
function System:onKeyReleased(key, scancode)
	-- override in subclass
end

--- Override to handle when mouse button is pressed.
---@param x number The x position of the mouse.
---@param y number The y position of the mouse.
---@param button number The button that was pressed.
---@param istouch boolean Whether the event is a touch event.
---@param presses number The number of presses.
function System:onMousePressed(x, y, button, istouch, presses)
	-- override in subclass
end

--- Override to handle when mouse button is released.
---@param x number The x position of the mouse.
---@param y number The y position of the mouse.
---@param button number The button that was released.
---@param istouch boolean Whether the event is a touch event.
---@param presses number The number of presses.
function System:onMouseReleased(x, y, button, istouch, presses)
	-- override in subclass
end

--- Override to handle when mouse is moved.
---@param x number The new x position of the mouse.
---@param y number The new y position of the mouse.
---@param dx number The change in x position.
---@param dy number The change in y position.
---@param istouch boolean Whether the event is a touch event.
function System:onMouseMoved(x, y, dx, dy, istouch)
	-- override in subclass
end

--- Override to handle when the window is resized.
---@param w number The new width of the window.
---@param h number The new height of the window.
function System:onResize(w, h)
	-- override in subclass
end

--- Override to handle when the window focus changes.
---@param focused boolean Whether the window is focused.
function System:onFocus(focused)
	-- override in subclass
end

--- Override to handle text input when typed.
---@param text string The text typed.
function System:onTextInput(text) end

---@param entity Entity
function System:onEntityRemoved(entity) end

return System
