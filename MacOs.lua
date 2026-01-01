--[[
FULL REBUILD – macOS‑style UI (matches screenshot)
Features:
✔ Exact layout (sidebar + dividers + content)
✔ Auto scale
✔ Mobile support
✔ Same visual style as image
✔ Simple API (no coding knowledge needed)
]]

local lib = {}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local function corner(obj, r)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, r)
end

-- GUI parent resolver (supports syn.protect_gui & gethui)
local function getGuiParent()
    if syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        syn.protect_gui(g)
        g.Parent = game:GetService("CoreGui")
        return g
    elseif gethui then
        local g = Instance.new("ScreenGui")
        g.Parent = gethui()
        return g
    else
        local g = Instance.new("ScreenGui")
        g.Parent = game:GetService("CoreGui")
        return g
    end
end

function lib:init(titleText)
    local gui = Instance.new("ScreenGui")
    gui.IgnoreGuiInset = true
    gui.Parent = game:GetService("CoreGui")

    local main = Instance.new("Frame", gui)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.Size = isMobile and UDim2.fromScale(0.92,0.85) or UDim2.fromOffset(721,584)
    main.BackgroundColor3 = Color3.fromRGB(255,255,255)
    main.BackgroundTransparency = 0.1
    corner(main,18)

    -- Auto scale
    local scale = Instance.new("UIScale", main)
    local function updateScale()
        local s = Camera.ViewportSize
        scale.Scale = math.clamp(math.min(s.X/721, s.Y/584), 0.75, 1)
    end
    updateScale()
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

    -- Sidebar
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0.33,0,1,0)
    sidebar.BackgroundColor3 = Color3.fromRGB(245,245,245)
    corner(sidebar,18)

    local sideList = Instance.new("UIListLayout", sidebar)
    sideList.Padding = UDim.new(0,6)

    -- Search bar
    local search = Instance.new("TextBox", sidebar)
    search.PlaceholderText = "Search"
    search.Size = UDim2.fromOffset(225,34)
    search.Position = UDim2.fromOffset(18,50)
    search.Font = Enum.Font.Gotham
    search.TextSize = 20
    search.BackgroundColor3 = Color3.fromRGB(255,255,255)
    corner(search,9)

    -- Content area
    local content = Instance.new("Frame", main)
    content.Position = UDim2.new(0.33,0,0,0)
    content.Size = UDim2.new(0.67,0,1,0)
    content.BackgroundColor3 = Color3.fromRGB(255,255,255)
    corner(content,18)

    -- Title
    local title = Instance.new("TextLabel", content)
    title.Text = titleText or ""
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 28
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(30,20)
    title.Size = UDim2.fromOffset(400,40)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0,10)
    list.HorizontalAlignment = Center

    local window = {}

    function window:Divider(text)
        local d = Instance.new("TextLabel", content)
        d.Text = text
        d.Font = Enum.Font.Gotham
        d.TextSize = 20
        d.TextColor3 = Color3.fromRGB(95,95,95)
        d.BackgroundTransparency = 1
        d.Size = UDim2.fromOffset(420,30)
        d.TextXAlignment = Left
    end

    function window:Button(text, cb)
        local b = Instance.new("TextButton", content)
        b.Text = text
        b.Font = Enum.Font.Gotham
        b.TextSize = 22
        b.Size = UDim2.fromOffset(420,40)
        b.BackgroundColor3 = Color3.fromRGB(21,103,251)
        b.TextColor3 = Color3.new(1,1,1)
        corner(b,9)
        b.MouseButton1Click:Connect(function() if cb then cb() end end)
    end

    function window:Label(text)
        local l = Instance.new("TextLabel", content)
        l.Text = text
        l.Font = Enum.Font.Gotham
        l.TextSize = 20
        l.TextColor3 = Color3.fromRGB(95,95,95)
        l.BackgroundTransparency = 1
        l.Size = UDim2.fromOffset(420,30)
    end

    function window:Switch(text, default, cb)
        local holder = Instance.new("Frame", content)
        holder.Size = UDim2.fromOffset(420,40)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextSize = 20
        label.TextXAlignment = Left
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(0.7,1)

        local toggle = Instance.new("TextButton", holder)
        toggle.Size = UDim2.fromOffset(60,30)
        toggle.Position = UDim2.fromScale(0.85,0.5)
        toggle.AnchorPoint = Vector2.new(0.5,0.5)
        toggle.Text = ""
        corner(toggle,15)

        local on = default
        toggle.BackgroundColor3 = on and Color3.fromRGB(21,103,251) or Color3.fromRGB(200,200,200)

        toggle.MouseButton1Click:Connect(function()
            on = not on
            toggle.BackgroundColor3 = on and Color3.fromRGB(21,103,251) or Color3.fromRGB(200,200,200)
            if cb then cb(on) end
        end)
    end

    return window
end

return lib