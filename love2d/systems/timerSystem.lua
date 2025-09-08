local class = require("modified_middleclass")
local System = require("lovely-ecs").System

local Timer = require("lovely-ecs.love2d.components.Timer")

---@class TimerSystem: System
local TimerSystem = class("TimerSystem", System)

function TimerSystem:update(dt)
	local entities = self.world:getEntitiesWith(Timer)

	for _, entity in ipairs(entities) do
		local timer = entity:getComponent(Timer)
		---@cast timer Timer

		for name, timerData in pairs(timer.timers) do
			if timerData.active then
				timerData.remaining = timerData.remaining - dt

				if timerData.remaining <= 0 then
					-- Execute callback
					if timerData.callback then
						timerData.callback(entity)
					end

					if timerData.repeating then
						timerData.remaining = timerData.duration
					else
						timer.timers[name] = nil
					end
				end
			end
		end
	end
end

return TimerSystem
