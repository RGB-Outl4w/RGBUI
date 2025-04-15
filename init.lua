-- RGBUI/init.lua

-- Create the main table that will hold our entire library.
local RGBUI = {}

-- Load core functionality.
RGBUI.Core = require(script.Core.Core)

-- Load Components.
RGBUI.Components = {}
RGBUI.Components.Button = require(script.Components.Button)
RGBUI.Components.Slider = require(script.Components.Slider)
RGBUI.Components.Checkbox = require(script.Components.Checkbox)
RGBUI.Components.TextInput = require(script.Components.TextInput)
RGBUI.Components.Dropdown = require(script.Components.Dropdown)

-- Load Themes.
RGBUI.Themes = {}
RGBUI.Themes.Default = require(script.Themes.Default)

-- Return the library table so that it can be used directly:
return RGBUI
