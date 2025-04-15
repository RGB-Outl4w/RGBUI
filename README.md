# RGBUI Library

RGBUI is a light, modern UI framework for Roblox that makes creating beautiful, responsive interfaces easy and intuitive.

## Features

### Layout Containers
Nest components with flexible layout containers:
- **VStack**: Vertical stack layout
- **HStack**: Horizontal stack layout
- **Grid**: Grid-based layout with rows and columns

### Dynamic Theming
- Global theme application
- Theme inheritance and extension
- Component-specific theme overrides

### Animations
- Smooth transitions via TweenService
- Animation presets (fade, slide, scale)
- Animation sequences

### Fluent API
- Chainable methods for all components
- Intuitive property setters

### Responsive Design
- UI responsiveness and autoscaling
- Anchor point management
- Aspect ratio constraints
- Screen size adaptation

### Component Registration
- Register custom components
- Component inheritance
- Theme application to registered components

### Error Handling
- Descriptive error messages
- Debug mode for development
- Visual debugging tools

### Keyboard/Gamepad Navigation
- Focus management
- Tab order
- Keyboard shortcuts
- Gamepad input mapping

## Getting Started

### Basic Usage

```lua
-- Load the library
local RGBUI = require(path.to.RGBUI)

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
```

### Using Layout Containers

```lua
-- Create a vertical stack layout
local vstack = RGBUI.Layouts.VStack.new()
vstack
    :SetSize(UDim2.new(0, 300, 0, 400))
    :SetPosition(UDim2.new(0.5, -150, 0.5, -200))
    :SetSpacing(10)
    :SetPadding(10, 10, 10, 10)
    :SetParent(screenGui)

-- Add buttons to the stack
for i = 1, 3 do
    local button = RGBUI.Components.Button.new("Button " .. i)
    button:SetSize(UDim2.new(1, 0, 0, 50))
    vstack:AddChild(button)
end
```

### Applying Themes

```lua
-- Create a custom theme
local myTheme = RGBUI.Theme.register("MyTheme", {
    Button = {
        BackgroundColor = Color3.fromRGB(45, 52, 54),
        TextColor = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
    },
    -- Add more component themes...
})

-- Set as active theme
RGBUI.Theme.setActive("MyTheme")
```

### Animations

```lua
-- Animate with preset
button:AnimateWithPreset("fadeIn", 0.5)

-- Custom animation
button:Animate(
    { BackgroundColor3 = Color3.fromRGB(0, 120, 255) },
    0.3,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Animation sequence
button:AnimateSequence({
    {
        properties = { Size = UDim2.new(0, 110, 0, 55) },
        duration = 0.2,
        easingStyle = Enum.EasingStyle.Back
    },
    {
        properties = { Size = UDim2.new(0, 100, 0, 50) },
        duration = 0.1
    }
})
```

### Keyboard Navigation

```lua
-- Make components focusable
button1:MakeFocusable(1) -- Tab order 1
button2:MakeFocusable(2) -- Tab order 2

-- Enable navigation
RGBUI.Navigation.setEnabled(true)
```

### Responsive Design

```lua
-- Apply aspect ratio
button:SetAspectRatio(2) -- Width is twice the height

-- Set anchor point
button:SetAnchorPoint(Vector2.new(0.5, 0.5)) -- Center anchor

-- Responsive sizing
button:SetResponsiveSize(RGBUI.Responsive.createSizeMap(
    UDim2.new(1, 0, 0, 40),  -- xs (mobile)
    UDim2.new(0.8, 0, 0, 50), -- sm (tablet)
    UDim2.new(0.5, 0, 0, 60)  -- md (desktop)
))
```

## Advanced Examples

Check out the `Example/AdvancedUI.lua` file for a comprehensive demonstration of all features working together.

## Creating Custom Components

```lua
local Core = require(path.to.RGBUI.Core.Core)
local Registry = require(path.to.RGBUI.Core.Registry)

-- Create a new component class
local MyComponent = {}
MyComponent.__index = MyComponent
setmetatable(MyComponent, {__index = Core})

-- Constructor
function MyComponent.new(text)
    local self = Core.new("Frame")
    setmetatable(self, MyComponent)
    
    -- Component setup...
    
    return self
end

-- Register the component
Registry.registerComponent("MyComponent", MyComponent)

-- Now it can be used like built-in components
local myComp = RGBUI.Registry.create("MyComponent", "Hello")
```

## Debug Mode

```lua
-- Enable debug mode
RGBUI.Debug.setEnabled(true)
RGBUI.Debug.setLogLevel(RGBUI.Debug.LogLevel.INFO)

-- Log messages
RGBUI.Debug.info("Component initialized")
RGBUI.Debug.warn("Potential issue detected")
```

## License

This library is available for use in your Roblox projects. Please provide attribution if you find it helpful.