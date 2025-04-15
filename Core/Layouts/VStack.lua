-- RGBUI/Core/Layouts/VStack.lua

local Core = require(script.Parent.Parent.Core)

local VStack = {}
VStack.__index = VStack
setmetatable(VStack, {__index = Core})

-- Create a new vertical stack layout container
function VStack.new()
    local self = Core.new("Frame")
    setmetatable(self, VStack)
    
    -- Default properties
    self.Instance.BackgroundTransparency = 1 -- Transparent by default
    self.Instance.Size = UDim2.new(1, 0, 1, 0) -- Fill parent by default
    
    -- Layout properties
    self.Spacing = 5 -- Default spacing between children
    self.Padding = {Top = 0, Bottom = 0, Left = 0, Right = 0} -- Default padding
    self.Alignment = "Start" -- Start, Center, End, SpaceBetween, SpaceAround
    
    -- Internal properties
    self._children = {}
    
    return self
end

-- Add a child to the VStack
function VStack:AddChild(child)
    if not child or not child.Instance then
        error("VStack:AddChild - Invalid child component")
        return self
    end
    
    -- Add to our internal children list
    table.insert(self._children, child)
    
    -- Set the parent of the child's instance
    child.Instance.Parent = self.Instance
    
    -- Update layout
    self:UpdateLayout()
    
    return self
end

-- Remove a child from the VStack
function VStack:RemoveChild(child)
    if not child then return self end
    
    -- Find and remove from our internal list
    for i, c in ipairs(self._children) do
        if c == child then
            table.remove(self._children, i)
            break
        end
    end
    
    -- Update layout
    self:UpdateLayout()
    
    return self
end

-- Set the spacing between children
function VStack:SetSpacing(spacing)
    self.Spacing = spacing
    self:UpdateLayout()
    return self
end

-- Set the padding around the stack
function VStack:SetPadding(top, right, bottom, left)
    self.Padding = {
        Top = top or self.Padding.Top,
        Right = right or self.Padding.Right,
        Bottom = bottom or self.Padding.Bottom,
        Left = left or self.Padding.Left
    }
    self:UpdateLayout()
    return self
end

-- Set the alignment of children
function VStack:SetAlignment(alignment)
    self.Alignment = alignment
    self:UpdateLayout()
    return self
end

-- Update the layout of all children
function VStack:UpdateLayout()
    if #self._children == 0 then return end
    
    local yOffset = self.Padding.Top
    local totalHeight = 0
    
    -- Calculate total height needed
    for _, child in ipairs(self._children) do
        totalHeight = totalHeight + child.Instance.Size.Y.Offset
    end
    
    -- Add spacing between children
    totalHeight = totalHeight + (self.Spacing * (#self._children - 1))
    
    -- Determine starting Y position based on alignment
    if self.Alignment == "Center" then
        yOffset = (self.Instance.AbsoluteSize.Y - totalHeight) / 2
    elseif self.Alignment == "End" then
        yOffset = self.Instance.AbsoluteSize.Y - totalHeight - self.Padding.Bottom
    elseif self.Alignment == "SpaceBetween" and #self._children > 1 then
        local availableSpace = self.Instance.AbsoluteSize.Y - totalHeight + (self.Spacing * (#self._children - 1))
        self.Spacing = availableSpace / (#self._children - 1)
    elseif self.Alignment == "SpaceAround" and #self._children > 0 then
        local availableSpace = self.Instance.AbsoluteSize.Y - totalHeight + (self.Spacing * (#self._children - 1))
        self.Spacing = availableSpace / (#self._children + 1)
        yOffset = self.Spacing
    end
    
    -- Position each child
    for i, child in ipairs(self._children) do
        local xPos = self.Padding.Left
        local width = self.Instance.AbsoluteSize.X - self.Padding.Left - self.Padding.Right
        
        -- Set position
        child.Instance.Position = UDim2.new(0, xPos, 0, yOffset)
        
        -- If child has scale in its X size, respect it, otherwise set to fill width
        if child.Instance.Size.X.Scale == 0 then
            child.Instance.Size = UDim2.new(1, -self.Padding.Left - self.Padding.Right, 
                                          child.Instance.Size.Y.Scale, child.Instance.Size.Y.Offset)
        end
        
        -- Move to next position
        yOffset = yOffset + child.Instance.Size.Y.Offset + self.Spacing
    end
    
    return self
end

-- Override SetSize to update layout when size changes
local originalSetSize = VStack.SetSize
function VStack:SetSize(size)
    originalSetSize(self, size)
    self:UpdateLayout()
    return self
end

-- Apply theme to the container
function VStack:SetTheme(theme)
    if theme.BackgroundColor then
        self.Instance.BackgroundColor3 = theme.BackgroundColor
        self.Instance.BackgroundTransparency = theme.BackgroundTransparency or self.Instance.BackgroundTransparency
    end
    return self
end

return VStack