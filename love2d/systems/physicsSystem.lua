local class = require("modified_middleclass")
local System = require("lovely-ecs").System

local PhysicsBody = require("love2d.components.PhysicsBody")

---@class PhysicsSystem: System
local PhysicsSystem = class("PhysicsSystem", System)

function PhysicsSystem:initialize(gx, gy)
	System.initialize(self)

	self.FIXED_TIMESTEP = 1 / 120
	self.acc = 0

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
	self.acc = self.acc + dt
	while self.acc > self.FIXED_TIMESTEP do
		self.physicsWorld:update(self.FIXED_TIMESTEP)
		self.acc = self.acc - self.FIXED_TIMESTEP
	end
end

function PhysicsSystem:getPhysicsWorld()
	return self.physicsWorld
end

---@param entity Entity
function PhysicsSystem:onEntityRemoved(entity)
	when(entity:getComponent(PhysicsBody), function(pb) ---@param pb PhysicsBody
		if pb.fixture and not pb.fixture:isDestroyed() then
			pb.fixture:destroy()
		end
		if pb.body and not pb.body:isDestroyed() then
			pb.body:destroy()
		end
	end)
end

return PhysicsSystem
