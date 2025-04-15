-- RGBUI/init.lua

-- Create the main table that will hold our entire library.
local RGBUI = {}

-- Load core functionality.
RGBUI.Core = require(script.Core.Core)

-- Load Components.
RGBUI.Components = {}
RGBUI.Components.Button = require(script.Components.Button)
-- Optionally load additional components if available:
-- RGBUI.Components.Panel = require(script.Components.Panel)
-- RGBUI.Components.TextInput = require(script.Components.TextInput)

-- Load Themes.
RGBUI.Themes = {}
RGBUI.Themes.Default = require(script.Themes.Default)

-- Return the library table so that it can be used directly:
return RGBUI
