-- RGBUI/Core/Layouts/HStack.lua

local Core = require(script.Parent.Parent.Core)

local HStack = {}
HStack.__index = HStack
setmetatable(HStack, {__index = Core})

-- Create a new horizontal stack layout container
function HStack.new()
    local self = Core.new("Frame")
    setmetatable(self, HStack)
    
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

-- Add a child to the HStack
function HStack:AddChild(child)
    if not child or not child.Instance then
        error("HStack:AddChild - Invalid child component")
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

-- Remove a child from the HStack
function HStack:RemoveChild(child)
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
function HStack:SetSpacing(spacing)
    self.Spacing = spacing
    self:UpdateLayout()
    return self
end

-- Set the padding around the stack
function HStack:SetPadding(top, right, bottom, left)
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
function HStack:SetAlignment(alignment)
    self.Alignment = alignment
    self:UpdateLayout()
    return self
end

-- Update the layout of all children
function HStack:UpdateLayout()
    if #self._children == 0 then return end
    
    local xOffset = self.Padding.Left
    local totalWidth = 0
    
    -- Calculate total width needed
    for _, child in ipairs(self._children) do
        totalWidth = totalWidth + child.Instance.Size.X.Offset
    end
    
    -- Add spacing between children
    totalWidth = totalWidth + (self.Spacing * (#self._children - 1))
    
    -- Determine starting X position based on alignment
    if self.Alignment == "Center" then
        xOffset = (self.Instance.AbsoluteSize.X - totalWidth) / 2
    elseif self.Alignment == "End" then
        xOffset = self.Instance.AbsoluteSize.X - totalWidth - self.Padding.Right
    elseif self.Alignment == "SpaceBetween" and #self._children > 1 then
        local availableSpace = self.Instance.AbsoluteSize.X - totalWidth + (self.Spacing * (#self._children - 1))
        self.Spacing = availableSpace / (#self._children - 1)
    elseif self.Alignment == "SpaceAround" and #self._children > 0 then
        local availableSpace = self.Instance.AbsoluteSize.X - totalWidth + (self.Spacing * (#self._children - 1))
        self.Spacing = availableSpace / (#self._children + 1)
        xOffset = self.Spacing
    end
    
    -- Position each child
    for i, child in ipairs(self._children) do
        local yPos = self.Padding.Top
        local height = self.Instance.AbsoluteSize.Y - self.Padding.Top - self.Padding.Bottom
        
        -- Set position
        child.Instance.Position = UDim2.new(0, xOffset, 0, yPos)
        
        -- If child has scale in its Y size, respect it, otherwise set to fill height
        if child.Instance.Size.Y.Scale == 0 then
            child.Instance.Size = UDim2.new(child.Instance.Size.X.Scale, child.Instance.Size.X.Offset,
                                          1, -self.Padding.Top - self.Padding.Bottom)
        end
        
        -- Move to next position
        xOffset = xOffset + child.Instance.Size.X.Offset + self.Spacing
    end
    
    return self
end

-- Override SetSize to update layout when size changes
local originalSetSize = HStack.SetSize
function HStack:SetSize(size)
    originalSetSize(self, size)
    self:UpdateLayout()
    return self
end

-- Apply theme to the container
function HStack:SetTheme(theme)
    if theme.BackgroundColor then
        self.Instance.BackgroundColor3 = theme.BackgroundColor
        self.Instance.BackgroundTransparency = theme.BackgroundTransparency or self.Instance.BackgroundTransparency
    end
    return self
end

return HStack