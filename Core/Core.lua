-- RGBUI/Core/Core.lua

local TweenService = game:GetService("TweenService")

-- Load core modules
local Debug = require(script.Parent.Debug)
local Theme = nil -- Will be required after initialization to avoid circular dependencies
local Registry = nil -- Will be required after initialization
local Responsive = nil -- Will be required after initialization
local Navigation = nil -- Will be required after initialization

local Core = {}
Core.__index = Core

-- Version information
Core.Version = "1.0.0"

-- Creates a new UI element of a given Roblox Instance type.
function Core.new(instanceType)
    local self = setmetatable({}, Core)
    self.Instance = Instance.new(instanceType)
    self.Events = {}
    self.__type = instanceType -- Store the type for debugging
    
    -- Add to registry for theme updates if applicable
    if Registry then
        Registry.registerForThemeUpdates(self, instanceType)
    end
    
    return self
end

-- Set the UI element's position.
function Core:SetPosition(position)
    self.Instance.Position = position
    return self
end

-- Set the UI element's size.
function Core:SetSize(size)
    self.Instance.Size = size
    return self
end

-- Set the parent of the UI element.
function Core:SetParent(parent)
    self.Instance.Parent = parent
    return self
end

-- Toggle the UI element's visibility.
function Core:SetVisible(visible)
    self.Instance.Visible = visible
    return self
end

-- Bind an event callback to a custom event.
function Core:On(eventName, callback)
    if not self.Events[eventName] then self.Events[eventName] = {} end
    table.insert(self.Events[eventName], callback)
    return self
end

-- Emit a custom event to notify all bound callbacks.
function Core:Emit(eventName, ...)
    if self.Events[eventName] then
        for _, callback in ipairs(self.Events[eventName]) do
            callback(...)
        end
    end
end

-- Animate properties using TweenService.
function Core:Animate(properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(self.Instance, tweenInfo, properties)
    tween:Play()
    return self, tween
end

-- Enhanced animation with presets
function Core:AnimateWithPreset(preset, duration, properties)
    local presetInfo = {
        fadeIn = {
            properties = { BackgroundTransparency = 0, TextTransparency = 0 },
            easingStyle = Enum.EasingStyle.Sine,
            easingDirection = Enum.EasingDirection.Out
        },
        fadeOut = {
            properties = { BackgroundTransparency = 1, TextTransparency = 1 },
            easingStyle = Enum.EasingStyle.Sine,
            easingDirection = Enum.EasingDirection.In
        },
        slideIn = {
            properties = { Position = UDim2.new(0.5, 0, 0.5, 0) },
            easingStyle = Enum.EasingStyle.Back,
            easingDirection = Enum.EasingDirection.Out
        },
        slideOut = {
            properties = { Position = UDim2.new(1.5, 0, 0.5, 0) },
            easingStyle = Enum.EasingStyle.Quint,
            easingDirection = Enum.EasingDirection.In
        },
        scaleIn = {
            properties = { Size = UDim2.new(1, 0, 1, 0) },
            easingStyle = Enum.EasingStyle.Elastic,
            easingDirection = Enum.EasingDirection.Out
        },
        scaleOut = {
            properties = { Size = UDim2.new(0, 0, 0, 0) },
            easingStyle = Enum.EasingStyle.Quint,
            easingDirection = Enum.EasingDirection.In
        }
    }
    
    local presetData = presetInfo[preset]
    if not presetData then
        Debug.warn("Animation preset '" .. preset .. "' not found. Using default animation.")
        return self:Animate(properties, duration)
    end
    
    -- Merge custom properties with preset properties
    local finalProperties = {}
    for k, v in pairs(presetData.properties) do
        finalProperties[k] = v
    end
    if properties then
        for k, v in pairs(properties) do
            finalProperties[k] = v
        end
    end
    
    return self:Animate(
        finalProperties, 
        duration or 0.5, 
        presetData.easingStyle, 
        presetData.easingDirection
    )
end

-- Chain multiple animations in sequence
function Core:AnimateSequence(animations)
    if not animations or #animations == 0 then return self end
    
    local currentAnimation = 1
    local function playNextAnimation()
        if currentAnimation > #animations then return end
        
        local anim = animations[currentAnimation]
        local _, tween = self:Animate(anim.properties, anim.duration, anim.easingStyle, anim.easingDirection)
        
        currentAnimation = currentAnimation + 1
        tween.Completed:Connect(playNextAnimation)
    end
    
    playNextAnimation()
    return self
end

-- Make component focusable for keyboard/gamepad navigation
function Core:MakeFocusable(tabOrder)
    if Navigation then
        Navigation.registerFocusable(self, tabOrder)
    end
    return self
end

-- Initialize Core module and its dependencies
function Core.init()
    -- Require modules after Core is defined to avoid circular dependencies
    Theme = require(script.Parent.Theme)
    Registry = require(script.Parent.Registry)
    Responsive = require(script.Parent.Responsive)
    Navigation = require(script.Parent.Navigation)
    
    -- Initialize modules
    Registry.init()
    Responsive.init()
    Navigation.init()
    
    -- Extend Core with responsive methods
    Responsive.extendCore(Core)
    
    Debug.info("RGBUI Core initialized (v" .. Core.Version .. ")")
    return Core
end

return Core
