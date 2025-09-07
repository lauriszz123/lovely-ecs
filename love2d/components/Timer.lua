local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Timer: Component
local Timer = class("Timer", Component)

function Timer:initialize()
	self.timers = {}
end

function Timer:addTimer(name, duration, callback, repeating)
	self.timers[name] = {
		duration = duration,
		remaining = duration,
		callback = callback,
		repeating = repeating or false,
		active = true,
	}
end

function Timer:removeTimer(name)
	self.timers[name] = nil
end

function Timer:pauseTimer(name)
	if self.timers[name] then
		self.timers[name].active = false
	end
end

function Timer:resumeTimer(name)
	if self.timers[name] then
		self.timers[name].active = true
	end
end

return Timer
