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
}

Default.Slider = {
    TrackColor = Color3.fromRGB(50, 50, 50),
    FillColor = Color3.fromRGB(0, 120, 255),
    HandleColor = Color3.fromRGB(255, 255, 255),
}

Default.Checkbox = {
    BoxColor = Color3.fromRGB(50, 50, 50),
    CheckColor = Color3.fromRGB(255, 255, 255),
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

return Default
