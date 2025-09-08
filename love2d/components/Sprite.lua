local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Sprite: Component
local Sprite = class("Sprite", Component)

function Sprite:initialize(imagePath, width, height)
	self.image = imagePath and love.graphics.newImage(imagePath) or nil
	self.width = width or (self.image and self.image:getWidth() or 32)
	self.height = height or (self.image and self.image:getHeight() or 32)
	self.originX = self.width / 2
	self.originY = self.height / 2
	self.color = { 1, 1, 1, 1 } -- RGBA
	self.visible = true
	self.layer = 0 -- For draw order
end

--- Set the color tint for the sprite.
---@param r number Red (0-1)
---@param g number Green (0-1)
---@param b number Blue (0-1)
---@param a number|nil Alpha (0-1), optional
function Sprite:setColor(r, g, b, a)
	self.color = { r, g, b, a or 1 }
end

return Sprite
