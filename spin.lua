-- Упрощённый спин скрипт для Delta Injector (мобила)
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

print("✅ Спин скрипт загружен!")

-- Функция спина
function spin(speed)
    print("🌪️ Начал спин со скоростью: " .. speed)
    
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local root = Character.HumanoidRootPart
        local spinTime = 5 -- 5 секунд спина
        local startTime = tick()
        
        while tick() - startTime < spinTime do
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed), 0)
            wait(0.01)
        end
        
        print("✅ Спин завершён!")
    else
        print("❌ Ошибка: HumanoidRootPart не найден!")
    end
end

-- Простое меню через print (в консоль Delta)
print("\n=== СПИН МЕНЮ ===")
print("Введи в консоль: spin(50)")
print("Где 50 - это скорость от 1 до 100")
print("Пример: spin(30) - медленный спин")
print("        spin(90) - быстрый спин")
print("=================\n")

-- Делаем функцию глобальной для использования в консоли
_G.spin = spin

print("💡 Введи в консоли: spin(50)")
