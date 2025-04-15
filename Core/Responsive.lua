-- RGBUI/Core/Responsive.lua

local Responsive = {}

-- Store for screen size breakpoints
Responsive.Breakpoints = {
    xs = 400,  -- Extra small screens
    sm = 600,  -- Small screens
    md = 800,  -- Medium screens
    lg = 1000, -- Large screens
    xl = 1200  -- Extra large screens
}

-- Current screen size
Responsive.CurrentScreenSize = Vector2.new(0, 0)

-- Set custom breakpoints
function Responsive.setBreakpoints(breakpoints)
    for name, size in pairs(breakpoints) do
        Responsive.Breakpoints[name] = size
    end
    return Responsive
end

-- Get current breakpoint name
function Responsive.getCurrentBreakpoint()
    local width = Responsive.CurrentScreenSize.X
    
    if width <= Responsive.Breakpoints.xs then
        return "xs"
    elseif width <= Responsive.Breakpoints.sm then
        return "sm"
    elseif width <= Responsive.Breakpoints.md then
        return "md"
    elseif width <= Responsive.Breakpoints.lg then
        return "lg"
    else
        return "xl"
    end
end

-- Apply responsive sizing to a component based on breakpoints
function Responsive.applyResponsiveSize(component, sizeMap)
    if not component or not sizeMap then return component end
    
    local breakpoint = Responsive.getCurrentBreakpoint()
    
    -- Find the appropriate size for the current breakpoint
    -- If the exact breakpoint isn't specified, use the next smaller one
    local size = nil
    
    if sizeMap[breakpoint] then
        size = sizeMap[breakpoint]
    else
        local breakpoints = {"xl", "lg", "md", "sm", "xs"}
        local breakpointFound = false
        
        for i, bp in ipairs(breakpoints) do
            if bp == breakpoint then
                breakpointFound = true
            elseif breakpointFound and sizeMap[bp] then
                size = sizeMap[bp]
                break
            end
        end
        
        -- If no smaller breakpoint found, try larger ones
        if not size then
            breakpointFound = false
            breakpoints = {"xs", "sm", "md", "lg", "xl"}
            
            for i, bp in ipairs(breakpoints) do
                if bp == breakpoint then
                    breakpointFound = true
                elseif breakpointFound and sizeMap[bp] then
                    size = sizeMap[bp]
                    break
                end
            end
        end
    end
    
    -- Apply the size if found
    if size then
        component:SetSize(size)
    end
    
    return component
end

-- Create a responsive size map
function Responsive.createSizeMap(xs, sm, md, lg, xl)
    local sizeMap = {}
    
    if xs then sizeMap.xs = xs end
    if sm then sizeMap.sm = sm end
    if md then sizeMap.md = md end
    if lg then sizeMap.lg = lg end
    if xl then sizeMap.xl = xl end
    
    return sizeMap
end

-- Apply aspect ratio constraint to a component
function Responsive.applyAspectRatio(component, ratio)
    if not component or not ratio then return component end
    
    local aspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    aspectRatioConstraint.AspectRatio = ratio
    aspectRatioConstraint.Parent = component.Instance
    
    -- Store reference to constraint
    component._aspectRatioConstraint = aspectRatioConstraint
    
    return component
end

-- Apply text scaling to a text component
function Responsive.applyTextScaling(component, minSize, maxSize)
    if not component then return component end
    
    local textScaler = Instance.new("UITextSizeConstraint")
    textScaler.MinTextSize = minSize or 8
    textScaler.MaxTextSize = maxSize or 40
    textScaler.Parent = component.Instance
    
    -- Store reference to constraint
    component._textSizeConstraint = textScaler
    
    return component
end

-- Update the current screen size
function Responsive.updateScreenSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    Responsive.CurrentScreenSize = Vector2.new(viewportSize.X, viewportSize.Y)
    return Responsive.CurrentScreenSize
end

-- Initialize responsive system
function Responsive.init()
    -- Get initial screen size
    Responsive.updateScreenSize()
    
    -- Connect to viewport size changed event
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        Responsive.updateScreenSize()
    end)
    
    return Responsive
end

-- Add responsive methods to Core
function Responsive.extendCore(Core)
    -- Set responsive size based on breakpoints
    function Core:SetResponsiveSize(sizeMap)
        return Responsive.applyResponsiveSize(self, sizeMap)
    end
    
    -- Set aspect ratio
    function Core:SetAspectRatio(ratio)
        return Responsive.applyAspectRatio(self, ratio)
    end
    
    -- Set text scaling (for text components)
    function Core:SetTextScaling(minSize, maxSize)
        return Responsive.applyTextScaling(self, minSize, maxSize)
    end
    
    -- Set anchor point
    function Core:SetAnchorPoint(anchorPoint)
        self.Instance.AnchorPoint = anchorPoint
        return self
    end
    
    -- Set scale type for responsive sizing
    function Core:SetScaleType(scaleType)
        if scaleType == "Fill" then
            self.Instance.Size = UDim2.new(1, 0, 1, 0)
        elseif scaleType == "FitWidth" then
            self.Instance.Size = UDim2.new(1, 0, 0, self.Instance.Size.Y.Offset)
        elseif scaleType == "FitHeight" then
            self.Instance.Size = UDim2.new(0, self.Instance.Size.X.Offset, 1, 0)
        end
        
        return self
    end
    
    return Core
end

return Responsive