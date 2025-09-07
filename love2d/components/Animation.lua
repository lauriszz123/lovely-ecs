local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Animation: Component
local Animation = class("Animation", Component)

function Animation:initialize()
	self.animations = {}
	self.currentAnimation = nil
	self.currentFrame = 1
	self.frameTime = 0
	self.playing = false
end

function Animation:addAnimation(name, frames, frameRate, looping)
	self.animations[name] = {
		frames = frames, -- Array of quads or frame indices
		frameRate = frameRate or 10,
		frameDuration = 1 / (frameRate or 10),
		looping = looping ~= false,
		length = #frames,
	}
end

function Animation:play(name, reset)
	if self.animations[name] then
		if reset or self.currentAnimation ~= name then
			self.currentAnimation = name
			self.currentFrame = 1
			self.frameTime = 0
		end
		self.playing = true
	end
end

function Animation:stop()
	self.playing = false
end

function Animation:getCurrentFrame()
	if self.currentAnimation then
		local anim = self.animations[self.currentAnimation]
		return anim.frames[self.currentFrame]
	end
	return nil
end

return Animation
