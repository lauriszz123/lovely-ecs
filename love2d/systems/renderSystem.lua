local class = require("middleclass")

local System = require("lovely-ecs").System

local Renderable = require("components.Renderable")
local PhysicsBody = require("components.PhysicsBody")

---@class RenderSystem: System
local RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()
	local entities = self.world:getEntitiesWith(Renderable)

	for _, e in ipairs(entities) do
		local r = e:getComponent(Renderable)
		local p = e:getComponent(PhysicsBody)

		if r and p then
			local x, y = p.body:getX(), p.body:getY()
			local angle = p.body:getAngle()

			love.graphics.setColor(r.color)
			love.graphics.push()
			love.graphics.translate(x, y)
			love.graphics.rotate(angle)
			r.shape(-(p.width / 2), -(p.height / 2), p.width, p.height)
			love.graphics.pop()
		elseif r then
			-- static renderable (no physics)
			love.graphics.setColor(r.color)
			r.shape(r.x, r.y, r.width, r.height)
		end
	end
end

return RenderSystem
