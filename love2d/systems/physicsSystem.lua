local class = require("middleclass")

local System = require("ecs").System

---@class PhysicsSystem: System
local PhysicsSystem = class("PhysicsSystem", System)

function PhysicsSystem:initialize(gx, gy)
	System.initialize(self)

	self.physicsWorld = love.physics.newWorld(gx or 0, gy or 0)

	self.physicsWorld:setCallbacks(function(a, b)
		self:beginContact(a, b)
	end, function(a, b)
		self:endContact(a, b)
	end, nil, nil)
end

function PhysicsSystem:beginContact(a, b)
	---@type Entity
	local bodyA = a:getUserData()

	---@type Entity
	local bodyB = b:getUserData()

	if bodyA and bodyA and bodyA.onCollision then
		bodyA:onCollision(bodyB)
	end

	if bodyB and bodyB and bodyB.onCollision then
		bodyB:onCollision(bodyA)
	end
end

function PhysicsSystem:endContact(a, b)
	---@type Entity
	local bodyA = a:getUserData()

	---@type Entity
	local bodyB = b:getUserData()

	if bodyA and bodyA and bodyA.onCollisionEnd then
		bodyA:onCollisionEnd(bodyB)
	end

	if bodyB and bodyB and bodyB.onCollisionEnd then
		bodyB:onCollisionEnd(bodyA)
	end
end

function PhysicsSystem:update(dt)
	self.physicsWorld:update(dt)
end

function PhysicsSystem:getPhysicsWorld()
	return self.physicsWorld
end

return PhysicsSystem
