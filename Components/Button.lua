-- RGBUI/Components/Button.lua

local Core = require(script.Parent.Core)

local Button = {}
Button.__index = Button
setmetatable(Button, {__index = Core})

-- Create a new button with specified text.
function Button.new(text)
    local self = Core.new("TextButton")
    setmetatable(self, Button)
    self.Instance.Text = text or "Button"
    self.Instance.AutoButtonColor = false  -- Manage colors via themes.

    -- Connect the native click event to our custom event system.
    self.Instance.MouseButton1Click:Connect(function()
        self:Emit("Click")
    end)
    return self
end

-- Set the button's displayed text.
function Button:SetText(newText)
    self.Instance.Text = newText
    return self
end

-- Apply a theme to the button (colors, font, etc.).
function Button:SetTheme(theme)
    if theme.BackgroundColor then
        self.Instance.BackgroundColor3 = theme.BackgroundColor
    end
    if theme.TextColor then
        self.Instance.TextColor3 = theme.TextColor
    end
    if theme.Font then
        self.Instance.Font = theme.Font
    end
    if theme.TextSize then
        self.Instance.TextSize = theme.TextSize
    end
    return self
end

return Button
