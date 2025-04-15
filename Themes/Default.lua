-- RGBUI/Themes/Default.lua

local Default = {}

Default.Button = {
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 18,
}

Default.Panel = {
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0,
}

Default.Slider = {
    TrackColor = Color3.fromRGB(50, 50, 50),
    FillColor = Color3.fromRGB(0, 120, 255),
    HandleColor = Color3.fromRGB(255, 255, 255),
}

Default.Checkbox = {
    BoxColor = Color3.fromRGB(50, 50, 50),
    CheckColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 18,
}

Default.TextInput = {
    BackgroundColor = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    PlaceholderColor = Color3.fromRGB(150, 150, 150),
    Font = Enum.Font.SourceSans,
    TextSize = 16,
}

Default.Dropdown = {
    BackgroundColor = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 16,
}

-- Add theme properties for layout containers
Default.VStack = {
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 1, -- Transparent by default
}

Default.HStack = {
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 1, -- Transparent by default
}

Default.Grid = {
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 1, -- Transparent by default
}

-- Add theme properties for focus indicators
Default.Focus = {
    BorderColor = Color3.fromRGB(0, 120, 255),
    BorderThickness = 2,
}

-- Add theme properties for text elements
Default.Text = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    BackgroundTransparency = 1,
}

return Default
