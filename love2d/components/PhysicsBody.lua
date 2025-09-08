local class = require("modified_middleclass")

local Component = require("lovely-ecs").Component

---@class PhysicsBody: Component
local PhysicsBody = class("PhysicsBody", Component)

function PhysicsBody:initialize(world, x, y, width, height, bodyType)
	Component.initialize(self)

	bodyType = bodyType or "dynamic"

	self.body = love.physics.newBody(world, x, y, bodyType)
	self.shape = love.physics.newRectangleShape(width, height)
	self.fixture = love.physics.newFixture(self.body, self.shape)

	self.width = width
	self.height = height

	if bodyType == "dynamic" then
		-- Prevent endless spinning on collision
		self.body:setAngularDamping(8.0) -- High angular damping to stop rotation quickly

		-- Set linear damping for more realistic movement
		self.body:setLinearDamping(2.0) -- Slight drag to feel more grounded

		-- Reduce restitution (bounciness) for more realistic collisions
		self.fixture:setRestitution(0.1) -- Very little bounce

		-- Set friction for realistic surface interaction
		self.fixture:setFriction(0.7)
	end
end

function PhysicsBody:onAdd()
	-- Store reference to entity in fixture for collision callbacks
	self.fixture:setUserData(self.entity)
end

function PhysicsBody:onRemove()
	if self.body then
		self.body:destroy()
	end
end

function PhysicsBody:getPosition()
	return self.body:getPosition()
end

function PhysicsBody:getAngle()
	return self.body:getAngle()
end

function PhysicsBody:setBullet(isBullet)
	self.body:setBullet(isBullet)
end

return PhysicsBody
