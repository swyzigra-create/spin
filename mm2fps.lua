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

-- Переменные для перемещения меню
local dragging = false
local dragStart = nil
local dragOffset = nil

-- ====== СОЗДАЁМ GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2ExploitGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное меню (Frame с кнопками) - УМЕНЬШЕНО В 2 РАЗА
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 140, 0, 225)
menuFrame.Position = UDim2.new(0, 10, 0.5, -112)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(255, 50, 100)
menuFrame.Parent = screenGui

-- Функция для перемещения меню (Drag and Drop)
local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            dragOffset = frame.AbsolutePosition - input.Position
        end
    end)

    frame.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            frame.Position = UDim2.new(0, input.Position.X + dragOffset.X, 0, input.Position.Y + dragOffset.Y)
        end
    end)
end

makeDraggable(menuFrame)

-- Заголовок меню с кнопкой закрытия
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 30)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = menuFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "MM2"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame

-- Кнопка закрытия меню
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 25, 1, 0)
closeBtn.Position = UDim2.new(0.75, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleFrame

-- Кнопка открытия меню (видна только когда меню закрыто)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "📋"
toggleBtn.Visible = false
toggleBtn.Parent = screenGui

-- Функция создания кнопки
local function createButton(name, position, color, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 25)
    button.Position = position
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 10
    button.Font = Enum.Font.GothamBold
    button.Text = name
    button.Parent = parent
    return button
end

-- Создаём кнопки (позиции адаптированы для уменьшенного меню)
local aimbotBtn = createButton("🎯 AIM", UDim2.new(0.05, 0, 0, 35), Color3.fromRGB(200, 50, 50), menuFrame)
local roleBtn = createButton("👁️ ROLE", UDim2.new(0.05, 0, 0, 62), Color3.fromRGB(50, 100, 200), menuFrame)
local grabBtn = createButton("🔫 GUN", UDim2.new(0.05, 0, 0, 89), Color3.fromRGB(200, 150, 50), menuFrame)
local noclipBtn = createButton("👻 NO", UDim2.new(0.05, 0, 0, 116), Color3.fromRGB(100, 200, 100), menuFrame)
local flyBtn = createButton("🛸 FLY", UDim2.new(0.05, 0, 0, 143), Color3.fromRGB(200, 100, 200), menuFrame)
local bunnyhopBtn = createButton("🐰 JUMP", UDim2.new(0.05, 0, 0, 170), Color3.fromRGB(255, 200, 50), menuFrame)

-- Статус дисплей
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.9, 0, 0, 15)
statusLabel.Position = UDim2.new(0.05, 0, 0, 200)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Готово"
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

-- ====== ROLE HIGHLIGHT (ESP) - СРАЗУ ВКЛЮЧАЕТСЯ ======
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
    updateRoles()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                local role = playerRoles[player.UserId] or "Unknown"
                
                -- ВСЕГДА подсвечиваем убийцу и шерифа
                if role == "Murderer" or role == "Sheriff" then
                    if not highlightedPlayers[player.UserId] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlightedPlayers[player.UserId] = highlight
                    end
                    
                    local highlight = highlightedPlayers[player.UserId]
                    
                    if role == "Murderer" then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillTransparency = 0.2
                        highlight.OutlineTransparency = 0
                    elseif role == "Sheriff" then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255)
                        highlight.FillTransparency = 0.2
                        highlight.OutlineTransparency = 0
                    end
                end
            end
        end
    end
end

-- ====== GRAB GUN (ИСПРАВЛЕНО - БЕРЁТ ПИСТОЛЕТ ШЕРИФА) ======
local function grabGun()
    updateRoles()
    
    -- Ищем мёртвого шерифа или живого шерифа
    local sheriffPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local role = playerRoles[player.UserId]
            if role == "Sheriff" then
                sheriffPlayer = player
                break
            end
        end
    end
    
    if sheriffPlayer and sheriffPlayer.Character then
        local sheriffRootPart = sheriffPlayer.Character:FindFirstChild("HumanoidRootPart")
        local playerRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if sheriffRootPart and playerRootPart then
            -- Ищем пистолет шерифа
            local gunFound = false
            
            -- Сначала ищем в персонаже шерифа
            for _, obj in pairs(sheriffPlayer.Character:GetChildren()) do
                if obj:IsA("Tool") and obj.Name == "Gun" then
                    obj.Parent = Character
                    statusLabel.Text = "🔫 Пистолет!"
                    task.wait(1)
                    statusLabel.Text = "Готово"
                    gunFound = true
                    break
                end
            end
            
            -- Если не нашли в персонаже, ищем на земле возле шерифа
            if not gunFound then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Tool") and obj.Name == "Gun" then
                        local gunPos = obj:FindFirstChild("Handle")
                        if gunPos then
                            local distance = (gunPos.Position - sheriffRootPart.Position).Magnitude
                            if distance < 50 then
                                -- Телепортируемся к пистолету
                                playerRootPart.CFrame = gunPos.CFrame + Vector3.new(0, 0, 3)
                                task.wait(0.3)
                                obj.Parent = Character
                                statusLabel.Text = "🔫 Взял пистолет!"
                                task.wait(1)
                                statusLabel.Text = "Готово"
                                gunFound = true
                                break
                            end
                        end
                    end
                end
            end
            
            if not gunFound then
                statusLabel.Text = "❌ Пистолет не найден"
            end
        end
    else
        statusLabel.Text = "❌ Шериф не найден"
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

-- ====== FLY (ПОЛНОСТЬЮ ПЕРЕДЕЛАН) ======
local flySpeed = 100
local currentFlyVelocity = Vector3.new(0, 0, 0)

local function fly()
    if not flyEnabled then return end
    
    if Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Character.HumanoidRootPart
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Получаем направление от камеры
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- Нормализуем и применяем скорость
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        else
            moveDirection = Vector3.new(0, 0, 0)
        end
        
        currentFlyVelocity = moveDirection
        rootPart.CFrame = rootPart.CFrame + currentFlyVelocity / 60
    end
end

-- ====== BUNNYHOP (УСИЛЕНО) ======
local lastJumpTime = 0
local jumpCooldown = 0.3

local function bunnyhop()
    if not bunnyhopEnabled then return end
    
    if Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") then
        local currentTime = tick()
        local rootPart = Character.HumanoidRootPart
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if (currentTime - lastJumpTime) > jumpCooldown then
                -- Даём обычный прыжок
                Character.Humanoid:Jump()
                
                -- Добавляем BodyVelocity для усиления прыжка
                if rootPart:FindFirstChild("JumpBoost") then
                    rootPart.JumpBoost:Destroy()
                end
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Name = "JumpBoost"
                bodyVelocity.Velocity = Vector3.new(0, 200, 0) -- Очень высокий прыжок
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = rootPart
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.15)
                
                lastJumpTime = currentTime
            end
        end
    end
end

-- ====== ОБРАБОТЧИКИ КНОПОК ЗАКРЫТИЯ/ОТКРЫТИЯ ======
closeBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    toggleBtn.Visible = true
    statusLabel.Text = "Меню закрыто"
end)

toggleBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = true
    toggleBtn.Visible = false
    statusLabel.Text = "Меню открыто"
end)

-- ====== ОБРАБОТЧИКИ КНОПОК ======
aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 50, 50)
    statusLabel.Text = aimbotEnabled and "AIM: ВКЛ" or "AIM: ВЫКЛ"
end)

roleBtn.MouseButton1Click:Connect(function()
    roleHighlightEnabled = not roleHighlightEnabled
    roleBtn.BackgroundColor3 = roleHighlightEnabled and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(50, 100, 200)
    statusLabel.Text = roleHighlightEnabled and "ROLE: ВКЛ" or "ROLE: ВЫКЛ"
end)

grabBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "⏳ Ищу пистолет..."
    grabGun()
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 200, 100)
    statusLabel.Text = noclipEnabled and "NO: ВКЛ" or "NO: ВЫКЛ"
end)

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    currentFlyVelocity = Vector3.new(0, 0, 0)
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(200, 100, 200)
    statusLabel.Text = flyEnabled and "FLY: ВКЛ" or "FLY: ВЫКЛ"
end)

bunnyhopBtn.MouseButton1Click:Connect(function()
    bunnyhopEnabled = not bunnyhopEnabled
    bunnyhopBtn.BackgroundColor3 = bunnyhopEnabled and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(255, 200, 50)
    statusLabel.Text = bunnyhopEnabled and "JUMP: ВКЛ" or "JUMP: ВЫКЛ"
end)

-- ====== ОСНОВНОЙ ЦИКЛ ======
RunService.RenderStepped:Connect(function()
    if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
        -- ESP ВСЕГДА РАБОТАЕТ
        roleHighlight()
        
        -- Остальные функции
        aimbot()
        noclip()
        fly()
        bunnyhop()
    end
end)

print("✅ MM2 Exploit готов!")
print("🎮 Нажимай кнопки на экране для управления!")
print("📋 Кнопка меню закрытия справа в заголовке")
print("👁️ ESP ВКЛЮЧЕН СРАЗУ - ВИДИШЬ КРАСНЫЙ (УБИЙЦА) и СИНИЙ (ШЕРИФ)!")
