-- Custom Roblox UI Library v3.0 (Local Variables, Error-Free)
-- Elements: Dropdown, Button, Paragraph, Code Block, Slider, Toggle

local Library = {}
local Windows = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local UI Storage
local Elements = {}

-- Create Main ScreenGui
local function createScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILib"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    return ScreenGui
end

-- Window Class
local Window = {}
Window.__index = Window

function Library:CreateWindow(options)
    options = options or {}
    local name = options.Name or "Custom UI"
    local hidePremium = options.HidePremium or false
    local introEnabled = options.IntroEnabled ~= false
    
    local windowData = {
        Name = name,
        MainFrame = nil,
        Tabs = {},
        CurrentTab = nil,
        Dragging = false,
        DragStart = nil,
        StartPos = nil,
        IntroEnabled = introEnabled
    }
    
    setmetatable(windowData, Window)
    
    local screenGui = createScreenGui()
    windowData.ScreenGui = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = false
    windowData.MainFrame = mainFrame
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 40)
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = topBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = topBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    closeBtn.TextSize = 20
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.Size = UDim2.new(0, 150, 1, -40)
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Parent = tabContainer
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Parent = mainFrame
    contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentContainer.BorderSizePixel = 0
    contentContainer.Position = UDim2.new(0, 150, 0, 40)
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentContainer
    
    windowData.TabContainer = tabContainer
    windowData.ContentContainer = contentContainer
    
    -- Drag Functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                         startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close Button
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Intro Animation
    if introEnabled then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 500, 0, 400),
            Position = UDim2.new(0.5, -250, 0.5, -200)
        })
        tween:Play()
    end
    
    table.insert(Windows, windowData)
    return windowData
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(options)
    local name = options.Name or "Tab"
    local icon = options.Icon or ""
    
    local tabData = {
        Name = name,
        Icon = icon,
        Window = self,
        Elements = {},
        Container = nil,
        Button = nil
    }
    
    setmetatable(tabData, Tab)
    
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Parent = self.TabContainer
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = icon .. " " .. name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.LayoutOrder = #self.Tabs
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    -- Tab Content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "Content"
    tabContent.Parent = self.ContentContainer
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    tabContent.Visible = false
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = tabContent
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    tabData.Container = tabContent
    tabData.Button = tabButton
    table.insert(self.Tabs, tabData)
    
    -- Tab Switching
    tabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.CurrentTab = tabData
    end)
    
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return tabData
end

-- Element Creation Functions
function Tab:AddButton(options)
    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "Button"
    buttonFrame.Parent = self.Container
    buttonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = buttonFrame
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    table.insert(Elements, buttonFrame)
    return buttonFrame
end

function Tab:AddToggle(options)
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Parent = self.Container
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = toggleFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Parent = toggleFrame
    toggleSwitch.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Position = UDim2.new(1, -40, 0.5, -10)
    toggleSwitch.Size = UDim2.new(0, 28, 0, 20)
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 10)
    switchCorner.Parent = toggleSwitch
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = toggleSwitch
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    indicator.Size = UDim2.new(0, 14, 0, 12)
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 6)
    indicatorCorner.Parent = indicator
    
    local toggleValue = default
    
    local function updateToggle(value)
        toggleValue = value
        callback(value)
        TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
            BackgroundColor3 = value and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        }):Play()
        indicator:TweenPosition(value and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.2)
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle(not toggleValue)
        end
    end)
    
    table.insert(Elements, toggleFrame)
    return {
        Set = updateToggle,
        Value = function() return toggleValue end
    }
end

function Tab:AddSlider(options)
    local name = options.Name or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or 50
    local increment = options.Increment or 1
    local callback = options.Callback or function() end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Parent = self.Container
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = sliderFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.BorderSizePixel = 0
    sliderBar.Position = UDim2.new(0, 10, 0.7, 0)
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = sliderBar
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Parent = sliderBar
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.Size = UDim2.new(0, 16, 0, 16)
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = knob
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(value)
        currentValue = math.floor((value - min) / increment + 0.5) * increment
        currentValue = math.clamp(currentValue, min, max)
        callback(currentValue)
        label.Text = name .. ": " .. currentValue
        local percent = (currentValue - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -8, 0.5, -8)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - barPos) / barSize, 0, 1)
            updateSlider(min + relativePos * (max - min))
        end
    end)
    
    updateSlider(default)
    
    table.insert(Elements, sliderFrame)
    return {
        Set = updateSlider,
        Value = function() return currentValue end
    }
end

function Tab:AddDropdown(options)
    local name = options.Name or "Dropdown"
    local optionsList = options.Options or {}
    local default = options.Default or optionsList[1]
    local callback = options.Callback or function() end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown"
    dropdownFrame.Parent = self.Container
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Size = UDim2.new(1, -20, 0, 40)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropdownFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = dropdownFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -50, 0.5, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = dropdownFrame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 10, 0.5, 0)
    valueLabel.Size = UDim2.new(1, -50, 0.5, 0)
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.Text = default or "None"
    valueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "List"
    dropdownList.Parent = dropdownFrame
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.BorderSizePixel = 0
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = dropdownList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    
    local listPadding = Instance.new("UIPadding")
    listPadding.Parent = dropdownList
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 10)
    listPadding.PaddingRight = UDim.new(0, 10)
    
    local currentValue = default
    local listVisible = false
    
    local function updateDropdown(value)
        currentValue = value
        valueLabel.Text = value or "None"
        callback(value)
    end
    
    local function toggleList()
        listVisible = not listVisible
        dropdownList.Visible = listVisible
        
        if listVisible then
            local height = math.min(#optionsList * 30 + 10, 150)
            dropdownList.Size = UDim2.new(1, 0, 0, height)
        else
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
        end
    end
    
    -- Create option buttons
    for i, option in ipairs(optionsList) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Name = option
        optionBtn.Parent = dropdownList
        optionBtn.BackgroundTransparency = 1
        optionBtn.Size = UDim2.new(1, 0, 0, 25)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionBtn.TextSize = 14
        optionBtn.LayoutOrder = i
        
        optionBtn.MouseButton1Click:Connect(function()
            updateDropdown(option)
            toggleList()
        end)
        
        optionBtn.MouseEnter:Connect(function()
            optionBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
        end)
        
        optionBtn.MouseLeave:Connect(function()
            optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if listVisible then
            dropdownList.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        end
    end)
    
    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleList()
        end
    end)
    
    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleList()
        end
    end)
    
    table.insert(Elements, dropdownFrame)
    return {
        Set = updateDropdown,
        Refresh = function(newOptions, deleteCurrent)
            if deleteCurrent then
                for _, child in ipairs(dropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
            end
            optionsList = newOptions
            -- Recreate buttons
            for i, option in ipairs(newOptions) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Name = option
                optionBtn.Parent = dropdownList
                optionBtn.BackgroundTransparency = 1
                optionBtn.Size = UDim2.new(1, 0, 0, 25)
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.Text = option
                optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionBtn.TextSize = 14
                optionBtn.LayoutOrder = i
                
                optionBtn.MouseButton1Click:Connect(function()
                    updateDropdown(option)
                    toggleList()
                end)
            end
        end,
        Value = function() return currentValue end
    }
end

function Tab:AddParagraph(title, content)
    local paragraphFrame = Instance.new("Frame")
    paragraphFrame.Name = "Paragraph"
    paragraphFrame.Parent = self.Container
    paragraphFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    paragraphFrame.BorderSizePixel = 0
    paragraphFrame.Size = UDim2.new(1, -20, 0, 80)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = paragraphFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = paragraphFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Parent = paragraphFrame
    contentLabel.BackgroundTransparency = 1
    contentLabel.Position = UDim2.new(0, 10, 0, 35)
    contentLabel.Size = UDim2.new(1, -20, 1, -40)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.TextSize = 13
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    
    table.insert(Elements, paragraphFrame)
    return {
        Set = function(newTitle, newContent)
            titleLabel.Text = newTitle
            contentLabel.Text = newContent
        end
    }
end

function Tab:AddCodeBlock(code)
    local codeFrame = Instance.new("Frame")
    codeFrame.Name = "CodeBlock"
    codeFrame.Parent = self.Container
    codeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    codeFrame.BorderSizePixel = 0
    codeFrame.Size = UDim2.new(1, -20, 0, 120)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = codeFrame
    
    local codeLabel = Instance.new("TextLabel")
    codeLabel.Name = "Code"
    codeLabel.Parent = codeFrame
    codeLabel.BackgroundTransparency = 1
    codeLabel.Position = UDim2.new(0, 10, 0, 10)
    codeLabel.Size = UDim2.new(1, -20, 1, -20)
    codeLabel.Font = Enum.Font.Code
    codeLabel.Text = code
    codeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    codeLabel.TextSize = 13
    codeLabel.TextXAlignment = Enum.TextXAlignment.Left
    codeLabel.TextWrapped = true
    codeLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    table.insert(Elements, codeFrame)
    return codeFrame
end

-- Initialize Library
function Library:Init()
    -- Library is ready
end

-- Return Library
return Library