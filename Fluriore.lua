-- Fluriore UI Library
-- Modern Roblox UI Library with clean design

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create the main library object
function Library:CreateWindow(config)
	local self = setmetatable({}, Library)
	
	local windowTitle = config.Title or "Fluriore UI"
	local windowSize = config.Size or UDim2.new(0, 450, 0, 400)
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlurioreUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = game.CoreGui
	
	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = windowSize
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = mainFrame
	
	-- Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 8)
	titleCorner.Parent = titleBar
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = windowTitle
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar
	
	-- Made by text
	local madeByLabel = Instance.new("TextLabel")
	madeByLabel.Name = "MadeBy"
	madeByLabel.Size = UDim2.new(0, 100, 1, 0)
	madeByLabel.Position = UDim2.new(0, 60, 0, 0)
	madeByLabel.BackgroundTransparency = 1
	madeByLabel.Text = "made by You"
	madeByLabel.TextColor3 = Color3.fromRGB(255, 50, 150)
	madeByLabel.TextSize = 12
	madeByLabel.Font = Enum.Font.GothamBold
	madeByLabel.TextXAlignment = Enum.TextXAlignment.Left
	madeByLabel.Parent = titleBar
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	closeBtn.Text = "×"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = titleBar
	
	local closeBtnCorner = Instance.new("UICorner")
	closeBtnCorner.CornerRadius = UDim.new(0, 6)
	closeBtnCorner.Parent = closeBtn
	
	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)
	
	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 150, 1, -35)
	sidebar.Position = UDim2.new(0, 0, 0, 35)
	sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame
	
	local sidebarList = Instance.new("UIListLayout")
	sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarList.Padding = UDim.new(0, 5)
	sidebarList.Parent = sidebar
	
	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 10)
	sidebarPadding.PaddingLeft = UDim.new(0, 10)
	sidebarPadding.PaddingRight = UDim.new(0, 10)
	sidebarPadding.Parent = sidebar
	
	-- Content Area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -150, 1, -35)
	contentArea.Position = UDim2.new(0, 150, 0, 35)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = mainFrame
	
	-- Dragging functionality
	local dragging = false
	local dragInput
	local dragStart
	local startPos
	
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	self.ScreenGui = screenGui
	self.MainFrame = mainFrame
	self.Sidebar = sidebar
	self.ContentArea = contentArea
	self.Tabs = {}
	self.CurrentTab = nil
	
	return self
end

function Library:CreateTab(tabName)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName
	tabButton.Size = UDim2.new(1, 0, 0, 35)
	tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabButton.Text = ""
	tabButton.Parent = self.Sidebar
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tabButton
	
	local tabIcon = Instance.new("ImageLabel")
	tabIcon.Name = "Icon"
	tabIcon.Size = UDim2.new(0, 20, 0, 20)
	tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
	tabIcon.BackgroundTransparency = 1
	tabIcon.Image = "rbxassetid://3926305904"
	tabIcon.ImageColor3 = Color3.fromRGB(255, 50, 150)
	tabIcon.Parent = tabButton
	
	local tabLabel = Instance.new("TextLabel")
	tabLabel.Name = "Label"
	tabLabel.Size = UDim2.new(1, -40, 1, 0)
	tabLabel.Position = UDim2.new(0, 35, 0, 0)
	tabLabel.BackgroundTransparency = 1
	tabLabel.Text = tabName
	tabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	tabLabel.TextSize = 14
	tabLabel.Font = Enum.Font.Gotham
	tabLabel.TextXAlignment = Enum.TextXAlignment.Left
	tabLabel.Parent = tabButton
	
	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Name = tabName .. "Content"
	tabContent.Size = UDim2.new(1, -20, 1, -20)
	tabContent.Position = UDim2.new(0, 10, 0, 10)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.ScrollBarThickness = 4
	tabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 150)
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.Visible = false
	tabContent.Parent = self.ContentArea
	
	local contentList = Instance.new("UIListLayout")
	contentList.SortOrder = Enum.SortOrder.LayoutOrder
	contentList.Padding = UDim.new(0, 10)
	contentList.Parent = tabContent
	
	contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
	end)
	
	tabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			tab.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
			tab.Content.Visible = false
		end
		
		tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabContent.Visible = true
		self.CurrentTab = tabName
	end)
	
	local tab = {
		Button = tabButton,
		Label = tabLabel,
		Content = tabContent,
		Name = tabName
	}
	
	self.Tabs[tabName] = tab
	
	if not self.CurrentTab then
		tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabContent.Visible = true
		self.CurrentTab = tabName
	end
	
	return self:CreateTabElements(tabContent)
end

function Library:CreateTabElements(parent)
	local elements = {}
	
	function elements:AddLabel(text)
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, 0, 0, 30)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 16
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = parent
		
		return label
	end
	
	function elements:AddParagraph(title, description)
		local container = Instance.new("Frame")
		container.Name = "Paragraph"
		container.Size = UDim2.new(1, 0, 0, 60)
		container.BackgroundTransparency = 1
		container.Parent = parent
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, 0, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = container
		
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, 0, 0, 35)
		descLabel.Position = UDim2.new(0, 0, 0, 20)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = description
		descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextWrapped = true
		descLabel.Parent = container
		
		return container
	end
	
	function elements:AddToggle(title, description, default, callback)
		local toggled = default or false
		
		local container = Instance.new("Frame")
		container.Name = "Toggle"
		container.Size = UDim2.new(1, 0, 0, 45)
		container.BackgroundTransparency = 1
		container.Parent = parent
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, -60, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = container
		
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, -60, 0, 20)
		descLabel.Position = UDim2.new(0, 0, 0, 20)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = description
		descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = container
		
		local toggleButton = Instance.new("TextButton")
		toggleButton.Name = "ToggleButton"
		toggleButton.Size = UDim2.new(0, 40, 0, 20)
		toggleButton.Position = UDim2.new(1, -45, 0, 5)
		toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(255, 50, 150) or Color3.fromRGB(40, 40, 40)
		toggleButton.Text = ""
		toggleButton.Parent = container
		
		local toggleCorner = Instance.new("UICorner")
		toggleCorner.CornerRadius = UDim.new(1, 0)
		toggleCorner.Parent = toggleButton
		
		local toggleCircle = Instance.new("Frame")
		toggleCircle.Name = "Circle"
		toggleCircle.Size = UDim2.new(0, 14, 0, 14)
		toggleCircle.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		toggleCircle.Parent = toggleButton
		
		local circleCorner = Instance.new("UICorner")
		circleCorner.CornerRadius = UDim.new(1, 0)
		circleCorner.Parent = toggleCircle
		
		toggleButton.MouseButton1Click:Connect(function()
			toggled = not toggled
			
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local colorTween = TweenService:Create(toggleButton, tweenInfo, {
				BackgroundColor3 = toggled and Color3.fromRGB(255, 50, 150) or Color3.fromRGB(40, 40, 40)
			})
			local positionTween = TweenService:Create(toggleCircle, tweenInfo, {
				Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
			})
			
			colorTween:Play()
			positionTween:Play()
			
			if callback then
				callback(toggled)
			end
		end)
		
		return container
	end
	
	function elements:AddButton(title, description, callback)
		local container = Instance.new("Frame")
		container.Name = "Button"
		container.Size = UDim2.new(1, 0, 0, 45)
		container.BackgroundTransparency = 1
		container.Parent = parent
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, -60, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = container
		
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, -60, 0, 20)
		descLabel.Position = UDim2.new(0, 0, 0, 20)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = description
		descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = container
		
		local button = Instance.new("TextButton")
		button.Name = "ActionButton"
		button.Size = UDim2.new(0, 30, 0, 30)
		button.Position = UDim2.new(1, -35, 0, 7.5)
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		button.Text = ""
		button.Parent = container
		
		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 6)
		buttonCorner.Parent = button
		
		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 18, 0, 18)
		icon.Position = UDim2.new(0.5, -9, 0.5, -9)
		icon.BackgroundTransparency = 1
		icon.Image = "rbxassetid://3926307971"
		icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		icon.Parent = button
		
		button.MouseButton1Click:Connect(function()
			local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tween = TweenService:Create(button, tweenInfo, {
				BackgroundColor3 = Color3.fromRGB(255, 50, 150)
			})
			tween:Play()
			tween.Completed:Wait()
			
			if callback then
				callback()
			end
			
			local tweenBack = TweenService:Create(button, tweenInfo, {
				BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			})
			tweenBack:Play()
		end)
		
		return container
	end
	
	function elements:AddSlider(title, description, min, max, default, callback)
		local value = default or min
		
		local container = Instance.new("Frame")
		container.Name = "Slider"
		container.Size = UDim2.new(1, 0, 0, 65)
		container.BackgroundTransparency = 1
		container.Parent = parent
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, 0, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = container
		
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, 0, 0, 15)
		descLabel.Position = UDim2.new(0, 0, 0, 20)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = description
		descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = container
		
		local sliderBack = Instance.new("Frame")
		sliderBack.Name = "SliderBackground"
		sliderBack.Size = UDim2.new(1, -60, 0, 6)
		sliderBack.Position = UDim2.new(0, 0, 0, 45)
		sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		sliderBack.BorderSizePixel = 0
		sliderBack.Parent = container
		
		local sliderCorner = Instance.new("UICorner")
		sliderCorner.CornerRadius = UDim.new(1, 0)
		sliderCorner.Parent = sliderBack
		
		local sliderFill = Instance.new("Frame")
		sliderFill.Name = "Fill"
		sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderBack
		
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(1, 0)
		fillCorner.Parent = sliderFill
		
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Name = "Value"
		valueLabel.Size = UDim2.new(0, 50, 0, 25)
		valueLabel.Position = UDim2.new(1, -50, 0, 38)
		valueLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
		valueLabel.Text = tostring(value)
		valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		valueLabel.TextSize = 14
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.Parent = container
		
		local valueCorner = Instance.new("UICorner")
		valueCorner.CornerRadius = UDim.new(0, 6)
		valueCorner.Parent = valueLabel
		
		local dragging = false
		
		sliderBack.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
			end
		end)
		
		sliderBack.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local sizeX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
				value = math.floor(min + (max - min) * sizeX)
				
				sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
				valueLabel.Text = tostring(value)
				
				if callback then
					callback(value)
				end
			end
		end)
		
		return container
	end
	
	return elements
end

return Library