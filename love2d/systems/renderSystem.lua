local class = require("modified_middleclass")

local System = require("lovely-ecs").System

---@diagnostic disable-next-line: different-requires
local Sprite = require("lovely-ecs.love2d.components.Sprite")
local Animation = require("lovely-ecs.love2d.components.Animation")
local PhysicsBody = require("lovely-ecs.love2d.components.PhysicsBody")

---@class RenderSystem: System
local RenderSystem = class("RenderSystem", System)

function RenderSystem:initialize()
	System.initialize(self)

	self.camera = { x = 0, y = 0, zoom = 1 }
end

function RenderSystem:draw()
	local entitiesWithSprites = self.world:getEntitiesWith(Sprite)
	local entitiesWithPhysicsBodies = self.world:getEntitiesWith(PhysicsBody)

	-- Sort by layer for proper draw order
	---@param a Entity
	---@param b Entity
	table.sort(entitiesWithSprites, function(a, b)
		local spriteA = a:getComponent(Sprite)
		---@cast spriteA Sprite

		local spriteB = b:getComponent(Sprite)
		---@cast spriteB Sprite

		return spriteA.layer < spriteB.layer
	end)

	-- Apply camera transform
	love.graphics.push()
	love.graphics.scale(self.camera.zoom)
	love.graphics.translate(-self.camera.x, -self.camera.y)

	for _, entity in ipairs(entitiesWithSprites) do
		when(
			entity:getComponent(Sprite),
			entity:getComponent(PhysicsBody),

			---@param sprite Sprite
			---@param physicsBody PhysicsBody
			function(sprite, physicsBody)
				if sprite.visible then
					local x, y = physicsBody.body:getX(), physicsBody.body:getY()
					local rotation = physicsBody.body:getAngle()
					love.graphics.push()
					love.graphics.translate(x, y)
					love.graphics.rotate(rotation)
					love.graphics.setColor(sprite.color)

					if sprite.image then
						local quad = nil
						when(entity:getComponent(Animation), function(animation) ---@param animation Animation
							quad = animation:getCurrentFrame(animation.currentAnimation)
						end)

						if quad then
							love.graphics.draw(sprite.image, quad, -sprite.originX, -sprite.originY)
						else
							love.graphics.draw(sprite.image, -sprite.originX, -sprite.originY)
						end
					else
						-- Draw a colored rectangle if no image
						love.graphics.rectangle(
							"fill",
							-sprite.width / 2,
							-sprite.height / 2,
							sprite.width,
							sprite.height
						)
					end

					love.graphics.pop()
				end
			end
		)
	end

	for _, e in ipairs(entitiesWithPhysicsBodies) do
		local p = e:getComponent(PhysicsBody)
		---@cast p PhysicsBody

		local s = e:getComponent(Sprite)
		---@cast s Sprite

		if p and not s then
			local x, y = p.body:getX(), p.body:getY()
			local angle = p.body:getAngle()

			love.graphics.setColor({ 1, 1, 1 })
			love.graphics.push()
			love.graphics.translate(x, y)
			love.graphics.rotate(angle)
			love.graphics.rectangle("fill", -(p.width / 2), -(p.height / 2), p.width, p.height)
			love.graphics.pop()
		end
	end

	love.graphics.pop()
	love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

return RenderSystem
