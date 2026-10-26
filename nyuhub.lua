-- NYU HUB - Generated bundle
-- File ini dibuat otomatis oleh build.js

local __factories = {}
local __cache = {}

local function __require(name)
    if __cache[name] ~= nil then
        return __cache[name]
    end

    local factory = __factories[name]
    assert(factory, 'Module tidak ditemukan: ' .. tostring(name))

    local result = factory()
    __cache[name] = result
    return result
end

-- ===== MODULE: config.games =====
__factories["config.games"] = function()

local Games = {
    {
        Id = 123974602339071,
        Name = "Just a baseplate",
        Module = "game1",
        Enabled = true,
    },
    {
        Id = nil,
        Name = "Game 2",
        Module = "game2",
        Enabled = false,
    },
    {
        Id = nil,
        Name = "Game 3",
        Module = "game3",
        Enabled = false,
    },
    {
        Id = nil,
        Name = "Game 4",
        Module = "game4",
        Enabled = false,
    },
    {
        Id = nil,
        Name = "Game 5",
        Module = "game5",
        Enabled = false,
    },
}

return Games

end

-- ===== MODULE: core.detector =====
__factories["core.detector"] = function()

--[[
    NYU HUB
    File: core/detector.lua
    Description: Mendeteksi game berdasarkan GameId.
]]

local Detector = {}

function Detector.Detect(games, currentGameId)
    if type(games) ~= "table" then
        return nil, "Konfigurasi game tidak valid."
    end

    if type(currentGameId) ~= "number" then
        return nil, "GameId tidak valid."
    end

    for _, gameConfig in ipairs(games) do
        if type(gameConfig) == "table"
            and gameConfig.Enabled == true
            and type(gameConfig.Id) == "number"
            and gameConfig.Id == currentGameId then

            return gameConfig
        end
    end

    return nil, "Game belum didukung."
end

return Detector

end

-- ===== MODULE: core.registry =====
__factories["core.registry"] = function()

--[[
    NYU HUB
    File: core/registry.lua
    Description: Registry modul game berdasarkan GameId.
]]

local Registry = {}

local registeredModules = {}

function Registry.Register(gameId, module)
    if type(gameId) ~= "number" then
        return false, "GameId harus berupa angka."
    end

    if type(module) ~= "table" then
        return false, "Modul game harus berupa table."
    end

    if type(module.Init) ~= "function" then
        return false, "Modul harus menyediakan fungsi Init."
    end

    if registeredModules[gameId] then
        return false, "GameId sudah terdaftar."
    end

    registeredModules[gameId] = module

    return true
end

function Registry.Get(gameId)
    return registeredModules[gameId]
end

function Registry.IsRegistered(gameId)
    return registeredModules[gameId] ~= nil
end

function Registry.RegisterMany(modules)
    if type(modules) ~= "table" then
        return false, "Daftar modul tidak valid."
    end

    for gameId, module in pairs(modules) do
        if type(gameId) ~= "number" then
            return false, "Setiap kunci modul harus berupa GameId angka."
        end

        if type(module) ~= "table"
            or type(module.Init) ~= "function" then
            return false, "Modul tidak valid untuk GameId " .. tostring(gameId)
        end

        if registeredModules[gameId] then
            return false, "GameId sudah terdaftar: " .. tostring(gameId)
        end
    end

    for gameId, module in pairs(modules) do
        registeredModules[gameId] = module
    end

    return true
end

function Registry.Clear()
    registeredModules = {}
end

return Registry

end

-- ===== MODULE: core.loader =====
__factories["core.loader"] = function()

--[[
    NYU HUB
    File: core/loader.lua
    Description: Mengelola inisialisasi modul game.
]]

local Loader = {}

local initializedGames = {}

function Loader.Init(gameConfig, module, context)
    if type(gameConfig) ~= "table" then
        return false, "Konfigurasi game tidak valid."
    end

    if gameConfig.Enabled ~= true then
        return false, "Game belum diaktifkan."
    end

    if type(gameConfig.Id) ~= "number" then
        return false, "GameId belum dikonfigurasi."
    end

    if type(module) ~= "table" or type(module.Init) ~= "function" then
        return false, "Modul game tidak valid."
    end

    if initializedGames[gameConfig.Id] then
        return false, "Modul game sudah diinisialisasi."
    end

    local success, result = pcall(function()
        return module.Init(context)
    end)

    if not success then
        return false, "Inisialisasi gagal: " .. tostring(result)
    end

    initializedGames[gameConfig.Id] = true

    return true, result
end

function Loader.IsInitialized(gameId)
    return initializedGames[gameId] == true
end

return Loader

end

-- ===== MODULE: ui.theme =====
__factories["ui.theme"] = function()
local Theme = {
    Name = "NYU HUB Minimal",

    Colors = {
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(18, 18, 18),
        SurfaceHover = Color3.fromRGB(32, 32, 32),
        SurfaceActive = Color3.fromRGB(38, 38, 38),

        Primary = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(245, 245, 245),
        Muted = Color3.fromRGB(155, 155, 155),

        Border = Color3.fromRGB(43, 43, 43),
        Disabled = Color3.fromRGB(65, 65, 65),

        ButtonText = Color3.fromRGB(0, 0, 0),
        ButtonBackground = Color3.fromRGB(255, 255, 255),
        ButtonDisabledText = Color3.fromRGB(155, 155, 155),
    },

    Sizes = {
        WindowWidth = 760,
        WindowHeight = 480,

        SidebarWidth = 170,
        HeaderHeight = 54,

        CornerRadius = 10,
        CardRadius = 10,
        ButtonRadius = 7,

        BorderThickness = 1,
        Padding = 16,
        ContentPadding = 20,
    },

    Font = Enum.Font.Gotham,

    Animation = {
        Enabled = false,
    },
}

return Theme
end

-- ===== MODULE: ui.components =====
__factories["ui.components"] = function()

local Components = {}

function Components.CreateFrame(parent, theme, properties)
    local frame = Instance.new("Frame")

    frame.Name = properties.Name or "Frame"
    frame.Size = properties.Size or UDim2.fromOffset(100, 100)
    frame.Position = properties.Position or UDim2.fromOffset(0, 0)
    frame.BackgroundColor3 =
        properties.BackgroundColor3 or theme.Colors.Surface
    frame.BackgroundTransparency =
        properties.BackgroundTransparency or 0
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = properties.ClipsDescendants or false
    frame.AnchorPoint = properties.AnchorPoint or Vector2.zero
    frame.LayoutOrder = properties.LayoutOrder or 0
    frame.Visible = properties.Visible ~= false
    frame.ZIndex = properties.ZIndex or 1

    for property, value in pairs(properties) do
        if property ~= "Name"
            and property ~= "Parent"
            and property ~= "CornerRadius"
            and property ~= "BorderRadius"
            and property ~= "Stroke"
            and property ~= "BorderColor3" then

            pcall(function()
                frame[property] = value
            end)
        end
    end

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(
        0,
        properties.CornerRadius or theme.Sizes.CornerRadius
    )
    corner.Parent = frame

    frame.Parent = parent

    return frame
end

function Components.CreateLabel(parent, theme, text, properties)
    properties = properties or {}

    local label = Instance.new("TextLabel")
    label.Name = properties.Name or "Label"
    label.Text = tostring(text or "")
    label.Size = properties.Size or UDim2.fromOffset(100, 24)
    label.Position = properties.Position or UDim2.fromOffset(0, 0)
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.TextColor3 = properties.TextColor3 or theme.Colors.Text
    label.Font = properties.Font or theme.Font
    label.TextSize = properties.TextSize or 13
    label.TextXAlignment =
        properties.TextXAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment =
        properties.TextYAlignment or Enum.TextYAlignment.Center
    label.TextWrapped = properties.TextWrapped or false
    label.TextTruncate = properties.TextTruncate or Enum.TextTruncate.None
    label.RichText = properties.RichText or false
    label.LayoutOrder = properties.LayoutOrder or 0
    label.ZIndex = properties.ZIndex or 2

    label.Parent = parent

    return label
end

function Components.CreateButton(parent, theme, text, callback, properties)
    properties = properties or {}

    local button = Instance.new("TextButton")
    button.Name = properties.Name or "Button"
    button.Text = tostring(text or "")
    button.Size = properties.Size or UDim2.fromOffset(120, 36)
    button.Position = properties.Position or UDim2.fromOffset(0, 0)
    button.BackgroundColor3 =
        properties.BackgroundColor3 or theme.Colors.ButtonBackground
    button.TextColor3 =
        properties.TextColor3 or theme.Colors.ButtonText
    button.Font = properties.Font or Enum.Font.GothamMedium
    button.TextSize = properties.TextSize or 12
    button.TextXAlignment =
        properties.TextXAlignment or Enum.TextXAlignment.Center
    button.TextYAlignment =
        properties.TextYAlignment or Enum.TextYAlignment.Center
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.LayoutOrder = properties.LayoutOrder or 0
    button.ZIndex = properties.ZIndex or 3

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(
        0,
        properties.CornerRadius or theme.Sizes.CornerRadius
    )
    corner.Parent = button

    button.Activated:Connect(function()
        if type(callback) == "function" then
            local success, err = pcall(callback)

            if not success then
                warn("[NYU HUB] Button error: " .. tostring(err))
            end
        end
    end)

    button.Parent = parent

    return button
end

function Components.CreateStroke(parent, theme)
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Colors.Border
    stroke.Thickness = theme.Sizes.BorderThickness
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent

    return stroke
end

return Components

end

-- ===== MODULE: ui.window =====
__factories["ui.window"] = function()
local Theme = __require("ui.theme")
local Components = __require("ui.components")
local Home = __require("ui.pages.home")
local Features = __require("ui.pages.features")
local Settings = __require("ui.pages.settings")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Window = {}

function Window.Create(options)
    options = options or {}

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local existing = playerGui:FindFirstChild("NyuHubUI")
    if existing then
        existing:Destroy()
    end

    local windowWidth = Theme.Sizes.WindowWidth
    local windowHeight = Theme.Sizes.WindowHeight
    local versionText = "v" .. tostring(options.Version or "1.0.0")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NyuHubUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 10

    -- Main window
    local root = Components.CreateFrame(screenGui, Theme, {
        Name = "Window",
        Size = UDim2.fromOffset(windowWidth, windowHeight),
        Position = UDim2.new(
            0.5, -windowWidth / 2,
            0.5, -windowHeight / 2
        ),
        BackgroundColor3 = Theme.Colors.Background,
        CornerRadius = 12,
        ClipsDescendants = true,
    })

    Components.CreateStroke(root, Theme)

    -- Header
    local header = Components.CreateFrame(root, Theme, {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight),
        BackgroundColor3 = Theme.Colors.Background,
        CornerRadius = 0,
    })

    header.Active = true

    -- Brand mark
    local brandMark = Components.CreateFrame(header, Theme, {
        Name = "BrandMark",
        Position = UDim2.fromOffset(18, 13),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Theme.Colors.Primary,
        CornerRadius = 8,
    })

    Components.CreateLabel(brandMark, Theme, "N", {
        Name = "BrandLetter",
        Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Colors.ButtonText,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    Components.CreateLabel(header, Theme, "NYU HUB", {
        Name = "Title",
        Position = UDim2.fromOffset(56, 7),
        Size = UDim2.fromOffset(110, 23),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
    })

    Components.CreateLabel(header, Theme, "SCRIPT HUB", {
        Name = "BrandSubtitle",
        Position = UDim2.fromOffset(57, 28),
        Size = UDim2.fromOffset(100, 14),
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = Theme.Colors.Muted,
    })

    Components.CreateLabel(header, Theme, versionText, {
        Name = "Version",
        Position = UDim2.new(1, -102, 0, 0),
        Size = UDim2.fromOffset(56, Theme.Sizes.HeaderHeight),
        TextColor3 = Theme.Colors.Muted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    -- Declare before callback to preserve the local reference.
    local floatingBar

    Components.CreateButton(
        header,
        Theme,
        "—",
        function()
            root.Visible = false
            floatingBar.Visible = true
        end,
        {
            Name = "MinimizeButton",
            Position = UDim2.new(1, -38, 0, 13),
            Size = UDim2.fromOffset(26, 26),
            BackgroundColor3 = Theme.Colors.SurfaceActive,
            TextColor3 = Theme.Colors.Text,
            TextSize = 15,
            CornerRadius = 7,
        }
    )

    local headerDivider = Instance.new("Frame")
    headerDivider.Name = "HeaderDivider"
    headerDivider.Position = UDim2.new(0, 0, 1, -1)
    headerDivider.Size = UDim2.new(1, 0, 0, 1)
    headerDivider.BackgroundColor3 = Theme.Colors.Border
    headerDivider.BorderSizePixel = 0
    headerDivider.Parent = header

    -- Sidebar
    local sidebar = Components.CreateFrame(root, Theme, {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, Theme.Sizes.HeaderHeight),
        Size = UDim2.new(
            0, Theme.Sizes.SidebarWidth,
            1, -Theme.Sizes.HeaderHeight
        ),
        BackgroundColor3 = Theme.Colors.Background,
        CornerRadius = 0,
    })

    Components.CreateLabel(sidebar, Theme, "WORKSPACE", {
        Name = "MenuLabel",
        Position = UDim2.fromOffset(18, 18),
        Size = UDim2.new(1, -30, 0, 18),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Theme.Colors.Muted,
    })

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "SidebarDivider"
    sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.BackgroundColor3 = Theme.Colors.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.Parent = sidebar

    -- Content area
    local content = Components.CreateFrame(root, Theme, {
        Name = "Content",
        Position = UDim2.fromOffset(
            Theme.Sizes.SidebarWidth,
            Theme.Sizes.HeaderHeight
        ),
        Size = UDim2.new(
            1, -Theme.Sizes.SidebarWidth,
            1, -Theme.Sizes.HeaderHeight
        ),
        BackgroundColor3 = Theme.Colors.Background,
        CornerRadius = 0,
    })

    local pageTitle = Components.CreateLabel(
        content,
        Theme,
        "Overview",
        {
            Name = "PageTitle",
            Position = UDim2.fromOffset(22, 16),
            Size = UDim2.new(1, -44, 0, 27),
            Font = Enum.Font.GothamBold,
            TextSize = 19,
        }
    )

    local pageSubtitle = Components.CreateLabel(
        content,
        Theme,
        "Your workspace at a glance.",
        {
            Name = "PageSubtitle",
            Position = UDim2.fromOffset(22, 43),
            Size = UDim2.new(1, -44, 0, 18),
            TextSize = 11,
            TextColor3 = Theme.Colors.Muted,
        }
    )

    local pageContainer = Components.CreateFrame(content, Theme, {
        Name = "PageContainer",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        CornerRadius = 0,
    })

    local currentPage
    local navigationButtons = {}

    local function clearPage()
        for _, child in ipairs(pageContainer:GetChildren()) do
            child:Destroy()
        end
    end

    local function showPage(pageName)
        clearPage()
        currentPage = pageName
        pageTitle.Text = pageName

        if pageName == "Home" then
            pageTitle.Text = "Overview"
            pageSubtitle.Text = "Your workspace at a glance."
        elseif pageName == "Features" then
            pageSubtitle.Text = "Manage available game features."
        elseif pageName == "Settings" then
            pageSubtitle.Text = "Configure your hub experience."
        end

        for name, button in pairs(navigationButtons) do
            local selected = name == pageName

            button.BackgroundColor3 = selected
                and Theme.Colors.SurfaceActive
                or Theme.Colors.Background

            button.TextColor3 = selected
                and Theme.Colors.Text
                or Theme.Colors.Muted

            local icon = button:FindFirstChild("NavIcon")
            if icon then
                icon.TextColor3 = selected
                    and Theme.Colors.Text
                    or Theme.Colors.Muted
            end

            local indicator = button:FindFirstChild("ActiveIndicator")
            if indicator then
                indicator.Visible = selected
            end
        end

        if pageName == "Home" then
            Home.Render(
                pageContainer,
                Theme,
                Components,
                options.GameInfo,
                options.GameModule
            )
        elseif pageName == "Features" then
            Features.Render(
                pageContainer,
                Theme,
                Components,
                options.GameModule
            )
        elseif pageName == "Settings" then
            Settings.Render(
                pageContainer,
                Theme,
                Components,
                {
                    Version = options.Version or "1.0.0",
                }
            )
        end
    end

    -- Navigation with compact text icons.
    local navigation = {
        { Name = "Home", Label = "Overview", Icon = "⌂" },
        { Name = "Features", Label = "Features", Icon = "◇" },
        { Name = "Settings", Label = "Settings", Icon = "⚙" },
    }

    for index, item in ipairs(navigation) do
        local button = Components.CreateButton(
            sidebar,
            Theme,
            item.Label,
            function()
                showPage(item.Name)
            end,
            {
                Name = item.Name .. "Button",
                Position = UDim2.fromOffset(
                    9,
                    48 + ((index - 1) * 42)
                ),
                Size = UDim2.new(1, -18, 0, 35),
                BackgroundColor3 = Theme.Colors.Background,
                TextColor3 = Theme.Colors.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 11,
                CornerRadius = 7,
            }
        )

        button.Text = ""
        button.AutoButtonColor = false

        local icon = Components.CreateLabel(
            button,
            Theme,
            item.Icon,
            {
                Name = "NavIcon",
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.fromOffset(22, 35),
                TextColor3 = Theme.Colors.Muted,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Center,
            }
        )

        icon.BackgroundTransparency = 1

        Components.CreateLabel(
            button,
            Theme,
            item.Label,
            {
                Name = "NavLabel",
                Position = UDim2.fromOffset(39, 0),
                Size = UDim2.new(1, -46, 1, 0),
                TextColor3 = Theme.Colors.Muted,
                TextSize = 11,
            }
        )

        local indicator = Instance.new("Frame")
        indicator.Name = "ActiveIndicator"
        indicator.Size = UDim2.fromOffset(3, 17)
        indicator.Position = UDim2.new(1, -4, 0.5, -8)
        indicator.BackgroundColor3 = Theme.Colors.Primary
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.Parent = button

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator

        navigationButtons[item.Name] = button
    end

    -- Sidebar footer
    local footerDivider = Instance.new("Frame")
    footerDivider.Name = "FooterDivider"
    footerDivider.Position = UDim2.new(0, 16, 1, -46)
    footerDivider.Size = UDim2.new(1, -32, 0, 1)
    footerDivider.BackgroundColor3 = Theme.Colors.Border
    footerDivider.BorderSizePixel = 0
    footerDivider.Parent = sidebar

    Components.CreateLabel(sidebar, Theme, "NYU STUDIO", {
        Name = "FooterBrand",
        Position = UDim2.new(0, 17, 1, -38),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Theme.Colors.Muted,
    })

    -- Floating bar
    floatingBar = Instance.new("TextButton")
    floatingBar.Name = "FloatingBar"
    floatingBar.Size = UDim2.fromOffset(230, 52)
    floatingBar.Position = UDim2.new(0.5, -115, 0, 18)
    floatingBar.BackgroundColor3 = Theme.Colors.Surface
    floatingBar.BorderSizePixel = 0
    floatingBar.Text = ""
    floatingBar.AutoButtonColor = false
    floatingBar.Visible = false
    floatingBar.Active = true
    floatingBar.ZIndex = 5

    local floatingCorner = Instance.new("UICorner")
    floatingCorner.CornerRadius = UDim.new(0, 14)
    floatingCorner.Parent = floatingBar

    local floatingStroke = Instance.new("UIStroke")
    floatingStroke.Color = Theme.Colors.Border
    floatingStroke.Thickness = 1
    floatingStroke.Parent = floatingBar

    local floatingLogo = Instance.new("Frame")
    floatingLogo.Name = "Logo"
    floatingLogo.Position = UDim2.fromOffset(11, 11)
    floatingLogo.Size = UDim2.fromOffset(30, 30)
    floatingLogo.BackgroundColor3 = Theme.Colors.Primary
    floatingLogo.BorderSizePixel = 0
    floatingLogo.ZIndex = 6
    floatingLogo.Parent = floatingBar

    local floatingLogoCorner = Instance.new("UICorner")
    floatingLogoCorner.CornerRadius = UDim.new(0, 8)
    floatingLogoCorner.Parent = floatingLogo

    local floatingLogoText = Instance.new("TextLabel")
    floatingLogoText.Name = "LogoText"
    floatingLogoText.Size = UDim2.fromScale(1, 1)
    floatingLogoText.BackgroundTransparency = 1
    floatingLogoText.Text = "N"
    floatingLogoText.TextColor3 = Theme.Colors.ButtonText
    floatingLogoText.Font = Enum.Font.GothamBold
    floatingLogoText.TextSize = 16
    floatingLogoText.ZIndex = 7
    floatingLogoText.Parent = floatingLogo

    local floatingTitle = Instance.new("TextLabel")
    floatingTitle.Name = "HubName"
    floatingTitle.Position = UDim2.fromOffset(50, 8)
    floatingTitle.Size = UDim2.new(1, -60, 0, 19)
    floatingTitle.BackgroundTransparency = 1
    floatingTitle.Text = "NYU HUB"
    floatingTitle.TextColor3 = Theme.Colors.Text
    floatingTitle.Font = Enum.Font.GothamBold
    floatingTitle.TextSize = 12
    floatingTitle.TextXAlignment = Enum.TextXAlignment.Left
    floatingTitle.ZIndex = 6
    floatingTitle.Parent = floatingBar

    local floatingVersion = Instance.new("TextLabel")
    floatingVersion.Name = "Version"
    floatingVersion.Position = UDim2.fromOffset(50, 27)
    floatingVersion.Size = UDim2.new(1, -60, 0, 14)
    floatingVersion.BackgroundTransparency = 1
    floatingVersion.Text = versionText .. "  ·  Click to open"
    floatingVersion.TextColor3 = Theme.Colors.Muted
    floatingVersion.Font = Enum.Font.Gotham
    floatingVersion.TextSize = 9
    floatingVersion.TextXAlignment = Enum.TextXAlignment.Left
    floatingVersion.ZIndex = 6
    floatingVersion.Parent = floatingBar

    floatingBar.Parent = screenGui

    -- Drag and resize controller
    local interaction = nil
    local wasDragged = false

    local function beginInteraction(input, target, mode)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        interaction = {
            Target = target,
            Mode = mode,
            InputType = input.UserInputType,
            StartInput = input.Position,
            StartPosition = target.Position,
            StartSize = target.Size,
        }

        wasDragged = false
    end

    header.InputBegan:Connect(function(input)
        beginInteraction(input, root, "drag")
    end)

    floatingBar.InputBegan:Connect(function(input)
        beginInteraction(input, floatingBar, "drag")
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not interaction then
            return
        end

        local isMouseMove =
            interaction.InputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement

        local isTouchMove =
            interaction.InputType == Enum.UserInputType.Touch
            and input.UserInputType == Enum.UserInputType.Touch

        if not isMouseMove and not isTouchMove then
            return
        end

        local delta = input.Position - interaction.StartInput

        if delta.Magnitude > 5 then
            wasDragged = true
        end

        if interaction.Mode == "drag" then
            local startPosition = interaction.StartPosition

            interaction.Target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        elseif interaction.Mode == "resize" then
            local startSize = interaction.StartSize

            local width = math.clamp(
                startSize.X.Offset + delta.X,
                560,
                1100
            )

            local height = math.clamp(
                startSize.Y.Offset + delta.Y,
                360,
                800
            )

            root.Size = UDim2.fromOffset(width, height)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not interaction then
            return
        end

        if input.UserInputType == interaction.InputType then
            interaction = nil
        end
    end)

    -- Resize handle
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.fromOffset(22, 22)
    resizeHandle.Position = UDim2.new(1, -22, 1, -22)
    resizeHandle.BackgroundColor3 = Theme.Colors.SurfaceActive
    resizeHandle.Text = "↘"
    resizeHandle.TextColor3 = Theme.Colors.Muted
    resizeHandle.TextSize = 12
    resizeHandle.BorderSizePixel = 0
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = root

    local resizeCorner = Instance.new("UICorner")
    resizeCorner.CornerRadius = UDim.new(0, 5)
    resizeCorner.Parent = resizeHandle

    resizeHandle.InputBegan:Connect(function(input)
        beginInteraction(input, root, "resize")
    end)

    floatingBar.Activated:Connect(function()
        if wasDragged then
            return
        end

        floatingBar.Visible = false
        root.Visible = true
    end)

    screenGui.Parent = playerGui

    showPage("Home")

    return {
        ScreenGui = screenGui,
        Root = root,
        Sidebar = sidebar,
        Content = content,
        FloatingBar = floatingBar,
        ShowPage = showPage,
        GetCurrentPage = function()
            return currentPage
        end,
    }
end

return Window
end

-- ===== MODULE: ui.pages.home =====
__factories["ui.pages.home"] = function()
local Home = {}

function Home.Render(parent, theme, components, gameInfo, gameModule)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "HomeContent" then
            child:Destroy()
        end
    end

    local container = components.CreateFrame(parent, theme, {
        Name = "HomeContent",
        Position = UDim2.fromOffset(20, 76),
        Size = UDim2.new(1, -40, 1, -92),
        BackgroundTransparency = 1,
        CornerRadius = 0,
    })

    local function createCard(name, position, size)
        local card = components.CreateFrame(container, theme, {
            Name = name,
            Position = position,
            Size = size,
            BackgroundColor3 = theme.Colors.Surface,
            CornerRadius = theme.Sizes.CardRadius,
        })

        components.CreateStroke(card, theme)

        return card
    end

    local detectedGame = "Unknown game"
    local supported = false

    if type(gameInfo) == "table" then
        if type(gameInfo.Name) == "string" then
            detectedGame = gameInfo.Name
        end

        supported = gameInfo.Enabled == true
    end

    local featureCount = 0

    if type(gameModule) == "table"
        and type(gameModule.GetFeatures) == "function" then

        local success, features = pcall(gameModule.GetFeatures)

        if success and type(features) == "table" then
            featureCount = #features
        end
    end

    -- Current game card
    local gameCard = createCard(
        "GameCard",
        UDim2.fromOffset(0, 0),
        UDim2.new(1, 0, 0, 116)
    )

    components.CreateLabel(gameCard, theme, "CURRENT EXPERIENCE", {
        Name = "SectionLabel",
        Position = UDim2.fromOffset(16, 13),
        Size = UDim2.new(1, -32, 0, 16),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = theme.Colors.Muted,
    })

    components.CreateLabel(gameCard, theme, detectedGame, {
        Name = "GameName",
        Position = UDim2.fromOffset(16, 35),
        Size = UDim2.new(1, -32, 0, 28),
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextWrapped = true,
    })

    local statusPill = components.CreateFrame(gameCard, theme, {
        Name = "GameStatus",
        Position = UDim2.fromOffset(16, 76),
        Size = UDim2.fromOffset(112, 25),
        BackgroundColor3 = theme.Colors.SurfaceActive,
        CornerRadius = 6,
    })

    local statusText = supported and "Supported" or "Not supported"

    components.CreateLabel(statusPill, theme, statusText, {
        Name = "StatusText",
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.new(1, -16, 1, 0),
        TextSize = 10,
        TextColor3 = supported
            and theme.Colors.Text
            or theme.Colors.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    -- Summary cards
    local summaryY = 128
    local gap = 10

    local summaryWidth = (container.AbsoluteSize.X - gap) / 2
    if summaryWidth <= 0 then
        summaryWidth = 250
    end

    local featureCard = createCard(
        "FeatureSummary",
        UDim2.fromOffset(0, summaryY),
        UDim2.new(0.5, -5, 0, 84)
    )

    components.CreateLabel(featureCard, theme, "AVAILABLE FEATURES", {
        Name = "SummaryTitle",
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.new(1, -28, 0, 16),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextColor3 = theme.Colors.Muted,
    })

    components.CreateLabel(featureCard, theme, tostring(featureCount), {
        Name = "FeatureCount",
        Position = UDim2.fromOffset(14, 32),
        Size = UDim2.new(1, -28, 0, 34),
        Font = Enum.Font.GothamBold,
        TextSize = 23,
    })

    local versionCard = createCard(
        "VersionSummary",
        UDim2.new(0.5, 5, 0, summaryY),
        UDim2.new(0.5, -5, 0, 84)
    )

    components.CreateLabel(versionCard, theme, "HUB VERSION", {
        Name = "SummaryTitle",
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.new(1, -28, 0, 16),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextColor3 = theme.Colors.Muted,
    })

    components.CreateLabel(
        versionCard,
        theme,
        "NYU HUB",
        {
            Name = "HubName",
            Position = UDim2.fromOffset(14, 32),
            Size = UDim2.new(1, -28, 0, 30),
            Font = Enum.Font.GothamBold,
            TextSize = 18,
        }
    )

    -- Welcome / information panel
    local infoCard = createCard(
        "InfoCard",
        UDim2.fromOffset(0, 222),
        UDim2.new(1, 0, 0, 74)
    )

    components.CreateLabel(infoCard, theme, "Workspace", {
        Name = "InfoTitle",
        Position = UDim2.fromOffset(14, 11),
        Size = UDim2.new(1, -28, 0, 20),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
    })

    components.CreateLabel(
        infoCard,
        theme,
        "Manage your available scripts and game features from one place.",
        {
            Name = "InfoDescription",
            Position = UDim2.fromOffset(14, 34),
            Size = UDim2.new(1, -28, 0, 28),
            TextColor3 = theme.Colors.Muted,
            TextSize = 10,
            TextWrapped = true,
        }
    )

    return container
end

return Home
end

-- ===== MODULE: ui.pages.features =====
__factories["ui.pages.features"] = function()
local Features = {}

function Features.Render(parent, theme, components, gameModule)
    local container = components.CreateFrame(parent, theme, {
        Name = "FeaturesContent",
        Position = UDim2.fromOffset(20, 76),
        Size = UDim2.new(1, -40, 1, -92),
        BackgroundTransparency = 1,
        CornerRadius = 0,
    })

    if not gameModule or type(gameModule.GetFeatures) ~= "function" then
        components.CreateLabel(
            container,
            theme,
            "No features are available for this game.",
            {
                Name = "EmptyMessage",
                Size = UDim2.new(1, 0, 0, 30),
                TextSize = 12,
                TextColor3 = theme.Colors.Muted,
            }
        )

        return container
    end

    local success, features = pcall(gameModule.GetFeatures)

    if not success or type(features) ~= "table" or #features == 0 then
        components.CreateLabel(
            container,
            theme,
            "No features are available yet.",
            {
                Name = "EmptyMessage",
                Size = UDim2.new(1, 0, 0, 30),
                TextSize = 12,
                TextColor3 = theme.Colors.Muted,
            }
        )

        return container
    end

    local function getFeatureState(featureName, fallback)
        local ok, currentFeatures = pcall(gameModule.GetFeatures)

        if not ok or type(currentFeatures) ~= "table" then
            return fallback
        end

        for _, currentFeature in ipairs(currentFeatures) do
            if currentFeature.Name == featureName then
                return currentFeature.Enabled == true
            end
        end

        return fallback
    end

    for index, feature in ipairs(features) do
        local card = components.CreateFrame(container, theme, {
            Name = "Feature_" .. index,
            Position = UDim2.fromOffset(0, (index - 1) * 82),
            Size = UDim2.new(1, 0, 0, 72),
            BackgroundColor3 = theme.Colors.Surface,
            CornerRadius = theme.Sizes.CardRadius,
        })

        components.CreateStroke(card, theme)

        local featureIcon = components.CreateFrame(card, theme, {
            Name = "FeatureIcon",
            Position = UDim2.fromOffset(12, 17),
            Size = UDim2.fromOffset(36, 36),
            BackgroundColor3 = theme.Colors.SurfaceActive,
            CornerRadius = 8,
        })

        components.CreateLabel(featureIcon, theme, "◇", {
            Name = "Icon",
            Size = UDim2.fromScale(1, 1),
            TextColor3 = theme.Colors.Text,
            TextSize = 17,
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        components.CreateLabel(card, theme, feature.Name or "Unnamed feature", {
            Name = "FeatureName",
            Position = UDim2.fromOffset(60, 12),
            Size = UDim2.new(1, -205, 0, 20),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
        })

        components.CreateLabel(
            card,
            theme,
            feature.Description or "No description available.",
            {
                Name = "FeatureDescription",
                Position = UDim2.fromOffset(60, 34),
                Size = UDim2.new(1, -205, 0, 22),
                TextSize = 10,
                TextColor3 = theme.Colors.Muted,
                TextWrapped = true,
            }
        )

        local isEnabled = feature.Enabled == true
        local button

        button = components.CreateButton(
            card,
            theme,
            isEnabled and "Nonaktifkan" or "Aktifkan",
            function()
                if type(gameModule.ToggleWalkSpeed) ~= "function" then
                    warn("[NYU HUB] Toggle handler tidak tersedia.")
                    return
                end

                local ok, message = gameModule.ToggleWalkSpeed()

                if not ok then
                    warn("[NYU HUB] " .. tostring(message))
                    return
                end

                local actualState = getFeatureState(
                    feature.Name,
                    not isEnabled
                )

                isEnabled = actualState
                button.Text = actualState
                    and "Nonaktifkan"
                    or "Aktifkan"

                print("[NYU HUB] " .. tostring(message))
            end,
            {
                Name = "ToggleButton",
                Position = UDim2.new(1, -124, 0, 18),
                Size = UDim2.fromOffset(112, 36),
                TextSize = 10,
                CornerRadius = 7,
                BackgroundColor3 = isEnabled
                    and theme.Colors.SurfaceActive
                    or theme.Colors.Primary,
                TextColor3 = isEnabled
                    and theme.Colors.Text
                    or theme.Colors.ButtonText,
            }
        )
    end

    return container
end

return Features
end

-- ===== MODULE: ui.pages.settings =====
__factories["ui.pages.settings"] = function()

--[[
    NYU HUB
    File: ui/pages/settings.lua
    Description: Halaman pengaturan NYU HUB.
]]

local Settings = {}

function Settings.Render(parent, theme, components, options)
    options = options or {}

    -- Hapus konten Settings sebelumnya.
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "SettingsContent" then
            child:Destroy()
        end
    end

    local container = components.CreateFrame(parent, theme, {
        Name = "SettingsContent",
        Position = UDim2.fromOffset(20, 58),
        Size = UDim2.new(1, -40, 1, -78),
        BackgroundTransparency = 1,
    })

    components.CreateLabel(container, theme, "General Settings", {
        Name = "SectionTitle",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 26),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
    })

    -- Informasi versi.
    local versionCard = components.CreateFrame(container, theme, {
        Name = "VersionCard",
        Position = UDim2.fromOffset(0, 38),
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = theme.Colors.Surface,
    })

    components.CreateStroke(versionCard, theme)

    components.CreateLabel(versionCard, theme, "NYU HUB Version", {
        Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -28, 0, 22),
        TextSize = 12,
        TextColor3 = theme.Colors.Muted,
    })

    components.CreateLabel(
        versionCard,
        theme,
        options.Version or "1.0.0",
        {
            Name = "VersionValue",
            Position = UDim2.fromOffset(14, 31),
            Size = UDim2.new(1, -28, 0, 22),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
        }
    )

    -- Pengaturan animasi.
    local animationCard = components.CreateFrame(container, theme, {
        Name = "AnimationCard",
        Position = UDim2.fromOffset(0, 114),
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = theme.Colors.Surface,
    })

    components.CreateStroke(animationCard, theme)

    components.CreateLabel(
        animationCard,
        theme,
        "UI Animations",
        {
            Position = UDim2.fromOffset(14, 8),
            Size = UDim2.new(1, -100, 0, 22),
            TextSize = 13,
        }
    )

    local animationStatus = components.CreateLabel(
        animationCard,
        theme,
        theme.Animation.Enabled and "Enabled" or "Disabled",
        {
            Name = "AnimationStatus",
            Position = UDim2.new(1, -100, 0, 8),
            Size = UDim2.fromOffset(86, 22),
            TextColor3 = theme.Colors.Muted,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextSize = 12,
        }
    )

    -- Tombol tutup UI.
    local closeButton = components.CreateButton(
        container,
        theme,
        "Close NYU HUB",
        function()
            local screenGui = container:FindFirstAncestorOfClass("ScreenGui")

            if screenGui then
                screenGui:Destroy()
            end
        end,
        {
            Name = "CloseButton",
            Position = UDim2.fromOffset(0, 192),
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = theme.Colors.Primary,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
        }
    )

    return {
        Container = container,
        AnimationStatus = animationStatus,
        CloseButton = closeButton,
    }
end

return Settings

end

-- ===== MODULE: games.game1 =====
__factories["games.game1"] = function()
local Game1 = {
    Name = "Game 1",
    Description = "Modul fitur untuk Game 1.",
}

local Players = game:GetService("Players")
local WALK_SPEED = 32

local speedEnabled = false
local originalWalkSpeed = nil

local function getHumanoid()
    local player = Players.LocalPlayer
    local character = player and player.Character

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

function Game1.GetFeatures()
    return {
        {
            Name = "Lari Cepat",
            Description = "Meningkatkan kecepatan jalan karakter.",
            Enabled = speedEnabled,
        },
    }
end

function Game1.ToggleWalkSpeed()
    local humanoid = getHumanoid()

    if not humanoid then
        return false, "Karakter belum siap."
    end

    if speedEnabled then
        if originalWalkSpeed then
            humanoid.WalkSpeed = originalWalkSpeed
        end

        speedEnabled = false
        originalWalkSpeed = nil

        return true, "Lari cepat dinonaktifkan."
    end

    originalWalkSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = WALK_SPEED
    speedEnabled = true

    return true, "Lari cepat diaktifkan."
end

function Game1.Init(context)
    print("[NYU HUB] Game 1 module initialized.")

    return {
        Success = true,
        Message = "Game 1 berhasil diinisialisasi.",
    }
end

function Game1.Destroy()
    local humanoid = getHumanoid()

    if speedEnabled and humanoid and originalWalkSpeed then
        humanoid.WalkSpeed = originalWalkSpeed
    end

    speedEnabled = false
    originalWalkSpeed = nil

    print("[NYU HUB] Game 1 module stopped.")
end

return Game1
end

-- ===== MODULE: games.game2 =====
__factories["games.game2"] = function()

--[[
    NYU HUB
    File: games/game2.lua
    Description: Template modul untuk Game 2.
]]

local GameModule = {
    Name = "Game 2",
    Description = "Modul game kedua NYU HUB.",
    Version = "1.0.0",
}

function GameModule.GetFeatures()
    return {
        {
            Name = "Feature A",
            Description = "Contoh fitur pertama untuk Game 2.",
        },
        {
            Name = "Feature B",
            Description = "Contoh fitur kedua untuk Game 2.",
        },
    }
end

function GameModule.Init(context)
    context = context or {}

    print("[NYU HUB] Game 2 module initialized.")

    return {
        Success = true,
        Message = "Game 2 berhasil diinisialisasi.",
    }
end

function GameModule.Destroy()
    print("[NYU HUB] Game 2 module stopped.")
end

return GameModule

end

-- ===== MODULE: games.game3 =====
__factories["games.game3"] = function()

--[[
    NYU HUB
    File: games/game3.lua
    Description: Template modul untuk Game 3.
]]

local GameModule = {
    Name = "Game 3",
    Description = "Modul game ketiga NYU HUB.",
    Version = "1.0.0",
}

function GameModule.GetFeatures()
    return {
        {
            Name = "Feature A",
            Description = "Contoh fitur pertama untuk Game 3.",
        },
        {
            Name = "Feature B",
            Description = "Contoh fitur kedua untuk Game 3.",
        },
    }
end

function GameModule.Init(context)
    context = context or {}

    print("[NYU HUB] Game 3 module initialized.")

    return {
        Success = true,
        Message = "Game 3 berhasil diinisialisasi.",
    }
end

function GameModule.Destroy()
    print("[NYU HUB] Game 3 module stopped.")
end

return GameModule

end

-- ===== MODULE: games.game4 =====
__factories["games.game4"] = function()

--[[
    NYU HUB
    File: games/game4.lua
    Description: Template modul untuk Game 4.
]]

local GameModule = {
    Name = "Game 4",
    Description = "Modul game keempat NYU HUB.",
    Version = "1.0.0",
}

function GameModule.GetFeatures()
    return {
        {
            Name = "Feature A",
            Description = "Contoh fitur pertama untuk Game 4.",
        },
        {
            Name = "Feature B",
            Description = "Contoh fitur kedua untuk Game 4.",
        },
    }
end

function GameModule.Init(context)
    context = context or {}

    print("[NYU HUB] Game 4 module initialized.")

    return {
        Success = true,
        Message = "Game 4 berhasil diinisialisasi.",
    }
end

function GameModule.Destroy()
    print("[NYU HUB] Game 4 module stopped.")
end

return GameModule

end

-- ===== MODULE: games.game5 =====
__factories["games.game5"] = function()

--[[
    NYU HUB
    File: games/game5.lua
    Description: Template modul untuk Game 5.
]]

local GameModule = {
    Name = "Game 5",
    Description = "Modul game kelima NYU HUB.",
    Version = "1.0.0",
}

function GameModule.GetFeatures()
    return {
        {
            Name = "Feature A",
            Description = "Contoh fitur pertama untuk Game 5.",
        },
        {
            Name = "Feature B",
            Description = "Contoh fitur kedua untuk Game 5.",
        },
    }
end

function GameModule.Init(context)
    context = context or {}

    print("[NYU HUB] Game 5 module initialized.")

    return {
        Success = true,
        Message = "Game 5 berhasil diinisialisasi.",
    }
end

function GameModule.Destroy()
    print("[NYU HUB] Game 5 module stopped.")
end

return GameModule

end

-- ===== MODULE: main =====
__factories["main"] = function()

--[[
    NYU HUB
    Description: Entry point utama NYU HUB.
]]

local NYUHub = {
    Name = "NYU HUB",
    Version = "1.0.0",
}

local function log(message)
    print("[NYU HUB] " .. tostring(message))
end

local function getPlaceId()
    local success, placeId = pcall(function()
        return game.PlaceId
    end)

    if not success or type(placeId) ~= "number" then
        return nil, "Tidak dapat membaca PlaceId."
    end

    return placeId
end

function NYUHub.Start(dependencies)
    dependencies = dependencies or {}

    local config = dependencies.Config
    local detector = dependencies.Detector
    local windowModule = dependencies.Window
    local registry = dependencies.Registry
    local loader = dependencies.Loader

    if type(config) ~= "table"
        or type(detector) ~= "table"
        or type(windowModule) ~= "table"
        or type(registry) ~= "table"
        or type(loader) ~= "table" then

        return false, "Dependensi NYU HUB belum lengkap."
    end

    log("Starting version " .. NYUHub.Version .. "...")

    local placeId, placeIdError = getPlaceId()

    if not placeId then
        log(placeIdError)
        return false, placeIdError
    end

    log("PlaceId: " .. tostring(placeId))

    local gameConfig, detectError = detector.Detect(config, placeId)

    if not gameConfig then
        log(detectError)

        windowModule.Create({
            Version = NYUHub.Version,
            GameInfo = {
                Name = "Game tidak didukung",
                Enabled = false,
            },
        })

        return false, detectError
    end

    local gameModule = registry.Get(gameConfig.Id)

    if not gameModule then
        local message = "Modul game belum terdaftar."

        log(message)

        windowModule.Create({
            Version = NYUHub.Version,
            GameInfo = gameConfig,
        })

        return false, message
    end

    local initialized, initResult = loader.Init(
        gameConfig,
        gameModule,
        {
            PlaceId = placeId,
            GameConfig = gameConfig,
        }
    )

    if not initialized then
        log(initResult)
        return false, initResult
    end

    local window = windowModule.Create({
        Version = NYUHub.Version,
        GameInfo = gameConfig,
        GameModule = gameModule,
    })

    log("Loaded " .. tostring(gameConfig.Name))

    return true, {
        Window = window,
        GameConfig = gameConfig,
        GameModule = gameModule,
        InitResult = initResult,
    }
end

return NYUHub

end

-- ===== NYU HUB BOOTSTRAP =====
local Config = __require('config.games')
local Detector = __require('core.detector')
local Registry = __require('core.registry')
local Loader = __require('core.loader')
local Window = __require('ui.window')
local Main = __require('main')

local gameModules = {
    game1 = __require('games.game1'),
    game2 = __require('games.game2'),
    game3 = __require('games.game3'),
    game4 = __require('games.game4'),
    game5 = __require('games.game5'),
}

for _, gameConfig in ipairs(Config) do
    if gameConfig.Enabled == true
        and type(gameConfig.Id) == 'number' then

        local module = gameModules[gameConfig.Module]
        if module then
            local ok, err = Registry.Register(gameConfig.Id, module)
            if not ok then
                warn('[NYU HUB] ' .. tostring(err))
            end
        end
    end
end

local ok, result = Main.Start({
    Config = Config,
    Detector = Detector,
    Registry = Registry,
    Loader = Loader,
    Window = Window,
})

if not ok then
    warn('[NYU HUB] Startup gagal: ' .. tostring(result))
end
