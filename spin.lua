local Player = game.Players.LocalPlayer

function showMenu()
    print("Выберите действие:")
    print("1. Spin")
    print("2. Выйти")
end

function spin(speed)
    print("Вы начали спин с скоростью: " .. speed)
    -- Здесь добавьте код для спина  
end

function chooseSpeed()
    local speed  
    repeat  
        print("Введите скорость спина (1-100):")
        speed = tonumber(io.read())
    until speed and speed >= 1 and speed <= 100  
    return speed  
end

while true do  
    showMenu()
    local choice = io.read()

    if choice == "1" then  
        local speed = chooseSpeed()
        spin(speed)
    elseif choice == "2" then  
        break  
    else  
        print("Неверный выбор.")
    end  
end
