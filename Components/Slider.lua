-- RGBUI/Components/Slider.lua

local Core = require(script.Parent.Core)

local Slider = {}
Slider.__index = Slider
setmetatable(Slider, {__index = Core})

-- Create a new slider with specified min, max, and default values.
function Slider.new(min, max, default)
    local self = Core.new("Frame")
    setmetatable(self, Slider)
    
    -- Set default values
    self.Min = min or 0
    self.Max = max or 100
    self.Value = default or self.Min
    
    -- Create the background track
    self.Track = Instance.new("Frame")
    self.Track.Name = "Track"
    self.Track.Size = UDim2.new(1, 0, 0, 6)
    self.Track.Position = UDim2.new(0, 0, 0.5, -3)
    self.Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    self.Track.BorderSizePixel = 0
    self.Track.Parent = self.Instance
    
    -- Create the fill bar
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
    self.Fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    self.Fill.BorderSizePixel = 0
    self.Fill.Parent = self.Track
    
    -- Create the handle
    self.Handle = Instance.new("TextButton")
    self.Handle.Name = "Handle"
    self.Handle.Size = UDim2.new(0, 16, 0, 16)
    self.Handle.Position = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), -8, 0.5, -8)
    self.Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Handle.BorderSizePixel = 0
    self.Handle.Text = ""
    self.Handle.Parent = self.Track
    
    -- Set up dragging functionality
    local isDragging = false
    
    self.Handle.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeX = input.Position.X - self.Track.AbsolutePosition.X
            local percentage = math.clamp(relativeX / self.Track.AbsoluteSize.X, 0, 1)
            self:SetValue(self.Min + (self.Max - self.Min) * percentage)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - self.Track.AbsolutePosition.X
            local percentage = math.clamp(relativeX / self.Track.AbsoluteSize.X, 0, 1)
            self:SetValue(self.Min + (self.Max - self.Min) * percentage)
        end
    end)
    
    return self
end

-- Set the slider's value
function Slider:SetValue(value)
    local newValue = math.clamp(value, self.Min, self.Max)
    self.Value = newValue
    
    -- Update the fill and handle positions
    local percentage = (newValue - self.Min) / (self.Max - self.Min)
    self.Fill.Size = UDim2.new(percentage, 0, 1, 0)
    self.Handle.Position = UDim2.new(percentage, -8, 0.5, -8)
    
    -- Emit the value change event
    self:Emit("ValueChanged", newValue)
    return self
end

-- Get the current value
function Slider:GetValue()
    return self.Value
end

-- Apply a theme to the slider
function Slider:SetTheme(theme)
    if theme.TrackColor then
        self.Track.BackgroundColor3 = theme.TrackColor
    end
    if theme.FillColor then
        self.Fill.BackgroundColor3 = theme.FillColor
    end
    if theme.HandleColor then
        self.Handle.BackgroundColor3 = theme.HandleColor
    end
    return self
end

return Slider