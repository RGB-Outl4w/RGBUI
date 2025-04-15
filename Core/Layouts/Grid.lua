-- RGBUI/Core/Layouts/Grid.lua

local Core = require(script.Parent.Parent.Core)

local Grid = {}
Grid.__index = Grid
setmetatable(Grid, {__index = Core})

-- Create a new grid layout container
function Grid.new(columns, rows)
    local self = Core.new("Frame")
    setmetatable(self, Grid)
    
    -- Default properties
    self.Instance.BackgroundTransparency = 1 -- Transparent by default
    self.Instance.Size = UDim2.new(1, 0, 1, 0) -- Fill parent by default
    
    -- Layout properties
    self.Columns = columns or 2 -- Default number of columns
    self.Rows = rows or 0 -- 0 means auto-calculate based on children count
    self.CellSize = UDim2.new(0, 100, 0, 100) -- Default cell size
    self.Spacing = Vector2.new(5, 5) -- Default spacing between cells
    self.Padding = {Top = 0, Bottom = 0, Left = 0, Right = 0} -- Default padding
    self.FillDirection = "Horizontal" -- Horizontal or Vertical
    
    -- Internal properties
    self._children = {}
    
    return self
end

-- Add a child to the Grid
function Grid:AddChild(child)
    if not child or not child.Instance then
        error("Grid:AddChild - Invalid child component")
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

-- Remove a child from the Grid
function Grid:RemoveChild(child)
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

-- Set the number of columns
function Grid:SetColumns(columns)
    self.Columns = columns
    self:UpdateLayout()
    return self
end

-- Set the number of rows
function Grid:SetRows(rows)
    self.Rows = rows
    self:UpdateLayout()
    return self
end

-- Set the size of each cell
function Grid:SetCellSize(size)
    self.CellSize = size
    self:UpdateLayout()
    return self
end

-- Set the spacing between cells
function Grid:SetSpacing(horizontal, vertical)
    self.Spacing = Vector2.new(horizontal or self.Spacing.X, vertical or self.Spacing.Y)
    self:UpdateLayout()
    return self
end

-- Set the padding around the grid
function Grid:SetPadding(top, right, bottom, left)
    self.Padding = {
        Top = top or self.Padding.Top,
        Right = right or self.Padding.Right,
        Bottom = bottom or self.Padding.Bottom,
        Left = left or self.Padding.Left
    }
    self:UpdateLayout()
    return self
end

-- Set the fill direction (Horizontal or Vertical)
function Grid:SetFillDirection(direction)
    if direction ~= "Horizontal" and direction ~= "Vertical" then
        error("Grid:SetFillDirection - Direction must be 'Horizontal' or 'Vertical'")
        return self
    end
    
    self.FillDirection = direction
    self:UpdateLayout()
    return self
end

-- Calculate the position of a child based on its index
function Grid:CalculatePosition(index)
    local rows = self.Rows
    local columns = self.Columns
    
    -- If rows is 0, calculate based on children count and columns
    if rows == 0 then
        rows = math.ceil(#self._children / columns)
    end
    
    local row, column
    
    if self.FillDirection == "Horizontal" then
        -- Fill horizontally first (left to right, then top to bottom)
        row = math.floor((index - 1) / columns) + 1
        column = ((index - 1) % columns) + 1
    else
        -- Fill vertically first (top to bottom, then left to right)
        column = math.floor((index - 1) / rows) + 1
        row = ((index - 1) % rows) + 1
    end
    
    local xPos = self.Padding.Left + (column - 1) * (self.CellSize.X.Offset + self.Spacing.X)
    local yPos = self.Padding.Top + (row - 1) * (self.CellSize.Y.Offset + self.Spacing.Y)
    
    return UDim2.new(0, xPos, 0, yPos)
end

-- Update the layout of all children
function Grid:UpdateLayout()
    if #self._children == 0 then return end
    
    -- Position each child
    for i, child in ipairs(self._children) do
        -- Set position
        child.Instance.Position = self:CalculatePosition(i)
        
        -- Set size to match cell size
        child.Instance.Size = self.CellSize
    end
    
    return self
end

-- Override SetSize to update layout when size changes
local originalSetSize = Grid.SetSize
function Grid:SetSize(size)
    originalSetSize(self, size)
    self:UpdateLayout()
    return self
end

-- Apply theme to the container
function Grid:SetTheme(theme)
    if theme.BackgroundColor then
        self.Instance.BackgroundColor3 = theme.BackgroundColor
        self.Instance.BackgroundTransparency = theme.BackgroundTransparency or self.Instance.BackgroundTransparency
    end
    return self
end

return Grid