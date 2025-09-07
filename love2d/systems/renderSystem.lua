local class = require("modified_middleclass")

local System = require("lovely-ecs").System

local Sprite = require("love2d.components.Sprite")
local PhysicsBody = require("love2d.components.PhysicsBody")

---@class RenderSystem: System
local RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()
	local entitiesWithSprites = self.world:getEntitiesWith(Sprite)
	local entitiesWithPhysicsBodies = self.world:getEntitiesWith(PhysicsBody)

	-- Sort by layer for proper draw order
	table.sort(entitiesWithSprites, function(a, b)
		local spriteA = a:getComponent(Sprite)
		local spriteB = b:getComponent(Sprite)
		return spriteA.layer < spriteB.layer
	end)

	-- Apply camera transform
	love.graphics.push()
	love.graphics.scale(self.camera.zoom)
	love.graphics.translate(-self.camera.x, -self.camera.y)

	for _, entity in ipairs(entitiesWithSprites) do
		local transform = entity:getComponent(Transform)
		local sprite = entity:getComponent(Sprite)
		local animation = entity:getComponent(Animation)

		if sprite.visible then
			love.graphics.push()
			love.graphics.translate(transform.x, transform.y)
			love.graphics.rotate(transform.rotation)
			love.graphics.scale(transform.scaleX, transform.scaleY)
			love.graphics.setColor(sprite.color)

			if sprite.image then
				local quad = nil
				if animation then
					quad = animation:getCurrentFrame()
				end

				if quad then
					love.graphics.draw(sprite.image, quad, -sprite.originX, -sprite.originY)
				else
					love.graphics.draw(sprite.image, -sprite.originX, -sprite.originY)
				end
			else
				-- Draw a colored rectangle if no image
				love.graphics.rectangle("fill", -sprite.width / 2, -sprite.height / 2, sprite.width, sprite.height)
			end

			love.graphics.pop()
		end
	end

	for _, e in ipairs(entitiesWithPhysicsBodies) do
		local p = e:getComponent(PhysicsBody)
		local s = e:getComponent(Sprite)

		if p and not s then
			local x, y = p.body:getX(), p.body:getY()
			local angle = p.body:getAngle()

			love.graphics.setColor(r.color)
			love.graphics.push()
			love.graphics.translate(x, y)
			love.graphics.rotate(angle)
			r.shape(-(p.width / 2), -(p.height / 2), p.width, p.height)
			love.graphics.pop()
		end
	end

	love.graphics.pop()
	love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

return RenderSystem
