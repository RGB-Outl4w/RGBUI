-- RGBUI/Core/Core.lua

local TweenService = game:GetService("TweenService")

local Core = {}
Core.__index = Core

-- Creates a new UI element of a given Roblox Instance type.
function Core.new(instanceType)
    local self = setmetatable({}, Core)
    self.Instance = Instance.new(instanceType)
    self.Events = {}
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

return Core
