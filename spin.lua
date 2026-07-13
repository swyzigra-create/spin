local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Переменные для спина
local isSpinning = false
local currentSpeed = 0

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpinGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное меню (кнопки)
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 200)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
menuFrame.Parent = screenGui

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🎡 SPIN MENU"
titleLabel.Parent = menuFrame

-- Кнопка "Запустить спин"
local spinButton = Instance.new("TextButton")
spinButton.Name = "SpinButton"
spinButton.Size = UDim2.new(0.8, 0, 0, 50)
spinButton.Position = UDim2.new(0.1, 0, 0, 70)
spinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.TextSize = 18
spinButton.Font = Enum.Font.GothamBold
spinButton.Text = "1️⃣ SPIN"
spinButton.Parent = menuFrame

-- Кнопка "Выход"
local exitButton = Instance.new("TextButton")
exitButton.Name = "ExitButton"
exitButton.Size = UDim2.new(0.8, 0, 0, 50)
exitButton.Position = UDim2.new(0.1, 0, 0, 130)
exitButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.TextSize = 18
exitButton.Font = Enum.Font.GothamBold
exitButton.Text = "2️⃣ ВЫХОД"
exitButton.Parent = menuFrame

-- Окно выбора скорости (появляется после нажатия кнопки)
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(0, 350, 0, 250)
speedFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedFrame.BorderSizePixel = 2
speedFrame.BorderColor3 = Color3.fromRGB(100, 150, 255)
speedFrame.Visible = false
speedFrame.Parent = screenGui

-- Заголовок выбора скорости
local speedTitle = Instance.new("TextLabel")
speedTitle.Name = "SpeedTitle"
speedTitle.Size = UDim2.new(1, 0, 0, 50)
speedTitle.Position = UDim2.new(0, 0, 0, 0)
speedTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
speedTitle.TextSize = 22
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Text = "⚡ ВЫБЕРИТЕ СКОРОСТЬ"
speedTitle.Parent = speedFrame

-- Input поле для скорости
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0.8, 0, 0, 45)
speedInput.Position = UDim2.new(0.1, 0, 0, 70)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 18
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "Введите скорость (1-100)"
speedInput.Parent = speedFrame

-- Кнопка подтверждения
local confirmButton = Instance.new("TextButton")
confirmButton.Name = "ConfirmButton"
confirmButton.Size = UDim2.new(0.35, 0, 0, 45)
confirmButton.Position = UDim2.new(0.1, 0, 0, 135)
confirmButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmButton.TextSize = 16
confirmButton.Font = Enum.Font.GothamBold
confirmButton.Text = "✅ НАЧАТЬ"
confirmButton.Parent = speedFrame

-- Кнопка отмены
local cancelButton = Instance.new("TextButton")
cancelButton.Name = "CancelButton"
cancelButton.Size = UDim2.new(0.35, 0, 0, 45)
cancelButton.Position = UDim2.new(0.55, 0, 0, 135)
cancelButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelButton.TextSize = 16
cancelButton.Font = Enum.Font.GothamBold
cancelButton.Text = "❌ ОТМЕНА"
cancelButton.Parent = speedFrame

-- Статус спина
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
statusLabel.Position = UDim2.new(0.1, 0, 0, 190)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Статус: готово"
statusLabel.Parent = speedFrame

-- Функция для спина персонажа
function spin(speed)
    if isSpinning then return end
    
    isSpinning = true
    statusLabel.Text = "Статус: 🌪️ СПИНЮ... (скорость: " .. speed .. ")"
    
    local spinTime = 5 -- длительность спина в секундах
    local startTime = tick()
    
    while tick() - startTime < spinTime and isSpinning do
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(speed), 0)
        end
        RunService.RenderStepped:Wait()
    end
    
    isSpinning = false
    statusLabel.Text = "Статус: ✅ спин закончен!"
    wait(2)
    statusLabel.Text = "Статус: готово"
end

-- Функция валидации скорости
function isValidSpeed(speedStr)
    local speed = tonumber(speedStr)
    if speed == nil then return false, "Введите число!" end
    if speed < 1 or speed > 100 then return false, "Скорость от 1 до 100!" end
    return true, speed
end

-- Обработчики кнопок
spinButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    speedFrame.Visible = true
    speedInput:CaptureFocus()
end)

confirmButton.MouseButton1Click:Connect(function()
    local valid, result = isValidSpeed(speedInput.Text)
    if valid then
        currentSpeed = result
        speedFrame.Visible = false
        menuFrame.Visible = true
        speedInput.Text = ""
        spin(currentSpeed)
    else
        statusLabel.Text = "❌ Ошибка: " .. result
        wait(2)
        statusLabel.Text = "Статус: готово"
    end
end)

cancelButton.MouseButton1Click:Connect(function()
    speedFrame.Visible = false
    menuFrame.Visible = true
    speedInput.Text = ""
end)

exitButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("Меню закрыто!")
end)

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.One then
        menuFrame.Visible = false
        speedFrame.Visible = true
        speedInput:CaptureFocus()
    elseif input.KeyCode == Enum.KeyCode.Two then
        screenGui:Destroy()
    end
end)

print("✅ Спин скрипт загружен! Нажми кнопки или используй цифры 1-2")
