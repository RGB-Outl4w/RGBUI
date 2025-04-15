# Using RGBUI with loadstring

This document explains how to use the RGBUI library via loadstring from GitHub.

## Basic Usage

```lua
-- Load the RGBUI library directly from GitHub
local RGBUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/RGB-Outl4w/RGBUI/main/init.lua'))() 

-- Create a ScreenGui to hold our UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a button
local myButton = RGBUI.Components.Button.new("Click Me!")
myButton
    :SetPosition(UDim2.new(0.5, -50, 0.5, -25))
    :SetSize(UDim2.new(0, 100, 0, 50))
    :SetTheme(RGBUI.Themes.Default.Button)
    :On("Click", function()
        print("Button clicked!")
    end)
    :SetParent(screenGui)

-- Create a vertical stack layout
local vstack = RGBUI.Layouts.VStack.new()
vstack
    :SetPosition(UDim2.new(0.7, 0, 0.3, 0))
    :SetSize(UDim2.new(0, 200, 0, 300))
    :SetParent(screenGui)

-- Add some components to the stack
local checkbox = RGBUI.Components.Checkbox.new("Enable Feature")
checkbox:SetTheme(RGBUI.Themes.Default.Checkbox)
vstack:AddChild(checkbox)

local slider = RGBUI.Components.Slider.new(0, 100, 50)
slider:SetSize(UDim2.new(1, 0, 0, 30))
slider:SetTheme(RGBUI.Themes.Default.Slider)
vstack:AddChild(slider)

local dropdown = RGBUI.Components.Dropdown.new({"Option 1", "Option 2", "Option 3"})
dropdown:SetSize(UDim2.new(1, 0, 0, 30))
dropdown:SetTheme(RGBUI.Themes.Default.Dropdown)
vstack:AddChild(dropdown)
```

## Important Notes

1. The library has been modified to work with loadstring by inlining all modules directly in the init.lua file.

2. When using loadstring, you must use HttpGet to fetch the library from GitHub:
   ```lua
   local RGBUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/RGB-Outl4w/RGBUI/main/init.lua'))()
   ```

3. Replace `yourusername` in the URL with your actual GitHub username where the repository is hosted.

4. All components and layouts are accessible directly through the RGBUI table, just as they would be if you required the module locally.

5. The library includes built-in themes that can be applied to components using the SetTheme method.

## Custom Components

You can still create and register custom components:

```lua
-- Create a new component class
local MyComponent = {}
MyComponent.__index = MyComponent
setmetatable(MyComponent, {__index = RGBUI.Core})

-- Constructor
function MyComponent.new(text)
    local self = RGBUI.Core.new("Frame")
    setmetatable(self, MyComponent)
    
    -- Component setup...
    
    return self
end

-- Register the component
RGBUI.Registry.registerComponent("MyComponent", MyComponent)

-- Now it can be used like built-in components
local myComp = RGBUI.Registry.create("MyComponent", "Hello")
```