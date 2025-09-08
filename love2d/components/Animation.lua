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

--- Adds an animation.
---@param name string Name of the animation.
---@param frames table Array of quads or frame indices.
---@param frameRate number Frames per second.
---@param looping boolean Whether the animation should looping.
function Animation:addAnimation(name, frames, frameRate, looping)
	self.animations[name] = {
		frames = frames, -- Array of quads or frame indices
		frameRate = frameRate or 10,
		frameDuration = 1 / (frameRate or 10),
		looping = looping ~= false,
		length = #frames,
	}
end

--- Plays the specified animation.
---@param name string Name of the animation to play.
---@param reset boolean Whether to reset the animation if it's already playing.
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

--- Stops the current animation.
function Animation:stop()
	self.playing = false
end

--- Gets the current frame of the animation.
---@param name string Animation name
---@return integer|nil Current animation frame
function Animation:getCurrentFrame(name)
	local anim = self.animations[name]
	if anim then
		return anim.frames[self.currentFrame]
	end

	return nil
end

return Animation
