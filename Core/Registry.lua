-- RGBUI/Core/Registry.lua

local Theme = require(script.Parent.Theme)

local Registry = {}

-- Store for all registered components
local componentRegistry = {}

-- Store for themed components that need updates when theme changes
local themedComponents = {}

-- Register a component class
function Registry.registerComponent(name, componentClass)
    if componentRegistry[name] then
        warn("Component '" .. name .. "' is already registered. Overwriting.")
    end
    
    componentRegistry[name] = componentClass
    return componentClass
end

-- Get a registered component class by name
function Registry.getComponent(name)
    return componentRegistry[name]
end

-- Create a new instance of a registered component
function Registry.create(name, ...)
    local componentClass = componentRegistry[name]
    
    if not componentClass then
        error("Component '" .. name .. "' is not registered")
        return nil
    end
    
    return componentClass.new(...)
end

-- Register a component instance for theme updates
function Registry.registerForThemeUpdates(component, componentType)
    if not component or not componentType then return end
    
    -- Add to themed components list
    table.insert(themedComponents, {
        component = component,
        type = componentType
    })
    
    -- Apply current theme if available
    local activeTheme = Theme.getActive()
    if activeTheme and activeTheme.Data[componentType] then
        component:SetTheme(activeTheme.Data[componentType])
    end
    
    return component
end

-- Apply theme to all registered components
function Registry.applyThemeToAll(theme)
    if not theme then return end
    
    for _, entry in ipairs(themedComponents) do
        local component = entry.component
        local componentType = entry.type
        
        -- Check if component still exists
        if component and component.Instance and theme.Data[componentType] then
            component:SetTheme(theme.Data[componentType])
        end
    end
end

-- Create a new component class that inherits from a base class
function Registry.extend(baseClass, newClassName)
    local newClass = {}
    newClass.__index = newClass
    setmetatable(newClass, {__index = baseClass})
    
    -- Add the new class to registry if name is provided
    if newClassName then
        Registry.registerComponent(newClassName, newClass)
    end
    
    return newClass
end

-- Initialize the registry
function Registry.init()
    -- Connect to Theme system
    Theme.onThemeChanged = Registry.applyThemeToAll
    
    -- Register built-in components
    -- This will be populated when we update init.lua
    
    return Registry
end

return Registry