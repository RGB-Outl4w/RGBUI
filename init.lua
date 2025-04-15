-- RGBUI/init.lua

-- Create the main table that will hold our entire library.
local RGBUI = {}

-- Load core functionality.
RGBUI.Core = require(script.Core.Core)

-- Initialize Core and its dependencies
RGBUI.Core.init()

-- Load Debug module
RGBUI.Debug = require(script.Core.Debug)

-- Load Theme system
RGBUI.Theme = require(script.Core.Theme)

-- Load Registry for component management
RGBUI.Registry = require(script.Core.Registry)

-- Load Responsive design utilities
RGBUI.Responsive = require(script.Core.Responsive)

-- Load Navigation system
RGBUI.Navigation = require(script.Core.Navigation)

-- Load Layout Containers
RGBUI.Layouts = {}
RGBUI.Layouts.VStack = require(script.Core.Layouts.VStack)
RGBUI.Layouts.HStack = require(script.Core.Layouts.HStack)
RGBUI.Layouts.Grid = require(script.Core.Layouts.Grid)

-- Load Components.
RGBUI.Components = {}
RGBUI.Components.Button = require(script.Components.Button)
RGBUI.Components.Slider = require(script.Components.Slider)
RGBUI.Components.Checkbox = require(script.Components.Checkbox)
RGBUI.Components.TextInput = require(script.Components.TextInput)
RGBUI.Components.Dropdown = require(script.Components.Dropdown)

-- Register built-in components with the Registry
RGBUI.Registry.registerComponent("Button", RGBUI.Components.Button)
RGBUI.Registry.registerComponent("Slider", RGBUI.Components.Slider)
RGBUI.Registry.registerComponent("Checkbox", RGBUI.Components.Checkbox)
RGBUI.Registry.registerComponent("TextInput", RGBUI.Components.TextInput)
RGBUI.Registry.registerComponent("Dropdown", RGBUI.Components.Dropdown)
RGBUI.Registry.registerComponent("VStack", RGBUI.Layouts.VStack)
RGBUI.Registry.registerComponent("HStack", RGBUI.Layouts.HStack)
RGBUI.Registry.registerComponent("Grid", RGBUI.Layouts.Grid)

-- Load Themes.
RGBUI.Themes = {}
RGBUI.Themes.Default = require(script.Themes.Default)

-- Register the default theme
RGBUI.Theme.register("Default", RGBUI.Themes.Default)
RGBUI.Theme.setActive("Default")

-- Enable debug mode in development
-- Comment this out for production
-- RGBUI.Debug.setEnabled(true)
-- RGBUI.Debug.setLogLevel(RGBUI.Debug.LogLevel.INFO)

-- Return the library table so that it can be used directly:
return RGBUI
