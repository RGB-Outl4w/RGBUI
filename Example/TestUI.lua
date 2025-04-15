-- RGBUI/Example/TestUI.lua

-- Create a ScreenGui and parent it to the local player's PlayerGui.
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Load the library from the init.lua entry point.
local RGBUI = require(script.Parent.Parent.init)

-- Fetch the default theme.
local DefaultTheme = RGBUI.Themes.Default

-- Create a new button using RGBUI.
local myButton = RGBUI.Components.Button.new("Click Me!")
myButton
    :SetPosition(UDim2.new(0.5, -50, 0.5, -25))
    :SetSize(UDim2.new(0, 100, 0, 50))
    :SetTheme(DefaultTheme.Button)
    :On("Click", function()
         print("RGBUI Button clicked!")
    end)
    :SetParent(ScreenGui)
