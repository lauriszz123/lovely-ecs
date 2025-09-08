local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Audio: Component
local Audio = class("Audio", Component)

function Audio:initialize()
	self.sounds = {}
	self.music = {}
	self.volume = 1.0
end

--- Adds a sound.
---@param name string Identifier for the sound.
---@param path string Path to the sound file.
---@param volume number Default volume (0.0 to 1.0).
function Audio:addSound(name, path, volume)
	self.sounds[name] = {
		source = love.audio.newSource(path, "static"),
		volume = volume or 1.0,
	}
end

--- Adds music.
---@param name string Identifier for the music.
---@param path string Path to the music file.
---@param volume number Default volume (0.0 to 1.0).
function Audio:addMusic(name, path, volume)
	self.music[name] = {
		source = love.audio.newSource(path, "stream"),
		volume = volume or 1.0,
	}
end

--- Plays a sound effect.
---@param name string Identifier of the sound to play.
---@param volume number Optional volume override (0.0 to 1.0).
function Audio:playSound(name, volume)
	if self.sounds[name] then
		local sound = self.sounds[name]
		sound.source:setVolume((volume or sound.volume) * self.volume)
		love.audio.play(sound.source)
	end
end

--- Plays music.
---@param name string Identifier of the music to play.
---@param loop boolean Whether to loop the music.
---@param volume number Optional volume override (0.0 to 1.0).
function Audio:playMusic(name, loop, volume)
	if self.music[name] then
		local music = self.music[name]
		music.source:setVolume((volume or music.volume) * self.volume)
		music.source:setLooping(loop ~= false)
		love.audio.play(music.source)
	end
end

return Audio
