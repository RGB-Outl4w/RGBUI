-- RGBUI/Components/TextInput.lua

local Core = require(script.Parent.Core)

local TextInput = {}
TextInput.__index = TextInput
setmetatable(TextInput, {__index = Core})

-- Create a new text input with specified placeholder text.
function TextInput.new(placeholder)
    local self = Core.new("Frame")
    setmetatable(self, TextInput)
    
    -- Create the text box
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Name = "TextBox"
    self.TextBox.Size = UDim2.new(1, 0, 1, 0)
    self.TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.TextBox.BorderSizePixel = 0
    self.TextBox.Text = ""
    self.TextBox.PlaceholderText = placeholder or "Enter text..."
    self.TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TextBox.TextSize = 16
    self.TextBox.Font = Enum.Font.SourceSans
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Parent = self.Instance
    
    -- Connect events
    self.TextBox.FocusLost:Connect(function(enterPressed)
        self:Emit("FocusLost", self.TextBox.Text, enterPressed)
    end)
    
    self.TextBox.Focused:Connect(function()
        self:Emit("Focused")
    end)
    
    self.TextBox.Changed:Connect(function(property)
        if property == "Text" then
            self:Emit("TextChanged", self.TextBox.Text)
        end
    end)
    
    return self
end

-- Set the text input's text
function TextInput:SetText(text)
    self.TextBox.Text = text or ""
    return self
end

-- Get the current text
function TextInput:GetText()
    return self.TextBox.Text
end

-- Set the placeholder text
function TextInput:SetPlaceholder(text)
    self.TextBox.PlaceholderText = text or ""
    return self
end

-- Apply a theme to the text input
function TextInput:SetTheme(theme)
    if theme.BackgroundColor then
        self.TextBox.BackgroundColor3 = theme.BackgroundColor
    end
    if theme.TextColor then
        self.TextBox.TextColor3 = theme.TextColor
    end
    if theme.PlaceholderColor then
        self.TextBox.PlaceholderColor3 = theme.PlaceholderColor
    end
    if theme.Font then
        self.TextBox.Font = theme.Font
    end
    if theme.TextSize then
        self.TextBox.TextSize = theme.TextSize
    end
    return self
end

return TextInput