local class = require("modified_middleclass")
local System = require("lovely-ecs").System

local Audio = require("lovely-ecs.love2d.components.Audio")

---@class AudioSystem: System
local AudioSystem = class("AudioSystem", System)

function AudioSystem:initialize()
	System.initialize(self)

	self.masterVolume = 1.0
end

function AudioSystem:update(dt)
	-- Audio system mainly handles events, not much to update each frame
	-- Could be used for 3D positional audio updates, fade effects, etc.
end

function AudioSystem:setMasterVolume(volume)
	self.masterVolume = volume
	love.audio.setVolume(volume)
end

function AudioSystem:stopAllSounds()
	love.audio.stop()
end

return AudioSystem
