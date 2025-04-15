-- RGBUI/Components/Dropdown.lua

local Core = require(script.Parent.Core)

local Dropdown = {}
Dropdown.__index = Dropdown
setmetatable(Dropdown, {__index = Core})

-- Create a new dropdown with specified options.
function Dropdown.new(options, defaultOption)
    local self = Core.new("Frame")
    setmetatable(self, Dropdown)
    
    -- Set default values
    self.Options = options or {}
    self.SelectedOption = defaultOption or (options and options[1] or "")
    self.IsOpen = false
    
    -- Create the main button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "Button"
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.Button.BorderSizePixel = 0
    self.Button.Text = self.SelectedOption
    self.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Button.TextSize = 16
    self.Button.Font = Enum.Font.SourceSans
    self.Button.Parent = self.Instance
    
    -- Create the arrow indicator
    self.Arrow = Instance.new("TextLabel")
    self.Arrow.Name = "Arrow"
    self.Arrow.Size = UDim2.new(0, 20, 0, 20)
    self.Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.Text = "▼"
    self.Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.Arrow.TextSize = 14
    self.Arrow.Font = Enum.Font.SourceSans
    self.Arrow.Parent = self.Button
    
    -- Create the dropdown container
    self.DropdownContainer = Instance.new("Frame")
    self.DropdownContainer.Name = "DropdownContainer"
    self.DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
    self.DropdownContainer.Position = UDim2.new(0, 0, 1, 0)
    self.DropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    self.DropdownContainer.BorderSizePixel = 0
    self.DropdownContainer.Visible = false
    self.DropdownContainer.ZIndex = 10
    self.DropdownContainer.Parent = self.Instance
    
    -- Connect the button click event
    self.Button.MouseButton1Click:Connect(function()
        self:ToggleDropdown()
    end)
    
    -- Populate the dropdown with options
    self:SetOptions(self.Options)
    
    return self
end

-- Toggle the dropdown visibility
function Dropdown:ToggleDropdown()
    self.IsOpen = not self.IsOpen
    self.DropdownContainer.Visible = self.IsOpen
    self.Arrow.Text = self.IsOpen and "▲" or "▼"
    return self
end

-- Close the dropdown
function Dropdown:CloseDropdown()
    self.IsOpen = false
    self.DropdownContainer.Visible = false
    self.Arrow.Text = "▼"
    return self
end

-- Set the dropdown options
function Dropdown:SetOptions(options)
    self.Options = options or {}
    
    -- Clear existing options
    for _, child in pairs(self.DropdownContainer:GetChildren()) do
        child:Destroy()
    end
    
    -- Calculate total height based on number of options
    local optionHeight = 30
    self.DropdownContainer.Size = UDim2.new(1, 0, 0, #self.Options * optionHeight)
    
    -- Create option buttons
    for i, option in ipairs(self.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. i
        optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * optionHeight)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 16
        optionButton.Font = Enum.Font.SourceSans
        optionButton.ZIndex = 11
        optionButton.Parent = self.DropdownContainer
        
        -- Connect option click event
        optionButton.MouseButton1Click:Connect(function()
            self:SelectOption(option)
        end)
    end
    
    return self
end

-- Select an option from the dropdown
function Dropdown:SelectOption(option)
    self.SelectedOption = option
    self.Button.Text = option
    self:CloseDropdown()
    self:Emit("OptionSelected", option)
    return self
end

-- Get the currently selected option
function Dropdown:GetSelectedOption()
    return self.SelectedOption
end

-- Apply a theme to the dropdown
function Dropdown:SetTheme(theme)
    if theme.BackgroundColor then
        self.Button.BackgroundColor3 = theme.BackgroundColor
        
        -- Apply a slightly darker color to the dropdown container
        local r, g, b = theme.BackgroundColor.R, theme.BackgroundColor.G, theme.BackgroundColor.B
        self.DropdownContainer.BackgroundColor3 = Color3.fromRGB(
            math.max(r * 255 - 10, 0),
            math.max(g * 255 - 10, 0),
            math.max(b * 255 - 10, 0)
        )
        
        -- Update all option buttons
        for _, child in pairs(self.DropdownContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = self.DropdownContainer.BackgroundColor3
            end
        end
    end
    if theme.TextColor then
        self.Button.TextColor3 = theme.TextColor
        self.Arrow.TextColor3 = theme.TextColor
        
        -- Update all option buttons
        for _, child in pairs(self.DropdownContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.TextColor
            end
        end
    end
    if theme.Font then
        self.Button.Font = theme.Font
        self.Arrow.Font = theme.Font
        
        -- Update all option buttons
        for _, child in pairs(self.DropdownContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.Font = theme.Font
            end
        end
    end
    if theme.TextSize then
        self.Button.TextSize = theme.TextSize
        
        -- Update all option buttons
        for _, child in pairs(self.DropdownContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextSize = theme.TextSize
            end
        end
    end
    return self
end

return Dropdown