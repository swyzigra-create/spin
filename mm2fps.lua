-- MM2 Exploit для Delta Injector (Мобила)
-- Функции: Aimbot, Role Highlight, Grab Gun, Noclip, Fly, Bunnyhop

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

print("✅ MM2 Exploit загружен!")

-- Переменные для функций
local aimbotEnabled = false
local roleHighlightEnabled = false
local noclipEnabled = false
local flyEnabled = false
local bunnyhopEnabled = false
local grabGunEnabled = false

-- Таблицы для хранения информации
local playerRoles = {}
local highlightedPlayers = {}

-- ====== AIMBOT ======
local function getEnemyMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then
                    -- Проверяем роль (мардер/шериф)
                    if playerRoles[player.UserId] == "Murderer" or playerRoles[player.UserId] == "Sheriff" then
                        return humanoidRootPart
                    end
                end
            end
        end
    end
    return nil
end

local function aimbot()
    if not aimbotEnabled then return end
    
    local target = getEnemyMurderer()
    if target then
        local direction = (target.Position - Camera.CFrame.Position).Unit
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
    end
end

-- ====== ROLE HIGHLIGHT ======
local function updateRoles()
    -- Получаем роли из GameTag
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- Проверяем теги игрока
                if player:FindFirstChild("Role") then
                    playerRoles[player.UserId] = player.Role.Value
                else
                    -- Пытаемся определить роль по оружию
                    if player.Character:FindFirstChild("Knife") then
                        playerRoles[player.UserId] = "Murderer"
                    elseif player.Character:FindFirstChild("Gun") then
                        playerRoles[player.UserId] = "Sheriff"
                    else
                        playerRoles[player.UserId] = "Innocent"
                    end
                end
            end
        end
    end
end

local function roleHighlight()
    if not roleHighlightEnabled then return end
    
    updateRoles()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                if not highlightedPlayers[player.UserId] then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlightedPlayers[player.UserId] = highlight
                end
                
                local highlight = highlightedPlayers[player.UserId]
                local role = playerRoles[player.UserId] or "Unknown"
                
                -- Разные цвета для разных ролей
                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Синий
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Зелёный
                end
            end
        end
    end
end

-- ====== GRAB GUN ======
local function grabGun()
    if not grabGunEnabled then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Knife") then
            obj.Parent = Character
            print("🔫 Схватил: " .. obj.Name)
            grabGunEnabled = false
            break
        end
    end
end

-- ====== NOCLIP ======
local function noclip()
    if not noclipEnabled then return end
    
    if Character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- ====== FLY ======
local flySpeed = 50
local flyDirection = Vector3.new(0, 0, 0)

local function fly()
    if not flyEnabled then return end
    
    if Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Character.HumanoidRootPart
        
        -- Клавиши управления
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            flyDirection = flyDirection + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            flyDirection = flyDirection - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            flyDirection = flyDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            flyDirection = flyDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            flyDirection = flyDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            flyDirection = flyDirection - Vector3.new(0, 1, 0)
        end
        
        flyDirection = flyDirection:Lerp(Vector3.new(0, 0, 0), 0.1)
        rootPart.CFrame = rootPart.CFrame + flyDirection * (flySpeed / 60)
    end
end

-- ====== BUNNYHOP ======
local canBunnyhop = true

local function bunnyhop()
    if not bunnyhopEnabled or not canBunnyhop then return end
    
    if Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") then
        Character.Humanoid:Jump()
        canBunnyhop = false
        task.wait(0.1)
        canBunnyhop = true
    end
end

-- ====== МЕНЮ В КОНСОЛИ ======
print("\n╔════════════════════════════════════════╗")
print("║  MM2 EXPLOIT МЕНЮ                      ║")
print("╚════════════════════════════════════════╝\n")

print("🎯 AIMBOT:")
print("  _G.toggleAimbot() - Вкл/Выкл Aimbot\n")

print("👁️ ROLE HIGHLIGHT:")
print("  _G.toggleRoleHighlight() - Вкл/Выкл Подсветку ролей\n")

print("🔫 GRAB GUN:")
print("  _G.grabGun() - Взять оружие\n")

print("👻 NOCLIP:")
print("  _G.toggleNoclip() - Вкл/Выкл Noclip\n")

print("🛸 FLY:")
print("  _G.toggleFly() - Вкл/Выкл Полёт")
print("  Управление: WASD + Space + Ctrl\n")

print("🐰 BUNNYHOP:")
print("  _G.toggleBunnyhop() - Вкл/Выкл Bunnyhop\n")

print("════════════════════════════════════════\n")

-- ====== ФУНКЦИИ ПЕРЕКЛЮЧЕНИЯ ======
_G.toggleAimbot = function()
    aimbotEnabled = not aimbotEnabled
    print(aimbotEnabled and "✅ Aimbot: ВКЛ" or "❌ Aimbot: ВЫКЛ")
end

_G.toggleRoleHighlight = function()
    roleHighlightEnabled = not roleHighlightEnabled
    print(roleHighlightEnabled and "✅ Role Highlight: ВКЛ" or "❌ Role Highlight: ВЫКЛ")
end

_G.toggleNoclip = function()
    noclipEnabled = not noclipEnabled
    print(noclipEnabled and "✅ Noclip: ВКЛ" or "❌ Noclip: ВЫКЛ")
end

_G.toggleFly = function()
    flyEnabled = not flyEnabled
    print(flyEnabled and "✅ Fly: ВКЛ" or "❌ Fly: ВЫКЛ")
end

_G.toggleBunnyhop = function()
    bunnyhopEnabled = not bunnyhopEnabled
    print(bunnyhopEnabled and "✅ Bunnyhop: ВКЛ" or "❌ Bunnyhop: ВЫКЛ")
end

_G.grabGun = function()
    grabGunEnabled = true
    grabGun()
    print("🔫 Попытка взять оружие...")
end

-- ====== ОСНОВНОЙ ЦИКЛ ======
RunService.RenderStepped:Connect(function()
    if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
        aimbot()
        roleHighlight()
        noclip()
        fly()
        
        if bunnyhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            bunnyhop()
        end
    else
        print("⚠️ Персонаж умер или не найден!")
    end
end)

-- ====== ГОРЯЧИЕ КЛАВИШИ ======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then _G.toggleAimbot() end
    if input.KeyCode == Enum.KeyCode.F2 then _G.toggleRoleHighlight() end
    if input.KeyCode == Enum.KeyCode.F3 then _G.grabGun() end
    if input.KeyCode == Enum.KeyCode.F4 then _G.toggleNoclip() end
    if input.KeyCode == Enum.KeyCode.F5 then _G.toggleFly() end
    if input.KeyCode == Enum.KeyCode.F6 then _G.toggleBunnyhop() end
end)

print("🎮 Нажми F1-F6 для быстрого переключения функций!")
print("💡 Или используй команды из меню выше!\n")
