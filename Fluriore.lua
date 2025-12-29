--// Fluirone UI Library
--// Local-variable-only design

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Library = {}
Library.__index = Library

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

--// Window
function Library:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.Accent = config.Accent or Color3.fromRGB(255, 0, 255)

    local ScreenGui = Create("ScreenGui", {
        Parent = Player:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.fromScale(0.4, 0.45),
        Position = UDim2.fromScale(0.3, 0.25),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    })

    Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 12)
    })

    -- Title
    local Title = Create("TextLabel", {
        Parent = MainFrame,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.fromOffset(10, 0),
        Text = config.Title or "Window",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Left,
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1)
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.fromOffset(0, 40),
        BackgroundColor3 = Color3.fromRGB(15,15,15),
        BorderSizePixel = 0
    })

    local TabsHolder = Create("UIListLayout", {
        Parent = Sidebar,
        Padding = UDim.new(0, 6)
    })

    -- Content
    local Content = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, -130, 1, -50),
        Position = UDim2.fromOffset(125, 45),
        BackgroundTransparency = 1
    })

    function Window:CreateTab(name)
        local Tab = {}
        local TabButton = Create("TextButton", {
            Parent = Sidebar,
            Size = UDim2.new(1, -10, 0, 32),
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(25,25,25),
            TextColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0
        })

        Create("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })

        local TabFrame = Create("Frame", {
            Parent = Content,
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            Visible = false
        })

        local Layout = Create("UIListLayout", {
            Parent = TabFrame,
            Padding = UDim.new(0, 10)
        })

        local function Show()
            for _, t in pairs(Window.Tabs) do
                t.Frame.Visible = false
            end
            TabFrame.Visible = true
        end

        TabButton.MouseButton1Click:Connect(Show)

        function Tab:AddParagraph(title, desc)
            local Frame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Color3.fromRGB(30,30,30),
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Frame, CornerRadius = UDim.new(0,8) })

            Create("TextLabel", {
                Parent = Frame,
                Text = title,
                Position = UDim2.fromOffset(10,5),
                Size = UDim2.new(1,-20,0,20),
                BackgroundTransparency = 1,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Left
            })

            Create("TextLabel", {
                Parent = Frame,
                Text = desc,
                Position = UDim2.fromOffset(10,25),
                Size = UDim2.new(1,-20,0,30),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(180,180,180),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Left
            })
        end

        function Tab:AddButton(text, callback)
            local Button = Create("TextButton", {
                Parent = TabFrame,
                Size = UDim2.new(1,0,0,40),
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                BackgroundColor3 = Window.Accent,
                TextColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Button, CornerRadius = UDim.new(0,8) })

            Button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        function Tab:AddToggle(text, default, callback)
            local state = default or false

            local Frame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1,0,0,40),
                BackgroundColor3 = Color3.fromRGB(30,30,30),
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Frame, CornerRadius = UDim.new(0,8) })

            local Label = Create("TextLabel", {
                Parent = Frame,
                Text = text,
                Position = UDim2.fromOffset(10,0),
                Size = UDim2.new(1,-60,1,0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Left
            })

            local Toggle = Create("TextButton", {
                Parent = Frame,
                Size = UDim2.fromOffset(36,20),
                Position = UDim2.fromOffset(Frame.AbsoluteSize.X - 46,10),
                BackgroundColor3 = state and Window.Accent or Color3.fromRGB(80,80,80),
                Text = "",
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Toggle, CornerRadius = UDim.new(1,0) })

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.BackgroundColor3 = state and Window.Accent or Color3.fromRGB(80,80,80)
                if callback then callback(state) end
            end)
        end

        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min

            local Frame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1,0,0,50),
                BackgroundColor3 = Color3.fromRGB(30,30,30),
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Frame, CornerRadius = UDim.new(0,8) })

            local Label = Create("TextLabel", {
                Parent = Frame,
                Text = text .. ": " .. value,
                Position = UDim2.fromOffset(10,5),
                Size = UDim2.new(1,-20,0,20),
                BackgroundTransparency = 1,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Left
            })

            local Bar = Create("Frame", {
                Parent = Frame,
                Position = UDim2.fromOffset(10,30),
                Size = UDim2.new(1,-20,0,6),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Bar, CornerRadius = UDim.new(1,0) })

            local Fill = Create("Frame", {
                Parent = Bar,
                Size = UDim2.fromScale((value-min)/(max-min),1),
                BackgroundColor3 = Window.Accent,
                BorderSizePixel = 0
            })

            Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1,0) })

            local dragging = false

            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * pct)
                    Fill.Size = UDim2.fromScale(pct,1)
                    Label.Text = text .. ": " .. value
                    if callback then callback(value) end
                end
            end)
        end

        Tab.Frame = TabFrame
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            TabFrame.Visible = true
        end

        return Tab
    end

    return Window
end

return Library