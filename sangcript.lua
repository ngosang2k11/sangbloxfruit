-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

-- Cho phép thay đổi tên menu
local MenuTitle = "SANG IOS" -- Tên menu mặc định
Title.Text = MenuTitle

-- Menu chức năng
local MenuFunctions = {
    {Name = "Trạng Thái Người Chơi", Function = function() showPlayerStats() end},
    {Name = "Auto Farm", Function = function() autoFarm() end},
    {Name = "Di Chuyển Nhanh", Function = function() teleportMenu() end},
    {Name = "Shop Vật Phẩm", Function = function() openShop() end},
    {Name = "Đổi Tộc", Function = function() changeRace() end},
    {Name = "Cài Đặt", Function = function() openSettings() end}
}

-- Bật/tắt menu bằng phím
local ToggleKey = Enum.KeyCode.M
local MenuOpen = true

-- Cài đặt GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "BloxFruitsMenu"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.05, 0, 0.5, -200)
MainFrame.Visible = MenuOpen

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Parent = MainFrame
Title.Text = "Blox Fruits Menu"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextYAlignment = Enum.TextYAlignment.Center

-- Close Button
CloseButton.Parent = MainFrame
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tạo nút chức năng
for i, menu in ipairs(MenuFunctions) do
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.Text = menu.Name
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Font = Enum.Font.SourceSans
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.Parent = Button
    BtnCorner.CornerRadius = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(menu.Function)
end

-- Phím bật/tắt menu
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == ToggleKey and not gameProcessed then
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
    end
end)

-- Đóng menu khi nhấn X
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MenuOpen = false
end)

-- CHỨC NĂNG MENU
function showPlayerStats()
    local player = game.Players.LocalPlayer
    local stats = {
        Level = player:FindFirstChild("Level") and player.Level.Value or "Chưa xác định",
        Beli = player:FindFirstChild("Beli") and player.Beli.Value or 0,
        Health = player.Character and player.Character.Humanoid.Health or "Không xác định",
        Energy = player.Character and player.Character:FindFirstChild("Energy") and player.Character.Energy.Value or "Không xác định"
    }
    print("----- Trạng Thái Người Chơi -----")
    for k, v in pairs(stats) do
        print(k .. ": " .. tostring(v))
    end
end

function autoFarm()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    while true do
        wait(0.5)
        local nearestEnemy = nil
        local shortestDistance = math.huge

        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    nearestEnemy = enemy
                    shortestDistance = distance
                end
            end
        end

        if nearestEnemy then
            humanoidRootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame
            wait(0.5)
            print("Đang tấn công quái: " .. nearestEnemy.Name)
            -- Thực hiện tấn công
        end
    end
end

function teleportMenu()
    local locations = {
        {"Starter Island", Vector3.new(100, 10, 100)},
        {"Sky Island", Vector3.new(500, 300, 500)},
        {"Snow Village", Vector3.new(-200, 50, -300)}
    }

    print("----- Menu Dịch Chuyển -----")
    for i, location in ipairs(locations) do
        print(i .. ". " .. location[1])
    end

    local choice = 1 -- Ví dụ, chọn vị trí đầu tiên
    local selectedLocation = locations[choice]
    if selectedLocation then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(selectedLocation[2])
        print("Đã dịch chuyển đến: " .. selectedLocation[1])
    end
end

function openShop()
    local items = {
        {Name = "Kiếm", Price = 1000},
        {Name = "Trái Ác Quỷ", Price = 5000},
        {Name = "Tăng XP", Price = 2000}
    }

    print("----- Cửa Hàng -----")
    for i, item in ipairs(items) do
        print(i .. ". " .. item.Name .. " - Giá: " .. item.Price .. " Beli")
    end

    local choice = 1 -- Ví dụ: Mua vật phẩm đầu tiên
    local selectedItem = items[choice]
    if selectedItem then
        local player = game.Players.LocalPlayer
        if player.Beli.Value >= selectedItem.Price then
            player.Beli.Value = player.Beli.Value - selectedItem.Price
            print("Đã mua: " .. selectedItem.Name)
        else
            print("Không đủ tiền!")
        end
    end
end

function changeRace()
    local player = game.Players.LocalPlayer
    local requiredBeli = 1000000

    if player.Beli.Value >= requiredBeli then
        player.Beli.Value = player.Beli.Value - requiredBeli
        player.Race.Value = "Sky"
        print("Đã đổi tộc thành công sang: Sky")
    else
        print("Không đủ tiền để đổi tộc!")
    end
end

function openSettings()
    print("----- Cài Đặt -----")
    print("Cài đặt âm thanh hoặc hiệu ứng tại đây...")
end
