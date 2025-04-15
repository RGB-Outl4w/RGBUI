-- RGBUI/Example/AdvancedUI.lua

-- Create a ScreenGui and parent it to the local player's PlayerGui.
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Load the library from the init.lua entry point.
local RGBUI = require(script.Parent.Parent)

-- Enable debug mode for development
RGBUI.Debug.setEnabled(true)
RGBUI.Debug.setLogLevel(RGBUI.Debug.LogLevel.INFO)

-- Create a custom theme based on the default theme
local CustomTheme = RGBUI.Theme.register("Custom", {
    Button = {
        BackgroundColor = Color3.fromRGB(45, 52, 54),
        TextColor = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
    },
    Panel = {
        BackgroundColor = Color3.fromRGB(30, 39, 46),
        BackgroundTransparency = 0,
    },
    Slider = {
        TrackColor = Color3.fromRGB(45, 52, 54),
        FillColor = Color3.fromRGB(85, 239, 196),
        HandleColor = Color3.fromRGB(255, 255, 255),
    },
    Checkbox = {
        BoxColor = Color3.fromRGB(45, 52, 54),
        CheckColor = Color3.fromRGB(85, 239, 196),
        TextColor = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
    },
    TextInput = {
        BackgroundColor = Color3.fromRGB(45, 52, 54),
        TextColor = Color3.fromRGB(255, 255, 255),
        PlaceholderColor = Color3.fromRGB(178, 190, 195),
        Font = Enum.Font.Gotham,
        TextSize = 16,
    },
})

-- Set the active theme
RGBUI.Theme.setActive("Custom")

-- Create a main panel using VStack layout
local mainPanel = RGBUI.Layouts.VStack.new()
mainPanel
    :SetSize(UDim2.new(0, 500, 0, 400))
    :SetPosition(UDim2.new(0.5, -250, 0.5, -200))
    :SetAnchorPoint(Vector2.new(0.5, 0.5))
    :SetTheme(CustomTheme.Data.Panel)
    :SetPadding(10, 10, 10, 10)
    :SetSpacing(10)
    :SetParent(ScreenGui)

-- Create a header using HStack
local header = RGBUI.Layouts.HStack.new()
header
    :SetSize(UDim2.new(1, 0, 0, 50))
    :SetAlignment("Center")

-- Add a title to the header
local title = RGBUI.new("TextLabel")
title
    :SetSize(UDim2.new(1, 0, 1, 0))
    :SetText("RGBUI Advanced Demo")
    :SetTheme({
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        BackgroundTransparency = 1,
    })

-- Add the title to the header
header:AddChild(title)

-- Add the header to the main panel
mainPanel:AddChild(header)

-- Create a content area using HStack for side-by-side layout
local content = RGBUI.Layouts.HStack.new()
content
    :SetSize(UDim2.new(1, 0, 1, -60))
    :SetSpacing(10)

-- Create a sidebar using VStack
local sidebar = RGBUI.Layouts.VStack.new()
sidebar
    :SetSize(UDim2.new(0.3, 0, 1, 0))
    :SetSpacing(5)
    :SetTheme({
        BackgroundColor3 = Color3.fromRGB(20, 25, 30),
        BackgroundTransparency = 0,
    })

-- Create main content area using VStack
local mainContent = RGBUI.Layouts.VStack.new()
mainContent
    :SetSize(UDim2.new(0.7, 0, 1, 0))
    :SetSpacing(10)
    :SetPadding(10, 10, 10, 10)
    :SetTheme({
        BackgroundColor3 = Color3.fromRGB(25, 30, 35),
        BackgroundTransparency = 0,
    })

-- Add buttons to the sidebar
local menuItems = {"Dashboard", "Profile", "Settings", "Help"}

for i, item in ipairs(menuItems) do
    local button = RGBUI.Components.Button.new(item)
    button
        :SetSize(UDim2.new(1, -10, 0, 40))
        :SetTheme(CustomTheme.Data.Button)
        :On("Click", function()
            RGBUI.Debug.info("Clicked on " .. item)
            
            -- Animate the button
            button:AnimateWithPreset("scaleIn", 0.3, {
                BackgroundColor3 = Color3.fromRGB(85, 239, 196)
            })
            
            -- Reset after animation
            wait(0.5)
            button:SetTheme(CustomTheme.Data.Button)
        end)
        :MakeFocusable(i) -- Make focusable for keyboard navigation
    
    sidebar:AddChild(button)
end

-- Add form elements to the main content
local formTitle = RGBUI.new("TextLabel")
formTitle
    :SetSize(UDim2.new(1, 0, 0, 30))
    :SetText("User Settings")
    :SetTheme({
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        BackgroundTransparency = 1,
    })

mainContent:AddChild(formTitle)

-- Create a form grid
local formGrid = RGBUI.Layouts.Grid.new(2, 0)
formGrid
    :SetSize(UDim2.new(1, 0, 0, 200))
    :SetCellSize(UDim2.new(0.5, -5, 0, 40))
    :SetSpacing(10, 10)

-- Add form elements
local nameLabel = RGBUI.new("TextLabel")
nameLabel
    :SetText("Username:")
    :SetTheme({
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

local nameInput = RGBUI.Components.TextInput.new("Enter username")
nameInput
    :SetTheme(CustomTheme.Data.TextInput)
    :MakeFocusable(5)

local ageLabel = RGBUI.new("TextLabel")
ageLabel
    :SetText("Age:")
    :SetTheme({
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

local ageSlider = RGBUI.Components.Slider.new(1, 100, 18)
ageSlider
    :SetTheme(CustomTheme.Data.Slider)
    :MakeFocusable(6)

local notifyLabel = RGBUI.new("TextLabel")
notifyLabel
    :SetText("Notifications:")
    :SetTheme({
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

local notifyCheckbox = RGBUI.Components.Checkbox.new("Enable notifications")
notifyCheckbox
    :SetTheme(CustomTheme.Data.Checkbox)
    :MakeFocusable(7)

-- Add elements to the form grid
formGrid:AddChild(nameLabel)
formGrid:AddChild(nameInput)
formGrid:AddChild(ageLabel)
formGrid:AddChild(ageSlider)
formGrid:AddChild(notifyLabel)
formGrid:AddChild(notifyCheckbox)

-- Add the form grid to the main content
mainContent:AddChild(formGrid)

-- Add a submit button
local submitButton = RGBUI.Components.Button.new("Save Settings")
submitButton
    :SetSize(UDim2.new(0, 150, 0, 40))
    :SetTheme({
        BackgroundColor = Color3.fromRGB(85, 239, 196),
        TextColor = Color3.fromRGB(20, 25, 30),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
    })
    :On("Click", function()
        -- Show animation
        submitButton:AnimateWithPreset("scaleIn", 0.3)
        
        -- Get form values
        local username = nameInput.Instance.Text
        local age = ageSlider:GetValue()
        local notifications = notifyCheckbox:IsChecked()
        
        -- Log the values
        RGBUI.Debug.info("Form submitted with values:")
        RGBUI.Debug.info("Username: " .. username)
        RGBUI.Debug.info("Age: " .. age)
        RGBUI.Debug.info("Notifications: " .. tostring(notifications))
    end)
    :MakeFocusable(8)

mainContent:AddChild(submitButton)

-- Add sidebar and main content to the content area
content:AddChild(sidebar)
content:AddChild(mainContent)

-- Add the content area to the main panel
mainPanel:AddChild(content)

-- Make the UI responsive
local function updateResponsiveLayout()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    if viewportSize.X < 800 then
        -- Mobile layout
        mainPanel:SetSize(UDim2.new(0.95, 0, 0.9, 0))
        mainPanel:SetPosition(UDim2.new(0.5, 0, 0.5, 0))
        
        -- Stack content vertically instead of horizontally
        content:SetSize(UDim2.new(1, 0, 1, -60))
        sidebar:SetSize(UDim2.new(1, 0, 0, 200))
        mainContent:SetSize(UDim2.new(1, 0, 1, -210))
        
        -- Update layout containers
        content:UpdateLayout()
    else
        -- Desktop layout
        mainPanel:SetSize(UDim2.new(0, 500, 0, 400))
        mainPanel:SetPosition(UDim2.new(0.5, -250, 0.5, -200))
        
        -- Side-by-side layout
        sidebar:SetSize(UDim2.new(0.3, 0, 1, 0))
        mainContent:SetSize(UDim2.new(0.7, 0, 1, 0))
        
        -- Update layout containers
        content:UpdateLayout()
    end
end

-- Initial layout update
updateResponsiveLayout()

-- Connect to viewport size changed event for responsive layout
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout)

-- Animate the panel when it first appears
mainPanel.Instance.BackgroundTransparency = 1
title.Instance.TextTransparency = 1

-- Sequence of animations
mainPanel:AnimateSequence({
    {
        properties = { BackgroundTransparency = 0 },
        duration = 0.5,
        easingStyle = Enum.EasingStyle.Sine,
        easingDirection = Enum.EasingDirection.Out
    },
    {
        properties = { Size = UDim2.new(0, 520, 0, 420) },
        duration = 0.2,
        easingStyle = Enum.EasingStyle.Back,
        easingDirection = Enum.EasingDirection.Out
    },
    {
        properties = { Size = UDim2.new(0, 500, 0, 400) },
        duration = 0.1,
        easingStyle = Enum.EasingStyle.Sine,
        easingDirection = Enum.EasingDirection.Out
    }
})

-- Animate the title separately
title:AnimateWithPreset("fadeIn", 0.8)

-- Print instructions
print("\n=== RGBUI Advanced Demo ===\n")
print("This demo showcases the following features:")
print("- Layout containers (VStack, HStack, Grid)")
print("- Dynamic theming")
print("- Smooth animations and transitions")
print("- Fluent, chainable API")
print("- UI responsiveness (try resizing the window)")
print("- Keyboard navigation (use Tab key to navigate)")
print("\nPress Tab to start keyboard navigation")