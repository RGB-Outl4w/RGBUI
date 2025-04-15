-- RGBUI/Core/Theme.lua

local Theme = {}
Theme.__index = Theme

-- Current active theme
local activeTheme = nil

-- Theme registry to store all registered themes
local themeRegistry = {}

-- Create a new theme
function Theme.new(themeName, themeData)
    local self = setmetatable({}, Theme)
    self.Name = themeName
    self.Data = themeData or {}
    
    -- Register the theme
    themeRegistry[themeName] = self
    
    return self
 end

-- Register a theme from an existing table
function Theme.register(themeName, themeData)
    return Theme.new(themeName, themeData)
end

-- Get a registered theme by name
function Theme.get(themeName)
    return themeRegistry[themeName]
end

-- Set the active theme globally
function Theme.setActive(themeName)
    local theme = type(themeName) == "string" and themeRegistry[themeName] or themeName
    
    if not theme then
        error("Theme '" .. tostring(themeName) .. "' not found in registry")
        return
    end
    
    activeTheme = theme
    Theme.applyGlobally()
    return theme
end

-- Get the current active theme
function Theme.getActive()
    return activeTheme
end

-- Apply the active theme to all UI elements that have registered for theme updates
function Theme.applyGlobally()
    if not activeTheme then return end
    
    -- This will be implemented when we add component registration
    -- We'll store references to themed components and update them here
end

-- Extend a theme with additional properties
function Theme:extend(newData)
    local extended = {}
    
    -- Copy existing theme data
    for k, v in pairs(self.Data) do
        extended[k] = v
    end
    
    -- Add new data
    for k, v in pairs(newData) do
        extended[k] = v
    end
    
    return Theme.new(self.Name .. "Extended", extended)
end

return Theme