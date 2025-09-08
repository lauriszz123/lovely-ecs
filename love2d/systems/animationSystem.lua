local class = require("modified_middleclass")
local System = require("lovely-ecs").System

local Animation = require("lovely-ecs.love2d.components.Animation")

---@class AnimationSystem: System
local AnimationSystem = class("AnimationSystem", System)

function AnimationSystem:update(dt)
	local entities = self.world:getEntitiesWith(Animation)

	for _, entity in ipairs(entities) do
		local animation = entity:getComponent(Animation)
		---@cast animation Animation

		if animation.playing and animation.currentAnimation then
			local anim = animation.animations[animation.currentAnimation]

			animation.frameTime = animation.frameTime + dt

			if animation.frameTime >= anim.frameDuration then
				animation.frameTime = animation.frameTime - anim.frameDuration
				animation.currentFrame = animation.currentFrame + 1

				if animation.currentFrame > anim.length then
					if anim.looping then
						animation.currentFrame = 1
					else
						animation.currentFrame = anim.length
						animation.playing = false
					end
				end
			end
		end
	end
end

return AnimationSystem
