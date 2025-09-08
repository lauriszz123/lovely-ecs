local class = require("modified_middleclass")
local Component = require("lovely-ecs").Component

---@class Timer: Component
local Timer = class("Timer", Component)

function Timer:initialize()
	self.timers = {}
end

--- Adds a new timer.
---@param name string Name of the timer.
---@param duration number Duration in seconds.
---@param callback function Function to call when the timer completes.
---@param repeating boolean|nil Optional. If true, the timer will reset after completing.
function Timer:addTimer(name, duration, callback, repeating)
	self.timers[name] = {
		duration = duration,
		remaining = duration,
		callback = callback,
		repeating = repeating or false,
		active = true,
	}
end

--- Sets the specified timer as active or inactive.
---@param name string Name of the timer.
---@param active boolean true to activate, false to deactivate.
function Timer:setActive(name, active)
	if self.timers[name] then
		self.timers[name].active = active
	end
end

--- Checks if the specified timer is currently active (running).
---@param name string Name of the timer.
---@return boolean true if the timer is active, false otherwise.
function Timer:isActive(name)
	if self.timers[name] then
		return self.timers[name].active
	end
	return false
end

--- Sets the specified timer as done or not done.
---@param name string Name of the timer.
---@param done boolean|nil If true, marks the timer as done; if false, resets it. Defaults to true.
function Timer:setDone(name, done)
	done = done or true
	if self.timers[name] then
		self.timers[name].remaining = done and 0 or self.timers[name].duration
	end
end

function Timer:isDone(name)
	if self.timers[name] then
		return self.timers[name].remaining <= 0
	end
	return true
end

--- Remove a timer by name.
---@param name string Name of the timer to remove.
function Timer:removeTimer(name)
	self.timers[name] = nil
end

--- Pauses a running timer.
---@param name string Name of the timer to pause.
function Timer:pauseTimer(name)
	if self.timers[name] then
		self.timers[name].active = false
	end
end

--- Resumes a paused timer.
---@param name string Name of the timer to resume.
function Timer:resumeTimer(name)
	if self.timers[name] then
		self.timers[name].active = true
	end
end

--- Resets the specified timer to its original duration.
---@param name string Name of the timer to reset.
function Timer:resetTimer(name)
	if self.timers[name] then
		self.timers[name].remaining = self.timers[name].duration
	end
end

return Timer
