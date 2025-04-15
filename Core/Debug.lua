-- RGBUI/Core/Debug.lua

local Debug = {}

-- Debug mode flag
Debug.Enabled = false

-- Log levels
Debug.LogLevel = {
    ERROR = 1,
    WARNING = 2,
    INFO = 3,
    DEBUG = 4
}

-- Current log level
Debug.CurrentLogLevel = Debug.LogLevel.ERROR

-- Enable or disable debug mode
function Debug.setEnabled(enabled)
    Debug.Enabled = enabled
    return Debug
end

-- Set the current log level
function Debug.setLogLevel(level)
    Debug.CurrentLogLevel = level
    return Debug
end

-- Log a message with a specific level
function Debug.log(message, level, component)
    level = level or Debug.LogLevel.INFO
    
    if level <= Debug.CurrentLogLevel then
        local levelName = "UNKNOWN"
        for name, value in pairs(Debug.LogLevel) do
            if value == level then
                levelName = name
                break
            end
        end
        
        local prefix = "[RGBUI]" .. (component and "[" .. component .. "]" or "") .. "[" .. levelName .. "]: "
        print(prefix .. message)
    end
    
    return Debug
end

-- Log an error message
function Debug.error(message, component)
    Debug.log(message, Debug.LogLevel.ERROR, component)
    
    if Debug.Enabled then
        error("[RGBUI] " .. message)
    end
    
    return Debug
end

-- Log a warning message
function Debug.warn(message, component)
    Debug.log(message, Debug.LogLevel.WARNING, component)
    return Debug
end

-- Log an info message
function Debug.info(message, component)
    Debug.log(message, Debug.LogLevel.INFO, component)
    return Debug
end

-- Log a debug message
function Debug.debug(message, component)
    Debug.log(message, Debug.LogLevel.DEBUG, component)
    return Debug
end

-- Safely call a function and catch any errors
function Debug.safeCall(func, ...)
    if not func then return nil end
    
    local success, result = pcall(func, ...)
    
    if not success then
        Debug.error("Error in function call: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Validate a component's properties
function Debug.validateProps(props, schema, componentName)
    if not Debug.Enabled then return true end
    
    componentName = componentName or "Unknown"
    
    for propName, propSchema in pairs(schema) do
        local value = props[propName]
        
        -- Check required props
        if propSchema.required and value == nil then
            Debug.error("Required property '" .. propName .. "' is missing", componentName)
            return false
        end
        
        -- Skip validation if value is nil and not required
        if value == nil then
            continue
        end
        
        -- Check type
        if propSchema.type and typeof(value) ~= propSchema.type then
            Debug.error("Property '" .. propName .. "' should be of type '" .. propSchema.type .. 
                      "', got '" .. typeof(value) .. "'", componentName)
            return false
        end
        
        -- Check enum values
        if propSchema.enum and not table.find(propSchema.enum, value) then
            Debug.error("Property '" .. propName .. "' should be one of: " .. 
                      table.concat(propSchema.enum, ", "), componentName)
            return false
        end
    end
    
    return true
end

-- Create a visual debug overlay for a component
function Debug.createVisualDebug(component)
    if not Debug.Enabled or not component or not component.Instance then return end
    
    -- Create a border around the component
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 0, 0)
    border.Thickness = 2
    border.Parent = component.Instance
    
    -- Create a label with component info
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, -20)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Text = component.__type or "Component"
    label.Parent = component.Instance
    
    return {
        border = border,
        label = label,
        
        -- Method to remove debug visuals
        remove = function()
            border:Destroy()
            label:Destroy()
        end
    }
end

return Debug