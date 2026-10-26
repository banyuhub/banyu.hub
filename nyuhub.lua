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
        Enabled = false,
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

--[[
    NYU HUB
    File: ui/theme.lua
    Description: Tema visual untuk custom UI.
]]

local Theme = {
    Name = "NYU HUB Default",

    Colors = {
        Background = Color3.fromRGB(247, 247, 245),
        Surface = Color3.fromRGB(255, 255, 255),

        Primary = Color3.fromRGB(31, 41, 55),
        Secondary = Color3.fromRGB(80, 109, 132),

        Text = Color3.fromRGB(31, 41, 55),
        Muted = Color3.fromRGB(107, 114, 134),

        Border = Color3.fromRGB(231, 229, 228),
        Disabled = Color3.fromRGB(231, 229, 228),
    },

    Sizes = {
        WindowWidth = 720,
        WindowHeight = 460,

        SidebarWidth = 160,
        HeaderHeight = 52,

        CornerRadius = 10,
        BorderThickness = 1,
        Padding = 12,
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

--[[
    NYU HUB
    File: ui/components.lua
    Description: Komponen dasar custom UI.
]]

local Components = {}

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent

    return corner
end

function Components.CreateFrame(parent, theme, properties)
    local frame = Instance.new("Frame")

    frame.BackgroundColor3 = theme.Colors.Surface
    frame.BorderSizePixel = 0

    for property, value in pairs(properties or {}) do
        frame[property] = value
    end

    createCorner(frame, theme.Sizes.CornerRadius)

    frame.Parent = parent

    return frame
end

function Components.CreateLabel(parent, theme, text, properties)
    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = theme.Colors.Text
    label.Font = theme.Font
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    for property, value in pairs(properties or {}) do
        label[property] = value
    end

    label.Parent = parent

    return label
end

function Components.CreateButton(parent, theme, text, callback, properties)
    local button = Instance.new("TextButton")

    button.BackgroundColor3 = theme.Colors.Background
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = theme.Colors.Text
    button.Font = theme.Font
    button.TextSize = 14
    button.AutoButtonColor = true

    for property, value in pairs(properties or {}) do
        button[property] = value
    end

    createCorner(button, theme.Sizes.CornerRadius)

    if type(callback) == "function" then
        button.Activated:Connect(callback)
    end

    button.Parent = parent

    return button
end

function Components.CreateStroke(parent, theme)
    local stroke = Instance.new("UIStroke")

    stroke.Color = theme.Colors.Border
    stroke.Thickness = theme.Sizes.BorderThickness
    stroke.Parent = parent

    return stroke
end

return Components

end

-- ===== MODULE: ui.window =====
__factories["ui.window"] = function()

--[[
    NYU HUB
    File: ui/window.lua
    Description: Window utama dan navigasi halaman.
]]

local Theme = __require("ui.theme")
local Components = __require("ui.components")

local Home = __require("ui.pages.home")
local Features = __require("ui.pages.features")
local Settings = __require("ui.pages.settings")

local Window = {}

function Window.Create(options)
    options = options or {}

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Hapus UI lama jika ada.
    local existing = playerGui:FindFirstChild("NyuHubUI")
    if existing then
        existing:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NyuHubUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local root = Components.CreateFrame(screenGui, Theme, {
        Name = "Window",
        Size = UDim2.fromOffset(
            Theme.Sizes.WindowWidth,
            Theme.Sizes.WindowHeight
        ),
        Position = UDim2.new(
            0.5,
            -Theme.Sizes.WindowWidth / 2,
            0.5,
            -Theme.Sizes.WindowHeight / 2
        ),
        BackgroundColor3 = Theme.Colors.Background,
    })

    Components.CreateStroke(root, Theme)

    -- Header.
    local header = Components.CreateFrame(root, Theme, {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Theme.Colors.Surface,
    })

    Components.CreateLabel(header, Theme, "NYU HUB", {
        Name = "Title",
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -32, 1, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 17,
    })

    -- Sidebar.
    local sidebar = Components.CreateFrame(root, Theme, {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, Theme.Sizes.HeaderHeight),
        Size = UDim2.new(
            0,
            Theme.Sizes.SidebarWidth,
            1,
            -Theme.Sizes.HeaderHeight
        ),
        BackgroundColor3 = Theme.Colors.Surface,
    })

    -- Area konten.
    local content = Components.CreateFrame(root, Theme, {
        Name = "Content",
        Position = UDim2.fromOffset(
            Theme.Sizes.SidebarWidth,
            Theme.Sizes.HeaderHeight
        ),
        Size = UDim2.new(
            1,
            -Theme.Sizes.SidebarWidth,
            1,
            -Theme.Sizes.HeaderHeight
        ),
        BackgroundColor3 = Theme.Colors.Background,
    })

    local pageTitle = Components.CreateLabel(content, Theme, "Home", {
        Name = "PageTitle",
        Position = UDim2.fromOffset(20, 16),
        Size = UDim2.new(1, -40, 0, 30),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
    })

    local pageContainer = Components.CreateFrame(content, Theme, {
        Name = "PageContainer",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    })

    local currentPage = nil
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

        -- Tandai tombol halaman aktif.
        for name, button in pairs(navigationButtons) do
            button.BackgroundColor3 =
                name == pageName
                and Theme.Colors.Disabled
                or Theme.Colors.Background
        end

        if pageName == "Home" then
            Home.Render(
                pageContainer,
                Theme,
                Components,
                options.GameInfo
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

    local navigation = {
        "Home",
        "Features",
        "Settings",
    }

    for index, pageName in ipairs(navigation) do
        local button = Components.CreateButton(
            sidebar,
            Theme,
            "   " .. pageName,
            function()
                showPage(pageName)
            end,
            {
                Name = pageName .. "Button",
                Position = UDim2.fromOffset(
                    10,
                    16 + ((index - 1) * 44)
                ),
                Size = UDim2.new(1, -20, 0, 36),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 13,
            }
        )

        navigationButtons[pageName] = button
    end

    screenGui.Parent = playerGui

    -- Tampilkan halaman Home saat pertama dibuka.
    showPage("Home")

    return {
        ScreenGui = screenGui,
        Root = root,
        Sidebar = sidebar,
        Content = content,
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

--[[
    NYU HUB
    File: ui/pages/home.lua
    Description: Konten dashboard Home.
]]

local Home = {}

function Home.Render(parent, theme, components, gameInfo)
    -- Bersihkan konten Home sebelumnya.
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "HomeContent" then
            child:Destroy()
        end
    end

    local container = components.CreateFrame(parent, theme, {
        Name = "HomeContent",
        Position = UDim2.fromOffset(20, 58),
        Size = UDim2.new(1, -40, 1, -78),
        BackgroundTransparency = 1,
    })

    local function createInfoCard(name, title, value, position)
        local card = components.CreateFrame(container, theme, {
            Name = name,
            Position = position,
            Size = UDim2.new(0.5, -6, 0, 100),
            BackgroundColor3 = theme.Colors.Surface,
        })

        components.CreateStroke(card, theme)

        components.CreateLabel(card, theme, title, {
            Name = "CardTitle",
            Position = UDim2.fromOffset(14, 12),
            Size = UDim2.new(1, -28, 0, 22),
            TextColor3 = theme.Colors.Muted,
            TextSize = 12,
        })

        local valueLabel = components.CreateLabel(card, theme, value, {
            Name = "CardValue",
            Position = UDim2.fromOffset(14, 39),
            Size = UDim2.new(1, -28, 0, 34),
            Font = Enum.Font.GothamBold,
            TextSize = 17,
            TextWrapped = true,
        })

        return valueLabel
    end

    local detectedGame = "Tidak terdeteksi"
    local gameStatus = "Belum dikonfigurasi"

    if type(gameInfo) == "table" then
        if type(gameInfo.Name) == "string" then
            detectedGame = gameInfo.Name
        end

        if gameInfo.Enabled == true then
            gameStatus = "Didukung"
        else
            gameStatus = "Belum aktif"
        end
    end

    createInfoCard(
        "GameCard",
        "GAME TERDETEKSI",
        detectedGame,
        UDim2.fromOffset(0, 0)
    )

    createInfoCard(
        "StatusCard",
        "STATUS GAME",
        gameStatus,
        UDim2.new(0.5, 6, 0, 0)
    )

    local welcome = components.CreateFrame(container, theme, {
        Name = "WelcomeCard",
        Position = UDim2.fromOffset(0, 116),
        Size = UDim2.new(1, 0, 0, 112),
        BackgroundColor3 = theme.Colors.Surface,
    })

    components.CreateStroke(welcome, theme)

    components.CreateLabel(welcome, theme, "Welcome to NYU HUB", {
        Name = "WelcomeTitle",
        Position = UDim2.fromOffset(16, 14),
        Size = UDim2.new(1, -32, 0, 26),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
    })

    components.CreateLabel(
        welcome,
        theme,
        "Your game scripts and available features will be managed here.",
        {
            Name = "WelcomeDescription",
            Position = UDim2.fromOffset(16, 44),
            Size = UDim2.new(1, -32, 0, 44),
            TextColor3 = theme.Colors.Muted,
            TextSize = 12,
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
        Position = UDim2.fromOffset(20, 58),
        Size = UDim2.new(1, -40, 1, -78),
        BackgroundTransparency = 1,
    })

    if not gameModule or type(gameModule.GetFeatures) ~= "function" then
        components.CreateLabel(
            container,
            theme,
            "Fitur untuk game ini belum tersedia.",
            {
                Name = "EmptyMessage",
                Size = UDim2.new(1, 0, 0, 30),
                TextSize = 13,
            }
        )

        return
    end

    local success, features = pcall(gameModule.GetFeatures)

    if not success or type(features) ~= "table" or #features == 0 then
        components.CreateLabel(
            container,
            theme,
            "Belum ada fitur yang tersedia.",
            {
                Name = "EmptyMessage",
                Size = UDim2.new(1, 0, 0, 30),
                TextSize = 13,
            }
        )

        return
    end

    for index, feature in ipairs(features) do
        local card = components.CreateFrame(container, theme, {
            Name = "Feature_" .. index,
            Position = UDim2.fromOffset(0, (index - 1) * 82),
            Size = UDim2.new(1, 0, 0, 72),
            BackgroundColor3 = theme.Colors.Surface,
        })

        components.CreateStroke(card, theme)

        components.CreateLabel(card, theme, feature.Name, {
            Name = "FeatureName",
            Position = UDim2.fromOffset(12, 8),
            Size = UDim2.new(1, -150, 0, 22),
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        components.CreateLabel(card, theme, feature.Description, {
            Name = "FeatureDescription",
            Position = UDim2.fromOffset(12, 32),
            Size = UDim2.new(1, -150, 0, 24),
            TextSize = 11,
            TextColor3 = theme.Colors.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
        })


        local button

        button = components.CreateButton(
            card,
            theme,
            feature.Enabled and "Nonaktifkan" or "Aktifkan",
            function()
                if type(gameModule.ToggleWalkSpeed) ~= "function" then
                    return
                end

                local ok, message = gameModule.ToggleWalkSpeed()

                if not ok then
                    warn("[NYU HUB] " .. tostring(message))
                    return
                end

                button.Text = message == "Lari cepat diaktifkan."
                    and "Nonaktifkan"
                    or "Aktifkan"

                print("[NYU HUB] " .. tostring(message))
            end,
            {
                Name = "ToggleButton",
                Position = UDim2.new(1, -124, 0, 18),
                Size = UDim2.fromOffset(112, 36),
                TextSize = 11,
            }
        )
    end
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
    File: main.lua
    Description: Entry point utama NYU HUB.
]]

local NYUHub = {
    Name = "NYU HUB",
    Version = "1.0.0",
}

local function log(message)
    print("[NYU HUB] " .. tostring(message))
end

local function getGameId()
    local success, gameId = pcall(function()
        return game.GameId
    end)

    if not success or type(gameId) ~= "number" then
        return nil, "Tidak dapat membaca GameId."
    end

    return gameId
end

function NYUHub.Start(dependencies)
    dependencies = dependencies or {}

    local config = dependencies.Config
    local detector = dependencies.Detector
    local windowModule = dependencies.Window
    local registry = dependencies.Registry
    local loader = dependencies.Loader

    -- Validasi dependensi.
    if type(config) ~= "table"
        or type(detector) ~= "table"
        or type(windowModule) ~= "table"
        or type(registry) ~= "table"
        or type(loader) ~= "table" then

        return false, "Dependensi NYU HUB belum lengkap."
    end

    log("Starting version " .. NYUHub.Version .. "...")

    -- Deteksi pengalaman Roblox.
    local gameId, gameIdError = getGameId()

    if not gameId then
        log(gameIdError)
        return false, gameIdError
    end

    log("GameId: " .. tostring(gameId))

    local gameConfig, detectError = detector.Detect(config, gameId)

    if not gameConfig then
        log(detectError)

        -- Tetap buka UI agar status game bisa dilihat.
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

    -- Inisialisasi modul yang cocok dengan game.
    local initialized, initResult = loader.Init(
        gameConfig,
        gameModule,
        {
            GameId = gameId,
            GameConfig = gameConfig,
        }
    )

    if not initialized then
        log(initResult)
        return false, initResult
    end

    -- UI hanya menerima modul untuk game yang terdeteksi.
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
