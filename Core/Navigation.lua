-- RGBUI/Core/Navigation.lua

local UserInputService = game:GetService("UserInputService")
local Debug = require(script.Parent.Debug)

local Navigation = {}

-- Store for all focusable components
local focusableComponents = {}

-- Currently focused component
local currentFocus = nil

-- Navigation enabled flag
Navigation.Enabled = true

-- Tab order mode
Navigation.TabOrderMode = "Automatic" -- Automatic, Manual, None

-- Enable or disable navigation
function Navigation.setEnabled(enabled)
    Navigation.Enabled = enabled
    return Navigation
end

-- Set the tab order mode
function Navigation.setTabOrderMode(mode)
    if mode ~= "Automatic" and mode ~= "Manual" and mode ~= "None" then
        Debug.error("Invalid tab order mode: " .. tostring(mode), "Navigation")
        return Navigation
    end
    
    Navigation.TabOrderMode = mode
    return Navigation
end

-- Register a component as focusable
function Navigation.registerFocusable(component, tabOrder)
    if not component or not component.Instance then
        Debug.error("Cannot register invalid component for focus", "Navigation")
        return component
    end
    
    -- Add to focusable components list
    table.insert(focusableComponents, {
        component = component,
        tabOrder = tabOrder or #focusableComponents + 1
    })
    
    -- Sort by tab order
    table.sort(focusableComponents, function(a, b)
        return a.tabOrder < b.tabOrder
    end)
    
    -- Add focus visual indicator
    component._focusIndicator = nil
    
    -- Add focus and blur methods to the component
    component.Focus = function(self)
        Navigation.focusComponent(self)
        return self
    end
    
    component.Blur = function(self)
        if currentFocus == self then
            Navigation.clearFocus()
        end
        return self
    end
    
    component.IsFocused = function(self)
        return currentFocus == self
    end
    
    -- Connect input events
    component._navigationConnections = {}
    
    -- Handle keyboard input when focused
    local function handleKeyboardInput(input, gameProcessed)
        if not Navigation.Enabled or currentFocus ~= component or gameProcessed then
            return
        end
        
        -- Emit keyboard events
        component:Emit("KeyDown", input.KeyCode)
        
        -- Handle special keys
        if input.KeyCode == Enum.KeyCode.Tab then
            -- Tab navigation
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or 
               UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                Navigation.focusPrevious()
            else
                Navigation.focusNext()
            end
        elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Space then
            -- Activate (like clicking)
            component:Emit("Activated")
            component:Emit("Click") -- For compatibility with existing components
        end
    end
    
    -- Handle gamepad input when focused
local function handleGamepadInput(input, gameProcessed)
        if not Navigation.Enabled or currentFocus ~= component or gameProcessed then
            return
        end
        
        -- Emit gamepad events
        component:Emit("GamepadInput", input.KeyCode)
        
        -- Handle special inputs
        if input.KeyCode == Enum.KeyCode.ButtonA then
            -- Activate (like clicking)
            component:Emit("Activated")
            component:Emit("Click") -- For compatibility with existing components
        elseif input.KeyCode == Enum.KeyCode.ButtonB then
            -- Cancel/back
            component:Emit("Canceled")
        elseif input.KeyCode == Enum.KeyCode.DPadUp or input.KeyCode == Enum.KeyCode.DPadDown or
               input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.DPadRight then
            -- Directional navigation
            Navigation.navigateDirection(input.KeyCode)
        end
    end
    
    -- Connect input events
    table.insert(component._navigationConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            handleKeyboardInput(input, gameProcessed)
        elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
            handleGamepadInput(input, gameProcessed)
        end
    end))
    
    return component
end

-- Unregister a component from focusable list
function Navigation.unregisterFocusable(component)
    if not component then return end
    
    -- Remove from focusable components list
    for i, entry in ipairs(focusableComponents) do
        if entry.component == component then
            table.remove(focusableComponents, i)
            break
        end
    end
    
    -- Disconnect input events
    if component._navigationConnections then
        for _, connection in ipairs(component._navigationConnections) do
            connection:Disconnect()
        end
        component._navigationConnections = nil
    end
    
    -- Remove focus indicator
    if component._focusIndicator then
        component._focusIndicator:Destroy()
        component._focusIndicator = nil
    end
    
    -- Clear focus if this component was focused
    if currentFocus == component then
        Navigation.clearFocus()
    end
    
    return component
end

-- Focus a specific component
function Navigation.focusComponent(component)
    if not Navigation.Enabled or not component then return end
    
    -- Clear current focus
    Navigation.clearFocus()
    
    -- Set new focus
    currentFocus = component
    
    -- Create focus indicator
    local instance = component.Instance
    if instance then
        -- Create a visual indicator for focus
        local focusIndicator = Instance.new("UIStroke")
        focusIndicator.Color = Color3.fromRGB(0, 120, 255)
        focusIndicator.Thickness = 2
        focusIndicator.Parent = instance
        
        component._focusIndicator = focusIndicator
        
        -- Emit focus event
        component:Emit("Focus")
    end
    
    return component
end

-- Clear current focus
function Navigation.clearFocus()
    if not currentFocus then return end
    
    -- Remove focus indicator
    if currentFocus._focusIndicator then
        currentFocus._focusIndicator:Destroy()
        currentFocus._focusIndicator = nil
    end
    
    -- Emit blur event
    currentFocus:Emit("Blur")
    
    -- Clear current focus
    currentFocus = nil
end

-- Focus the next component in tab order
function Navigation.focusNext()
    if not Navigation.Enabled or Navigation.TabOrderMode == "None" then return end
    
    if #focusableComponents == 0 then return end
    
    local nextIndex = 1
    
    -- Find the current focus index
    if currentFocus then
        for i, entry in ipairs(focusableComponents) do
            if entry.component == currentFocus then
                nextIndex = i + 1
                break
            end
        end
        
        -- Wrap around to the beginning
        if nextIndex > #focusableComponents then
            nextIndex = 1
        end
    end
    
    -- Focus the next component
    Navigation.focusComponent(focusableComponents[nextIndex].component)
end

-- Focus the previous component in tab order
function Navigation.focusPrevious()
    if not Navigation.Enabled or Navigation.TabOrderMode == "None" then return end
    
    if #focusableComponents == 0 then return end
    
    local prevIndex = #focusableComponents
    
    -- Find the current focus index
    if currentFocus then
        for i, entry in ipairs(focusableComponents) do
            if entry.component == currentFocus then
                prevIndex = i - 1
                break
            end
        end
        
        -- Wrap around to the end
        if prevIndex < 1 then
            prevIndex = #focusableComponents
        end
    end
    
    -- Focus the previous component
    Navigation.focusComponent(focusableComponents[prevIndex].component)
end

-- Navigate in a direction (for gamepad)
function Navigation.navigateDirection(direction)
    if not Navigation.Enabled or #focusableComponents == 0 or not currentFocus then return end
    
    local currentPosition = currentFocus.Instance.AbsolutePosition
    local currentSize = currentFocus.Instance.AbsoluteSize
    local currentCenter = currentPosition + (currentSize / 2)
    
    local bestComponent = nil
    local bestDistance = math.huge
    
    for _, entry in ipairs(focusableComponents) do
        local component = entry.component
        if component == currentFocus then continue end
        
        local instance = component.Instance
        if not instance then continue end
        
        local position = instance.AbsolutePosition
        local size = instance.AbsoluteSize
        local center = position + (size / 2)
        
        local delta = center - currentCenter
        local distance = delta.Magnitude
        
        -- Check if the component is in the correct direction
        local inDirection = false
        
        if direction == Enum.KeyCode.DPadUp and delta.Y < 0 then
            inDirection = true
        elseif direction == Enum.KeyCode.DPadDown and delta.Y > 0 then
            inDirection = true
        elseif direction == Enum.KeyCode.DPadLeft and delta.X < 0 then
            inDirection = true
        elseif direction == Enum.KeyCode.DPadRight and delta.X > 0 then
            inDirection = true
        end
        
        if inDirection and distance < bestDistance then
            bestComponent = component
            bestDistance = distance
        end
    end
    
    if bestComponent then
        Navigation.focusComponent(bestComponent)
    end
end

-- Initialize navigation system
function Navigation.init()
    -- Connect to input service for global navigation
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not Navigation.Enabled or gameProcessed then return end
        
        -- Handle Tab key for initial focus if nothing is focused
        if input.KeyCode == Enum.KeyCode.Tab and not currentFocus then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or 
               UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                Navigation.focusPrevious()
            else
                Navigation.focusNext()
            end
        end
    end)
    
    Debug.info("Navigation system initialized", "Navigation")
    return Navigation
end

return Navigation