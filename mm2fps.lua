-- MM2 Exploit для Delta Injector (Мобила с GUI кнопками)
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

-- ====== СОЗДАЁМ GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2ExploitGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное меню (Frame с кнопками)
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 280, 0, 450)
menuFrame.Position = UDim2.new(0, 10, 0.5, -225)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(255, 50, 100)
menuFrame.Parent = screenGui

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🎮 MM2 EXPLOIT"
titleLabel.Parent = menuFrame

-- Функция создания кнопки
local function createButton(name, position, color, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = position
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Text = name
    button.Parent = parent
    return button
end

-- Создаём кнопки
local aimbotBtn = createButton("🎯 AIMBOT", UDim2.new(0.05, 0, 0, 60), Color3.fromRGB(200, 50, 50), menuFrame)
local roleBtn = createButton("👁️ ROLES", UDim2.new(0.05, 0, 0, 120), Color3.fromRGB(50, 100, 200), menuFrame)
local grabBtn = createButton("🔫 GRAB GUN", UDim2.new(0.05, 0, 0, 180), Color3.fromRGB(200, 150, 50), menuFrame)
local noclipBtn = createButton("👻 NOCLIP", UDim2.new(0.05, 0, 0, 240), Color3.fromRGB(100, 200, 100), menuFrame)
local flyBtn = createButton("🛸 FLY", UDim2.new(0.05, 0, 0, 300), Color3.fromRGB(200, 100, 200), menuFrame)
local bunnyhopBtn = createButton("🐰 BUNNYHOP", UDim2.new(0.05, 0, 0, 360), Color3.fromRGB(255, 200, 50), menuFrame)

-- Статус дисплей
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.9, 0, 0, 35)
statusLabel.Position = UDim2.new(0.05, 0, 0, 410)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Статус: готово"
statusLabel.Parent = menuFrame

-- ====== AIMBOT ======
local function getEnemyMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then
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
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if player:FindFirstChild("Role") then
                    playerRoles[player.UserId] = player.Role.Value
                else
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
                
                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    end
end

-- ====== GRAB GUN ======
local function grabGun()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Knife") then
            obj.Parent = Character
            statusLabel.Text = "Статус: 🔫 Схватил " .. obj.Name
            task.wait(1)
            statusLabel.Text = "Статус: готово"
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

-- ====== ОБРАБОТЧИКИ КНОПОК ======
aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 50, 50)
    statusLabel.Text = aimbotEnabled and "Статус: 🎯 Aimbot ВКЛ" or "Статус: 🎯 Aimbot ВЫКЛ"
end)

roleBtn.MouseButton1Click:Connect(function()
    roleHighlightEnabled = not roleHighlightEnabled
    roleBtn.BackgroundColor3 = roleHighlightEnabled and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(50, 100, 200)
    statusLabel.Text = roleHighlightEnabled and "Статус: 👁️ Roles ВКЛ" or "Статус: 👁️ Roles ВЫКЛ"
end)

grabBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Статус: 🔫 Ищу оружие..."
    grabGun()
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 200, 100)
    statusLabel.Text = noclipEnabled and "Статус: 👻 Noclip ВКЛ" or "Статус: 👻 Noclip ВЫКЛ"
end)

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(200, 100, 200)
    statusLabel.Text = flyEnabled and "Статус: 🛸 Fly ВКЛ" or "Статус: 🛸 Fly ВЫКЛ"
end)

bunnyhopBtn.MouseButton1Click:Connect(function()
    bunnyhopEnabled = not bunnyhopEnabled
    bunnyhopBtn.BackgroundColor3 = bunnyhopEnabled and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(255, 200, 50)
    statusLabel.Text = bunnyhopEnabled and "Статус: 🐰 Bunnyhop ВКЛ" or "Статус: 🐰 Bunnyhop ВЫКЛ"
end)

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
    end
end)

print("✅ MM2 Exploit готов!")
print("🎮 Нажимай кнопки на экране для управления!")
