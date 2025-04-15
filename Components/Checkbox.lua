-- RGBUI/Components/Checkbox.lua

local Core = require(script.Parent.Core)

local Checkbox = {}
Checkbox.__index = Checkbox
setmetatable(Checkbox, {__index = Core})

-- Create a new checkbox with specified checked state.
function Checkbox.new(checked)
    local self = Core.new("Frame")
    setmetatable(self, Checkbox)
    
    -- Set default values
    self.Checked = checked or false
    
    -- Create the box frame
    self.Box = Instance.new("Frame")
    self.Box.Name = "Box"
    self.Box.Size = UDim2.new(1, 0, 1, 0)
    self.Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    self.Box.BorderSizePixel = 0
    self.Box.Parent = self.Instance
    
    -- Create the checkmark
    self.Checkmark = Instance.new("TextLabel")
    self.Checkmark.Name = "Checkmark"
    self.Checkmark.Size = UDim2.new(1, 0, 1, 0)
    self.Checkmark.BackgroundTransparency = 1
    self.Checkmark.Text = "✓"
    self.Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Checkmark.TextSize = 18
    self.Checkmark.Font = Enum.Font.SourceSans
    self.Checkmark.Visible = self.Checked
    self.Checkmark.Parent = self.Box
    
    -- Create the click detector
    self.ClickDetector = Instance.new("TextButton")
    self.ClickDetector.Name = "ClickDetector"
    self.ClickDetector.Size = UDim2.new(1, 0, 1, 0)
    self.ClickDetector.BackgroundTransparency = 1
    self.ClickDetector.Text = ""
    self.ClickDetector.Parent = self.Instance
    
    -- Connect the click event
    self.ClickDetector.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    return self
end

-- Toggle the checkbox state
function Checkbox:Toggle()
    self.Checked = not self.Checked
    self.Checkmark.Visible = self.Checked
    self:Emit("ValueChanged", self.Checked)
    return self
end

-- Set the checkbox state
function Checkbox:SetChecked(checked)
    if self.Checked ~= checked then
        self.Checked = checked
        self.Checkmark.Visible = checked
        self:Emit("ValueChanged", checked)
    end
    return self
end

-- Get the current checked state
function Checkbox:IsChecked()
    return self.Checked
end

-- Apply a theme to the checkbox
function Checkbox:SetTheme(theme)
    if theme.BoxColor then
        self.Box.BackgroundColor3 = theme.BoxColor
    end
    if theme.CheckColor then
        self.Checkmark.TextColor3 = theme.CheckColor
    end
    if theme.Font then
        self.Checkmark.Font = theme.Font
    end
    if theme.TextSize then
        self.Checkmark.TextSize = theme.TextSize
    end
    return self
end

return Checkbox