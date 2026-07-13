-- Murder Mystery 2 Auto Farm Script для Delta Injector (МОБИЛЬНАЯ ВЕРСИЯ)
-- Автофарм + Авто-ресет при макс монетах + СКЛАДНОЕ МЕНЮ

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== КОНФИГУРАЦИЯ =====
local CONFIG = {
    MAX_COINS = 500,           -- Максимум монет перед ресетом
    AUTO_FARM_ENABLED = false, -- Включить автофарм (выключено при старте)
    AUTO_RESET_ENABLED = true, -- Включить авто-ресет
    FARM_RANGE = 100,          -- Дальность поиска NPC
    FARM_SPEED = 0.1,          -- Скорость фарма (меньше = быстрее)
    DEBUG_MODE = true,         -- Вывод логов
    MOBILE_MODE = true         -- Мобильный режим
}

-- ===== ПЕРЕМЕННЫЕ =====
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local CurrentCoins = 0
local IsFarming = false
local UIPanel = nil
local MenuOpen = false

-- ===== ФУНКЦИИ =====

-- Логирование
local function Log(message)
    if CONFIG.DEBUG_MODE then
        print("[MM2 FARM MOBILE] " .. tostring(message))
    end
end

-- Получить текущее количество монет
local function GetCoins()
    if not Player then return 0 end
    
    local PlayerStats = Player:FindFirstChild("leaderstats")
    if PlayerStats then
        local CoinsValue = PlayerStats:FindFirstChild("Coins") or PlayerStats:FindFirstChild("Money")
        if CoinsValue then
            return CoinsValue.Value
        end
    end
    return 0
end

-- Найти ближайший NPC для фарма
local function FindNearestNPC()
    if not RootPart then return nil end
    
    local NPCs = workspace:FindFirstChild("NPCs") or workspace
    local NearestNPC = nil
    local MinDistance = CONFIG.FARM_RANGE
    
    for _, npc in pairs(NPCs:GetDescendants()) do
        if npc:IsA("Humanoid") and npc.Parent ~= Character then
            local NPCRoot = npc.Parent:FindFirstChild("HumanoidRootPart")
            if NPCRoot then
                local Distance = (RootPart.Position - NPCRoot.Position).Magnitude
                if Distance < MinDistance and npc.Health > 0 then
                    MinDistance = Distance
                    NearestNPC = npc.Parent
                end
            end
        end
    end
    
    return NearestNPC
end

-- Атаковать NPC (оптимизировано для мобилки)
local function AttackNPC(npc)
    if not npc or not npc:FindFirstChild("Humanoid") then return end
    if not Character or not RootPart then return end
    
    local NPCRoot = npc:FindFirstChild("HumanoidRootPart")
    if not NPCRoot then return end
    
    -- Телепортация к NPC
    pcall(function()
        RootPart.CFrame = NPCRoot.CFrame + NPCRoot.CFrame.LookVector * 3
    end)
    task.wait(0.1)
    
    -- Поиск оружия в инвентаре
    local Backpack = Player:FindFirstChild("Backpack")
    if Backpack then
        local Weapon = Backpack:FindFirstChildWhichIsA("Tool")
        if Weapon then
            Weapon.Parent = Character
            task.wait(0.2)
            
            -- Активация атаки
            if Weapon:FindFirstChild("Handle") then
                local RemoteEvents = Weapon:FindFirstChildWhichIsA("RemoteEvent")
                if RemoteEvents then
                    pcall(function()
                        RemoteEvents:FireServer()
                    end)
                else
                    pcall(function()
                        Weapon:Activate()
                    end)
                end
            end
        end
    end
end

-- Ресет игры
local function ResetGame()
    if not Player then return end
    
    local Stats = Player:FindFirstChild("leaderstats")
    if Stats then
        local ResetEvent = workspace:FindFirstChild("ResetEvent") or 
                          game:GetService("ReplicatedStorage"):FindFirstChild("ResetEvent")
        
        if ResetEvent then
            pcall(function()
                ResetEvent:FireServer()
            end)
            Log("Ресет выполнен")
        else
            if Character and Humanoid then
                Humanoid.Health = 0
                Log("Ресет выполнен (смерть)")
            end
        end
    end
end

-- Автофарм основной цикл
local function AutoFarm()
    Log("Автофарм начат!")
    
    while CONFIG.AUTO_FARM_ENABLED do
        if not Character or not Humanoid or Humanoid.Health <= 0 then
            Character = Player.Character or Player.CharacterAdded:Wait()
            Humanoid = Character:WaitForChild("Humanoid")
            RootPart = Character:WaitForChild("HumanoidRootPart")
            task.wait(1)
        end
        
        if CONFIG.AUTO_FARM_ENABLED then
            CurrentCoins = GetCoins()
            
            -- Проверка на максимум монет
            if CONFIG.AUTO_RESET_ENABLED and CurrentCoins >= CONFIG.MAX_COINS then
                Log("Достигнут максимум монет (" .. CurrentCoins .. "). Выполняю ресет...")
                UpdateUI()
                ResetGame()
                task.wait(3)
            end
            
            -- Поиск и атака NPC
            local NearestNPC = FindNearestNPC()
            if NearestNPC then
                AttackNPC(NearestNPC)
            end
        end
        
        task.wait(CONFIG.FARM_SPEED)
    end
    
    Log("Автофарм остановлен")
end

-- ===== МОБИЛЬНЫЙ UI С СКЛАДНЫМ МЕНЮ =====

-- Функция для анимации открытия/закрытия
local function AnimatePanel(panel, targetSize, duration)
    local startTime = tick()
    local startSize = panel.Size
    
    while tick() - startTime < duration do
        local progress = (tick() - startTime) / duration
        panel.Size = UDim2.new(
            startSize.X.Scale + (targetSize.X.Scale - startSize.X.Scale) * progress,
            startSize.X.Offset + (targetSize.X.Offset - startSize.X.Offset) * progress,
            startSize.Y.Scale + (targetSize.Y.Scale - startSize.Y.Scale) * progress,
            startSize.Y.Offset + (targetSize.Y.Offset - startSize.Y.Offset) * progress
        )
        task.wait(0.016)
    end
    panel.Size = targetSize
end

-- Функция для изменения видимости элементов
local function SetChildrenVisible(parent, visible)
    for _, child in pairs(parent:GetChildren()) do
        if child.Name ~= "Title" and child.Name ~= "ToggleButton" then
            child.Visible = visible
        end
    end
end

-- Обновить UI
local function UpdateUI()
    if UIPanel then
        UIPanel.CoinsLabel.Text = "💰 " .. CurrentCoins .. "/" .. CONFIG.MAX_COINS
        
        if CONFIG.AUTO_FARM_ENABLED then
            UIPanel.StatusLabel.Text = "📊 АКТИВЕН ✓"
            UIPanel.FarmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            UIPanel.FarmButton.Text = "⏸ СТОП"
        else
            UIPanel.StatusLabel.Text = "📊 ВЫКЛЮЧЕН"
            UIPanel.FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            UIPanel.FarmButton.Text = "▶ ФАРМ"
        end
    end
end

-- Создать UI панель
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MM2FarmUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Основная панель (уменьшена в 1.5 раза: было 280x250, теперь ~187x167)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainPanel"
    MainFrame.Size = UDim2.new(0, 200, 0, 50)  -- Сначала закрыта
    MainFrame.Position = UDim2.new(0, 10, 0, 50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true
    
    -- Скругление углов
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Заголовок/Кнопка переключения
    local Title = Instance.new("TextButton")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🎮 MM2 FARM ▼"
    Title.BorderSizePixel = 0
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title
    
    -- Информация о монетах
    local CoinsLabel = Instance.new("TextLabel")
    CoinsLabel.Name = "CoinsLabel"
    CoinsLabel.Size = UDim2.new(1, -6, 0, 22)
    CoinsLabel.Position = UDim2.new(0, 3, 0, 55)
    CoinsLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CoinsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    CoinsLabel.TextSize = 10
    CoinsLabel.Font = Enum.Font.GothamMedium
    CoinsLabel.Text = "💰 0/" .. CONFIG.MAX_COINS
    CoinsLabel.Parent = MainFrame
    CoinsLabel.Visible = false
    
    -- Статус
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -6, 0, 18)
    StatusLabel.Position = UDim2.new(0, 3, 0, 80)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 9
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "📊 готов"
    StatusLabel.Parent = MainFrame
    StatusLabel.Visible = false
    
    -- Кнопка фарма (уменьшена)
    local FarmButton = Instance.new("TextButton")
    FarmButton.Name = "FarmButton"
    FarmButton.Size = UDim2.new(0.45, -2, 0, 28)
    FarmButton.Position = UDim2.new(0, 3, 0, 102)
    FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmButton.TextSize = 9
    FarmButton.Font = Enum.Font.GothamBold
    FarmButton.Text = "▶ ФАРМ"
    FarmButton.BorderSizePixel = 0
    FarmButton.Parent = MainFrame
    FarmButton.Visible = false
    
    local FarmCorner = Instance.new("UICorner")
    FarmCorner.CornerRadius = UDim.new(0, 5)
    FarmCorner.Parent = FarmButton
    
    -- Кнопка ресета (уменьшена)
    local ResetButton = Instance.new("TextButton")
    ResetButton.Name = "ResetButton"
    ResetButton.Size = UDim2.new(0.45, -2, 0, 28)
    ResetButton.Position = UDim2.new(0.55, 0, 0, 102)
    ResetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResetButton.TextSize = 9
    ResetButton.Font = Enum.Font.GothamBold
    ResetButton.Text = "🔄 РЕСЕТ"
    ResetButton.BorderSizePixel = 0
    ResetButton.Parent = MainFrame
    ResetButton.Visible = false
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 5)
    ResetCorner.Parent = ResetButton
    
    -- Кнопка авто-ресета (уменьшена)
    local AutoResetButton = Instance.new("TextButton")
    AutoResetButton.Name = "AutoResetButton"
    AutoResetButton.Size = UDim2.new(1, -6, 0, 25)
    AutoResetButton.Position = UDim2.new(0, 3, 0, 133)
    AutoResetButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    AutoResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoResetButton.TextSize = 8
    AutoResetButton.Font = Enum.Font.GothamBold
    AutoResetButton.Text = "🔁 АВТО-РЕСЕТ: ВКЛ"
    AutoResetButton.BorderSizePixel = 0
    AutoResetButton.Parent = MainFrame
    AutoResetButton.Visible = false
    
    local AutoResetCorner = Instance.new("UICorner")
    AutoResetCorner.CornerRadius = UDim.new(0, 5)
    AutoResetCorner.Parent = AutoResetButton
    
    -- Состояние меню
    local IsMenuOpen = false
    local FullSize = UDim2.new(0, 200, 0, 165)
    local CollapsedSize = UDim2.new(0, 200, 0, 50)
    
    -- Обработчик открытия/закрытия меню
    Title.TouchTap:Connect(function()
        IsMenuOpen = not IsMenuOpen
        
        if IsMenuOpen then
            -- Открытие меню
            Title.Text = "🎮 MM2 FARM ▲"
            SetChildrenVisible(MainFrame, true)
            AnimatePanel(MainFrame, FullSize, 0.3)
            Log("Меню открыто")
        else
            -- Закрытие меню
            Title.Text = "🎮 MM2 FARM ▼"
            SetChildrenVisible(MainFrame, false)
            AnimatePanel(MainFrame, CollapsedSize, 0.3)
            Log("Меню закрыто")
        end
    end)
    
    -- Обработчики кнопок
    FarmButton.TouchTap:Connect(function()
        CONFIG.AUTO_FARM_ENABLED = not CONFIG.AUTO_FARM_ENABLED
        UpdateUI()
        Log("Фарм: " .. (CONFIG.AUTO_FARM_ENABLED and "ВКЛЮЧЕН" or "ВЫКЛЮЧЕН"))
    end)
    
    ResetButton.TouchTap:Connect(function()
        Log("Ручной ресет...")
        ResetGame()
    end)
    
    AutoResetButton.TouchTap:Connect(function()
        CONFIG.AUTO_RESET_ENABLED = not CONFIG.AUTO_RESET_ENABLED
        if CONFIG.AUTO_RESET_ENABLED then
            AutoResetButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            AutoResetButton.Text = "🔁 АВТО-РЕСЕТ: ВКЛ"
        else
            AutoResetButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            AutoResetButton.Text = "🔁 АВТО-РЕСЕТ: ВЫКЛ"
        end
        Log("Авто-ресет: " .. (CONFIG.AUTO_RESET_ENABLED and "ВКЛЮЧЕН" or "ВЫКЛЮЧЕН"))
    end)
    
    return {
        Frame = MainFrame,
        CoinsLabel = CoinsLabel,
        StatusLabel = StatusLabel,
        FarmButton = FarmButton,
        Title = Title,
        IsOpen = IsMenuOpen
    }
end

-- Обновление UI каждый кадр
RunService.RenderStepped:Connect(function()
    if CONFIG.AUTO_FARM_ENABLED then
        CurrentCoins = GetCoins()
        UpdateUI()
    end
end)

-- ===== ИНИЦИАЛИЗАЦИЯ =====
task.wait(1)
Log("Скрипт загружен для МОБИЛЬНОГО УСТРОЙСТВА!")
UIPanel = CreateUI()
Log("UI панель создана (складное меню)")

-- Запуск автофарма в отдельной корутине
spawn(function()
    AutoFarm()
end)

Log("Автофарм готов к запуску!")
