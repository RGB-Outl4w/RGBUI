-- RGBUI/init.lua

-- Create a module system that works with loadstring
local RGBUI = {}

-- Module cache to avoid circular dependencies
local _moduleCache = {}

-- Custom module loader that works with loadstring
local function loadModule(modulePath)
    if _moduleCache[modulePath] then
        return _moduleCache[modulePath]
    end
    
    -- Create empty module entry to handle circular dependencies
    _moduleCache[modulePath] = {}
    
    -- Define all modules inline for loadstring compatibility
    if modulePath == "Core/Core" then
        local module = {}
        module.__index = module
        
        -- Version information
        module.Version = "1.0.0"
        
        -- Creates a new UI element of a given Roblox Instance type
        function module.new(instanceType)
            local self = setmetatable({}, module)
            self.Instance = Instance.new(instanceType)
            self.Events = {}
            self.__type = instanceType -- Store the type for debugging
            
            -- Add to registry for theme updates if applicable
            if RGBUI.Registry then
                RGBUI.Registry.registerForThemeUpdates(self, instanceType)
            end
            
            return self
        end
        
        -- Set the UI element's position
        function module:SetPosition(position)
            self.Instance.Position = position
            return self
        end
        
        -- Set the UI element's size
        function module:SetSize(size)
            self.Instance.Size = size
            return self
        end
        
        -- Set the parent of the UI element
        function module:SetParent(parent)
            self.Instance.Parent = parent
            return self
        end
        
        -- Event handling system
        function module:On(eventName, callback)
            self.Events[eventName] = self.Events[eventName] or {}
            table.insert(self.Events[eventName], callback)
            return self
        end
        
        function module:Emit(eventName, ...)
            local eventCallbacks = self.Events[eventName]
            if eventCallbacks then
                for _, callback in ipairs(eventCallbacks) do
                    callback(...)
                end
            end
            return self
        end
        
        -- Initialize core dependencies
        function module.init()
            -- Load dependencies after initialization to avoid circular dependencies
            RGBUI.Theme = loadModule("Core/Theme")
            RGBUI.Registry = loadModule("Core/Registry")
            RGBUI.Responsive = loadModule("Core/Responsive")
            RGBUI.Navigation = loadModule("Core/Navigation")
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Debug" then
        local module = {}
        
        -- Debug mode flag
        module.Enabled = false
        
        -- Log levels
        module.LogLevel = {
            ERROR = 1,
            WARNING = 2,
            INFO = 3,
            DEBUG = 4
        }
        
        -- Current log level
        module.CurrentLogLevel = module.LogLevel.ERROR
        
        -- Enable or disable debug mode
        function module.setEnabled(enabled)
            module.Enabled = enabled
            return module
        end
        
        -- Set the current log level
        function module.setLogLevel(level)
            module.CurrentLogLevel = level
            return module
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Theme" then
        local module = {}
        module.__index = module
        
        -- Current active theme
        local activeTheme = nil
        
        -- Theme registry to store all registered themes
        local themeRegistry = {}
        
        -- Register a theme from an existing table
        function module.register(themeName, themeData)
            themeRegistry[themeName] = themeData
            return themeData
        end
        
        -- Get a registered theme by name
        function module.get(themeName)
            return themeRegistry[themeName]
        end
        
        -- Set the active theme
        function module.setActive(themeName)
            local theme = module.get(themeName)
            if theme then
                activeTheme = theme
                -- Trigger theme update for all registered components
                if RGBUI.Registry then
                    RGBUI.Registry.updateAllThemes()
                end
            end
            return module
        end
        
        -- Get the current active theme
        function module.getActive()
            return activeTheme
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Registry" then
        local module = {}
        
        -- Store for all registered components
        local componentRegistry = {}
        
        -- Store for themed components that need updates when theme changes
        local themedComponents = {}
        
        -- Register a component class
        function module.registerComponent(name, componentClass)
            if componentRegistry[name] then
                warn("Component '" .. name .. "' is already registered. Overwriting.")
            end
            
            componentRegistry[name] = componentClass
            return componentClass
        end
        
        -- Get a registered component class by name
        function module.getComponent(name)
            return componentRegistry[name]
        end
        
        -- Create a new instance of a registered component
        function module.create(name, ...)
            local componentClass = componentRegistry[name]
            
            if not componentClass then
                error("Component '" .. name .. "' is not registered")
                return nil
            end
            
            return componentClass.new(...)
        end
        
        -- Register a component instance for theme updates
        function module.registerForThemeUpdates(component, componentType)
            if not component or not componentType then return end
            
            -- Add to themed components list
            table.insert(themedComponents, {
                component = component,
                type = componentType
            })
        end
        
        -- Update all themed components with the current theme
        function module.updateAllThemes()
            local activeTheme = RGBUI.Theme.getActive()
            if not activeTheme then return end
            
            for _, entry in ipairs(themedComponents) do
                local component = entry.component
                local componentType = entry.type
                
                -- Apply theme if component has a SetTheme method and theme has data for this component type
                if component.SetTheme and activeTheme[componentType] then
                    component:SetTheme(activeTheme[componentType])
                end
            end
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Responsive" then
        local module = {}
        
        -- Responsive breakpoints
        module.Breakpoints = {
            xs = 0,
            sm = 400,
            md = 600,
            lg = 800,
            xl = 1000
        }
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Navigation" then
        local module = {}
        
        -- Navigation system implementation would go here
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Layouts/VStack" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        function module.new()
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- VStack implementation
            self.Instance.BackgroundTransparency = 1
            self.Children = {}
            
            return self
        end
        
        function module:AddChild(child)
            table.insert(self.Children, child)
            child:SetParent(self.Instance)
            self:UpdateLayout()
            return self
        end
        
        function module:UpdateLayout()
            -- Simple vertical stack layout
            local yOffset = 0
            for _, child in ipairs(self.Children) do
                child:SetPosition(UDim2.new(0, 0, 0, yOffset))
                yOffset = yOffset + child.Instance.Size.Y.Offset + 5 -- 5px spacing
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Layouts/HStack" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        function module.new()
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- HStack implementation
            self.Instance.BackgroundTransparency = 1
            self.Children = {}
            
            return self
        end
        
        function module:AddChild(child)
            table.insert(self.Children, child)
            child:SetParent(self.Instance)
            self:UpdateLayout()
            return self
        end
        
        function module:UpdateLayout()
            -- Simple horizontal stack layout
            local xOffset = 0
            for _, child in ipairs(self.Children) do
                child:SetPosition(UDim2.new(0, xOffset, 0, 0))
                xOffset = xOffset + child.Instance.Size.X.Offset + 5 -- 5px spacing
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Core/Layouts/Grid" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        function module.new(columns)
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- Grid implementation
            self.Instance.BackgroundTransparency = 1
            self.Children = {}
            self.Columns = columns or 2
            
            return self
        end
        
        function module:AddChild(child)
            table.insert(self.Children, child)
            child:SetParent(self.Instance)
            self:UpdateLayout()
            return self
        end
        
        function module:UpdateLayout()
            -- Simple grid layout
            for i, child in ipairs(self.Children) do
                local column = (i - 1) % self.Columns
                local row = math.floor((i - 1) / self.Columns)
                
                child:SetPosition(UDim2.new(0, column * 105, 0, row * 105)) -- 100px + 5px spacing
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Components/Button" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        -- Create a new button with specified text
        function module.new(text)
            local self = Core.new("TextButton")
            setmetatable(self, module)
            self.Instance.Text = text or "Button"
            self.Instance.AutoButtonColor = false  -- Manage colors via themes
            
            -- Connect the native click event to our custom event system
            self.Instance.MouseButton1Click:Connect(function()
                self:Emit("Click")
            end)
            return self
        end
        
        -- Set the button's displayed text
        function module:SetText(newText)
            self.Instance.Text = newText
            return self
        end
        
        -- Apply a theme to the button (colors, font, etc.)
        function module:SetTheme(theme)
            if theme then
                if theme.BackgroundColor then self.Instance.BackgroundColor3 = theme.BackgroundColor end
                if theme.TextColor then self.Instance.TextColor3 = theme.TextColor end
                if theme.Font then self.Instance.Font = theme.Font end
                if theme.TextSize then self.Instance.TextSize = theme.TextSize end
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Components/Slider" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        -- Create a new slider
        function module.new(min, max, initial)
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- Slider implementation
            self.Min = min or 0
            self.Max = max or 100
            self.Value = initial or self.Min
            
            -- Create slider components
            self.Track = Instance.new("Frame")
            self.Track.Name = "Track"
            self.Track.Size = UDim2.new(1, 0, 0, 10)
            self.Track.Position = UDim2.new(0, 0, 0.5, -5)
            self.Track.Parent = self.Instance
            
            self.Fill = Instance.new("Frame")
            self.Fill.Name = "Fill"
            self.Fill.Size = UDim2.new(0, 0, 1, 0)
            self.Fill.Parent = self.Track
            
            self.Handle = Instance.new("TextButton")
            self.Handle.Name = "Handle"
            self.Handle.Size = UDim2.new(0, 20, 0, 20)
            self.Handle.Position = UDim2.new(0, -10, 0.5, -10)
            self.Handle.Parent = self.Fill
            
            -- Setup slider interaction
            self:SetValue(self.Value)
            
            return self
        end
        
        -- Set the slider's value
        function module:SetValue(value)
            self.Value = math.clamp(value, self.Min, self.Max)
            local percent = (self.Value - self.Min) / (self.Max - self.Min)
            
            self.Fill.Size = UDim2.new(percent, 0, 1, 0)
            self:Emit("ValueChanged", self.Value)
            
            return self
        end
        
        -- Apply a theme to the slider
        function module:SetTheme(theme)
            if theme then
                if theme.TrackColor then self.Track.BackgroundColor3 = theme.TrackColor end
                if theme.FillColor then self.Fill.BackgroundColor3 = theme.FillColor end
                if theme.HandleColor then self.Handle.BackgroundColor3 = theme.HandleColor end
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Components/Checkbox" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        -- Create a new checkbox
        function module.new(text, checked)
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- Checkbox implementation
            self.Checked = checked or false
            
            -- Create checkbox components
            self.Box = Instance.new("TextButton")
            self.Box.Name = "Box"
            self.Box.Size = UDim2.new(0, 20, 0, 20)
            self.Box.Parent = self.Instance
            
            self.Check = Instance.new("TextLabel")
            self.Check.Name = "Check"
            self.Check.Text = "✓"
            self.Check.Size = UDim2.new(1, 0, 1, 0)
            self.Check.Parent = self.Box
            self.Check.Visible = self.Checked
            
            self.Label = Instance.new("TextLabel")
            self.Label.Name = "Label"
            self.Label.Text = text or "Checkbox"
            self.Label.Size = UDim2.new(0, 200, 0, 20)
            self.Label.Position = UDim2.new(0, 30, 0, 0)
            self.Label.TextXAlignment = Enum.TextXAlignment.Left
            self.Label.BackgroundTransparency = 1
            self.Label.Parent = self.Instance
            
            -- Setup checkbox interaction
            self.Box.MouseButton1Click:Connect(function()
                self:Toggle()
            end)
            
            return self
        end
        
        -- Toggle the checkbox state
        function module:Toggle()
            self.Checked = not self.Checked
            self.Check.Visible = self.Checked
            self:Emit("ValueChanged", self.Checked)
            return self
        end
        
        -- Set the checkbox state
        function module:SetChecked(checked)
            self.Checked = checked
            self.Check.Visible = self.Checked
            return self
        end
        
        -- Apply a theme to the checkbox
        function module:SetTheme(theme)
            if theme then
                if theme.BoxColor then self.Box.BackgroundColor3 = theme.BoxColor end
                if theme.CheckColor then self.Check.TextColor3 = theme.CheckColor end
                if theme.TextColor then self.Label.TextColor3 = theme.TextColor end
                if theme.Font then self.Label.Font = theme.Font end
                if theme.TextSize then self.Label.TextSize = theme.TextSize end
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Components/TextInput" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        -- Create a new text input
        function module.new(placeholder)
            local self = Core.new("TextBox")
            setmetatable(self, module)
            
            -- TextInput implementation
            self.Instance.PlaceholderText = placeholder or "Enter text..."
            self.Instance.ClearTextOnFocus = false
            
            -- Connect events
            self.Instance.FocusLost:Connect(function(enterPressed)
                self:Emit("TextChanged", self.Instance.Text)
                if enterPressed then
                    self:Emit("Submitted", self.Instance.Text)
                end
            end)
            
            return self
        end
        
        -- Set the text input's value
        function module:SetText(text)
            self.Instance.Text = text or ""
            return self
        end
        
        -- Get the text input's value
        function module:GetText()
            return self.Instance.Text
        end
        
        -- Apply a theme to the text input
        function module:SetTheme(theme)
            if theme then
                if theme.BackgroundColor then self.Instance.BackgroundColor3 = theme.BackgroundColor end
                if theme.TextColor then self.Instance.TextColor3 = theme.TextColor end
                if theme.PlaceholderColor then self.Instance.PlaceholderColor3 = theme.PlaceholderColor end
                if theme.Font then self.Instance.Font = theme.Font end
                if theme.TextSize then self.Instance.TextSize = theme.TextSize end
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Components/Dropdown" then
        local Core = loadModule("Core/Core")
        
        local module = {}
        module.__index = module
        setmetatable(module, {__index = Core})
        
        -- Create a new dropdown
        function module.new(options)
            local self = Core.new("Frame")
            setmetatable(self, module)
            
            -- Dropdown implementation
            self.Options = options or {}
            self.SelectedIndex = 1
            self.IsOpen = false
            
            -- Create dropdown components
            self.Button = Instance.new("TextButton")
            self.Button.Name = "Button"
            self.Button.Size = UDim2.new(1, 0, 0, 30)
            self.Button.Text = #self.Options > 0 and self.Options[1] or "Select..."
            self.Button.Parent = self.Instance
            
            self.List = Instance.new("Frame")
            self.List.Name = "List"
            self.List.Size = UDim2.new(1, 0, 0, 0)
            self.List.Position = UDim2.new(0, 0, 0, 30)
            self.List.Visible = false
            self.List.Parent = self.Instance
            
            -- Setup dropdown interaction
            self.Button.MouseButton1Click:Connect(function()
                self:Toggle()
            end)
            
            -- Create option buttons
            self:RefreshOptions()
            
            return self
        end
        
        -- Toggle the dropdown state
        function module:Toggle()
            self.IsOpen = not self.IsOpen
            self.List.Visible = self.IsOpen
            
            if self.IsOpen then
                self.List.Size = UDim2.new(1, 0, 0, #self.Options * 30)
            else
                self.List.Size = UDim2.new(1, 0, 0, 0)
            end
            
            return self
        end
        
        -- Refresh the dropdown options
        function module:RefreshOptions()
            -- Clear existing options
            for _, child in pairs(self.List:GetChildren()) do
                child:Destroy()
            end
            
            -- Create new option buttons
            for i, option in ipairs(self.Options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. i
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                optionButton.Text = option
                optionButton.Parent = self.List
                
                optionButton.MouseButton1Click:Connect(function()
                    self:Select(i)
                end)
            end
            
            return self
        end
        
        -- Select an option by index
        function module:Select(index)
            if index >= 1 and index <= #self.Options then
                self.SelectedIndex = index
                self.Button.Text = self.Options[index]
                self:Toggle() -- Close the dropdown
                self:Emit("SelectionChanged", self.Options[index], index)
            end
            return self
        end
        
        -- Set the dropdown options
        function module:SetOptions(options)
            self.Options = options or {}
            self:RefreshOptions()
            return self
        end
        
        -- Apply a theme to the dropdown
        function module:SetTheme(theme)
            if theme then
                if theme.BackgroundColor then 
                    self.Button.BackgroundColor3 = theme.BackgroundColor 
                    self.List.BackgroundColor3 = theme.BackgroundColor
                end
                if theme.TextColor then self.Button.TextColor3 = theme.TextColor end
                if theme.Font then self.Button.Font = theme.Font end
                if theme.TextSize then self.Button.TextSize = theme.TextSize end
            end
            return self
        end
        
        _moduleCache[modulePath] = module
        return module
        
    elseif modulePath == "Themes/Default" then
        local module = {
            Button = {
                BackgroundColor = Color3.fromRGB(30, 30, 30),
                TextColor = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSans,
                TextSize = 18,
            },
            
            Panel = {
                BackgroundColor = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0,
            },
            
            Slider = {
                TrackColor = Color3.fromRGB(50, 50, 50),
                FillColor = Color3.fromRGB(0, 120, 255),
                HandleColor = Color3.fromRGB(255, 255, 255),
            },
            
            Checkbox = {
                BoxColor = Color3.fromRGB(50, 50, 50),
                CheckColor = Color3.fromRGB(255, 255, 255),
                TextColor = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSans,
                TextSize = 18,
            },
            
            TextInput = {
                BackgroundColor = Color3.fromRGB(40, 40, 40),
                TextColor = Color3.fromRGB(255, 255, 255),
                PlaceholderColor = Color3.fromRGB(150, 150, 150),
                Font = Enum.Font.SourceSans,
                TextSize = 18,
            },
            
            Dropdown = {
                BackgroundColor = Color3.fromRGB(40, 40, 40),
                TextColor = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSans,
                TextSize = 18,
            },
        }
        
        _moduleCache[modulePath] = module
        return module
    end
    
    -- If module not found
    warn("Module not found: " .. modulePath)
    return {}
end

-- Load core functionality
RGBUI.Core = loadModule("Core/Core")

-- Initialize Core and its dependencies
RGBUI.Core.init()

-- Add Core.new as a direct method on RGBUI for convenience
function RGBUI.new(instanceType)
    return RGBUI.Core.new(instanceType)
end

-- Load Debug module
RGBUI.Debug = loadModule("Core/Debug")

-- Load Theme system
RGBUI.Theme = loadModule("Core/Theme")

-- Load Registry for component management
RGBUI.Registry = loadModule("Core/Registry")

-- Load Responsive design utilities
RGBUI.Responsive = loadModule("Core/Responsive")

-- Load Navigation system
RGBUI.Navigation = loadModule("Core/Navigation")

-- Load Layout Containers
RGBUI.Layouts = {}
RGBUI.Layouts.VStack = loadModule("Core/Layouts/VStack")
RGBUI.Layouts.HStack = loadModule("Core/Layouts/HStack")
RGBUI.Layouts.Grid = loadModule("Core/Layouts/Grid")

-- Load Components
RGBUI.Components = {}
RGBUI.Components.Button = loadModule("Components/Button")
RGBUI.Components.Slider = loadModule("Components/Slider")
RGBUI.Components.Checkbox = loadModule("Components/Checkbox")
RGBUI.Components.TextInput = loadModule("Components/TextInput")
RGBUI.Components.Dropdown = loadModule("Components/Dropdown")

-- Register built-in components with the Registry
RGBUI.Registry.registerComponent("Button", RGBUI.Components.Button)
RGBUI.Registry.registerComponent("Slider", RGBUI.Components.Slider)
RGBUI.Registry.registerComponent("Checkbox", RGBUI.Components.Checkbox)
RGBUI.Registry.registerComponent("TextInput", RGBUI.Components.TextInput)
RGBUI.Registry.registerComponent("Dropdown", RGBUI.Components.Dropdown)
RGBUI.Registry.registerComponent("VStack", RGBUI.Layouts.VStack)
RGBUI.Registry.registerComponent("HStack", RGBUI.Layouts.HStack)
RGBUI.Registry.registerComponent("Grid", RGBUI.Layouts.Grid)

-- Load Themes
RGBUI.Themes = {}
RGBUI.Themes.Default = loadModule("Themes/Default")

-- Register the default theme
RGBUI.Theme.register("Default", RGBUI.Themes.Default)
RGBUI.Theme.setActive("Default")

-- Return the library table so that it can be used directly
return RGBUI
