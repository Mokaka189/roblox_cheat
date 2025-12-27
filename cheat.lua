local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Переменные
local flying = false
local infiniteJump = false
local speedBoost = false
local bodyVelocity, bodyGyro = nil, nil
local flySpeed = 50
local walkSpeed = 16
local mainFrameVisible = true
local humanoid = nil

-- Основное GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 450)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Кнопки управления
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 15)
minCorner.Parent = minimizeBtn

local scaleBtn = Instance.new("TextButton")
scaleBtn.Size = UDim2.new(0, 30, 0, 30)
scaleBtn.Position = UDim2.new(1, -70, 0, 5)
scaleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
scaleBtn.Text = "📏"
scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleBtn.TextScaled = true
scaleBtn.Font = Enum.Font.GothamBold
scaleBtn.Parent = mainFrame

local scaleCorner = Instance.new("UICorner")
scaleCorner.CornerRadius = UDim.new(0, 15)
scaleCorner.Parent = scaleBtn

-- Кнопка развернуть
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
toggleBtn.Text = "👑"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Visible = false
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleBtn

-- Заголовок (теперь ИСПРАВЛЕН перетаскивание)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "👑 СУПЕР АДМИН ПАНЕЛЬ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Вкладки
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
tabFrame.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

local tabs = {"📍 Телепорт", "✈️ Полёт", "⚡ Чит", "👥 Игроки"}
local currentTab = 1
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -5, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 80)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
end

-- Контент
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -85)
contentFrame.Position = UDim2.new(0, 10, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Вкладка Телепорт
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(1, 0, 1, 0)
teleportFrame.BackgroundTransparency = 1
teleportFrame.Visible = true
teleportFrame.Parent = contentFrame

local tpTextBox = Instance.new("TextBox")
tpTextBox.Size = UDim2.new(0.68, 0, 0, 35)
tpTextBox.Position = UDim2.new(0, 0, 0, 0)
tpTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
tpTextBox.Text = "Ник игрока..."
tpTextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
tpTextBox.TextScaled = true
tpTextBox.Font = Enum.Font.Gotham
tpTextBox.Parent = teleportFrame

local tpToMeBtn = Instance.new("TextButton")
tpToMeBtn.Size = UDim2.new(0.15, -5, 0, 35)
tpToMeBtn.Position = UDim2.new(0.7, 0, 0, 0)
tpToMeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
tpToMeBtn.Text = "Ко мне ➤"
tpToMeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToMeBtn.TextScaled = true
tpToMeBtn.Font = Enum.Font.GothamBold
tpToMeBtn.Parent = teleportFrame

local tpToPlayerBtn = Instance.new("TextButton")
tpToPlayerBtn.Size = UDim2.new(0.15, -5, 0, 35)
tpToPlayerBtn.Position = UDim2.new(0.86, 0, 0, 0)
tpToPlayerBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
tpToPlayerBtn.Text = "➤ К нему"
tpToPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToPlayerBtn.TextScaled = true
tpToPlayerBtn.Font = Enum.Font.GothamBold
tpToPlayerBtn.Parent = teleportFrame

-- Вкладка Полёт
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, 0, 1, 0)
flyFrame.BackgroundTransparency = 1
flyFrame.Visible = false
flyFrame.Parent = contentFrame

local flyToggleBtn = Instance.new("TextButton")
flyToggleBtn.Size = UDim2.new(0.48, -5, 0, 50)
flyToggleBtn.Position = UDim2.new(0, 0, 0, 0)
flyToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
flyToggleBtn.Text = "✈️ ПОЛЁТ ВЫКЛ"
flyToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggleBtn.TextScaled = true
flyToggleBtn.Font = Enum.Font.GothamBold
flyToggleBtn.Parent = flyFrame

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(1, 0, 0, 30)
flySpeedLabel.Position = UDim2.new(0, 0, 0, 60)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Скорость полёта: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.TextScaled = true
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.Parent = flyFrame

local flySpeedSlider = Instance.new("TextButton")
flySpeedSlider.Size = UDim2.new(1, 0, 0, 25)
flySpeedSlider.Position = UDim2.new(0, 0, 0, 95)
flySpeedSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
flySpeedSlider.Text = ""
flySpeedSlider.Parent = flyFrame

-- Вкладка Чит
local cheatFrame = Instance.new("Frame")
cheatFrame.Size = UDim2.new(1, 0, 1, 0)
cheatFrame.BackgroundTransparency = 1
cheatFrame.Visible = false
cheatFrame.Parent = contentFrame

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.48, -5, 0, 50)
jumpBtn.Position = UDim2.new(0, 0, 0, 0)
jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
jumpBtn.Text = "🦘 ПРЫЖОК ВЫКЛ"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.Parent = cheatFrame

local speedBoostBtn = Instance.new("TextButton")
speedBoostBtn.Size = UDim2.new(0.48, -5, 0, 50)
speedBoostBtn.Position = UDim2.new(0.52, 0, 0, 0)
speedBoostBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
speedBoostBtn.Text = "🚀 СКОР ВЫКЛ"
speedBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBoostBtn.TextScaled = true
speedBoostBtn.Font = Enum.Font.GothamBold
speedBoostBtn.Parent = cheatFrame

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(1, 0, 0, 30)
walkSpeedLabel.Position = UDim2.new(0, 0, 0, 60)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "Скорость ходьбы: 16"
walkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedLabel.TextScaled = true
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.Parent = cheatFrame

local walkSpeedSlider = Instance.new("TextButton")
walkSpeedSlider.Size = UDim2.new(1, 0, 0, 25)
walkSpeedSlider.Position = UDim2.new(0, 0, 0, 95)
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
walkSpeedSlider.Text = ""
walkSpeedSlider.Parent = cheatFrame

-- Вкладка Игроки
local playersFrame = Instance.new("Frame")
playersFrame.Size = UDim2.new(1, 0, 1, 0)
playersFrame.BackgroundTransparency = 1
playersFrame.Visible = false
playersFrame.Parent = contentFrame

local playersList = Instance.new("ScrollingFrame")
playersList.Size = UDim2.new(1, -10, 1, -10)
playersList.Position = UDim2.new(0, 5, 0, 5)
playersList.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
playersList.BorderSizePixel = 0
playersList.ScrollBarThickness = 8
playersList.Parent = playersFrame

-- Стилизация углов
local function addCorners(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

addCorners(tpTextBox, 8)
addCorners(tpToMeBtn, 8)
addCorners(tpToPlayerBtn, 8)
addCorners(flyToggleBtn, 10)
addCorners(flySpeedSlider, 6)
addCorners(jumpBtn, 10)
addCorners(speedBoostBtn, 10)
addCorners(walkSpeedSlider, 6)
addCorners(playersList, 8)

-- Анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 450)}):Play()

-- === ИСПРАВЛЕННОЕ ПЕРЕТАСКИВАНИЕ ОКНА ===
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        -- Подписываемся на InputChanged только при перетаскивании
        local connection
        connection = UserInputService.InputChanged:Connect(updateInput)
        
        UserInputService.InputEnded:Connect(function(inputEnd)
            if inputEnd.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

-- Перетаскивание кнопки toggleBtn
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if toggleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - toggleDragStart
                toggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(inputEnd)
            if inputEnd.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleDragging = false
                connection:Disconnect()
            end
        end)
    end
end)

-- === СВОРАЧИВАНИЕ ===
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrameVisible = false
    mainFrame.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrameVisible = true
    mainFrame.Visible = true
    toggleBtn.Visible = false
end)

-- === МАСШТАБИРОВАНИЕ ===
local scale = 1
scaleBtn.MouseButton1Click:Connect(function()
    scale = scale == 1 and 1.5 or scale == 1.5 and 0.7 or 1
    local newSizeX, newSizeY = 450 * scale, 450 * scale
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, newSizeX, 0, newSizeY)
    }):Play()
    mainCorner.CornerRadius = UDim.new(0, 12 * scale)
end)

-- === ВКЛАДКИ ===
for i, tabBtn in ipairs(tabButtons) do
    tabBtn.MouseButton1Click:Connect(function()
        for j, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = j == i and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 80)
        end
        teleportFrame.Visible = i == 1
        flyFrame.Visible = i == 2
        cheatFrame.Visible = i == 3
        playersFrame.Visible = i == 4
    end)
end

-- === ТЕЛЕПОРТ ===
local function teleportPlayer(targetName, toMe)
    local targetPlayer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetName:lower()) or p.DisplayName:lower():find(targetName:lower()) then
            targetPlayer = p
            break
        end
    end
    
    if not targetPlayer then return false end
    
    local myChar = player.Character
    local targetChar = targetPlayer.Character
    
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return false end
    
    if toMe then
        targetChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
    else
        myChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
    end
    return true
end

tpToMeBtn.MouseButton1Click:Connect(function()
    if teleportPlayer(tpTextBox.Text, true) then
        tpTextBox.Text = "✅ Телепортирован к вам!"
    else
        tpTextBox.Text = "❌ Игрок не найден"
    end
    game:GetService("Debris"):AddItem(function() tpTextBox.Text = "Ник игрока..." end, 2)
end)

tpToPlayerBtn.MouseButton1Click:Connect(function()
    if teleportPlayer(tpTextBox.Text, false) then
        tpTextBox.Text = "✅ Вы телепортированы!"
    else
        tpTextBox.Text = "❌ Игрок не найден"
    end
    game:GetService("Debris"):AddItem(function() tpTextBox.Text = "Ник игрока..." end, 2)
end)

-- === ПОЛЁТ ===
local function toggleFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    flying = not flying
    
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = char.HumanoidRootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.CFrame = char.HumanoidRootPart.CFrame
        bodyGyro.Parent = char.HumanoidRootPart
        
        flyToggleBtn.Text = "✈️ ПОЛЁТ ВКЛ"
        flyToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity, bodyGyro = nil, nil
        flyToggleBtn.Text = "✈️ ПОЛЁТ ВЫКЛ"
        flyToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end

flyToggleBtn.MouseButton1Click:Connect(toggleFly)

-- Слайдер скорости полёта
local flyDraggingSlider = false
flySpeedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDraggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDraggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flyDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = math.clamp((input.Position.X - flySpeedSlider.AbsolutePosition.X) / flySpeedSlider.AbsoluteSize.X, 0, 1)
        flySpeed = 10 + (percent * 90)
        flySpeedLabel.Text = "Скорость полёта: " .. math.floor(flySpeed)
    end
end)

-- Обновление полёта
RunService.RenderStepped:Connect(function()
    if not flying then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
    
    if bodyVelocity then bodyVelocity.Velocity = moveVector * flySpeed end
    if bodyGyro then bodyGyro.CFrame = camera.CFrame end
end)

-- === БЕСКОНЕЧНЫЙ ПРЫЖОК ===
jumpBtn.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    jumpBtn.Text = infiniteJump and "🦘 ПРЫЖОК ВКЛ" or "🦘 ПРЫЖОК ВЫКЛ"
    jumpBtn.BackgroundColor3 = infiniteJump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- === СЛАЙДЕР СКОРОСТИ ХОДЬБЫ ===
local walkDraggingSlider = false
walkSpeedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        walkDraggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        walkDraggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if walkDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = math.clamp((input.Position.X - walkSpeedSlider.AbsolutePosition.X) / walkSpeedSlider.AbsoluteSize.X, 0, 1)
        walkSpeed = 16 + (percent * 184) -- 16-200
        walkSpeedLabel.Text = "Скорость ходьбы: " .. math.floor(walkSpeed)
        
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = walkSpeed
        end
    end
end)

-- === УСКОРЕНИЕ (кнопка теперь отдельно от слайдера) ===
speedBoostBtn.MouseButton1Click:Connect(function()
    speedBoost = not speedBoost
    speedBoostBtn.Text = speedBoost and "🚀 СКОР ВКЛ" or "🚀 СКОР ВЫКЛ"
    speedBoostBtn.BackgroundColor3 = speedBoost and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Применение скорости ходьбы
spawn(function()
    while true do
        if speedBoost then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = walkSpeed * 2 -- Удваивает слайдер
            end
        else
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = walkSpeed
            end
        end
        wait(0.1)
    end
end)

-- === СПИСОК ИГРОКОВ ===
local function updatePlayersList()
    for _, child in pairs(playersList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local yPos = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, 0, 0, 40)
            playerBtn.Position = UDim2.new(0, 0, 0, yPos)
            playerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
            playerBtn.Text = p.DisplayName .. " (" .. p.Name .. ")"
            playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerBtn.TextScaled = true
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.Parent = playersList
            
            addCorners(playerBtn, 6)
            
            playerBtn.MouseButton1Click:Connect(function()
                tpTextBox.Text = p.Name
                for j, btn in ipairs(tabButtons) do
                    btn.BackgroundColor3 = j == 1 and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 80)
                end
                teleportFrame.Visible = true
            end)
            
            yPos = yPos + 45
        end
    end
    
    playersList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

updatePlayersList()
Players.PlayerAdded:Connect(updatePlayersList)
Players.PlayerRemoving:Connect(updatePlayersList)

-- Фокус textbox
tpTextBox.Focused:Connect(function()
    if tpTextBox.Text == "Ник игрока..." then
        tpTextBox.Text = ""
    end
end)

-- Очистка при респавне
player.CharacterAdded:Connect(function()
    flying = false
    infiniteJump = false
    speedBoost = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    flyToggleBtn.Text = "✈️ ПОЛЁТ ВЫКЛ"
    flyToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    jumpBtn.Text = "🦘 ПРЫЖОК ВЫКЛ"
    jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    speedBoostBtn.Text = "🚀 СКОР ВЫКЛ"
    speedBoostBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    walkSpeed = 16
    walkSpeedLabel.Text = "Скорость ходьбы: 16"
end)

print("👑 СУПЕР АДМИН ПАНЕЛЬ ИСПРАВЛЕНА И УЛУЧШЕНА!")
