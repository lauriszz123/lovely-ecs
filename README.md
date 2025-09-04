# LÖVEly ECS

A lightweight and flexible Entity Component System (ECS) implementation for Lua, designed with LÖVE (Love2D) in mind.

## Overview

LÖVEly ECS provides a clean and intuitive way to organize game logic using the Entity Component System architectural pattern. This pattern promotes composition over inheritance, making your code more modular, maintainable, and flexible.

### Key Features

* **Simple API**: Easy to understand and use
* **Flexible Architecture**: Components can be easily added/removed from entities
* **System Management**: Organized update and draw loops
* **Entity Queries**: Efficiently find entities with specific components
* **Collision Handling**: Built-in collision detection hooks
* **Lifecycle Hooks**: Component and system lifecycle management

## Installation

1. Clone or download this repository into your project
2. Require the ECS module in your code:

```lua
local ECS = require("lovely-ecs")
```

## Quick Start

```lua
local ECS = require("lovely-ecs")
local class = require("middleclass")

-- Create a world
local world = ECS.World()

-- Create a position component
local Position = class("Position", ECS.Component)
function Position:initialize(x, y)
    ECS.Component.initialize(self)
    self.x = x or 0
    self.y = y or 0
end

-- Create a velocity component
local Velocity = class("Velocity", ECS.Component)
function Velocity:initialize(dx, dy)
    ECS.Component.initialize(self)
    self.dx = dx or 0
    self.dy = dy or 0
end

-- Create a movement system
local MovementSystem = class("MovementSystem", ECS.System)
function MovementSystem:update(dt)
    local entities = self.world:getEntitiesWith(Position, Velocity)
    for _, entity in ipairs(entities) do
        local pos = entity:getComponent(Position)
        local vel = entity:getComponent(Velocity)
        pos.x = pos.x + vel.dx * dt
        pos.y = pos.y + vel.dy * dt
    end
end

-- Create an entity with components
local player = ECS.Entity()
player:addComponent(Position(100, 100))
player:addComponent(Velocity(50, 0))

-- Add entity and system to world
world:addEntity(player)
world:addSystem(MovementSystem())

-- In your game loop
function love.update(dt)
    world:update(dt)
end
```

## Core Classes

### Entity

Entities are containers for components. They represent objects in your game world.

#### Methods

* `addComponent(component)` - Adds a component to the entity
* `removeComponent(component)` - Removes a component from the entity
* `getComponent(componentClass)` - Retrieves a component of the specified type
* `onCollision(other)` - Override this to handle collisions with other entities

#### Example

```lua
local entity = ECS.Entity()
entity:addComponent(Position(10, 20))
entity:addComponent(Velocity(5, 0))

local pos = entity:getComponent(Position)
print(pos.x, pos.y) -- Output: 10, 20
```

### Component

Components are data containers that can be attached to entities. They should contain no logic, only data.

#### Lifecycle Hooks

* `onAdd()` - Called when the component is added to an entity
* `onRemove()` - Called when the component is removed from an entity

#### Example

```lua
local Health = class("Health", ECS.Component)
function Health:initialize(max)
    ECS.Component.initialize(self)
    self.max = max or 100
    self.current = self.max
end

function Health:onAdd()
    print("Health component added to entity")
end

function Health:onRemove()
    print("Health component removed from entity")
end
```

### System

Systems contain the logic that operates on entities with specific components. They process entities during the game loop.

#### Methods

* `update(dt)` - Override this for game logic updates
* `draw()` - Override this for rendering
* `onEntityAdded(entity)` - Called when an entity is added to the world
* `onApplicationClose()` - Called when the application is closing

#### Example

```lua
local RenderSystem = class("RenderSystem", ECS.System)
function RenderSystem:draw()
    local entities = self.world:getEntitiesWith(Position, Sprite)
    for _, entity in ipairs(entities) do
        local pos = entity:getComponent(Position)
        local sprite = entity:getComponent(Sprite)
        love.graphics.draw(sprite.image, pos.x, pos.y)
    end
end
```

### World

The world manages all entities and systems. It coordinates the game loop and provides entity queries.

#### Methods

* `addEntity(entity)` - Adds an entity to the world
* `removeEntity(entity)` - Removes an entity from the world
* `addSystem(system)` - Adds a system to the world
* `getEntitiesWith(...)` - Returns entities that have all specified components
* `update(dt)` - Updates all systems
* `draw()` - Draws all systems
* `onApplicationClose()` - Notifies systems of application shutdown

#### Example

```lua
local world = ECS.World()

-- Add systems
world:addSystem(MovementSystem())
world:addSystem(RenderSystem())

-- Query entities
local movableEntities = world:getEntitiesWith(Position, Velocity)
```

## Complete Example

Here's a more comprehensive example showing a simple game with multiple entities and systems:

```lua
local ECS = require("lovely-ecs")
local class = require("middleclass")

-- Components
local Position = class("Position", ECS.Component)
function Position:initialize(x, y)
    ECS.Component.initialize(self)
    self.x, self.y = x or 0, y or 0
end

local Velocity = class("Velocity", ECS.Component)
function Velocity:initialize(dx, dy)
    ECS.Component.initialize(self)
    self.dx, self.dy = dx or 0, dy or 0
end

local Health = class("Health", ECS.Component)
function Health:initialize(max)
    ECS.Component.initialize(self)
    self.max = max or 100
    self.current = self.max
end

local Sprite = class("Sprite", ECS.Component)
function Sprite:initialize(image)
    ECS.Component.initialize(self)
    self.image = image
end

-- Systems
local MovementSystem = class("MovementSystem", ECS.System)
function MovementSystem:update(dt)
    local entities = self.world:getEntitiesWith(Position, Velocity)
    for _, entity in ipairs(entities) do
        local pos = entity:getComponent(Position)
        local vel = entity:getComponent(Velocity)
        pos.x = pos.x + vel.dx * dt
        pos.y = pos.y + vel.dy * dt
    end
end

local RenderSystem = class("RenderSystem", ECS.System)
function RenderSystem:draw()
    local entities = self.world:getEntitiesWith(Position, Sprite)
    for _, entity in ipairs(entities) do
        local pos = entity:getComponent(Position)
        local sprite = entity:getComponent(Sprite)
        love.graphics.draw(sprite.image, pos.x, pos.y)
    end
end

-- Game setup
local world = ECS.World()
world:addSystem(MovementSystem())
world:addSystem(RenderSystem())

-- Create entities
local player = ECS.Entity()
player:addComponent(Position(100, 100))
player:addComponent(Velocity(50, 0))
player:addComponent(Health(100))
player:addComponent(Sprite(love.graphics.newImage("player.png")))

world:addEntity(player)

-- Game loop integration
function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end

function love.quit()
    world:onApplicationClose()
end
```

## Best Practices

### Component Design

* Keep components as pure data containers
* Avoid putting logic in components
* Use descriptive names for component properties
* Initialize all component properties in the constructor

### System Design

* Each system should have a single responsibility
* Use `world:getEntitiesWith()` to query for relevant entities
* Keep systems independent of each other when possible
* Handle edge cases (empty entity lists, missing components)

### Entity Management

* Create factory functions for common entity types
* Remove entities when they're no longer needed
* Use meaningful names for entity variables

### Performance Tips

* Cache entity queries in systems when possible
* Remove unused entities to prevent memory leaks
* Consider object pooling for frequently created/destroyed entities
* Profile your systems to identify bottlenecks

## Dependencies

* **middleclass**: Object-oriented programming library for Lua (included as `modified_middleclass.lua`)

## License

This project is open source. Please refer to the individual license files for more information.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Credits

Built with ❤️ for the LÖVE community.