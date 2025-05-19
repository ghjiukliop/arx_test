-- Anime Rangers X Script

-- Kiểm tra Place ID
local currentPlaceId = game.PlaceId
local allowedPlaceId = 72829404259339

if currentPlaceId ~= allowedPlaceId then
    warn("Script này chỉ hoạt động trên game Anime Rangers X (Place ID: " .. tostring(allowedPlaceId) .. ")")
    return
end

-- Phiên bản thay thế cho Fluent:Notify
local Fluent = {}
Fluent.Notify = function(options)
    local title = options.Title or ""
    local content = options.Content or ""
    local duration = options.Duration or 3
    
    -- In thông báo ra console thay vì hiển thị UI
    print("[" .. title .. "] " .. content)
    
    -- Có thể thêm logic thông báo khác tại đây nếu cần
    return {
        -- Giả lập các phương thức của đối tượng thông báo Fluent nếu cần
        Destroy = function() end
    }
end

-- Hệ thống xác thực key
local KeySystem = {}
KeySystem.Keys = {
    "HT_ANIME_RANGERS_ACCESS_5723",  -- Key 1
    "RANGER_PRO_ACCESS_9841",        -- Key 2
    "PREMIUM_ANIME_ACCESS_3619"      -- Key 3
}
KeySystem.KeyFileName = "htkey_anime_rangers.txt"
KeySystem.WebhookURL = "https://discord.com/api/webhooks/1348673902506934384/ZRMIlRzlQq9Hfnjgpu96GGF7jCG8mG1qqfya3ErW9YvbuIKOaXVomOgjg4tM_Xk57yAK" -- Thay bằng webhook của bạn

-- Hàm kiểm tra key đã lưu
KeySystem.CheckSavedKey = function()
    if not isfile then
        return false, "Executor của bạn không hỗ trợ isfile/readfile"
    end
    
    if isfile(KeySystem.KeyFileName) then
        local savedKey = readfile(KeySystem.KeyFileName)
        for _, validKey in ipairs(KeySystem.Keys) do
            if savedKey == validKey then
                return true, "Key hợp lệ"
            end
        end
        -- Nếu key không hợp lệ, xóa file
        delfile(KeySystem.KeyFileName)
    end
    
    return false, "Key không hợp lệ hoặc chưa được lưu"
end

-- Hàm lưu key
KeySystem.SaveKey = function(key)
    if not writefile then
        return false, "Executor của bạn không hỗ trợ writefile"
    end
    
    writefile(KeySystem.KeyFileName, key)
    return true, "Đã lưu key"
end

-- Hàm gửi log đến webhook Discord
KeySystem.SendWebhook = function(username, key, status)
    if KeySystem.WebhookURL == "https://discord.com/api/webhooks/1348673902506934384/ZRMIlRzlQq9Hfnjgpu96GGF7jCG8mG1qqfya3ErW9YvbuIKOaXVomOgjg4tM_Xk57yAK" then
        return -- Bỏ qua nếu webhook chưa được cấu hình
    end
    
    local HttpService = game:GetService("HttpService")
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Anime Rangers X Script - Key Log",
            ["description"] = "Người dùng đã sử dụng script",
            ["type"] = "rich",
            ["color"] = status and 65280 or 16711680,
            ["fields"] = {
                {
                    ["name"] = "Username",
                    ["value"] = username,
                    ["inline"] = true
                },
                {
                    ["name"] = "Key Status",
                    ["value"] = status and "Hợp lệ" or "Không hợp lệ",
                    ["inline"] = true
                },
                {
                    ["name"] = "Key Used",
                    ["value"] = key ~= "" and key or "N/A",
                    ["inline"] = true
                }
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local success, _ = pcall(function()
        HttpService:PostAsync(KeySystem.WebhookURL, HttpService:JSONEncode(data))
    end)
    
    return success
end

-- Tạo UI nhập key
KeySystem.CreateKeyUI = function()
    local success, keyValid = KeySystem.CheckSavedKey()
    if success then
        print("HT Hub | Key hợp lệ, đang tải script...")
        KeySystem.SendWebhook(game.Players.LocalPlayer.Name, "Key đã lưu", true)
        return true
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Description = Instance.new("TextLabel")
    local KeyInput = Instance.new("TextBox")
    local UICorner_2 = Instance.new("UICorner")
    local SubmitButton = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local GetKeyButton = Instance.new("TextButton")
    local UICorner_4 = Instance.new("UICorner")
    local StatusLabel = Instance.new("TextLabel")
    
    -- Thiết lập UI
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    ScreenGui.Name = "HTHubKeySystem"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.Position = UDim2.new(0.5, -175, 0.5, -125)
    Main.Size = UDim2.new(0, 350, 0, 250)
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main
    
    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "HT Hub | Anime Rangers X"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20.000
    
    Description.Name = "Description"
    Description.Parent = Main
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1.000
    Description.Position = UDim2.new(0, 0, 0, 45)
    Description.Size = UDim2.new(1, 0, 0, 40)
    Description.Font = Enum.Font.Gotham
    Description.Text = "Nhập key để sử dụng script"
    Description.TextColor3 = Color3.fromRGB(200, 200, 200)
    Description.TextSize = 14.000
    
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = Main
    KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    KeyInput.Position = UDim2.new(0.5, -125, 0, 100)
    KeyInput.Size = UDim2.new(0, 250, 0, 40)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Nhập key vào đây..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14.000
    
    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = KeyInput
    
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Parent = Main
    SubmitButton.BackgroundColor3 = Color3.fromRGB(90, 90, 255)
    SubmitButton.Position = UDim2.new(0.5, -60, 0, 155)
    SubmitButton.Size = UDim2.new(0, 120, 0, 35)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Text = "Xác nhận"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 14.000
    
    UICorner_3.CornerRadius = UDim.new(0, 6)
    UICorner_3.Parent = SubmitButton
    
    GetKeyButton.Name = "GetKeyButton"
    GetKeyButton.Parent = Main
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    GetKeyButton.Position = UDim2.new(0.5, -75, 0, 200)
    GetKeyButton.Size = UDim2.new(0, 150, 0, 35)
    GetKeyButton.Font = Enum.Font.GothamBold
    GetKeyButton.Text = "Lấy key tại discord"
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyButton.TextSize = 14.000
    
    UICorner_4.CornerRadius = UDim.new(0, 6)
    UICorner_4.Parent = GetKeyButton
    
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = Main
    StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.BackgroundTransparency = 1.000
    StatusLabel.Position = UDim2.new(0, 0, 0, 240)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 12.000
    
    -- Biến để theo dõi trạng thái xác thực
    local keyAuthenticated = false
    
    -- Hàm xác thực key
    local function checkKey(key)
        for _, validKey in ipairs(KeySystem.Keys) do
            if key == validKey then
                return true
            end
        end
        return false
    end
    
    -- Xử lý sự kiện nút Submit
    SubmitButton.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text
        
        if inputKey == "" then
            StatusLabel.Text = "Vui lòng nhập key"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        local isKeyValid = checkKey(inputKey)
        
        if isKeyValid then
            StatusLabel.Text = "Key hợp lệ! Đang tải script..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Lưu key
            KeySystem.SaveKey(inputKey)
            
            -- Gửi log
            KeySystem.SendWebhook(game.Players.LocalPlayer.Name, inputKey, true)
            
            -- Đánh dấu đã xác thực thành công
            keyAuthenticated = true
            
            -- Xóa UI sau 1 giây
            wait(1)
            ScreenGui:Destroy()
        else
            StatusLabel.Text = "Key không hợp lệ, vui lòng thử lại"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Gửi log
            KeySystem.SendWebhook(game.Players.LocalPlayer.Name, inputKey, false)
        end
    end)
    
    -- Xử lý sự kiện nút Get Key
    GetKeyButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/6WXu2zZC3d")
        StatusLabel.Text = "Đã sao chép liên kết vào clipboard"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    
    -- Đợi cho đến khi xác thực thành công hoặc đóng UI
    local startTime = tick()
    local timeout = 300 -- 5 phút timeout
    
    repeat
        wait(0.1)
    until keyAuthenticated or (tick() - startTime > timeout)
    
    if keyAuthenticated then
        return true
    else
        -- Nếu hết thời gian chờ mà không xác thực, đóng UI và trả về false
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy() 
        end
        return false
    end
end

-- Khởi chạy hệ thống key
local keyValid = KeySystem.CreateKeyUI()
if not keyValid then
    -- Nếu key không hợp lệ, dừng script
    warn("Key không hợp lệ hoặc đã hết thời gian chờ. Script sẽ dừng.")
    return
end

-- Delay 30 giây trước khi mở script
print("HT Hub | Anime Rangers X đang khởi động, vui lòng đợi 15 giây...")
wait(1)
print("Đang tải script...")

-- Tải thư viện Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

if not success then
    warn("Lỗi khi tải thư viện Fluent: " .. tostring(err))
    -- Thử tải từ URL dự phòng
    pcall(function()
        Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Fluent.lua"))()
        SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
        InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    end)
end

if not Fluent then
    error("Không thể tải thư viện Fluent. Vui lòng kiểm tra kết nối internet hoặc executor.")
    return
end

-- Utility function để kiểm tra và lấy service/object một cách an toàn
local function safeGetService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    return success and service or nil
end

-- Utility function để kiểm tra và lấy child một cách an toàn
local function safeGetChild(parent, childName, waitTime)
    if not parent then return nil end
    
    local child = parent:FindFirstChild(childName)
    
    -- Chỉ sử dụng WaitForChild nếu thực sự cần thiết
    if not child and waitTime and waitTime > 0 then
        local success, result = pcall(function()
            return parent:WaitForChild(childName, waitTime)
        end)
        if success then child = result end
    end
    
    return child
end

-- Utility function để lấy đường dẫn đầy đủ một cách an toàn
local function safeGetPath(startPoint, path, waitTime)
    if not startPoint then return nil end
    waitTime = waitTime or 0.5 -- Giảm thời gian chờ mặc định xuống 0.5 giây
    
    local current = startPoint
    for _, name in ipairs(path) do
        if not current then return nil end
        current = safeGetChild(current, name, waitTime)
    end
    
    return current
end

-- Hệ thống lưu trữ cấu hình
local ConfigSystem = {}
ConfigSystem.FileName = "HTHubARConfig_" .. game:GetService("Players").LocalPlayer.Name .. ".json"
ConfigSystem.DefaultConfig = {
    -- Các cài đặt mặc định
    UITheme = "Amethyst",
    
    -- Cài đặt Shop/Summon
    SummonAmount = "x1",
    SummonBanner = "Standard",
    AutoSummon = false,
    
    -- Cài đặt Quest
    AutoClaimQuest = false,
    
    -- Cài đặt Story
    SelectedMap = "OnePiece",
    SelectedChapter = "Chapter1",
    SelectedDifficulty = "Normal",
    FriendOnly = false,
    AutoJoinMap = false,
    StoryTimeDelay = 5,
    
    -- Cài đặt Ranger Stage
    SelectedRangerMap = "OnePiece",
    SelectedRangerMaps = {}, -- Thêm cấu hình mặc định cho map đã chọn (ban đầu rỗng hoặc chỉ có map default)
    SelectedActs = {RangerStage1 = true},
    RangerFriendOnly = false,
    AutoJoinRanger = false,
    RangerTimeDelay = 5,
    
    -- Cài đặt Boss Event
    AutoBossEvent = false,
    BossEventTimeDelay = 5,
    
    -- Cài đặt Challenge
    AutoChallenge = false,
    ChallengeTimeDelay = 5,
    
    -- Cài đặt In-Game
    AutoPlay = false,
    AutoRetry = false,
    AutoNext = false,
    AutoVote = false,
    RemoveAnimation = true,
    
    -- Cài đặt Update Units
    AutoUpdate = false,
    AutoUpdateRandom = false,
    Slot1Level = 0,
    Slot2Level = 0,
    Slot3Level = 0,
    Slot4Level = 0,
    Slot5Level = 0,
    Slot6Level = 0,
    
    -- Cài đặt AFK
    AutoJoinAFK = false,
    
    -- Cài đặt UI
    AutoHideUI = false,
    
    -- Cài đặt Merchant
    SelectedMerchantItems = {},
    AutoMerchantBuy = false,
    
    -- Cài đặt Auto TP Lobby
    AutoTPLobby = false,
    AutoTPLobbyDelay = 10, -- Mặc định 10 phút
    
    -- Cài đặt Auto Scan Units
    AutoScanUnits = true, -- Mặc định bật
    
    -- Cài đặt Easter Egg
    AutoJoinEasterEgg = false,
    EasterEggTimeDelay = 5,
    
    -- Cài đặt Anti AFK
    AntiAFK = true, -- Mặc định bật
    
    -- Cài đặt Auto Leave
    AutoLeave = false,
    
    -- Cài đặt Webhook
    WebhookURL = "",
    AutoSendWebhook = false,
    DeleteMap = false,
}
ConfigSystem.CurrentConfig = {}

-- Cache cho ConfigSystem để giảm lượng I/O
ConfigSystem.LastSaveTime = 0
ConfigSystem.SaveCooldown = 2 -- 2 giây giữa các lần lưu
ConfigSystem.PendingSave = false

-- Hàm để lưu cấu hình
ConfigSystem.SaveConfig = function()
    -- Kiểm tra thời gian từ lần lưu cuối
    local currentTime = os.time()
    if currentTime - ConfigSystem.LastSaveTime < ConfigSystem.SaveCooldown then
        -- Đã lưu gần đây, đánh dấu để lưu sau
        ConfigSystem.PendingSave = true
        return
    end
    
    local success, err = pcall(function()
        local HttpService = game:GetService("HttpService")
        writefile(ConfigSystem.FileName, HttpService:JSONEncode(ConfigSystem.CurrentConfig))
    end)
    
    if success then
        ConfigSystem.LastSaveTime = currentTime
        ConfigSystem.PendingSave = false
        -- Không cần in thông báo mỗi lần lưu để giảm spam
    else
        warn("Lưu cấu hình thất bại:", err)
    end
end

-- Hàm để tải cấu hình
ConfigSystem.LoadConfig = function()
    local success, content = pcall(function()
        if isfile(ConfigSystem.FileName) then
            return readfile(ConfigSystem.FileName)
        end
        return nil
    end)
    
    if success and content then
        local success2, data = pcall(function()
            local HttpService = game:GetService("HttpService")
            return HttpService:JSONDecode(content)
        end)
        
        if success2 and data then
            -- Merge with default config to ensure all settings exist
            for key, value in pairs(ConfigSystem.DefaultConfig) do
                if data[key] == nil then
                    data[key] = value
                end
            end
            
        ConfigSystem.CurrentConfig = data
        return true
        end
    end
    
    -- Nếu tải thất bại, sử dụng cấu hình mặc định
        ConfigSystem.CurrentConfig = table.clone(ConfigSystem.DefaultConfig)
        ConfigSystem.SaveConfig()
        return false
    end

-- Thiết lập timer để lưu định kỳ nếu có thay đổi chưa lưu
spawn(function()
    while wait(5) do
        if ConfigSystem.PendingSave then
            ConfigSystem.SaveConfig()
        end
end
end)

-- Tải cấu hình khi khởi động
ConfigSystem.LoadConfig()

-- Biến toàn cục để theo dõi UI
local OpenUI = nil
local isMinimized = false

-- Biến lưu trạng thái Summon
local selectedSummonAmount = ConfigSystem.CurrentConfig.SummonAmount or "x1"
local selectedSummonBanner = ConfigSystem.CurrentConfig.SummonBanner or "Standard"
local autoSummonEnabled = ConfigSystem.CurrentConfig.AutoSummon or false
local autoSummonLoop = nil

-- Biến lưu trạng thái Quest
local autoClaimQuestEnabled = ConfigSystem.CurrentConfig.AutoClaimQuest or false
local autoClaimQuestLoop = nil

-- Mapping giữa tên hiển thị và tên thật của map
local mapNameMapping = {
    ["Voocha Village"] = "OnePiece",
    ["Green Planet"] = "Namek",
    ["Demon Forest"] = "DemonSlayer",
    ["Leaf Village"] = "Naruto",
    ["Z City"] = "OPM"
}

-- Mapping ngược lại để hiển thị tên cho người dùng
local reverseMapNameMapping = {}
for display, real in pairs(mapNameMapping) do
    reverseMapNameMapping[real] = display
end

-- Biến lưu trạng thái Story
local selectedMap = ConfigSystem.CurrentConfig.SelectedMap or "OnePiece"
local selectedDisplayMap = reverseMapNameMapping[selectedMap] or "Voocha Village"
local selectedChapter = ConfigSystem.CurrentConfig.SelectedChapter or "Chapter1"
local selectedDifficulty = ConfigSystem.CurrentConfig.SelectedDifficulty or "Normal"
local friendOnly = ConfigSystem.CurrentConfig.FriendOnly or false
local autoJoinMapEnabled = ConfigSystem.CurrentConfig.AutoJoinMap or false
local autoJoinMapLoop = nil

-- Biến lưu trạng thái Ranger Stage
local selectedRangerMap = ConfigSystem.CurrentConfig.SelectedRangerMap or "OnePiece"
local selectedRangerDisplayMap = reverseMapNameMapping[selectedRangerMap] or "Voocha Village"
-- Thêm biến lưu các map đã chọn
local selectedRangerMaps = ConfigSystem.CurrentConfig.SelectedRangerMaps or { [selectedRangerMap] = true } -- Lưu dạng table {MapName = true}
local selectedActs = ConfigSystem.CurrentConfig.SelectedActs or {RangerStage1 = true}
local currentActIndex = 1  -- Lưu trữ index của Act hiện tại đang được sử dụng
local orderedActs = {}     -- Lưu trữ danh sách các Acts theo thứ tự
local rangerFriendOnly = ConfigSystem.CurrentConfig.RangerFriendOnly or false
local autoJoinRangerEnabled = ConfigSystem.CurrentConfig.AutoJoinRanger or false
local autoJoinRangerLoop = nil

-- Biến lưu trạng thái Boss Event
local autoBossEventEnabled = ConfigSystem.CurrentConfig.AutoBossEvent or false
local autoBossEventLoop = nil

-- Biến lưu trạng thái Challenge
local autoChallengeEnabled = ConfigSystem.CurrentConfig.AutoChallenge or false
local autoChallengeLoop = nil
local challengeTimeDelay = ConfigSystem.CurrentConfig.ChallengeTimeDelay or 5

-- Biến lưu trạng thái In-Game
local autoPlayEnabled = ConfigSystem.CurrentConfig.AutoPlay or false
local autoRetryEnabled = ConfigSystem.CurrentConfig.AutoRetry or false
local autoNextEnabled = ConfigSystem.CurrentConfig.AutoNext or false
local autoVoteEnabled = ConfigSystem.CurrentConfig.AutoVote or false
local removeAnimationEnabled = ConfigSystem.CurrentConfig.RemoveAnimation or true
local autoRetryLoop = nil
local autoNextLoop = nil
local autoVoteLoop = nil
local removeAnimationLoop = nil

-- Biến lưu trạng thái Update Units
local autoUpdateEnabled = ConfigSystem.CurrentConfig.AutoUpdate or false
local autoUpdateRandomEnabled = ConfigSystem.CurrentConfig.AutoUpdateRandom or false
local autoUpdateLoop = nil
local autoUpdateRandomLoop = nil
local unitSlotLevels = {
    ConfigSystem.CurrentConfig.Slot1Level or 0,
    ConfigSystem.CurrentConfig.Slot2Level or 0,
    ConfigSystem.CurrentConfig.Slot3Level or 0,
    ConfigSystem.CurrentConfig.Slot4Level or 0,
    ConfigSystem.CurrentConfig.Slot5Level or 0,
    ConfigSystem.CurrentConfig.Slot6Level or 0
}
local unitSlots = {}

-- Biến lưu trạng thái Time Delay
local storyTimeDelay = ConfigSystem.CurrentConfig.StoryTimeDelay or 5
local rangerTimeDelay = ConfigSystem.CurrentConfig.RangerTimeDelay or 5
local bossEventTimeDelay = ConfigSystem.CurrentConfig.BossEventTimeDelay or 5

-- Biến lưu trạng thái AFK
local autoJoinAFKEnabled = ConfigSystem.CurrentConfig.AutoJoinAFK or false
local autoJoinAFKLoop = nil

-- Biến lưu trạng thái Auto Hide UI
local autoHideUIEnabled = ConfigSystem.CurrentConfig.AutoHideUI or false
local autoHideUITimer = nil

-- Thông tin người chơi
local playerName = game:GetService("Players").LocalPlayer.Name

-- Tạo Window
local Window = Fluent:CreateWindow({
    Title = "HT Hub | Anime Rangers X",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = ConfigSystem.CurrentConfig.UITheme or "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tạo tab Info
local InfoTab = Window:AddTab({
    Title = "Info",
    Icon = "rbxassetid://7733964719"
})

-- Tạo tab Play
local PlayTab = Window:AddTab({
    Title = "Play",
    Icon = "rbxassetid://7743871480"
})

-- Tạo tab Priority
local PriorityTab = Window:AddTab({
    Title = "Priority",
    Icon = "rbxassetid://6031280882" -- Thay bằng icon phù hợp nếu cần
})

-- Tạo tab Event
local EventTab = Window:AddTab({
    Title = "Event",
    Icon = "rbxassetid://8997385940"
})

-- Tạo tab Unit
local UnitTab = Window:AddTab({
    Title = "Unit",
    Icon = "rbxassetid://7743866529"
})

-- Tạo tab In-Game
local InGameTab = Window:AddTab({
    Title = "In-Game",
    Icon = "rbxassetid://7733799901"
})

-- Tạo tab Shop
local ShopTab = Window:AddTab({
    Title = "Shop",
    Icon = "rbxassetid://7734056747"
})

-- Tạo tab Settings
local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "rbxassetid://6031280882"
})

-- Tạo tab Webhook
local WebhookTab = Window:AddTab({
    Title = "Webhook",
    Icon = "rbxassetid://7734058803"
})

-- Thêm hỗ trợ Logo khi minimize
repeat task.wait(0.25) until game:IsLoaded()
getgenv().Image = "rbxassetid://90319448802378" -- ID tài nguyên hình ảnh logo
getgenv().ToggleUI = "LeftControl" -- Phím để bật/tắt giao diện

-- Tạo logo để mở lại UI khi đã minimize
task.spawn(function()
    local success, errorMsg = pcall(function()
        if not getgenv().LoadedMobileUI == true then 
            getgenv().LoadedMobileUI = true
            local OpenUI = Instance.new("ScreenGui")
            local ImageButton = Instance.new("ImageButton")
            local UICorner = Instance.new("UICorner")
            
            -- Kiểm tra môi trường
            if syn and syn.protect_gui then
                syn.protect_gui(OpenUI)
                OpenUI.Parent = game:GetService("CoreGui")
            elseif gethui then
                OpenUI.Parent = gethui()
            else
                OpenUI.Parent = game:GetService("CoreGui")
            end
            
            OpenUI.Name = "OpenUI"
            OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            
            ImageButton.Parent = OpenUI
            ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105)
            ImageButton.BackgroundTransparency = 0.8
            ImageButton.Position = UDim2.new(0.9,0,0.1,0)
            ImageButton.Size = UDim2.new(0,50,0,50)
            ImageButton.Image = getgenv().Image
            ImageButton.Draggable = true
            ImageButton.Transparency = 0.2
            
            UICorner.CornerRadius = UDim.new(0,200)
            UICorner.Parent = ImageButton
            
            -- Khi click vào logo sẽ mở lại UI
            ImageButton.MouseButton1Click:Connect(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().ToggleUI,false,game)
            end)
        end
    end)
    
    if not success then
        warn("Lỗi khi tạo nút Logo UI: " .. tostring(errorMsg))
    end
end)

-- Tự động chọn tab Info khi khởi động
Window:SelectTab(1) -- Chọn tab đầu tiên (Info)

-- Thêm section thông tin trong tab Info
local InfoSection = InfoTab:AddSection("Thông tin")

InfoSection:AddParagraph({
    Title = "Anime Rangers X",
    Content = "Phiên bản: 0.2 Beta\nTrạng thái: Hoạt động"
})

InfoSection:AddParagraph({
    Title = "Người phát triển",
    Content = "Script được phát triển bởi Dương Tuấn và ghjiukliop"
})

-- Kiểm tra xem người chơi đã ở trong map chưa
local function isPlayerInMap()
    local player = game:GetService("Players").LocalPlayer
    if not player then return false end
    
    -- Kiểm tra UnitsFolder một cách hiệu quả
    return player:FindFirstChild("UnitsFolder") ~= nil
end

-- Thêm section Story trong tab Play
local StorySection = PlayTab:AddSection("Story")

-- Hàm để thay đổi map
local function changeWorld(worldDisplay)
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            -- Chuyển đổi từ tên hiển thị sang tên thật
            local worldReal = mapNameMapping[worldDisplay] or "OnePiece"
            
            local args = {
                [1] = "Change-World",
                [2] = {
                    ["World"] = worldReal
                }
            }
            
            Event:FireServer(unpack(args))
            print("Đã đổi map: " .. worldDisplay .. " (thực tế: " .. worldReal .. ")")
        else
            warn("Không tìm thấy Event để đổi map")
        end
    end)
    
    if not success then
        warn("Lỗi khi đổi map: " .. tostring(err))
    end
end

-- Hàm để thay đổi chapter
local function changeChapter(map, chapter)
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            local args = {
                [1] = "Change-Chapter",
                [2] = {
                    ["Chapter"] = map .. "_" .. chapter
                }
            }
            
            Event:FireServer(unpack(args))
            print("Đã đổi chapter: " .. map .. "_" .. chapter)
        else
            warn("Không tìm thấy Event để đổi chapter")
        end
    end)
    
    if not success then
        warn("Lỗi khi đổi chapter: " .. tostring(err))
    end
end

-- Hàm để thay đổi difficulty
local function changeDifficulty(difficulty)
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            local args = {
                [1] = "Change-Difficulty",
                [2] = {
                    ["Difficulty"] = difficulty
                }
            }
            
            Event:FireServer(unpack(args))
            print("Đã đổi difficulty: " .. difficulty)
        else
            warn("Không tìm thấy Event để đổi difficulty")
        end
    end)
    
    if not success then
        warn("Lỗi khi đổi difficulty: " .. tostring(err))
    end
end

-- Hàm để toggle Friend Only
local function toggleFriendOnly()
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            local args = {
                [1] = "Change-FriendOnly"
            }
            
            Event:FireServer(unpack(args))
            print("Đã toggle Friend Only")
        else
            warn("Không tìm thấy Event để toggle Friend Only")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Friend Only: " .. tostring(err))
    end
end

-- Hàm để tự động tham gia map
local function joinMap()
    -- Kiểm tra xem người chơi đã ở trong map chưa
    if isPlayerInMap() then
        print("Đã phát hiện người chơi đang ở trong map, không thực hiện join map")
        return false
    end
    
    local success, err = pcall(function()
        -- Lấy Event
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if not Event then
            warn("Không tìm thấy Event để join map")
            return
        end
        
        -- 1. Create
        Event:FireServer("Create")
        wait(0.5)
        
        -- 2. Friend Only (nếu được bật)
        if friendOnly then
            Event:FireServer("Change-FriendOnly")
            wait(0.5)
        end
        
        -- 3. Chọn Map và Chapter
        -- 3.1 Đổi Map
        local args1 = {
            [1] = "Change-World",
            [2] = {
                ["World"] = selectedMap
            }
        }
        Event:FireServer(unpack(args1))
        wait(0.5)
        
        -- 3.2 Đổi Chapter
        local args2 = {
            [1] = "Change-Chapter",
            [2] = {
                ["Chapter"] = selectedMap .. "_" .. selectedChapter
            }
        }
        Event:FireServer(unpack(args2))
        wait(0.5)
        
        -- 3.3 Đổi Difficulty
        local args3 = {
            [1] = "Change-Difficulty",
            [2] = {
                ["Difficulty"] = selectedDifficulty
            }
        }
        Event:FireServer(unpack(args3))
        wait(0.5)
        
        -- 4. Submit
        Event:FireServer("Submit")
        wait(1)
        
        -- 5. Start
        Event:FireServer("Start")
        
        print("Đã join map: " .. selectedMap .. "_" .. selectedChapter .. " với độ khó " .. selectedDifficulty)
    end)
    
    if not success then
        warn("Lỗi khi join map: " .. tostring(err))
        return false
    end
    
    return true
end

-- Dropdown để chọn Map
StorySection:AddDropdown("MapDropdown", {
    Title = "Choose Map",
    Values = {"Voocha Village", "Green Planet", "Demon Forest", "Leaf Village", "Z City"},
    Multi = false,
    Default = selectedDisplayMap,
    Callback = function(Value)
        selectedDisplayMap = Value
        selectedMap = mapNameMapping[Value] or "OnePiece"
        ConfigSystem.CurrentConfig.SelectedMap = selectedMap
        ConfigSystem.SaveConfig()
        
        -- Thay đổi map khi người dùng chọn
        changeWorld(Value)
        print("Đã chọn map: " .. Value .. " (thực tế: " .. selectedMap .. ")")
    end
})

-- Dropdown để chọn Chapter
StorySection:AddDropdown("ChapterDropdown", {
    Title = "Choose Chapter",
    Values = {"Chapter1", "Chapter2", "Chapter3", "Chapter4", "Chapter5", "Chapter6", "Chapter7", "Chapter8", "Chapter9", "Chapter10"},
    Multi = false,
    Default = ConfigSystem.CurrentConfig.SelectedChapter or "Chapter1",
    Callback = function(Value)
        selectedChapter = Value
        ConfigSystem.CurrentConfig.SelectedChapter = Value
        ConfigSystem.SaveConfig()
        
        -- Thay đổi chapter khi người dùng chọn
        changeChapter(selectedMap, Value)
        print("Đã chọn chapter: " .. Value)
    end
})

-- Dropdown để chọn Difficulty
StorySection:AddDropdown("DifficultyDropdown", {
    Title = "Choose Difficulty",
    Values = {"Normal", "Hard", "Nightmare"},
    Multi = false,
    Default = ConfigSystem.CurrentConfig.SelectedDifficulty or "Normal",
    Callback = function(Value)
        selectedDifficulty = Value
        ConfigSystem.CurrentConfig.SelectedDifficulty = Value
        ConfigSystem.SaveConfig()
        
        -- Thay đổi difficulty khi người dùng chọn
        changeDifficulty(Value)
        print("Đã chọn difficulty: " .. Value)
        
    end
})

-- Toggle Friend Only
StorySection:AddToggle("FriendOnlyToggle", {
    Title = "Friend Only",
    Default = ConfigSystem.CurrentConfig.FriendOnly or false,
    Callback = function(Value)
        friendOnly = Value
        ConfigSystem.CurrentConfig.FriendOnly = Value
        ConfigSystem.SaveConfig()
        
        -- Toggle Friend Only khi người dùng thay đổi
        toggleFriendOnly()
        
        if Value then
            print("Đã bật chế độ Friend Only")
        else
            print("Đã tắt chế độ Friend Only")
        end
    end
})

-- Toggle Auto Join Map
StorySection:AddToggle("AutoJoinMapToggle", {
    Title = "Auto Join Map",
    Default = ConfigSystem.CurrentConfig.AutoJoinMap or false,
    Callback = function(Value)
        autoJoinMapEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinMap = Value
        ConfigSystem.SaveConfig()
        
        if autoJoinMapEnabled then
            -- Kiểm tra ngay lập tức nếu người chơi đang ở trong map
            if isPlayerInMap() then
                print("Đang ở trong map, Auto Join Map sẽ hoạt động khi bạn rời khỏi map")
            else
                print("Auto Join Map đã được bật, sẽ bắt đầu sau " .. storyTimeDelay .. " giây")
                
                -- Thực hiện join map sau thời gian delay
                spawn(function()
                    wait(storyTimeDelay) -- Chờ theo time delay đã đặt
                    if autoJoinMapEnabled and not isPlayerInMap() then
                        joinMap()
                    end
                end)
            end
            
            -- Tạo vòng lặp Auto Join Map
            spawn(function()
                while autoJoinMapEnabled and wait(10) do -- Thử join map mỗi 10 giây
                    -- Chỉ thực hiện join map nếu người chơi không ở trong map
                    if not isPlayerInMap() then
                        -- Áp dụng time delay
                        print("Đợi " .. storyTimeDelay .. " giây trước khi join map")
                        wait(storyTimeDelay)
                        
                        -- Kiểm tra lại sau khi delay
                        if autoJoinMapEnabled and not isPlayerInMap() then
                            joinMap()
                        end
                    else
                        -- Người chơi đang ở trong map, không cần join
                        print("Đang ở trong map, đợi đến khi người chơi rời khỏi map")
                    end
                end
            end)
        else
            print("Auto Join Map đã được tắt")
        end
    end
})

-- Auto Join Highest Story 
-- Biến lưu trạng thái Auto Join Highest Story
local autoJoinHighestStoryEnabled = ConfigSystem.CurrentConfig.AutoJoinHighestStory or false
local autoJoinHighestStoryLoop = nil
local isInHighestStory = false

-- Hàm lấy giá trị Level hiện tại từ DataValue
local function getCurrentLevel()
    local levelValue = game:GetService("ReplicatedStorage"):FindFirstChild("Values")
    and game:GetService("ReplicatedStorage").Values:FindFirstChild("Game")
    and game:GetService("ReplicatedStorage").Values.Game:FindFirstChild("Level")

    if levelValue then
        print("Current Level from DataValue:", levelValue.Value)
        return levelValue.Value
    end

    return nil
end

-- Hàm tìm và join highest story
local function findAndJoinHighestStory()
    if isInHighestStory then
        print("Người chơi đang ở trong map cao nhất, không thực hiện join.")
        return
    end

    local player = game:GetService("Players").LocalPlayer
    local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
    local playerFolder = playerData and playerData:FindFirstChild(player.Name)
    local chapterLevels = playerFolder and playerFolder:FindFirstChild("ChapterLevels")

    -- Map thứ tự ưu tiên
    local mapOrder = {"OnePiece", "Namek", "DemonSlayer", "Naruto", "OPM"}
    local highestMap, highestChapter = nil, nil

    if chapterLevels then
        for i = #mapOrder, 1, -1 do
            local map = mapOrder[i]
            if chapterLevels:FindFirstChild(map .. "_Chapter1") then
                for j = 10, 1, -1 do
                    local chapterName = map .. "_Chapter" .. j
                    if chapterLevels:FindFirstChild(chapterName) then
                        highestMap = map
                        highestChapter = "Chapter" .. j
                        break
                    end
                end
            end
            if highestMap then break end
        end
    end

    if highestMap and highestChapter then
        local currentLevel = getCurrentLevel()
        local highestLevel = highestMap .. "_" .. highestChapter

        if currentLevel == highestLevel then
            print("Người chơi đang ở level cao nhất: " .. highestLevel)
            isInHighestStory = true
            return
        end

        print("Đã tìm thấy highest story để join: " .. highestLevel)

        -- Thực hiện join map
        local function joinMap()
            local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Remote"):FindFirstChild("Server"):FindFirstChild("PlayRoom"):FindFirstChild("Event")
            if not Event then
                warn("Không tìm thấy Event để join map.")
                return
            end
            Event:FireServer("Create")
            wait(0.5)
            Event:FireServer("Change-World", { ["World"] = highestMap })
            wait(0.5)
            Event:FireServer("Change-Chapter", { ["Chapter"] = highestLevel })
            wait(0.5)
            Event:FireServer("Change-Difficulty", { ["Difficulty"] = "Normal" })
            wait(0.5)
            Event:FireServer("Submit")
            wait(1)
            Event:FireServer("Start")
            print("Đã join map: " .. highestLevel)
            isInHighestStory = true
        end

        joinMap()
    else
        print("Không tìm thấy highest story để join.")
    end
end

-- Hàm xử lý toggle Auto Join Highest Story
local function toggleAutoJoinHighestStory(state)
    autoJoinHighestStoryEnabled = state
    ConfigSystem.CurrentConfig.AutoJoinHighestStory = state
    ConfigSystem.SaveConfig()
    isInHighestStory = false

    if autoJoinHighestStoryEnabled then
        print("Auto Join Highest Story đã được bật")
        autoJoinHighestStoryLoop = task.spawn(function()
            while autoJoinHighestStoryEnabled do
                findAndJoinHighestStory()
                wait(10)
            end
        end)
    else
        print("Auto Join Highest Story đã được tắt")
        if autoJoinHighestStoryLoop then
            task.cancel(autoJoinHighestStoryLoop)
            autoJoinHighestStoryLoop = nil
        end
    end
end

-- Thêm Toggle vào tab Play
local StorySection = PlayTab:AddSection("Story")

StorySection:AddToggle("AutoJoinHighestStoryToggle", {
    Title = "Auto Join Highest Story",
    Default = autoJoinHighestStoryEnabled,
    Callback = function(value)
        toggleAutoJoinHighestStory(value)
    end
})



-- end
-- Hiển thị trạng thái trong game
StorySection:AddParagraph({
    Title = "Trạng thái",
    Content = "Nhấn nút bên dưới để cập nhật trạng thái"
})

-- Thêm nút cập nhật trạng thái
StorySection:AddButton({
    Title = "Cập nhật trạng thái",
    Callback = function()
        local statusText = isPlayerInMap() and "Đang ở trong map" or "Đang ở sảnh chờ"
        
        -- Hiển thị thông báo với trạng thái hiện tại
        Fluent:Notify({
            Title = "Trạng thái hiện tại",
            Content = statusText,
            Duration = 3
        })
        
        print("Trạng thái: " .. statusText)
    end
})

-- Thêm section Summon trong tab Shop
local SummonSection = ShopTab:AddSection("Summon")

-- Hàm thực hiện summon
local function performSummon()
    -- An toàn kiểm tra Remote có tồn tại không
    local success, err = pcall(function()
        local Remote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "Gambling", "UnitsGacha"}, 2)
        
        if Remote then
            local args = {
                [1] = selectedSummonAmount,
                [2] = selectedSummonBanner,
                [3] = {}
            }
            
            Remote:FireServer(unpack(args))
            print("Đã summon: " .. selectedSummonAmount .. " - " .. selectedSummonBanner)
        else
            warn("Không tìm thấy Remote UnitsGacha")
        end
    end)
    
    if not success then
        warn("Lỗi khi summon: " .. tostring(err))
    end
end

-- Dropdown để chọn số lượng summon
SummonSection:AddDropdown("SummonAmountDropdown", {
    Title = "Choose Summon Amount",
    Values = {"x1", "x10"},
    Multi = false,
    Default = ConfigSystem.CurrentConfig.SummonAmount or "x1",
    Callback = function(Value)
        selectedSummonAmount = Value
        ConfigSystem.CurrentConfig.SummonAmount = Value
        ConfigSystem.SaveConfig()
        print("Đã chọn summon amount: " .. Value)
    end
})

-- Dropdown để chọn banner
SummonSection:AddDropdown("SummonBannerDropdown", {
    Title = "Choose Banner",
    Values = {"Standard", "Rate-Up"},
    Multi = false,
    Default = ConfigSystem.CurrentConfig.SummonBanner or "Standard",
    Callback = function(Value)
        selectedSummonBanner = Value
        ConfigSystem.CurrentConfig.SummonBanner = Value
        ConfigSystem.SaveConfig()
        print("Đã chọn banner: " .. Value)
    end
})

-- Toggle Auto Summon
SummonSection:AddToggle("AutoSummonToggle", {
    Title = "Auto Summon",
    Default = ConfigSystem.CurrentConfig.AutoSummon or false,
    Callback = function(Value)
        autoSummonEnabled = Value
        ConfigSystem.CurrentConfig.AutoSummon = Value
        ConfigSystem.SaveConfig()
        
        if autoSummonEnabled then
            print("Auto Summon đã được bật")
            
            -- Tạo vòng lặp Auto Summon
            if autoSummonLoop then
                autoSummonLoop:Disconnect()
                autoSummonLoop = nil
            end
            
            -- Sử dụng spawn thay vì coroutine
            spawn(function()
                while autoSummonEnabled and wait(2) do -- Summon mỗi 2 giây
                    performSummon()
                end
            end)
            
        else
            print("Auto Summon đã được tắt")
            
            if autoSummonLoop then
                autoSummonLoop:Disconnect()
                autoSummonLoop = nil
            end
        end
    end
})

-- Thêm section Quest trong tab Shop
local QuestSection = ShopTab:AddSection("Quest")

-- Hàm để nhận tất cả nhiệm vụ
local function claimAllQuests()
    local success, err = pcall(function()
        -- Kiểm tra an toàn đường dẫn PlayerData
        local ReplicatedStorage = safeGetService("ReplicatedStorage")
        if not ReplicatedStorage then
            warn("Không tìm thấy ReplicatedStorage")
            return
        end
        
        local PlayerData = safeGetChild(ReplicatedStorage, "Player_Data", 2)
        if not PlayerData then
            warn("Không tìm thấy Player_Data")
            return
        end
        
        local PlayerFolder = safeGetChild(PlayerData, playerName, 2)
        if not PlayerFolder then
            warn("Không tìm thấy dữ liệu người chơi: " .. playerName)
            return
        end
        
        local DailyQuest = safeGetChild(PlayerFolder, "DailyQuest", 2)
        if not DailyQuest then
            warn("Không tìm thấy DailyQuest")
            return
        end
        
        -- Lấy đường dẫn đến QuestEvent
        local QuestEvent = safeGetPath(ReplicatedStorage, {"Remote", "Server", "Gameplay", "QuestEvent"}, 2)
        if not QuestEvent then
            warn("Không tìm thấy QuestEvent")
            return
        end
        
        -- Tìm tất cả nhiệm vụ có thể nhận
        for _, quest in pairs(DailyQuest:GetChildren()) do
            if quest then
                local args = {
                    [1] = "ClaimAll",
                    [2] = quest
                }
                
                QuestEvent:FireServer(unpack(args))
                wait(0.2) -- Chờ một chút giữa các lần claim để tránh lag
            end
        end
    end)
    
    if not success then
        warn("Lỗi khi claim quest: " .. tostring(err))
    end
end

-- Toggle Auto Claim All Quest
QuestSection:AddToggle("AutoClaimQuestToggle", {
    Title = "Auto Claim All Quests",
    Default = ConfigSystem.CurrentConfig.AutoClaimQuest or false,
    Callback = function(Value)
        autoClaimQuestEnabled = Value
        ConfigSystem.CurrentConfig.AutoClaimQuest = Value
        ConfigSystem.SaveConfig()
        
        if autoClaimQuestEnabled then
            print("Auto Claim Quests đã được bật")
            
            -- Tạo vòng lặp Auto Claim Quests
            spawn(function()
                while autoClaimQuestEnabled and wait(1) do -- Claim mỗi 30 giây
                    claimAllQuests()
                end
            end)
        else
            print("Auto Claim Quests đã được tắt")
        end
    end
})

-- Thêm section thiết lập trong tab Settings
local SettingsSection = SettingsTab:AddSection("Thiết lập")

-- Dropdown chọn theme
SettingsSection:AddDropdown("ThemeDropdown", {
    Title = "Chọn Theme",
    Values = {"Dark", "Light", "Darker", "Aqua", "Amethyst"},
    Multi = false,
    Default = ConfigSystem.CurrentConfig.UITheme or "Dark",
    Callback = function(Value)
        ConfigSystem.CurrentConfig.UITheme = Value
        ConfigSystem.SaveConfig()
        print("Đã chọn theme: " .. Value)
    end
})

-- Auto Save Config
local function AutoSaveConfig()
    spawn(function()
        while wait(5) do -- Lưu mỗi 5 giây
            pcall(function()
                ConfigSystem.SaveConfig()
            end)
        end
    end)
end

-- Thêm event listener để lưu ngay khi thay đổi giá trị
local function setupSaveEvents()
    for _, tab in pairs({InfoTab, PlayTab, ShopTab, SettingsTab}) do
        if tab and tab._components then
            for _, element in pairs(tab._components) do
                if element and element.OnChanged then
                    element.OnChanged:Connect(function()
                        pcall(function()
                            ConfigSystem.SaveConfig()
                        end)
                    end)
                end
            end
        end
    end
end

-- Tích hợp với SaveManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Thay đổi cách lưu cấu hình để sử dụng tên người chơi
InterfaceManager:SetFolder("HTHubAR")
SaveManager:SetFolder("HTHubAR/" .. playerName)

-- Thêm thông tin vào tab Settings
SettingsTab:AddParagraph({
    Title = "Cấu hình tự động",
    Content = "Cấu hình của bạn đang được tự động lưu theo tên nhân vật: " .. playerName
})

SettingsTab:AddParagraph({
    Title = "Phím tắt",
    Content = "Nhấn LeftControl để ẩn/hiện giao diện"
})

-- Thực thi tự động lưu cấu hình
AutoSaveConfig()

-- Thiết lập events
setupSaveEvents()

-- Khởi tạo các vòng lặp tối ưu
local function setupOptimizedLoops()
    -- Vòng lặp kiểm tra Auto Scan Units - sử dụng lại cho nhiều tính năng
        spawn(function()
        while wait(3) do
            -- Scan units nếu đang trong map và tính năng Auto Scan được bật
            if autoScanUnitsEnabled and isPlayerInMap() then
                scanUnits()
    end
    
            -- Kiểm tra và lưu cấu hình nếu có thay đổi
            if ConfigSystem.PendingSave then
                ConfigSystem.SaveConfig()
            end
        end
    end)
    
    -- Vòng lặp quản lý tham gia map và events
        spawn(function()
        -- Đợi một chút để script khởi động hoàn tất
        wait(5)
        
        while wait(5) do
            -- Chỉ thực hiện nếu không ở trong map
            if not isPlayerInMap() then
                local shouldContinue = false
                
                -- Kiểm tra Auto Join Map
                if autoJoinMapEnabled and not shouldContinue then
                    joinMap()
                    wait(1) -- Đợi để xem đã vào map chưa
                    shouldContinue = isPlayerInMap()
                end
                
                -- Kiểm tra Auto Join Ranger
                if autoJoinRangerEnabled and not shouldContinue then
                    cycleRangerStages()
                    wait(1)
                    shouldContinue = isPlayerInMap()
                end
                
                -- Kiểm tra Auto Boss Event
                if autoBossEventEnabled and not shouldContinue then
                joinBossEvent()
                    wait(1)
                    shouldContinue = isPlayerInMap()
    end
    
                -- Kiểm tra Auto Challenge
                if autoChallengeEnabled and not shouldContinue then
                    joinChallenge()
                    wait(1)
                    shouldContinue = isPlayerInMap()
                end
                
                -- Kiểm tra Auto Easter Egg
                if autoJoinEasterEggEnabled and not shouldContinue then
                    joinEasterEggEvent()
                    wait(1)
                    shouldContinue = isPlayerInMap()
                end
                
                -- Kiểm tra Auto Join AFK nếu không áp dụng các tính năng trên
                if autoJoinAFKEnabled and not shouldContinue and not isPlayerInMap() then
                    joinAFKWorld()
            end
            else
                -- Đang ở trong map, kiểm tra tính năng Auto Update Units
                if autoUpdateEnabled then
                    for i = 1, 6 do
                        if unitSlots[i] and unitSlotLevels[i] > 0 then
                            upgradeUnit(unitSlots[i])
                            wait(0.1)
                        end
                    end
                elseif autoUpdateRandomEnabled and #unitSlots > 0 then
                    -- Chọn ngẫu nhiên một slot để nâng cấp
                    local randomIndex = math.random(1, #unitSlots)
                    if unitSlots[randomIndex] then
                        upgradeUnit(unitSlots[randomIndex])
                    end
                end
            end
        end
    end)
end

-- Thêm section Ranger Stage trong tab Play
local RangerSection = PlayTab:AddSection("Ranger Stage")

-- Hàm để thay đổi act
local function changeAct(map, act)
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            local args = {
                [1] = "Change-Chapter",
                [2] = {
                    ["Chapter"] = map .. "_" .. act
                }
            }
            
            Event:FireServer(unpack(args))
            print("Đã đổi act: " .. map .. "_" .. act)
        else
            warn("Không tìm thấy Event để đổi act")
        end
    end)
    
    if not success then
        warn("Lỗi khi đổi act: " .. tostring(err))
    end
end

-- Hàm để toggle Friend Only cho Ranger
local function toggleRangerFriendOnly()
    local success, err = pcall(function()
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if Event then
            local args = {
                [1] = "Change-FriendOnly"
            }
            
            Event:FireServer(unpack(args))
            print("Đã toggle Friend Only cho Ranger")
        else
            warn("Không tìm thấy Event để toggle Friend Only")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Friend Only: " .. tostring(err))
    end
end

-- Hàm để cập nhật danh sách Acts đã sắp xếp
local function updateOrderedActs()
    orderedActs = {}
    for act, isSelected in pairs(selectedActs) do
        if isSelected then
            table.insert(orderedActs, act)
        end
    end
    
    -- Đảm bảo currentActIndex không vượt quá số lượng acts
    if #orderedActs > 0 then
        currentActIndex = ((currentActIndex - 1) % #orderedActs) + 1
    else
        currentActIndex = 1
    end
end


local function joinRangerStage()
    -- Kiểm tra xem người chơi đã ở trong map chưa
    if isPlayerInMap() then
        print("Đã phát hiện người chơi đang ở trong map, không thực hiện join Ranger Stage")
        return false
    end

    -- Lấy dữ liệu người chơi từ ReplicatedStorage
    local player = game:GetService("Players").LocalPlayer
    local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
    if not playerData then
        warn("Không tìm thấy Player_Data")
        return false
    end

    local playerFolder = playerData:FindFirstChild(player.Name)
    if not playerFolder then
        warn("Không tìm thấy dữ liệu người chơi: " .. player.Name)
        return false
    end

    local rangerStageFolder = playerFolder:FindFirstChild("RangerStage")
    if not rangerStageFolder then
        warn("Không tìm thấy folder RangerStage")
        return false
    end

    -- Lặp qua tất cả các map đã chọn
    for map, isSelected in pairs(selectedRangerMaps) do
        if isSelected then
            -- Kiểm tra xem các stage của map này có tồn tại không
            local stages = {"RangerStage1", "RangerStage2", "RangerStage3"}
            for _, stage in ipairs(stages) do
                local stageKey = map .. "_" .. stage
                local stageStatus = rangerStageFolder:FindFirstChild(stageKey)

                if not stageStatus then
                    print("Stage " .. stageKey .. " không tồn tại, có thể tham gia được.")

                    -- Thực hiện join stage
                    local success, err = pcall(function()
                        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
                        if not Event then
                            warn("Không tìm thấy Event để join Ranger Stage")
                            return
                        end

                        -- 1. Create
                        Event:FireServer("Create")
                        wait(0.5)

                        -- 2. Change Mode to Ranger Stage
                        Event:FireServer("Change-Mode", { Mode = "Ranger Stage" })
                        wait(0.5)

                        -- 3. Friend Only (nếu được bật)
                        if rangerFriendOnly then
                            Event:FireServer("Change-FriendOnly")
                            wait(0.5)
                        end

                        -- 4. Chọn Map và Act
                        Event:FireServer("Change-World", { World = map })
                        wait(0.5)
                        Event:FireServer("Change-Chapter", { Chapter = stageKey })
                        wait(0.5)

                        -- 5. Submit
                        Event:FireServer("Submit")
                        wait(1)

                        -- 6. Start
                        Event:FireServer("Start")
                        print("Đã join Ranger Stage: " .. stageKey)
                    end)

                    if success then
                        return true -- Thoát ngay khi tham gia thành công
                    else
                        warn("Lỗi khi join Ranger Stage: " .. tostring(err))
                        return false
                    end
                else
                    print("Stage " .. stageKey .. " đã tồn tại, bỏ qua.")
                end
            end
        end
    end

    print("Không tìm thấy Ranger Stage nào có thể tham gia.")
    Fluent:Notify({
        Title = "Ranger Stage",
        Content = "Không tìm thấy Ranger Stage nào có thể tham gia.",
        Duration = 3
    })
    return false
end


-- Lưu biến cho Story Time Delay
local storyTimeDelayInput = nil


-- Input cho Story Time Delay
storyTimeDelayInput = StorySection:AddInput("StoryTimeDelayInput", {
    Title = "Story Time Delay (1-30s)", -- Thêm min/max vào Title
    Placeholder = "Nhập delay",
    Default = tostring(storyTimeDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 30 then
            storyTimeDelay = numValue
            ConfigSystem.CurrentConfig.StoryTimeDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Story Time Delay (Input): " .. numValue .. " giây")
            -- Bỏ cập nhật Slider
            -- if storyTimeDelaySlider and storyTimeDelaySlider.Set then storyTimeDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-30)")
            -- Reset Input về giá trị cũ nếu không hợp lệ
            if storyTimeDelayInput and storyTimeDelayInput.Set then storyTimeDelayInput:Set(tostring(storyTimeDelay)) end
        end
    end
})

-- Dropdown để chọn Map cho Ranger
RangerSection:AddDropdown("RangerMapDropdown", {
    Title = "Map", -- Sửa tiêu đề
    Values = {"Voocha Village", "Green Planet", "Demon Forest", "Leaf Village", "Z City"},
    Multi = true, -- Cho phép chọn nhiều
    Default = (function() -- Khôi phục trạng thái đã chọn từ config
        local defaults = {}
        for mapName, isSelected in pairs(selectedRangerMaps) do
            local displayMap = reverseMapNameMapping[mapName]
            if displayMap and isSelected then
                defaults[displayMap] = true
            end
        end
        -- Đảm bảo luôn có ít nhất 1 map được chọn ban đầu nếu config rỗng
         if next(defaults) == nil and reverseMapNameMapping[selectedRangerMap] then
             defaults[reverseMapNameMapping[selectedRangerMap]] = true
         end
        return defaults
    end)(),
    Callback = function(Values)
        selectedRangerMaps = {} -- Reset trước khi cập nhật
        local firstSelectedMap = nil
        local firstSelectedDisplayMap = nil
        for displayMap, isSelected in pairs(Values) do
            local realMap = mapNameMapping[displayMap]
            if realMap and isSelected then
                selectedRangerMaps[realMap] = true
                if not firstSelectedMap then
                    firstSelectedMap = realMap
                    firstSelectedDisplayMap = displayMap
                end
                print("Đã chọn Ranger map: " .. displayMap .. " (thực tế: " .. realMap .. ")")
            end
        end
        -- Cập nhật selectedRangerMap (dùng cho các chức năng khác nếu cần) thành map đầu tiên được chọn
        selectedRangerMap = firstSelectedMap or "OnePiece"
        selectedRangerDisplayMap = firstSelectedDisplayMap or "Voocha Village"

        ConfigSystem.CurrentConfig.SelectedRangerMaps = selectedRangerMaps
        ConfigSystem.CurrentConfig.SelectedRangerMap = selectedRangerMap -- Lưu map đầu tiên làm map chính (nếu cần)
        ConfigSystem.SaveConfig()

        -- Thông báo (có thể bỏ nếu không muốn)
        local selectedMapsText = ""
        for map, isSelected in pairs(selectedRangerMaps) do
             if isSelected then selectedMapsText = selectedMapsText .. (reverseMapNameMapping[map] or map) .. ", " end
        end
        if selectedMapsText ~= "" then
             selectedMapsText = selectedMapsText:sub(1, -3)
             print("Các map Ranger đã chọn: " .. selectedMapsText)
        else
             print("Chưa chọn map Ranger nào.")
        end
    end
})

-- Dropdown để chọn Act
RangerSection:AddDropdown("ActDropdown", {
    Title = "Act",
    Values = {"RangerStage1", "RangerStage2", "RangerStage3"},
    Multi = true,
    Default = ConfigSystem.CurrentConfig.SelectedActs or {RangerStage1 = true},
    Callback = function(Values)
        selectedActs = Values
        ConfigSystem.CurrentConfig.SelectedActs = Values
        ConfigSystem.SaveConfig()
        
        -- Cập nhật danh sách Acts đã sắp xếp
        updateOrderedActs()
        
        -- Hiển thị thông báo khi người dùng chọn act
        local selectedActsText = ""
        for act, isSelected in pairs(Values) do
            if isSelected then
                selectedActsText = selectedActsText .. act .. ", "
        
        -- Thay đổi act khi người dùng chọn
                changeAct(selectedRangerMap, act)
                print("Đã chọn act: " .. act)
                wait(0.1) -- Đợi 0.5 giây giữa các lần gửi để tránh lỗi
            end
        end
        
        if selectedActsText ~= "" then
            selectedActsText = selectedActsText:sub(1, -3) -- Xóa dấu phẩy cuối cùng
            print("Đã chọn act: " .. selectedActsText)
        else
            print("Bạn chưa chọn act nào! Vui lòng chọn ít nhất một act.")
        end
    end
})

-- Toggle Friend Only cho Ranger
RangerSection:AddToggle("RangerFriendOnlyToggle", {
    Title = "Friend Only",
    Default = ConfigSystem.CurrentConfig.RangerFriendOnly or false,
    Callback = function(Value)
        rangerFriendOnly = Value
        ConfigSystem.CurrentConfig.RangerFriendOnly = Value
        ConfigSystem.SaveConfig()
        
        -- Toggle Friend Only khi người dùng thay đổi
        toggleRangerFriendOnly()
        
        if Value then
            print("Đã bật chế độ Friend Only cho Ranger Stage")
        else
            print("Đã tắt chế độ Friend Only cho Ranger Stage")
        end
    end
})

-- Lưu biến cho Ranger Time Delay
local rangerTimeDelayInput = nil

-- Input cho Ranger Time Delay (Giữ lại, sửa callback)
rangerTimeDelayInput = RangerSection:AddInput("RangerTimeDelayInput", {
    Title = "Delay (1-30s)",
    Placeholder = "Nhập delay",
    Default = tostring(rangerTimeDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 30 then
            rangerTimeDelay = numValue
            ConfigSystem.CurrentConfig.RangerTimeDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Ranger Time Delay (Input): " .. numValue .. " giây")
            -- Bỏ cập nhật Slider
            -- if rangerTimeDelaySlider and rangerTimeDelaySlider.Set then rangerTimeDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-30)")
            if rangerTimeDelayInput and rangerTimeDelayInput.Set then rangerTimeDelayInput:Set(tostring(rangerTimeDelay)) end
        end
    end
})

-- Hàm kiểm tra cooldown của map và act
local function isMapActOnCooldown(mapName, actName)
    local success, result = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if not player then return false end
        
        local playerName = player.Name
        local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
        if not playerData then return false end
        
        local playerFolder = playerData:FindFirstChild(playerName)
        if not playerFolder then return false end
        
        local rangerStageFolder = playerFolder:FindFirstChild("RangerStage")
        if not rangerStageFolder then return false end
        
        -- Kiểm tra xem map_act này có đang trong cooldown không
        local mapActKey = mapName .. "_" .. actName
        return rangerStageFolder:FindFirstChild(mapActKey) ~= nil
    end)
    
    if not success then
        warn("Lỗi khi kiểm tra cooldown cho "..mapName.."_"..actName..": "..tostring(result))
        return false
    end
    
    return result
end

-- Cải tiến hàm Auto Join Ranger Stage để thông minh hơn với việc xử lý cooldown
RangerSection:AddToggle("AutoJoinRangerToggle", {
    Title = "Auto Join Selected Stage", -- Đổi tên cho rõ nghĩa
    Default = ConfigSystem.CurrentConfig.AutoJoinRanger or false,
    Callback = function(Value)
        autoJoinRangerEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinRanger = Value
        ConfigSystem.SaveConfig()

        if autoJoinRangerEnabled then
            -- Kiểm tra xem có Map nào được chọn không
            local hasSelectedMap = false
            for _, isSelected in pairs(selectedRangerMaps) do if isSelected then hasSelectedMap = true; break; end end
            if not hasSelectedMap then print("Chưa chọn map nào trong Ranger Stage!"); return end

            -- Kiểm tra xem có Act nào được chọn không
            local hasSelectedAct = false
            for _, isSelected in pairs(selectedActs) do if isSelected then hasSelectedAct = true; break; end end
            if not hasSelectedAct then print("Chưa chọn act nào trong Ranger Stage!"); return end

            print("Auto Join Selected Ranger Stage đã được bật")
            if autoJoinRangerLoop then autoJoinRangerLoop:Disconnect(); autoJoinRangerLoop = nil; end

            autoJoinRangerLoop = spawn(function()
                while autoJoinRangerEnabled do
                    local didJoin = false
                    
                    -- Kiểm tra nếu đang ở trong map Ranger Stage, đợi ra khỏi map trước
                    if isPlayerInRangerStageMap() then
                        print("Đang ở trong map Ranger Stage, đợi thoát...")
                        while isPlayerInRangerStageMap() and autoJoinRangerEnabled do wait(0.1) end
                        if not autoJoinRangerEnabled then return end
                        wait(0.5) -- Đợi một chút giữa các lần kiểm tra
                    end
                    
                    -- Tìm map và act không bị cooldown để join
                    local availableMaps = {}
                    
                    -- Thu thập tất cả map+act không bị cooldown
                    for map, mapSelected in pairs(selectedRangerMaps) do
                        if mapSelected then
                            for act, actSelected in pairs(selectedActs) do
                                if actSelected then
                                    if not isMapActOnCooldown(map, act) then
                                        table.insert(availableMaps, {map = map, act = act})
                                    else
                                        print(map .. "_" .. act .. " đang trong cooldown, sẽ bỏ qua")
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Nếu có map nào available, join map đó
                    if #availableMaps > 0 then
                        -- Ưu tiên map theo thứ tự (có thể tùy chỉnh logic sắp xếp nếu muốn)
                        local mapToJoin = availableMaps[1]
                        print("Chuẩn bị join map không có cooldown: " .. mapToJoin.map .. " - " .. mapToJoin.act)
                        
                        -- Join map
                        joinRangerStage(mapToJoin.map, mapToJoin.act)
                        didJoin = true
                        
                        -- Đợi vào map hoặc timeout
                        local t = 0
                        while not isPlayerInRangerStageMap() and t < 10 and autoJoinRangerEnabled do wait(0.5); t = t + 0.5; end
                        
                        -- Nếu đã vào map, đợi delay
                        if isPlayerInRangerStageMap() and autoJoinRangerEnabled then
                            print("Đã vào map Ranger Stage, đợi " .. rangerTimeDelay .. " giây...")
                            wait(rangerTimeDelay)
                        end
                    else
                        print("Tất cả map đã chọn đều đang trong cooldown, đợi 5 giây và kiểm tra lại...")
                        wait(5)
                    end
                    
                    -- Nếu không join được map nào, đợi một chút
                    if not didJoin and autoJoinRangerEnabled then
                        wait(1)
                    end
                end
            end)
        else
            print("Auto Join Selected Ranger Stage đã được tắt")
            if autoJoinRangerLoop then autoJoinRangerLoop:Disconnect(); autoJoinRangerLoop = nil; end
        end
    end
})

-- Biến lưu trạng thái Auto Leave
local autoLeaveEnabled = ConfigSystem.CurrentConfig.AutoLeave or false
local autoLeaveLoop = nil

-- Hàm teleport về lobby (dùng cho Auto Leave)
local function leaveMap()
    local success, err = pcall(function()
        local Players = game:GetService("Players")
        local TeleportService = game:GetService("TeleportService")
        
        -- Hiển thị thông báo trước khi teleport
        print("Không tìm thấy kẻ địch và agent trong 10 giây, đang teleport về lobby...")
        
        -- Thực hiện teleport tất cả người chơi
        for _, player in pairs(Players:GetPlayers()) do
            TeleportService:Teleport(game.PlaceId, player)
        end
    end)
    
    if not success then
        warn("Lỗi khi teleport về lobby: " .. tostring(err))
    end
end

-- Hàm kiểm tra EnemyT folder và Agent folder
local function checkEnemyFolder()
    -- Kiểm tra thật nhanh trước với pcall để tránh lỗi
    if not workspace:FindFirstChild("Agent") then
        return true
    end
    
    local enemyFolder = workspace.Agent:FindFirstChild("EnemyT")
    local agentFolder = workspace.Agent:FindFirstChild("Agent")
    
    -- Nếu không tìm thấy cả hai folder, coi như trống
    if not enemyFolder and not agentFolder then
        return true
    end
    
    -- Kiểm tra folder EnemyT có trống không
    local isEnemyTEmpty = not enemyFolder or #enemyFolder:GetChildren() == 0
    
    -- Kiểm tra folder Agent có trống không
    local isAgentEmpty = not agentFolder or #agentFolder:GetChildren() == 0
    
    -- Chỉ trả về true nếu cả hai folder đều trống
    return isEnemyTEmpty and isAgentEmpty
end

-- Toggle Auto Leave với tối ưu hiệu suất
RangerSection:AddToggle("AutoLeaveToggle", {
    Title = "Auto Leave",
    Default = ConfigSystem.CurrentConfig.AutoLeave or false,
    Callback = function(Value)
        autoLeaveEnabled = Value
        ConfigSystem.CurrentConfig.AutoLeave = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto Leave đã được bật. Sẽ tự động rời map nếu không có kẻ địch và agent trong 10 giây")
            
            -- Hủy vòng lặp cũ nếu có
            if autoLeaveLoop then
                autoLeaveLoop:Disconnect()
                autoLeaveLoop = nil
            end
            
            -- Tạo vòng lặp tối ưu để kiểm tra folders
            autoLeaveLoop = spawn(function()
                local checkInterval = 1 -- Kiểm tra mỗi 1 giây
                local maxEmptyTime = 10 -- Thời gian tối đa folder trống trước khi leave
                local emptyTime = 0
                
                while autoLeaveEnabled do
                    -- Chỉ kiểm tra nếu đang ở trong map
                    if isPlayerInMap() then
                        local areEmpty = checkEnemyFolder()
                        
                        if areEmpty then
                            emptyTime = emptyTime + checkInterval
                            if emptyTime >= maxEmptyTime then
                                leaveMap()
                                break -- Thoát vòng lặp sau khi leave
                            end
                            print("EnemyT và Agent folder trống: " .. emptyTime .. "/" .. maxEmptyTime .. " giây")
                        else
                            -- Reset counter nếu folders không trống
                            if emptyTime > 0 then
                                emptyTime = 0
                                print("Folders không còn trống, reset bộ đếm")
                            end
                        end
                    else
                        -- Reset counter khi không ở trong map
                        emptyTime = 0
                    end
                    
                    wait(checkInterval)
                    
                    -- Thoát vòng lặp nếu Auto Leave bị tắt
                    if not autoLeaveEnabled then
                        break
                    end
                end
            end)
        else
            print("Auto Leave đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoLeaveLoop then
                autoLeaveLoop:Disconnect()
                autoLeaveLoop = nil
            end
        end
    end
})

-- Thêm section Boss Event trong tab Play
local BossEventSection = PlayTab:AddSection("Boss Event")

-- Hàm để tham gia Boss Event
local function joinBossEvent()
    -- Kiểm tra xem người chơi đã ở trong map chưa
    if isPlayerInMap() then
        print("Đã phát hiện người chơi đang ở trong map, không thực hiện join Boss Event")
        return false
    end
    
    local success, err = pcall(function()
        -- Lấy Event
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if not Event then
            warn("Không tìm thấy Event để tham gia Boss Event")
            return
        end
        
        -- Gọi Boss Event
        local args = {
            [1] = "Boss-Event"
        }
        
        Event:FireServer(unpack(args))
        print("Đã gửi yêu cầu tham gia Boss Event")
    end)
    
    if not success then
        warn("Lỗi khi tham gia Boss Event: " .. tostring(err))
        return false
    end
    
    return true
end

-- Lưu biến cho Boss Event Time Delay
local bossEventTimeDelayInput = nil

-- Input cho Boss Event Time Delay
bossEventTimeDelayInput = BossEventSection:AddInput("BossEventTimeDelayInput", {
    Title = "Boss Event Delay (1-30s)",
    Placeholder = "Nhập delay",
    Default = tostring(bossEventTimeDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 30 then
            bossEventTimeDelay = numValue
            ConfigSystem.CurrentConfig.BossEventTimeDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Boss Event Time Delay (Input): " .. numValue .. " giây")
            -- Bỏ cập nhật Slider
            -- if bossEventTimeDelaySlider and bossEventTimeDelaySlider.Set then bossEventTimeDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-30)")
            if bossEventTimeDelayInput and bossEventTimeDelayInput.Set then bossEventTimeDelayInput:Set(tostring(bossEventTimeDelay)) end
        end
    end
})

-- Toggle Auto Join Boss Event
BossEventSection:AddToggle("AutoJoinBossEventToggle", {
    Title = "Auto Boss Event",
    Default = ConfigSystem.CurrentConfig.AutoBossEvent or false,
    Callback = function(Value)
        autoBossEventEnabled = Value
        ConfigSystem.CurrentConfig.AutoBossEvent = Value
        ConfigSystem.SaveConfig()
        
        if autoBossEventEnabled then
            -- Kiểm tra ngay lập tức nếu người chơi đang ở trong map
            if isPlayerInMap() then
                print("Đang ở trong map, Auto Boss Event sẽ hoạt động khi bạn rời khỏi map")
            else
                print("Auto Boss Event đã được bật, sẽ bắt đầu sau " .. bossEventTimeDelay .. " giây")
                
                -- Thực hiện tham gia Boss Event sau thời gian delay
                spawn(function()
                    wait(bossEventTimeDelay)
                    if autoBossEventEnabled and not isPlayerInMap() then
                        joinBossEvent()
                    end
                end)
            end
            
            -- Tạo vòng lặp Auto Join Boss Event
            spawn(function()
                while autoBossEventEnabled and wait(30) do -- Thử join boss event mỗi 30 giây
                    -- Chỉ thực hiện tham gia nếu người chơi không ở trong map
                    if not isPlayerInMap() then
                        -- Áp dụng time delay
                        print("Đợi " .. bossEventTimeDelay .. " giây trước khi tham gia Boss Event")
                        wait(bossEventTimeDelay)
                        
                        -- Kiểm tra lại sau khi delay
                        if autoBossEventEnabled and not isPlayerInMap() then
                            joinBossEvent()
                        end
                    else
                        -- Người chơi đang ở trong map, không cần tham gia
                        print("Đang ở trong map, đợi đến khi người chơi rời khỏi map")
                    end
                end
            end)
        else
            print("Auto Boss Event đã được tắt")
        end
    end
})

-- Thêm section Challenge trong tab Play
local ChallengeSection = PlayTab:AddSection("Challenge")

-- Hàm để tham gia Challenge
local function joinChallenge()
    -- Kiểm tra xem người chơi đã ở trong map chưa
    if isPlayerInMap() then
        print("Đã phát hiện người chơi đang ở trong map, không thực hiện join Challenge")
        return false
    end
    
    local success, err = pcall(function()
        -- Lấy Event
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if not Event then
            warn("Không tìm thấy Event để join Challenge")
            return
        end
        
        -- 1. Create Challenge Room
        local args1 = {
            [1] = "Create",
            [2] = {
                ["CreateChallengeRoom"] = true
            }
        }
        Event:FireServer(unpack(args1))
        print("Đã tạo Challenge Room")
        wait(1) -- Đợi 1 giây
        
        -- 2. Start Challenge
        local args2 = {
            [1] = "Start"
        }
        Event:FireServer(unpack(args2))
        print("Đã bắt đầu Challenge")
    end)
    
    if not success then
        warn("Lỗi khi join Challenge: " .. tostring(err))
        return false
    end
    
    return true
end

-- Lưu biến cho Challenge Time Delay
local challengeTimeDelayInput = nil

-- Input cho Challenge Time Delay
challengeTimeDelayInput = ChallengeSection:AddInput("ChallengeTimeDelayInput", {
    Title = "Challenge Delay (1-30s)",
    Placeholder = "Nhập delay",
    Default = tostring(challengeTimeDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 30 then
            challengeTimeDelay = numValue
            ConfigSystem.CurrentConfig.ChallengeTimeDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Challenge Time Delay (Input): " .. numValue .. " giây")
            -- Bỏ cập nhật Slider
            -- if challengeTimeDelaySlider and challengeTimeDelaySlider.Set then challengeTimeDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-30)")
            if challengeTimeDelayInput and challengeTimeDelayInput.Set then challengeTimeDelayInput:Set(tostring(challengeTimeDelay)) end
        end
    end
})

-- Toggle Auto Challenge
ChallengeSection:AddToggle("AutoChallengeToggle", {
    Title = "Auto Challenge",
    Default = ConfigSystem.CurrentConfig.AutoChallenge or false,
    Callback = function(Value)
        autoChallengeEnabled = Value
        ConfigSystem.CurrentConfig.AutoChallenge = Value
        ConfigSystem.SaveConfig()

        if Value then
            print("Auto Challenge đã được bật")
            spawn(function()
                while autoChallengeEnabled and wait(10) do
                    if not isPlayerInMap() then
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local playerName = game:GetService("Players").LocalPlayer.Name

                        -- Kiểm tra khả năng tham gia Challenge
                        local playerData = ReplicatedStorage:FindFirstChild("Player_Data")
                        local playerFolder = playerData and playerData:FindFirstChild(playerName)
                        local chapterLevels = playerFolder and playerFolder:FindFirstChild("ChapterLevels")
                        local challengeChapter = ReplicatedStorage:FindFirstChild("Gameplay")
                            and ReplicatedStorage.Gameplay.Game.Challenge:FindFirstChild("Chapter")

                        if chapterLevels and challengeChapter and challengeChapter:IsA("StringValue") then
                            local challengeName = challengeChapter.Value
                            print("Challenge hiện tại:", challengeName)

                            if chapterLevels:FindFirstChild(challengeName) then
                                print("Đi được, đang tham gia Challenge...")
                                joinChallenge()
                            else
                                print("Không đi được, không thể tham gia Challenge.")
                            end
                        else
                            warn("Dữ liệu không hợp lệ hoặc thiếu")
                        end
                    else
                        print("Đang ở trong map, đợi rời khỏi map để tham gia Challenge.")
                    end
                end
            end)
        else
            print("Auto Challenge đã được tắt")
        end
    end
})

-- Nút Join Challenge (manual)
ChallengeSection:AddButton({
    Title = "Join Challenge Now",
    Callback = function()
        -- Kiểm tra nếu người chơi đã ở trong map
        if isPlayerInMap() then
            print("Bạn đang ở trong map, không thể tham gia Challenge mới")
            return
        end
        
        local success = joinChallenge()
        
        if success then
            print("Đang tham gia Challenge")
        else
            print("Không thể tham gia Challenge. Vui lòng thử lại sau.")
        end
    end
})


-- priority tab 
-- Priority tab
local PrioritySection = PriorityTab:AddSection("Priority Settings")

-- Biến lưu trạng thái Auto Join Priority
local autoJoinPriorityEnabled = ConfigSystem.CurrentConfig.AutoJoinPriority or false
local autoJoinPriorityLoop = nil
-- Danh sách các mode
local availableModes = {"Story", "Ranger Stage", "Boss Event", "Challenge", "Easter Egg", "None"}

-- Biến lưu thứ tự ưu tiên
local priorityOrder = {"None", "None", "None", "None", "None"}

-- Tạo 5 dropdown cho thứ tự ưu tiên
for i = 1, 5 do
    PrioritySection:AddDropdown("PriorityDropdown" .. i, {
        Title = "Priority Slot " .. i,
        Values = availableModes,
        Multi = false,
        Default = ConfigSystem.CurrentConfig["PrioritySlot" .. i] or "None", -- Lấy giá trị từ JSON hoặc mặc định là "None"
        Callback = function(Value)
            priorityOrder[i] = Value -- Cập nhật thứ tự ưu tiên
            ConfigSystem.CurrentConfig["PrioritySlot" .. i] = Value -- Lưu vào cấu hình
            ConfigSystem.SaveConfig() -- Lưu cấu hình vào file JSON
            
            print("Đã chọn Priority Slot " .. i .. ": " .. Value)
        end
    })
end

-- Cập nhật hàm Auto Join Priority để bỏ qua "None"
local function autoJoinPriority()
    if not autoJoinPriorityEnabled or isPlayerInMap() then
        return
    end

    -- Duyệt qua thứ tự ưu tiên và bỏ qua "None"
    for _, mode in ipairs(priorityOrder) do
        if mode ~= "None" then
            local success = false
            if mode == "Story" then
                success = joinMap()
            elseif mode == "Ranger Stage" then
                success = joinRangerStage()
            elseif mode == "Boss Event" then
                success = joinBossEvent()
            elseif mode == "Challenge" then
                -- Kiểm tra khả năng tham gia Challenge
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local playerName = game:GetService("Players").LocalPlayer.Name

                local playerData = ReplicatedStorage:FindFirstChild("Player_Data")
                local playerFolder = playerData and playerData:FindFirstChild(playerName)
                local chapterLevels = playerFolder and playerFolder:FindFirstChild("ChapterLevels")
                local challengeChapter = ReplicatedStorage:FindFirstChild("Gameplay")
                    and ReplicatedStorage.Gameplay.Game.Challenge:FindFirstChild("Chapter")

                if chapterLevels and challengeChapter and challengeChapter:IsA("StringValue") then
                    local challengeName = challengeChapter.Value
                    print("Challenge hiện tại:", challengeName)

                    if chapterLevels:FindFirstChild(challengeName) then
                        print("Challenge có thể tham gia, đang thực hiện...")
                        success = joinChallenge()
                    else
                        print("Không thể tham gia Challenge: Không đủ điều kiện.")
                    end
                else
                    warn("Dữ liệu Challenge không hợp lệ hoặc thiếu.")
                end
            elseif mode == "Easter Egg" then
                success = joinEasterEggEvent()
            end

            -- Nếu tham gia thành công, dừng vòng lặp
            if success then
                print("Đã tham gia mode: " .. mode)
                return
            else
                print("Không thể tham gia mode: " .. mode .. ", chuyển sang mode tiếp theo.")
            end
        end
    end

    print("Không có mode nào khả dụng để tham gia.")
end

-- Tự động tải thứ tự ưu tiên từ cấu hình khi khởi động
spawn(function()
    wait(1) -- Đợi game load
    for i = 1, 5 do
        priorityOrder[i] = ConfigSystem.CurrentConfig["PrioritySlot" .. i] or "None"
    end
    print("Đã tải thứ tự ưu tiên từ cấu hình:", table.concat(priorityOrder, ", "))
end)

-- Toggle Auto Join Priority
PrioritySection:AddToggle("AutoJoinPriorityToggle", {
    Title = "Enable Auto Join Priority",
    Default = autoJoinPriorityEnabled,
    Callback = function(Value)
        autoJoinPriorityEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinPriority = Value
        ConfigSystem.SaveConfig()

        if Value then
            Fluent:Notify({
                Title = "Auto Join Priority",
                Content = "Auto Join Priority đã được bật.",
                Duration = 3
            })

            -- Gọi hàm autoJoinPriority ngay lập tức
            autoJoinPriority()

            -- Tạo vòng lặp Auto Join Priority
            if autoJoinPriorityLoop then
                autoJoinPriorityLoop:Disconnect()
                autoJoinPriorityLoop = nil
            end

            spawn(function()
                while autoJoinPriorityEnabled and wait(5) do
                    autoJoinPriority()
                end
            end)
        else
            Fluent:Notify({
                Title = "Auto Join Priority",
                Content = "Auto Join Priority đã được tắt.",
                Duration = 3
            })

            -- Hủy vòng lặp nếu có
            if autoJoinPriorityLoop then
                autoJoinPriorityLoop:Disconnect()
                autoJoinPriorityLoop = nil
            end
        end
    end
})

-- Tự động tải trạng thái Auto Join Priority và Priority List khi khởi động
spawn(function()
    wait(1) -- Đợi game load

    -- Tải trạng thái Auto Join Priority
    autoJoinPriorityEnabled = ConfigSystem.CurrentConfig.AutoJoinPriority or false

    -- Tải danh sách Priority List
    priorityOrder = {
        ConfigSystem.CurrentConfig["PrioritySlot1"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot2"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot3"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot4"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot5"] or "None"
    }

    print("Đã tải trạng thái Auto Join Priority và Priority List từ cấu hình.")
end)
-- end 

-- Thêm section In-Game Controls
local InGameSection = InGameTab:AddSection("Game Controls")

-- Thêm biến lưu trạng thái Auto TP Lobby
local autoTPLobbyEnabled = ConfigSystem.CurrentConfig.AutoTPLobby or false
local autoTPLobbyDelay = ConfigSystem.CurrentConfig.AutoTPLobbyDelay or 10 -- Mặc định 10 phút
local autoTPLobbyLoop = nil

-- Hàm để teleport về lobby
local function teleportToLobby()
    local success, err = pcall(function()
        local Players = game:GetService("Players")
        local TeleportService = game:GetService("TeleportService")
        
        -- Hiển thị thông báo trước khi teleport
        print("Đang teleport về lobby...")
        
        -- Thực hiện teleport
        for _, player in pairs(Players:GetPlayers()) do
            if player == game:GetService("Players").LocalPlayer then
                TeleportService:Teleport(game.PlaceId, player)
                break -- Chỉ teleport người chơi hiện tại
            end
        end
    end)
    
    if not success then
        warn("Lỗi khi teleport về lobby: " .. tostring(err))
    end
end

-- Lưu biến cho Auto TP Lobby Delay
local autoTPLobbyDelayInput = nil

-- Input cho Auto TP Lobby Delay
autoTPLobbyDelayInput = InGameSection:AddInput("AutoTPLobbyDelayInput", {
    Title = "Auto TP Lobby Delay (1-60 phút)",
    Placeholder = "Nhập phút",
    Default = tostring(autoTPLobbyDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 60 then
            autoTPLobbyDelay = numValue
            ConfigSystem.CurrentConfig.AutoTPLobbyDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Auto TP Lobby Delay (Input): " .. numValue .. " phút")
            -- Bỏ cập nhật Slider
            -- if autoTPLobbyDelaySlider and autoTPLobbyDelaySlider.Set then autoTPLobbyDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-60 phút)")
            if autoTPLobbyDelayInput and autoTPLobbyDelayInput.Set then autoTPLobbyDelayInput:Set(tostring(autoTPLobbyDelay)) end
        end
    end
})

-- Toggle Auto TP Lobby
InGameSection:AddToggle("AutoTPLobbyToggle", {
    Title = "Auto TP Lobby",
    Default = autoTPLobbyEnabled,
    Callback = function(Value)
        autoTPLobbyEnabled = Value
        ConfigSystem.CurrentConfig.AutoTPLobby = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto TP Lobby đã được bật, sẽ teleport sau " .. autoTPLobbyDelay .. " phút")
            
            -- Hủy vòng lặp cũ nếu có
            if autoTPLobbyLoop then
                autoTPLobbyLoop:Disconnect()
                autoTPLobbyLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                local timeRemaining = autoTPLobbyDelay * 60 -- Chuyển đổi thành giây
                
                while autoTPLobbyEnabled and wait(1) do -- Đếm ngược mỗi giây
                    timeRemaining = timeRemaining - 1
                    
                    -- Hiển thị thông báo khi còn 1 phút
                    if timeRemaining == 60 then
                        print("Sẽ teleport về lobby trong 1 phút nữa")
                    end
                    
                    -- Khi hết thời gian, thực hiện teleport
                    if timeRemaining <= 0 then
                        if autoTPLobbyEnabled then
                            teleportToLobby()
                        end
                        
                        -- Reset thời gian đếm ngược
                        timeRemaining = autoTPLobbyDelay * 60
                    end
                end
            end)
        else
            print("Auto TP Lobby đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoTPLobbyLoop then
                autoTPLobbyLoop:Disconnect()
                autoTPLobbyLoop = nil
            end
        end
    end
})

-- Nút TP Lobby ngay lập tức
InGameSection:AddButton({
    Title = "TP Lobby Now",
    Callback = function()
        teleportToLobby()
    end
})

-- Hàm để kiểm tra trạng thái AutoPlay thực tế trong game
local function checkActualAutoPlayState()
    local success, result = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if not player then return false end
        
        local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
        if not playerData then return false end
        
        local playerFolder = playerData:FindFirstChild(player.Name)
        if not playerFolder then return false end
        
        local dataFolder = playerFolder:FindFirstChild("Data")
        if not dataFolder then return false end
        
        local autoPlayValue = dataFolder:FindFirstChild("AutoPlay")
        if not autoPlayValue then return false end
        
        return autoPlayValue.Value
    end)
    
    if not success then
        warn("Lỗi khi kiểm tra trạng thái AutoPlay: " .. tostring(result))
        return false
    end
    
    return result
end

-- Hàm để bật/tắt Auto Play
local function toggleAutoPlay()
    local success, err = pcall(function()
        local AutoPlayRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "Units", "AutoPlay"}, 2)
        
        if AutoPlayRemote then
            AutoPlayRemote:FireServer()
            print("Đã toggle Auto Play")
        else
            warn("Không tìm thấy Remote AutoPlay")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Auto Play: " .. tostring(err))
    end
end

-- Toggle Auto Play
InGameSection:AddToggle("AutoPlayToggle", {
    Title = "Auto Play",
    Default = ConfigSystem.CurrentConfig.AutoPlay or false,
    Callback = function(Value)
        -- Cập nhật cấu hình
        autoPlayEnabled = Value
        ConfigSystem.CurrentConfig.AutoPlay = Value
        ConfigSystem.SaveConfig()
        
        -- Kiểm tra trạng thái thực tế của AutoPlay
        local actualState = checkActualAutoPlayState()
        
        -- Chỉ toggle khi trạng thái mong muốn khác với trạng thái hiện tại
        if Value ~= actualState then
            toggleAutoPlay()
            
            if Value then
                print("Auto Play đã được bật")
            else
                print("Auto Play đã được tắt")
            end
        else
            print("Trạng thái Auto Play đã phù hợp (" .. (Value and "bật" or "tắt") .. ")")
        end
    end
})

-- Hàm để bật/tắt Auto Retry
local function toggleAutoRetry()
    local success, err = pcall(function()
        local AutoRetryRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "OnGame", "Voting", "VoteRetry"}, 2)
        
        if AutoRetryRemote then
            AutoRetryRemote:FireServer()
            print("Đã toggle Auto Retry")
        else
            warn("Không tìm thấy Remote VoteRetry")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Auto Retry: " .. tostring(err))
    end
end

-- Hàm để bật/tắt Auto Next
local function toggleAutoNext()
    local success, err = pcall(function()
        local AutoNextRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "OnGame", "Voting", "VoteNext"}, 2)
        
        if AutoNextRemote then
            AutoNextRemote:FireServer()
            print("Đã toggle Auto Next")
        else
            warn("Không tìm thấy Remote VoteNext")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Auto Next: " .. tostring(err))
    end
end

-- Hàm để bật/tắt Auto Vote
local function toggleAutoVote()
    local success, err = pcall(function()
        local AutoVoteRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "OnGame", "Voting", "VotePlaying"}, 2)
        
        if AutoVoteRemote then
            AutoVoteRemote:FireServer()
            print("Đã toggle Auto Vote")
        else
            warn("Không tìm thấy Remote VotePlaying")
        end
    end)
    
    if not success then
        warn("Lỗi khi toggle Auto Vote: " .. tostring(err))
    end
end

-- Toggle Auto Retry
InGameSection:AddToggle("AutoRetryToggle", {
    Title = "Auto Retry",
    Default = ConfigSystem.CurrentConfig.AutoRetry or false,
    Callback = function(Value)
        autoRetryEnabled = Value
        ConfigSystem.CurrentConfig.AutoRetry = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto Retry đã được bật")
            
            -- Hủy vòng lặp cũ nếu có
            if autoRetryLoop then
                autoRetryLoop:Disconnect()
                autoRetryLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                while autoRetryEnabled and wait(3) do -- Gửi yêu cầu mỗi 3 giây
                    toggleAutoRetry()
                end
            end)
        else
            print("Auto Retry đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoRetryLoop then
                autoRetryLoop:Disconnect()
                autoRetryLoop = nil
            end
        end
    end
})

-- Toggle Auto Next
InGameSection:AddToggle("AutoNextToggle", {
    Title = "Auto Next",
    Default = ConfigSystem.CurrentConfig.AutoNext or false,
    Callback = function(Value)
        autoNextEnabled = Value
        ConfigSystem.CurrentConfig.AutoNext = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto Next đã được bật")
            
            -- Hủy vòng lặp cũ nếu có
            if autoNextLoop then
                autoNextLoop:Disconnect()
                autoNextLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                while autoNextEnabled and wait(3) do -- Gửi yêu cầu mỗi 3 giây
                    toggleAutoNext()
                end
            end)
        else
            print("Auto Next đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoNextLoop then
                autoNextLoop:Disconnect()
                autoNextLoop = nil
            end
        end
    end
})

-- Toggle Auto Vote
InGameSection:AddToggle("AutoVoteToggle", {
    Title = "Auto Vote",
    Default = ConfigSystem.CurrentConfig.AutoVote or false,
    Callback = function(Value)
        autoVoteEnabled = Value
        ConfigSystem.CurrentConfig.AutoVote = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto Vote đã được bật, sẽ bắt đầu ngay lập tức")
            -- Hủy vòng lặp cũ nếu có
            if autoVoteLoop then
                autoVoteLoop:Disconnect()
                autoVoteLoop = nil
            end
            -- Gửi vote ngay lập tức
            toggleAutoVote()
            -- Tạo vòng lặp mới
            spawn(function()
                while autoVoteEnabled and wait(0.5) do -- Gửi yêu cầu mỗi 0.5 giây
                    toggleAutoVote()
                end
            end)
        else
            print("Auto Vote đã được tắt")
            -- Hủy vòng lặp nếu có
            if autoVoteLoop then
                autoVoteLoop:Disconnect()
                autoVoteLoop = nil
            end
        end
    end
})

-- Hàm để scan unit trong UnitsFolder
local function scanUnits()
        -- Lấy UnitsFolder
        local player = game:GetService("Players").LocalPlayer
        if not player then
        return false
        end
        
        local unitsFolder = player:FindFirstChild("UnitsFolder")
        if not unitsFolder then
        return false
        end
        
        -- Lấy danh sách unit theo thứ tự
        unitSlots = {}
    local children = unitsFolder:GetChildren()
    for i, unit in ipairs(children) do
        if (unit:IsA("Folder") or unit:IsA("Model")) and i <= 6 then -- Giới hạn 6 slot
                unitSlots[i] = unit
            -- Không in log để giảm spam
            end
        end
        
        return #unitSlots > 0
    end
    
-- Hàm để nâng cấp unit tối ưu
local function upgradeUnit(unit)
    if not unit then
        return false
    end
    
    local upgradeRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "Units", "Upgrade"}, 0.5)
    if not upgradeRemote then
        return false
    end
    
    upgradeRemote:FireServer(unit)
    return true
end

-- Thêm section Units Update trong tab In-Game
local UnitsUpdateSection = InGameTab:AddSection("Units Update")

-- Tạo 6 dropdown cho 6 slot
for i = 1, 6 do
    UnitsUpdateSection:AddDropdown("Slot" .. i .. "LevelDropdown", {
        Title = "Slot " .. i .. " Level",
        Values = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
        Multi = false,
        Default = tostring(unitSlotLevels[i]),
        Callback = function(Value)
            -- Chuyển đổi giá trị thành số
            local numberValue = tonumber(Value)
            if not numberValue then
                numberValue = 0
            end
            
            unitSlotLevels[i] = numberValue
            ConfigSystem.CurrentConfig["Slot" .. i .. "Level"] = numberValue
            ConfigSystem.SaveConfig()
            
            print("Đã đặt cấp độ slot " .. i .. " thành: " .. numberValue)
        end
    })
end

-- Toggle Auto Update
UnitsUpdateSection:AddToggle("AutoUpdateToggle", {
    Title = "Auto Update",
    Default = ConfigSystem.CurrentConfig.AutoUpdate or false,
    Callback = function(Value)
        autoUpdateEnabled = Value
        ConfigSystem.CurrentConfig.AutoUpdate = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Scan unit trước khi bắt đầu
            scanUnits()
            
            print("Auto Update đã được bật")
            
            -- Hủy vòng lặp cũ nếu có
            if autoUpdateLoop then
                autoUpdateLoop:Disconnect()
                autoUpdateLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                while autoUpdateEnabled and wait(0.1) do -- Cập nhật mỗi 0.1 giây
                    -- Kiểm tra xem có trong map không
                    if isPlayerInMap() then
                        -- Lặp qua từng slot và nâng cấp theo cấp độ đã chọn
                        for i = 1, 6 do
                            if unitSlots[i] and unitSlotLevels[i] > 0 then
                                for j = 1, unitSlotLevels[i] do
                                    upgradeUnit(unitSlots[i])
                                    wait(0.1) -- Chờ một chút giữa các lần nâng cấp
                                end
                            end
                        end
                    else
                        -- Người chơi không ở trong map, thử scan lại
                        scanUnits()
                    end
                end
            end)
        else
            print("Auto Update đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoUpdateLoop then
                autoUpdateLoop:Disconnect()
                autoUpdateLoop = nil
            end
        end
    end
})

-- Toggle Auto Update Random
UnitsUpdateSection:AddToggle("AutoUpdateRandomToggle", {
    Title = "Auto Update Random",
    Default = ConfigSystem.CurrentConfig.AutoUpdateRandom or false,
    Callback = function(Value)
        autoUpdateRandomEnabled = Value
        ConfigSystem.CurrentConfig.AutoUpdateRandom = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Scan unit trước khi bắt đầu
            scanUnits()
            
            print("Auto Update Random đã được bật")
            
            -- Hủy vòng lặp cũ nếu có
            if autoUpdateRandomLoop then
                autoUpdateRandomLoop:Disconnect()
                autoUpdateRandomLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                while autoUpdateRandomEnabled and wait(0.1) do -- Cập nhật mỗi 0.1 giây
                    -- Kiểm tra xem có trong map không
                    if isPlayerInMap() and #unitSlots > 0 then
                        -- Chọn ngẫu nhiên một slot để nâng cấp
                        local randomIndex = math.random(1, #unitSlots)
                        if unitSlots[randomIndex] then
                            upgradeUnit(unitSlots[randomIndex])
                        end
                    else
                        -- Người chơi không ở trong map, thử scan lại
                        scanUnits()
                    end
                end
            end)
        else
            print("Auto Update Random đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoUpdateRandomLoop then
                autoUpdateRandomLoop:Disconnect()
                autoUpdateRandomLoop = nil
            end
        end
    end
})

-- Hàm để kiểm tra trạng thái AFKWorld
local function checkAFKWorldState()
    local success, result = pcall(function()
        local afkWorldValue = game:GetService("ReplicatedStorage"):WaitForChild("Values", 1):WaitForChild("AFKWorld", 1)
        if afkWorldValue then
            return afkWorldValue.Value
        end
        return false
    end)
    
    if not success then
        warn("Lỗi khi kiểm tra trạng thái AFKWorld: " .. tostring(result))
        return false
    end
    
    return result
end

-- Tối ưu hóa hàm tham gia AFK World
local function joinAFKWorld()
        -- Kiểm tra nếu người chơi đã ở AFKWorld
        if checkAFKWorldState() then
        return true
        end
        
    -- Lấy remote và gửi yêu cầu
    local afkTeleportRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "Lobby", "AFKWorldTeleport"}, 0.5)
    if not afkTeleportRemote then
            warn("Không tìm thấy Remote AFKWorldTeleport")
        return false
        end
    
    afkTeleportRemote:FireServer()
    return true
end

-- Thêm section AFK vào tab Settings
local AFKSection = SettingsTab:AddSection("AFK Settings")

-- Biến lưu trạng thái Anti AFK
local antiAFKEnabled = ConfigSystem.CurrentConfig.AntiAFK or true -- Mặc định bật
local antiAFKConnection = nil -- Kết nối sự kiện

-- Tối ưu hệ thống Anti AFK
local function setupAntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Ngắt kết nối cũ nếu có
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    -- Tạo kết nối mới nếu được bật
    if antiAFKEnabled and LocalPlayer then
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.5) -- Giảm thời gian chờ xuống 0.5 giây
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end

-- Toggle Anti AFK
AFKSection:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Default = antiAFKEnabled,
    Callback = function(Value)
        antiAFKEnabled = Value
        ConfigSystem.CurrentConfig.AntiAFK = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            Fluent:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK đã được bật",
                Duration = 2
            })
            setupAntiAFK()
        else
            Fluent:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK đã được tắt",
                Duration = 2
            })
            -- Ngắt kết nối nếu có
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
        end
    end
})

-- Toggle Auto Join AFK
AFKSection:AddToggle("AutoJoinAFKToggle", {
    Title = "Auto Join AFK",
    Default = ConfigSystem.CurrentConfig.AutoJoinAFK or false,
    Callback = function(Value)
        autoJoinAFKEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinAFK = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Kiểm tra trạng thái AFKWorld
            local isInAFKWorld = checkAFKWorldState()

            print("Auto Join AFK đã được bật")
            
            -- Nếu không ở trong AFKWorld, teleport ngay lập tức
            if not isInAFKWorld then
                joinAFKWorld()
            else
                print("Bạn đã ở trong AFKWorld")
            end
            
            -- Hủy vòng lặp cũ nếu có
            if autoJoinAFKLoop then
                autoJoinAFKLoop:Disconnect()
                autoJoinAFKLoop = nil
            end
            
            -- Tạo vòng lặp mới
            spawn(function()
                while autoJoinAFKEnabled and wait(60) do -- Kiểm tra mỗi 60 giây
                    -- Chỉ teleport nếu không ở trong AFKWorld
                    if not checkAFKWorldState() then
                        joinAFKWorld()
                    end
                end
            end)
        else
            print("Auto Join AFK đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoJoinAFKLoop then
                autoJoinAFKLoop:Disconnect()
                autoJoinAFKLoop = nil
            end
        end
    end
})

-- Nút Join AFK Now
AFKSection:AddButton({
    Title = "Join AFK Now",
    Callback = function()
        local isInAFKWorld = checkAFKWorldState()
        
        if isInAFKWorld then
            print("Bạn đã ở trong AFKWorld")
            return
        end
        
        joinAFKWorld()
        
        print("Đang teleport đến AFKWorld...")
    end
})

-- Tự động đồng bộ trạng thái từ game khi khởi động
spawn(function()
    wait(3) -- Đợi game load
    
    -- Khởi tạo danh sách Acts khi script khởi động
    updateOrderedActs()
    
    -- Kiểm tra nếu người chơi đã ở trong AFKWorld
    local isInAFKWorld = checkAFKWorldState()
    
    -- Nếu Auto Join AFK được bật và người chơi không ở trong AFKWorld
    if autoJoinAFKEnabled and not isInAFKWorld then
        joinAFKWorld()
    end
end)

-- Thêm section UI Settings vào tab Settings
local UISettingsSection = SettingsTab:AddSection("UI Settings")

-- Toggle Auto Hide UI
UISettingsSection:AddToggle("AutoHideUIToggle", {
    Title = "Auto Hide UI",
    Default = ConfigSystem.CurrentConfig.AutoHideUI or false,
    Callback = function(Value)
        autoHideUIEnabled = Value
        ConfigSystem.CurrentConfig.AutoHideUI = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Auto Hide UI đã được bật, UI sẽ tự động ẩn sau 1 giây")
            
            -- Tạo timer mới để tự động ẩn UI
            if autoHideUITimer then
                autoHideUITimer:Disconnect()
                autoHideUITimer = nil
            end
            
            autoHideUITimer = spawn(function()
                wait(1) -- Đợi 1 giây
                -- Sử dụng Window.Visible thay vì isMinimized để kiểm tra
                if autoHideUIEnabled and Window and Window.Visible then 
                    Window:Minimize()
                end
            end)
        else
            print("Auto Hide UI đã được tắt")
            
            -- Hủy timer nếu có
            if autoHideUITimer then
                autoHideUITimer:Disconnect()
                autoHideUITimer = nil
            end
        end
    end
})

-- Tự động ẩn UI nếu tính năng được bật KHI KHỞI ĐỘNG SCRIPT
spawn(function()
    print("AutoHideUI startup: Waiting for Window and game load...") -- Debug
    -- Đợi cho đến khi Window được tạo và game load xong
    while not Window or not game:IsLoaded() do wait(0.1) end
    print("AutoHideUI startup: Window and game loaded.") -- Debug
    wait(1.5) -- Tăng thời gian chờ lên 1.5 giây
    print("AutoHideUI startup: Checking config...") -- Debug

    -- Kiểm tra config và thực hiện minimize nếu cần
    if ConfigSystem.CurrentConfig.AutoHideUI then
        print("AutoHideUI startup: Config enabled. Attempting to minimize Window...") -- Debug
        -- Kiểm tra kỹ Window và phương thức Minimize trước khi gọi
        if Window and type(Window.Minimize) == 'function' then 
            local success, err = pcall(function()
                 Window:Minimize()
            end)
            if success then
                 print("AutoHideUI startup: Window:Minimize() called successfully.") -- Debug
            else
                 print("AutoHideUI startup: Error calling Window:Minimize():", err) -- Debug
            end
        else
             print("AutoHideUI startup: Error - Window object or Window.Minimize method not available or not a function.") -- Debug
        end
    else
        print("AutoHideUI startup: Config disabled.") -- Debug
    end
end)

-- Hàm để xóa animations
local function removeAnimations()
    if not isPlayerInMap() then
        return false
    end
    
    local success, err = pcall(function()
        -- Xóa UIS.Packages.Transition.Flash từ ReplicatedStorage
        local uis = game:GetService("ReplicatedStorage"):FindFirstChild("UIS")
            if uis then
                local packages = uis:FindFirstChild("Packages")
                if packages then
                    local transition = packages:FindFirstChild("Transition")
                    if transition then
                    local flash = transition:FindFirstChild("Flash")
                    if flash then
                        flash:Destroy()
                        print("Đã xóa ReplicatedStorage.UIS.Packages.Transition.Flash")
                    end
                end
            end
            
            -- Xóa RewardsUI
            local rewardsUI = uis:FindFirstChild("RewardsUI")
            if rewardsUI then
                rewardsUI:Destroy()
                print("Đã xóa ReplicatedStorage.UIS.RewardsUI")
            end
        end
    end)
    
    if not success then
        warn("Lỗi khi xóa animations: " .. tostring(err))
        return false
    end
    
    return true
end

-- Thêm Toggle Remove Animation
InGameSection:AddToggle("RemoveAnimationToggle", {
    Title = "Remove Animation",
    Default = ConfigSystem.CurrentConfig.RemoveAnimation or true,
    Callback = function(Value)
        removeAnimationEnabled = Value
        ConfigSystem.CurrentConfig.RemoveAnimation = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            print("Remove Animation đã được bật")
            
            -- Hủy vòng lặp cũ nếu có
            if removeAnimationLoop then
                removeAnimationLoop:Disconnect()
                removeAnimationLoop = nil
            end
            
            -- Thử xóa animations ngay lập tức nếu đang trong map
            if isPlayerInMap() then
                removeAnimations()
            else
                print("Không ở trong map, sẽ xóa animations khi vào map")
            end
            
            -- Tạo vòng lặp mới để xóa animations định kỳ
            spawn(function()
                while removeAnimationEnabled and wait(3) do
                    if isPlayerInMap() then
                        removeAnimations()
                    end
                end
            end)
        else
            print("Remove Animation đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if removeAnimationLoop then
                removeAnimationLoop:Disconnect()
                removeAnimationLoop = nil
            end
        end
    end
})

-- Tự động xóa animations khi khởi động script nếu tính năng được bật và đang ở trong map
spawn(function()
    wait(3) -- Đợi game load
    
    if removeAnimationEnabled and isPlayerInMap() then
        removeAnimations()
        
        -- Tạo vòng lặp để tiếp tục xóa animations định kỳ
        spawn(function()
            while removeAnimationEnabled and wait(3) do
                if isPlayerInMap() then
                    removeAnimations()
                end
            end
        end)
    end
end)

-- Thêm section Merchant trong tab Shop
local MerchantSection = ShopTab:AddSection("Merchant")

-- Biến lưu trạng thái Merchant
local selectedMerchantItems = ConfigSystem.CurrentConfig.SelectedMerchantItems or {}
local autoMerchantBuyEnabled = ConfigSystem.CurrentConfig.AutoMerchantBuy or false
local autoMerchantBuyLoop = nil

-- Danh sách các item có thể mua từ Merchant
local merchantItems = {
    "Green Bean",
    "Onigiri",
    "Dr. Megga Punk", 
    "Cursed Finger",
    "Stats Key",
    "French Fries",
    "Trait Reroll",
    "Ranger Crystal",
    "Rubber Fruit"
}

-- Hàm để mua item từ Merchant
local function buyMerchantItem(itemName)
    local success, err = pcall(function()
        local merchantRemote = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "Gameplay", "Merchant"}, 2)
        
        if merchantRemote then
            local args = {
                [1] = itemName,
                [2] = 1
            }
            
            merchantRemote:FireServer(unpack(args))
            print("Đã mua item: " .. itemName)
            
            -- Hiển thị thông báo
            print("Đã mua item: " .. itemName)
        else
            warn("Không tìm thấy Remote Merchant")
        end
    end)
    
    if not success then
        warn("Lỗi khi mua item từ Merchant: " .. tostring(err))
    end
end

-- Dropdown để chọn nhiều items
MerchantSection:AddDropdown("MerchantItemsDropdown", {
    Title = "Select Items",
    Values = merchantItems,
    Multi = true,
    Default = selectedMerchantItems,
    Callback = function(Values)
        selectedMerchantItems = Values
        ConfigSystem.CurrentConfig.SelectedMerchantItems = Values
        ConfigSystem.SaveConfig()
        
        local selectedItemsText = ""
        -- Sửa cách xử lý Values để tránh lỗi
        if type(Values) == "table" then
            for item, isSelected in pairs(Values) do
                if isSelected then
                    selectedItemsText = selectedItemsText .. item .. ", "
                end
            end
        end
        
        if selectedItemsText ~= "" then
            selectedItemsText = selectedItemsText:sub(1, -3) -- Xóa dấu phẩy cuối cùng
            print("Đã chọn items: " .. selectedItemsText)
        else
            print("Không có item nào được chọn")
        end
    end
})

-- Nút Buy Selected Item (mua thủ công)
MerchantSection:AddButton({
    Title = "Buy Selected Items",
    Callback = function()
        local selectedItemsCount = 0
        -- Sửa cách duyệt qua selectedMerchantItems
        for item, isSelected in pairs(selectedMerchantItems) do
            if isSelected then
                selectedItemsCount = selectedItemsCount + 1
                buyMerchantItem(item)
                wait(0.5) -- Chờ 0.5 giây giữa các lần mua
            end
        end
        
        if selectedItemsCount == 0 then
            print("Không có item nào được chọn để mua")
        end
    end
})

-- Toggle Auto Buy
MerchantSection:AddToggle("AutoMerchantBuyToggle", {
    Title = "Auto Buy",
    Default = ConfigSystem.CurrentConfig.AutoMerchantBuy or false,
    Callback = function(Value)
        autoMerchantBuyEnabled = Value
        ConfigSystem.CurrentConfig.AutoMerchantBuy = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            local selectedItemsCount = 0
            for item, isSelected in pairs(selectedMerchantItems) do
                if isSelected then
                    selectedItemsCount = selectedItemsCount + 1
                end
            end
            
            if selectedItemsCount == 0 then
                print("Auto Buy đã bật nhưng không có item nào được chọn")
            else
                print("Auto Buy đã được bật, sẽ tự động mua items mỗi 2 giây")
            end
            
            -- Hủy vòng lặp cũ nếu có
            if autoMerchantBuyLoop then
                autoMerchantBuyLoop:Disconnect()
                autoMerchantBuyLoop = nil
            end
            
            -- Tạo vòng lặp mới để tự động mua
            spawn(function()
                while autoMerchantBuyEnabled and wait(2) do -- Mua mỗi 2 giây
                    for item, isSelected in pairs(selectedMerchantItems) do
                        if isSelected then
                            buyMerchantItem(item)
                            wait(0.5) -- Chờ 0.5 giây giữa các lần mua
                        end
                    end
                end
            end)
        else
            print("Auto Buy đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoMerchantBuyLoop then
                autoMerchantBuyLoop:Disconnect()
                autoMerchantBuyLoop = nil
            end
        end
    end
})

-- Biến lưu trạng thái Auto Scan Units
local autoScanUnitsEnabled = ConfigSystem.CurrentConfig.AutoScanUnits or true
local autoScanUnitsLoop = nil

-- Tự động scan unit khi bắt đầu
spawn(function()
    wait(5) -- Đợi 5 giây để game load
    scanUnits()
    
    -- Bắt đầu vòng lặp auto scan nếu đã bật
    if autoScanUnitsEnabled then
        spawn(function()
            while autoScanUnitsEnabled and wait(3) do
                if isPlayerInMap() then
                    local success = scanUnits()
                    if success then
                        print("Auto Scan: Phát hiện " .. #unitSlots .. " unit")
                    end
                end
            end
        end)
    end
end)

-- Tự động cập nhật trạng thái từ game khi khởi động
spawn(function()
    wait(3) -- Đợi game load
    local actualState = checkActualAutoPlayState()
    
    -- Cập nhật cấu hình nếu trạng thái thực tế khác với cấu hình
    if autoPlayEnabled ~= actualState then
        autoPlayEnabled = actualState
        ConfigSystem.CurrentConfig.AutoPlay = actualState
        ConfigSystem.SaveConfig()
        
        -- Cập nhật UI nếu cần
        local autoPlayToggle = InGameSection:GetComponent("AutoPlayToggle")
        if autoPlayToggle and autoPlayToggle.Set then
            autoPlayToggle:Set(actualState)
        end
        
        print("Đã cập nhật trạng thái Auto Play từ game: " .. (actualState and "bật" or "tắt"))
    end
end)

-- Thêm section Easter Egg - Event trong tab Event
local EasterEggSection = EventTab:AddSection("Easter Egg - Event")

-- Biến lưu trạng thái Easter Egg
local autoJoinEasterEggEnabled = ConfigSystem.CurrentConfig.AutoJoinEasterEgg or false
local easterEggTimeDelay = ConfigSystem.CurrentConfig.EasterEggTimeDelay or 5
local autoJoinEasterEggLoop = nil

-- Hàm để tham gia Easter Egg Event
local function joinEasterEggEvent()
    -- Kiểm tra xem người chơi đã ở trong map chưa
    if isPlayerInMap() then
        print("Đã phát hiện người chơi đang ở trong map, không thực hiện join Easter Egg Event")
        return false
    end
    
    local success, err = pcall(function()
        -- Lấy Event
        local Event = safeGetPath(game:GetService("ReplicatedStorage"), {"Remote", "Server", "PlayRoom", "Event"}, 2)
        
        if not Event then
            warn("Không tìm thấy Event để join Easter Egg Event")
            return
        end
        
        -- 1. Gửi lệnh Easter-Event
        local args1 = {
            [1] = "Easter-Event"
        }
        Event:FireServer(unpack(args1))
        print("Đã gửi lệnh Easter-Event")
        wait(1) -- Đợi 1 giây
        
        -- 2. Gửi lệnh Start
        local args2 = {
            [1] = "Start"
        }
        Event:FireServer(unpack(args2))
        print("Đã gửi lệnh Start cho Easter Egg Event")
    end)
    
    if not success then
        warn("Lỗi khi tham gia Easter Egg Event: " .. tostring(err))
        return false
    end
    
    return true
end

-- Lưu biến cho Easter Egg Time Delay
local easterEggTimeDelayInput = nil

-- Input cho Easter Egg Time Delay
easterEggTimeDelayInput = EasterEggSection:AddInput("EasterEggTimeDelayInput", {
    Title = "Easter Egg Delay (1-60s)",
    Placeholder = "Nhập delay",
    Default = tostring(easterEggTimeDelay),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue >= 1 and numValue <= 60 then
            easterEggTimeDelay = numValue
            ConfigSystem.CurrentConfig.EasterEggTimeDelay = numValue
            ConfigSystem.SaveConfig()
            print("Đã đặt Easter Egg Time Delay (Input): " .. numValue .. " giây")
            -- Bỏ cập nhật Slider
            -- if easterEggTimeDelaySlider and easterEggTimeDelaySlider.Set then easterEggTimeDelaySlider:Set(numValue) end
        else
            print("Giá trị delay không hợp lệ (1-60)")
            if easterEggTimeDelayInput and easterEggTimeDelayInput.Set then easterEggTimeDelayInput:Set(tostring(easterEggTimeDelay)) end
        end
    end
})

-- Toggle Auto Join Easter Egg
EasterEggSection:AddToggle("AutoJoinEasterEggToggle", {
    Title = "Auto Join Easter Egg",
    Default = ConfigSystem.CurrentConfig.AutoJoinEasterEgg or false,
    Callback = function(Value)
        autoJoinEasterEggEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinEasterEgg = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Kiểm tra ngay lập tức nếu người chơi đang ở trong map
            if isPlayerInMap() then
                print("Đang ở trong map, Auto Join Easter Egg sẽ hoạt động khi bạn rời khỏi map")
            else
                print("Auto Join Easter Egg đã được bật, sẽ bắt đầu sau " .. easterEggTimeDelay .. " giây")
                
                -- Thực hiện join Easter Egg Event sau thời gian delay
                spawn(function()
                    wait(easterEggTimeDelay)
                    if autoJoinEasterEggEnabled and not isPlayerInMap() then
                        joinEasterEggEvent()
                    end
                end)
            end
            
            -- Tạo vòng lặp Auto Join Easter Egg Event
            spawn(function()
                while autoJoinEasterEggEnabled and wait(10) do -- Thử join mỗi 10 giây
                    -- Chỉ thực hiện join nếu người chơi không ở trong map
                    if not isPlayerInMap() then
                        -- Áp dụng time delay
                        print("Đợi " .. easterEggTimeDelay .. " giây trước khi join Easter Egg Event")
                        wait(easterEggTimeDelay)
                        
                        -- Kiểm tra lại sau khi delay
                        if autoJoinEasterEggEnabled and not isPlayerInMap() then
                            joinEasterEggEvent()
                        end
                    else
                        -- Người chơi đang ở trong map, không cần join
                        print("Đang ở trong map, đợi đến khi người chơi rời khỏi map")
                    end
                end
            end)
        else
            print("Auto Join Easter Egg đã được tắt")
            
            -- Hủy vòng lặp nếu có
            if autoJoinEasterEggLoop then
                autoJoinEasterEggLoop:Disconnect()
                autoJoinEasterEggLoop = nil
            end
        end
    end
})

-- Nút Join Easter Egg Now (thủ công)
EasterEggSection:AddButton({
    Title = "Join Easter Egg Now",
    Callback = function()
        -- Kiểm tra nếu người chơi đang ở trong map
        if isPlayerInMap() then
        print("Bạn đang ở trong map, không thể tham gia Easter Egg Event mới")
            return
        end
        
        print("Đang tham gia Easter Egg Event...")
        
        joinEasterEggEvent()
    end
})

-- Khởi tạo Anti AFK khi script khởi động
spawn(function()
    -- Đợi một chút để script khởi động hoàn tất
    wait(3)
    
    -- Nếu Anti AFK được bật, thiết lập nó
    if antiAFKEnabled then
        setupAntiAFK()
        print("Đã tự động thiết lập Anti AFK khi khởi động script")
    end
end)

-- Tự động xóa animations khi khởi động script nếu tính năng được bật và đang ở trong map
spawn(function()
    wait(3) -- Đợi game load
    
    if removeAnimationEnabled and isPlayerInMap() then
        removeAnimations()
        
        -- Tạo vòng lặp để tiếp tục xóa animations định kỳ
        spawn(function()
            while removeAnimationEnabled and wait(3) do
                if isPlayerInMap() then
                    removeAnimations()
                end
            end
        end)
    end
end)

-- Khởi động các vòng lặp tối ưu
setupOptimizedLoops()

-- Kiểm tra trạng thái người chơi khi script khởi động
if isPlayerInMap() then
    print("Bạn đang ở trong map, Auto Join sẽ chỉ hoạt động khi bạn rời khỏi map")
end

-- Thông báo khi script đã tải xong
Fluent:Notify({
    Title = "HT Hub | Anime Rangers X",
    Content = "Script đã tải thành công! Đã tối ưu hóa cho trải nghiệm mượt mà.",
    Duration = 3
})

print("Anime Rangers X Script has been loaded and optimized!")

-- Biến lưu trạng thái Webhook
local webhookURL = ConfigSystem.CurrentConfig.WebhookURL or ""
local autoSendWebhookEnabled = ConfigSystem.CurrentConfig.AutoSendWebhook or false
local webhookSentLog = {} -- Lưu trữ log các lần đã gửi để tránh gửi lặp lại

-- Hàm lấy thông tin phần thưởng
local function getRewards()
    local player = game:GetService("Players").LocalPlayer
    local rewardsShow = player:FindFirstChild("RewardsShow")
    local result = {}
    
    if rewardsShow then
        for _, folder in ipairs(rewardsShow:GetChildren()) do
            local amount = folder:FindFirstChild("Amount")
            table.insert(result, {
                Name = folder.Name,
                Amount = (amount and amount.Value) or 0
            })
        end
    end
    
    return result
end

-- Hàm lấy số lượng tài nguyên hiện tại
local function getCurrentResources()
    local player = game:GetService("Players").LocalPlayer
    local playerName = player.Name
    local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
    
    if not playerData then
        return {}
    end
    
    local playerFolder = playerData:FindFirstChild(playerName)
    if not playerFolder then
        return {}
    end
    
    local dataFolder = playerFolder:FindFirstChild("Data")
    if not dataFolder then
        return {}
    end
    
    local resources = {}
    
    -- Lấy số lượng các tài nguyên phổ biến
    local commonResources = {"Gold", "Gem", "EXP", "Rubber Fruit"}
    for _, resourceName in ipairs(commonResources) do
        local resourceValue = dataFolder:FindFirstChild(resourceName)
        if resourceValue then
            resources[resourceName] = resourceValue.Value
        end
    end
    
    -- Kiểm tra thêm các tài nguyên khác trong Data folder
    for _, child in pairs(dataFolder:GetChildren()) do
        if child:IsA("IntValue") or child:IsA("NumberValue") then
            resources[child.Name] = child.Value
        end
    end
    
    return resources
end

-- Hàm tính tổng tài nguyên sau khi nhận phần thưởng
local function calculateTotalResources(rewards)
    local currentResources = getCurrentResources()
    local totalResources = {}
    
    -- Tính tổng cho mỗi loại tài nguyên
    for _, reward in ipairs(rewards) do
        local resourceName = reward.Name
        local currentAmount = currentResources[resourceName] or 0
        totalResources[resourceName] = currentAmount + reward.Amount
    end
    
    return totalResources
end

-- Hàm lấy thông tin trận đấu
local function getGameInfoText()
    local player = game:GetService("Players").LocalPlayer
    local rewardsUI = player:WaitForChild("PlayerGui", 1):FindFirstChild("RewardsUI")
    local infoLines = {}
    
    if rewardsUI then
        local leftSide = rewardsUI:FindFirstChild("Main") and rewardsUI.Main:FindFirstChild("LeftSide")
        if leftSide then
            local labels = {
                "GameStatus",
                "Mode",
                "World",
                "Chapter",
                "Difficulty",
                "TotalTime"
            }
            
            for _, labelName in ipairs(labels) do
                local label = leftSide:FindFirstChild(labelName)
                if label and label:IsA("TextLabel") then
                    table.insert(infoLines, "- " .. labelName .. ": " .. label.Text)
                end
            end
        end
    end
    
    return table.concat(infoLines, "\n")
end

-- Hàm tạo nội dung embed
local function createEmbed(rewards, gameInfo)
    local fields = {}
    
    -- Thêm trường phần thưởng
    local rewardText = ""
    for _, r in ipairs(rewards) do
        rewardText = rewardText .. "- " .. r.Name .. ": +" .. r.Amount .. "\n"
    end
    
    if rewardText ~= "" then
        table.insert(fields, {
            name = "📦 Phần thưởng vừa nhận",
            value = rewardText,
            inline = false
        })
    end
    
    -- Lấy và hiển thị thông tin tài nguyên người chơi
    local playerResources = getCurrentResources()
    local statsText = ""
    
    -- Thêm tên người chơi
    local playerName = game:GetService("Players").LocalPlayer.Name
    statsText = "- Name: " .. playerName .. "\n"
    
    -- Luôn hiển thị các tài nguyên chính: Level, Gem, Gold, Egg
    local mainResources = {"Level", "Gem", "Gold", "Egg"}
    for _, resourceName in ipairs(mainResources) do
        local value = playerResources[resourceName] or 0
        statsText = statsText .. "- " .. resourceName .. ": " .. value .. "\n"
    end
    
    table.insert(fields, {
        name = "👤 Account",
        value = statsText,
        inline = false
    })
    
    -- Thêm trường thông tin trận đấu
    if gameInfo ~= "" then
        table.insert(fields, {
            name = "📝 Thông tin trận đấu",
            value = gameInfo,
            inline = false
        })
    end
    
    -- Tạo embed
    local embed = {
        title = "Anime Rangers X - Kết quả trận đấu",
        description = "Thông tin về trận đấu vừa kết thúc",
        color = 5793266, -- Màu tím
        fields = fields,
        thumbnail = {
            url = "https://media.discordapp.net/attachments/1321403790343274597/1364864770699821056/HT_HUB.png?ex=680b38df&is=6809e75f&hm=8a8272215b54db14974319f1745680390342942777e2fc291e38a4be4edf6fda&=&format=webp&quality=lossless&width=930&height=930" -- Logo HT Hub
        },
        footer = {
            text = "HT Hub | Anime Rangers X • " .. os.date("%x %X"),
            icon_url = "https://media.discordapp.net/attachments/1321403790343274597/1364864770699821056/HT_HUB.png?ex=680b38df&is=6809e75f&hm=8a8272215b54db14974319f1745680390342942777e2fc291e38a4be4edf6fda&=&format=webp&quality=lossless&width=930&height=930"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    
    return embed
end

-- Hàm gửi webhook
local function sendWebhook(rewards)
    -- Kiểm tra URL webhook
    if webhookURL == "" then
        warn("URL webhook trống, không thể gửi thông tin")
        return false
    end
    
    -- Tạo ID cho lần gửi này
    local gameId = os.time() .. "_" .. math.random(1000, 9999)
    
    -- Kiểm tra nếu đã gửi trước đó
    if webhookSentLog[gameId] then
        return false
    end
    
    -- Lấy thông tin trận đấu
    local gameInfo = getGameInfoText()
    
    -- Sử dụng embed
    local embed = createEmbed(rewards, gameInfo)
    local payload = game:GetService("HttpService"):JSONEncode({
        embeds = {embed}
    })
    
    -- Gửi request
    local httpRequest = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or HttpPost
    if not httpRequest then
        warn("Không tìm thấy hàm gửi HTTP request tương thích.")
        return false
    end
    
    local success, response = pcall(function()
        return httpRequest({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)
    
    if success then
        print("Đã gửi phần thưởng và thông tin game qua webhook!")
        webhookSentLog[gameId] = true
        return true
    else
        warn("Gửi webhook thất bại:", response)
        return false
    end
end

-- Thiết lập vòng lặp kiểm tra game kết thúc và gửi webhook
local function setupWebhookMonitor()
    spawn(function()
        while wait(2) do
            if not autoSendWebhookEnabled then
                wait(1)
            else
                -- Chỉ kiểm tra nếu đang ở trong map
                if isPlayerInMap() then
                    local player = game:GetService("Players").LocalPlayer
                    local agentFolder = workspace:FindFirstChild("Agent") and workspace.Agent:FindFirstChild("Agent")
                    local rewardsShow = player:FindFirstChild("RewardsShow")
                    
                    -- Kiểm tra điều kiện kết thúc game
                    if agentFolder and #agentFolder:GetChildren() == 0 and rewardsShow then
                        local rewards = getRewards()
                        if #rewards > 0 then
                            sendWebhook(rewards)
                            -- Đợi một thời gian để không gửi lặp lại
                            wait(10)
                        end
                    end
                end
            end
        end
    end)
end

-- Thêm section Webhook trong tab Webhook
local WebhookSection = WebhookTab:AddSection("Discord Webhook")

-- Thêm input để nhập URL webhook
WebhookSection:AddInput("WebhookURLInput", {
    Title = "Webhook URL",
    Default = webhookURL,
    Placeholder = "Nhập URL webhook Discord của bạn",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        webhookURL = Value
        ConfigSystem.CurrentConfig.WebhookURL = Value
        ConfigSystem.SaveConfig()
        
        print("Đã cập nhật URL webhook")
    end
})

-- Toggle Auto SendWebhook
WebhookSection:AddToggle("AutoSendWebhookToggle", {
    Title = "Auto Send Webhook",
    Default = autoSendWebhookEnabled,
    Callback = function(Value)
        if Value then
            -- Kiểm tra URL webhook
            if webhookURL == "" then
                print("URL webhook trống! Vui lòng nhập URL webhook trước khi bật tính năng này.")
                -- Trả về toggle về trạng thái tắt
                WebhookSection:GetComponent("AutoSendWebhookToggle"):Set(false)
                return
            end
            
            -- Loại bỏ kiểm tra đang ở trong map không, cho phép bật ở lobby
            autoSendWebhookEnabled = true
            ConfigSystem.CurrentConfig.AutoSendWebhook = true
            ConfigSystem.SaveConfig()
            
            print("Auto Send Webhook đã được bật. Thông tin trận đấu sẽ tự động gửi khi game kết thúc.")
        else
            autoSendWebhookEnabled = false
            ConfigSystem.CurrentConfig.AutoSendWebhook = false
            ConfigSystem.SaveConfig()
            
            print("Auto Send Webhook đã được tắt")
        end
    end
})

-- Nút Test Webhook
WebhookSection:AddButton({
    Title = "Test Webhook",
    Callback = function()
        -- Kiểm tra URL webhook
        if webhookURL == "" then
            print("URL webhook trống! Vui lòng nhập URL webhook trước khi test.")
            return
        end
        
        -- Tạo dữ liệu test
        local testRewards = {
            {Name = "Gem", Amount = 100},
            {Name = "Gold", Amount = 1000},
            {Name = "EXP", Amount = 500}
        }
        
        -- Gửi webhook test
        local success = sendWebhook(testRewards)
        
        if success then
            print("Đã gửi webhook test thành công!")
        else
            print("Gửi webhook test thất bại! Kiểm tra lại URL và quyền truy cập.")
        end
    end
})

-- Khởi động vòng lặp kiểm tra game kết thúc
setupWebhookMonitor()

-- Thêm section Egg Event trong tab Shop
local EggEventSection = ShopTab:AddSection("Egg Event")

-- Biến lưu trạng thái Auto Buy Egg
local autoBuyEggEnabled = ConfigSystem.CurrentConfig.AutoBuyEgg or false
local autoBuyEggLoop = nil

-- Biến lưu trạng thái Auto Open Egg
local autoOpenEggEnabled = ConfigSystem.CurrentConfig.AutoOpenEgg or false
local autoOpenEggLoop = nil

-- Toggle Auto Buy Egg
EggEventSection:AddToggle("AutoBuyEggToggle", {
    Title = "Auto Buy Egg",
    Default = autoBuyEggEnabled,
    Callback = function(Value)
        autoBuyEggEnabled = Value
        ConfigSystem.CurrentConfig.AutoBuyEgg = Value
        ConfigSystem.SaveConfig()
        if Value then
            print("Auto Buy Egg đã được bật")
            if autoBuyEggLoop then
                autoBuyEggLoop:Disconnect()
                autoBuyEggLoop = nil
            end
            spawn(function()
                while autoBuyEggEnabled do
                    local args = {"Egg Capsule", 1}
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Gameplay"):WaitForChild("EasterEgg"):FireServer(unpack(args))
                    end)
                    if not success then
                        warn("Lỗi khi Auto Buy Egg: " .. tostring(err))
                    end
                    wait(0.5)
                end
            end)
        else
            print("Auto Buy Egg đã được tắt")
            if autoBuyEggLoop then
                autoBuyEggLoop:Disconnect()
                autoBuyEggLoop = nil
            end
        end
    end
})

-- Toggle Auto Open Egg
EggEventSection:AddToggle("AutoOpenEggToggle", {
    Title = "Auto Open Egg",
    Default = autoOpenEggEnabled,
    Callback = function(Value)
        autoOpenEggEnabled = Value
        ConfigSystem.CurrentConfig.AutoOpenEgg = Value
        ConfigSystem.SaveConfig()
        if Value then
            print("Auto Open Egg đã được bật")
            if autoOpenEggLoop then
                autoOpenEggLoop:Disconnect()
                autoOpenEggLoop = nil
            end
            spawn(function()
                while autoOpenEggEnabled do
                    local playerName = game:GetService("Players").LocalPlayer.Name
                    local eggItem = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild(playerName):WaitForChild("Items"):FindFirstChild("Egg Capsule")
                    if eggItem then
                        local args = {eggItem, {SummonAmount = 1}}
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Lobby"):WaitForChild("ItemUse"):FireServer(unpack(args))
                        end)
                        if not success then
                            warn("Lỗi khi Auto Open Egg: " .. tostring(err))
                        end
                    else
                        warn("Không tìm thấy Egg Capsule trong Items!")
                    end
                    wait(0.5)
                end
            end)
        else
            print("Auto Open Egg đã được tắt")
            if autoOpenEggLoop then
                autoOpenEggLoop:Disconnect()
                autoOpenEggLoop = nil
            end
        end
    end
})

-- Toggle Auto Join All (Ranger)
local autoJoinAllRangerEnabled = ConfigSystem.CurrentConfig.AutoJoinAllRanger or false
local autoJoinAllRangerLoop = nil

RangerSection:AddToggle("AutoJoinAllRangerToggle", {
    Title = "Auto Join All",
    Default = autoJoinAllRangerEnabled,
    Callback = function(Value)
        autoJoinAllRangerEnabled = Value
        ConfigSystem.CurrentConfig.AutoJoinAllRanger = Value
        ConfigSystem.SaveConfig()
        if Value then
            print("Auto Join All Ranger đã được bật")
            if autoJoinAllRangerLoop then
                autoJoinAllRangerLoop:Disconnect()
                autoJoinAllRangerLoop = nil
            end
            spawn(function()
                local allMaps = {"OnePiece", "Namek", "DemonSlayer", "Naruto", "OPM"}
                local allActs = {"RangerStage1", "RangerStage2", "RangerStage3"}
                while autoJoinAllRangerEnabled do
                    for _, map in ipairs(allMaps) do
                        for _, act in ipairs(allActs) do
                            if not autoJoinAllRangerEnabled then return end
                            if not isPlayerInMap() then
                                -- Đổi map và act không cần thiết nữa vì joinRangerStage đã xử lý
                                -- local displayMap = reverseMapNameMapping[map] or map
                                -- changeWorld(displayMap)
                                -- wait(0.5)
                                -- changeAct(map, act)
                                -- wait(0.5)
                                
                                -- Join Ranger Stage với map và act cụ thể
                                joinRangerStage(map, act) -- << Truyền map và act vào đây
                                
                                print("Đã yêu cầu join: " .. map .. " - " .. act)
                                
                                -- Đợi cho đến khi vào map hoặc hết delay
                                local t = 0
                                while not isPlayerInMap() and t < 10 and autoJoinAllRangerEnabled do wait(0.5) t = t + 0.5 end
                                
                                -- Đợi delay giữa các lần join (nếu còn bật)
                                if autoJoinAllRangerEnabled then wait(rangerTimeDelay) end
                            else
                                -- Nếu đang ở trong map thì đợi ra khỏi map
                                while isPlayerInMap() and autoJoinAllRangerEnabled do wait(0.5) end
                            end
                            -- Thêm delay nhỏ để tránh spam quá nhanh nếu lỗi join
                            if not isPlayerInMap() and autoJoinAllRangerEnabled then wait(0.5) end 
                        end
                    end
                    -- Lặp lại từ đầu sau khi hết các map/act
                    print("Đã hoàn thành vòng lặp Auto Join All, bắt đầu lại...")
                    wait(0.5)
                end
            end)
        else
            print("Auto Join All Ranger đã được tắt")
            if autoJoinAllRangerLoop then
                autoJoinAllRangerLoop:Disconnect()
                autoJoinAllRangerLoop = nil
            end
        end
    end
})

-- Thêm section FPS Boost vào tab Settings
local FPSBoostSection = SettingsTab:AddSection("FPS Boost")

-- Biến lưu trạng thái Delete Map
local deleteMapEnabled = ConfigSystem.CurrentConfig.DeleteMap or false
local deleteMapActive = false

-- Hàm để xóa map
local function deleteMap()
    -- Kiểm tra nếu đang ở trong map
    if not isPlayerInMap() then
        print("Bạn phải ở trong map để sử dụng tính năng này")
        return false
    end
    
    -- Đã xóa map và đang chờ vòng xóa tiếp theo
    if deleteMapActive then
        return true
    end
    
    local success, err = pcall(function()
        deleteMapActive = true
        
        -- Tìm workspace.Building
        local building = workspace:FindFirstChild("Building")
        if not building then
            warn("Không tìm thấy Building trong workspace")
            return
        end
        
        -- Hàm để giữ lại các object đặc biệt
        local function preserveSpecialObjects(parent)
            local map = parent:FindFirstChild("Map")
            if map then
                local objectsToPreserve = {}
                for _, child in pairs(map:GetDescendants()) do
                    if child.Name == "Baseplate" or child.Name == "Part" then
                        table.insert(objectsToPreserve, child)
                        -- Di chuyển đến nơi an toàn
                        child.Parent = game:GetService("ReplicatedStorage")
                    end
                end
                return objectsToPreserve
            end
            return {}
        end
        
        -- Hàm để khôi phục các object đã giữ lại
        local function restoreObjects(preservedObjects)
            local map = building:FindFirstChild("Map")
            if not map then
                map = Instance.new("Folder")
                map.Name = "Map"
                map.Parent = building
            end
            
            for _, obj in pairs(preservedObjects) do
                obj.Parent = map
            end
        end
        
        -- Bước 1: Tìm và tạm thời di chuyển các object đặc biệt
        local preservedObjects = preserveSpecialObjects(building)
        
        -- Bước 2: Xóa tất cả trong Building
        for _, child in pairs(building:GetChildren()) do
            child:Destroy()
        end
        
        -- Bước 3: Tạo lại Map folder và khôi phục các object đã giữ lại
        local map = Instance.new("Folder")
        map.Name = "Map"
        map.Parent = building
        
        restoreObjects(preservedObjects)
        
        -- Xóa tất cả trong Lighting
        local lighting = game:GetService("Lighting")
        for _, child in pairs(lighting:GetChildren()) do
            child:Destroy()
        end
        
        print("Đã xóa map để tăng FPS")
        
        -- Đặt lại trạng thái sau 5 giây
        spawn(function()
            wait(5)
            deleteMapActive = false
        end)
    end)
    
    if not success then
        warn("Lỗi khi xóa map: " .. tostring(err))
        deleteMapActive = false
        return false
    end
    
    return true
end

-- Toggle Delete Map
FPSBoostSection:AddToggle("DeleteMapToggle", {
    Title = "Delete Map",
    Default = deleteMapEnabled,
    Callback = function(Value)
        deleteMapEnabled = Value
        ConfigSystem.CurrentConfig.DeleteMap = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Kiểm tra ngay nếu đang trong map
            if isPlayerInMap() then
                deleteMap()
                print("Delete Map đã được bật - Map đã được xóa để tăng FPS")
                
                -- Thêm một event handler để xóa map mỗi khi vào map mới
                if not game:GetService("Players").LocalPlayer.CharacterAdded:IsA("RBXScriptConnection") then
                    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
                        -- Chờ một chút để map load xong
                        wait(2)
                        if deleteMapEnabled and isPlayerInMap() and not deleteMapActive then
                            deleteMap()
                        end
                    end)
                end
            else
                print("Delete Map đã được bật - Map sẽ bị xóa khi bạn vào map")
                
                -- Thêm một event handler để xóa map khi vào map
                if not game:GetService("Players").LocalPlayer.CharacterAdded:IsA("RBXScriptConnection") then
                    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
                        -- Chờ một chút để map load xong
                        wait(2)
                        if deleteMapEnabled and isPlayerInMap() and not deleteMapActive then
                            deleteMap()
                        end
                    end)
                end
            end
        else
            print("Delete Map đã được tắt")
        end
    end
})

-- Biến lưu trạng thái Boost FPS
local boostFPSEnabled = ConfigSystem.CurrentConfig.BoostFPS or false
local boostFPSActive = false
local fpsBoostScriptLoaded = false

-- Toggle Boost FPS
FPSBoostSection:AddToggle("BoostFPSToggle", {
    Title = "Boost FPS",
    Default = boostFPSEnabled,
    Callback = function(Value)
        boostFPSEnabled = Value
        ConfigSystem.CurrentConfig.BoostFPS = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            -- Kiểm tra ngay nếu đang trong map
            if isPlayerInMap() then
                -- Thực hiện Boost FPS một lần duy nhất nếu chưa load
                if not fpsBoostScriptLoaded then
                    local success, err = pcall(function()
                        boostFPSActive = true
                        
                        -- Thiết lập cấu hình FPS Boost
                        _G.Settings = {
                            Players = {
                                ["Ignore Me"] = true, -- Ignore your Character
                                ["Ignore Others"] = true -- Ignore other Characters
                            },
                            Meshes = {
                                Destroy = false, -- Destroy Meshes
                                LowDetail = true -- Low detail meshes (NOT SURE IT DOES ANYTHING)
                            },
                            Images = {
                                Invisible = true, -- Invisible Images
                                LowDetail = false, -- Low detail images (NOT SURE IT DOES ANYTHING)
                                Destroy = false, -- Destroy Images
                            },
                            ["No Particles"] = true, -- Disables all ParticleEmitter, Trail, Smoke, Fire and Sparkles
                            ["No Camera Effects"] = true, -- Disables all PostEffect's (Camera/Lighting Effects)
                            ["No Explosions"] = true, -- Makes Explosion's invisible
                            ["No Clothes"] = true, -- Removes Clothing from the game
                            ["Low Water Graphics"] = true, -- Removes Water Quality
                            ["No Shadows"] = true, -- Remove Shadows
                            ["Low Rendering"] = true, -- Lower Rendering
                            ["Low Quality Parts"] = true -- Lower quality parts
                        }
                        
                        -- Load FPS Boost script
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiet010402/FPS-BOOST/refs/heads/main/FPSBOOTS.lua"))()
                        
                        fpsBoostScriptLoaded = true
                        print("FPS Boost đã được kích hoạt thành công!")
                    end)
                    
                    if not success then
                        warn("Lỗi khi Boost FPS: " .. tostring(err))
                        boostFPSActive = false
                        fpsBoostScriptLoaded = false
                    end
                else
                    print("FPS Boost đã được kích hoạt trước đó, không cần kích hoạt lại")
                end
                
                print("Boost FPS đã được bật - Đã tối ưu hóa FPS")
            else
                print("Boost FPS đã được bật - Sẽ tối ưu hóa FPS khi vào map")
                
                -- Thêm một event handler để Boost FPS khi vào map
                if not game:GetService("Players").LocalPlayer.CharacterAdded:IsA("RBXScriptConnection") then
                    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
                        -- Chờ một chút để map load xong
                        wait(2)
                        if boostFPSEnabled and isPlayerInMap() and not fpsBoostScriptLoaded then
                            -- Thiết lập cấu hình FPS Boost
                            _G.Settings = {
                                Players = {
                                    ["Ignore Me"] = true,
                                    ["Ignore Others"] = true
                                },
                                Meshes = {
                                    Destroy = false,
                                    LowDetail = true
                                },
                                Images = {
                                    Invisible = true,
                                    LowDetail = false,
                                    Destroy = false,
                                },
                                ["No Particles"] = true,
                                ["No Camera Effects"] = true,
                                ["No Explosions"] = true,
                                ["No Clothes"] = true,
                                ["Low Water Graphics"] = true,
                                ["No Shadows"] = true,
                                ["Low Rendering"] = true,
                                ["Low Quality Parts"] = true
                            }
                            
                            -- Load FPS Boost script
                            pcall(function()
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiet010402/FPS-BOOST/refs/heads/main/FPSBOOTS.lua"))()
                                fpsBoostScriptLoaded = true
                                print("FPS Boost đã được kích hoạt thành công khi vào map!")
                            end)
                        end
                    end)
                end
            end
        else
            print("Boost FPS đã được tắt (Lưu ý: Thay đổi đã áp dụng vẫn sẽ có hiệu lực, cần reload game để khôi phục)")
        end
    end
})


-- Thêm section Stats Potential trong tab Unit
local StatsPotentialSection = UnitTab:AddSection("Stats Potential")

-- Biến lưu trạng thái Stats Potential
local availableUnits = {}
local selectedUnit = nil
local selectedUnitTag = nil
local selectedDamageValues = {}
local selectedHealthValues = {}
local selectedSpeedValues = {}
local selectedRangeValues = {}
local selectedCooldownValues = {}
local autoRollStatsEnabled = ConfigSystem.CurrentConfig.AutoRollStats or false
local autoRollStatsLoop = nil

-- Hàm để quét và lấy danh sách units từ Collection
local function scanAvailableUnits()
    local success, result = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerName = player.Name
        local playerData = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data")
        local playerCollection = playerData:FindFirstChild(playerName) and playerData[playerName]:FindFirstChild("Collection")
        
        if not playerCollection then
            return {}
        end
        
        -- Tạo bảng tạm để nhóm các unit theo tên và level
        local unitGroups = {}
        
        for _, unit in pairs(playerCollection:GetChildren()) do
            if unit:IsA("Folder") and unit:FindFirstChild("Tag") and unit:FindFirstChild("Level") then
                local unitName = unit.Name
                local unitLevel = unit.Level.Value
                local unitTag = unit.Tag.Value
                
                -- Tạo key để nhóm theo tên và level
                local groupKey = unitName .. "_" .. unitLevel
                
                -- Tạo nhóm nếu chưa tồn tại
                if not unitGroups[groupKey] then
                    unitGroups[groupKey] = {}
                end
                
                -- Thêm unit vào nhóm
                table.insert(unitGroups[groupKey], {
                    name = unitName,
                    level = unitLevel,
                    tag = unitTag,
                    ref = unit
                })
            end
        end
        
        -- Tạo danh sách kết quả với displayName đã được đánh số
        local units = {}
        
        for groupKey, groupUnits in pairs(unitGroups) do
            -- Nếu chỉ có 1 unit trong nhóm, không cần đánh số
            if #groupUnits == 1 then
                local unit = groupUnits[1]
                table.insert(units, {
                    name = unit.name,
                    displayName = unit.name .. " (Lv: " .. unit.level .. ")",
                    tag = unit.tag,
                    ref = unit.ref
                })
            else
                -- Nếu có nhiều unit trong nhóm, đánh số để phân biệt
                for i, unit in ipairs(groupUnits) do
                    table.insert(units, {
                        name = unit.name,
                        displayName = unit.name .. " (Lv: " .. unit.level .. " #" .. i .. ")",
                        tag = unit.tag,
                        ref = unit.ref
                    })
                end
            end
        end
        
        -- Sắp xếp theo tên
        table.sort(units, function(a, b)
            return a.name < b.name
        end)
        
        return units
    end)
    
    if success then
        return result
    else
        warn("Lỗi khi quét units: " .. tostring(result))
        return {}
    end
end

-- Hàm để lấy danh sách tên hiển thị của các unit
local function getUnitDisplayNames()
    local displayNames = {}
    for _, unit in ipairs(availableUnits) do
        table.insert(displayNames, unit.displayName)
    end
    return displayNames
end

-- Hàm để lấy thông tin chi tiết về unit đã chọn
local function getUnitDetailsByDisplayName(displayName)
    for _, unit in ipairs(availableUnits) do
        if unit.displayName == displayName then
            return unit
        end
    end
    return nil
end

-- Hàm để kiểm tra xem giá trị potential hiện tại có nằm trong danh sách mong muốn không
local function isPotentialValueInTargetList(currentValue, targetValues)
    -- Nếu không có giá trị nào được chọn, không cần roll
    if not targetValues or next(targetValues) == nil then
        return true
    end
    
    -- Kiểm tra xem giá trị hiện tại có nằm trong danh sách mong muốn không
    return targetValues[currentValue] == true
end

-- Hàm để roll stats potential
local function rollStatsPotential()
    if not selectedUnit or not selectedUnitTag then
        print("Không có unit nào được chọn để roll stats.")
        return
    end
    
    local unitRef = selectedUnit.ref
    if not unitRef then
        print("Không tìm thấy thông tin unit.")
        return
    end
    
    local stats = {
        { name = "Damage", potential = "DamagePotential", selected = selectedDamageValues },
        { name = "Health", potential = "HealthPotential", selected = selectedHealthValues },
        { name = "Speed", potential = "SpeedPotential", selected = selectedSpeedValues },
        { name = "Range", potential = "RangePotential", selected = selectedRangeValues },
        { name = "AttackCooldown", potential = "AttackCooldownPotential", selected = selectedCooldownValues }
    }
    
    local rollCount = 0
    
    for _, stat in ipairs(stats) do
        -- Kiểm tra xem có giá trị nào được chọn không
        if next(stat.selected) ~= nil then
            local potentialValue = unitRef:FindFirstChild(stat.potential) and unitRef[stat.potential].Value or ""
            
            -- Kiểm tra xem giá trị hiện tại có nằm trong danh sách mong muốn không
            if not isPotentialValueInTargetList(potentialValue, stat.selected) then
                -- Thực hiện roll cho stat này
                local statArgName = stat.name
                if statArgName == "AttackCooldown" then
                    statArgName = "AttackCooldown"
                end
                
                local args = {
                    statArgName,
                    selectedUnitTag,
                    "Selective"
                }
                
                local rerollRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Gambling"):WaitForChild("RerollPotential")
                rerollRemote:FireServer(unpack(args))
                
                print("Đã roll " .. stat.name .. " cho " .. selectedUnit.name .. " - Giá trị hiện tại: " .. potentialValue)
                rollCount = rollCount + 1
                wait(1) -- Đợi 1 giây giữa các lần roll
            else
                print(stat.name .. " đã đạt giá trị mong muốn: " .. potentialValue)
            end
        end
    end
    
    if rollCount == 0 then
        print("Không có stat nào cần roll cho " .. selectedUnit.name)
    else
        print("Đã roll " .. rollCount .. " stats cho " .. selectedUnit.name)
    end
end

-- Quét danh sách các unit có sẵn
availableUnits = scanAvailableUnits()

-- Dropdown để chọn Unit
local unitDropdown = StatsPotentialSection:AddDropdown("UnitDropdown", {
    Title = "Choose Unit",
    Values = getUnitDisplayNames(),
    Multi = false,
    Default = "",
    Callback = function(Value)
        local unit = getUnitDetailsByDisplayName(Value)
        if unit then
            selectedUnit = unit
            selectedUnitTag = unit.tag
            print("Đã chọn unit: " .. unit.name .. " (Tag: " .. unit.tag .. ")")
            
            -- Hiển thị thông tin chi tiết về potential hiện tại
            local unitRef = unit.ref
            if unitRef then
                local damageValue = unitRef:FindFirstChild("DamagePotential") and unitRef.DamagePotential.Value or "N/A"
                local healthValue = unitRef:FindFirstChild("HealthPotential") and unitRef.HealthPotential.Value or "N/A"
                local speedValue = unitRef:FindFirstChild("SpeedPotential") and unitRef.SpeedPotential.Value or "N/A"
                local rangeValue = unitRef:FindFirstChild("RangePotential") and unitRef.RangePotential.Value or "N/A"
                local cooldownValue = unitRef:FindFirstChild("AttackCooldownPotential") and unitRef.AttackCooldownPotential.Value or "N/A"
                
                print("Stats Potential hiện tại:")
                print("- Damage: " .. damageValue)
                print("- Health: " .. healthValue)
                print("- Speed: " .. speedValue)
                print("- Range: " .. rangeValue)
                print("- Cooldown: " .. cooldownValue)
            end
        else
            selectedUnit = nil
            selectedUnitTag = nil
            print("Không tìm thấy thông tin unit")
        end
    end
})

-- Nút Refresh Units
StatsPotentialSection:AddButton({
    Title = "Refresh Units List",
    Callback = function()
        print("Đang cập nhật danh sách units...")
        availableUnits = scanAvailableUnits()
        
        if #availableUnits > 0 then
            if unitDropdown and unitDropdown.SetValues then
                unitDropdown:SetValues(getUnitDisplayNames())
                print("Đã cập nhật danh sách với " .. #availableUnits .. " units")
            end
        else
            print("Không tìm thấy unit nào trong Collection")
        end
    end
})

-- Định nghĩa các giá trị potential
local potentialValues = {"S", "S-", "S+", "SS", "SSS", "O", "O-", "O+"}

-- Dropdown để chọn giá trị Damage Potential
StatsPotentialSection:AddDropdown("DamageDropdown", {
    Title = "Damage",
    Values = potentialValues,
    Multi = true,
    Default = {},
    Callback = function(Values)
        selectedDamageValues = Values
        ConfigSystem.CurrentConfig.SelectedDamageValues = Values
        ConfigSystem.SaveConfig()
        
        local selectedText = ""
        for value, isSelected in pairs(Values) do
            if isSelected then
                selectedText = selectedText .. value .. ", "
            end
        end
        
        if selectedText ~= "" then
            selectedText = selectedText:sub(1, -3) -- Xóa dấu phẩy cuối cùng
            print("Mục tiêu Damage: " .. selectedText)
        else
            print("Không có mục tiêu Damage nào được chọn")
        end
    end
})

-- Dropdown để chọn giá trị Health Potential
StatsPotentialSection:AddDropdown("HealthDropdown", {
    Title = "Health",
    Values = potentialValues,
    Multi = true,
    Default = {},
    Callback = function(Values)
        selectedHealthValues = Values
        ConfigSystem.CurrentConfig.SelectedHealthValues = Values
        ConfigSystem.SaveConfig()
        
        local selectedText = ""
        for value, isSelected in pairs(Values) do
            if isSelected then
                selectedText = selectedText .. value .. ", "
            end
        end
        
        if selectedText ~= "" then
            selectedText = selectedText:sub(1, -3)
            print("Mục tiêu Health: " .. selectedText)
        else
            print("Không có mục tiêu Health nào được chọn")
        end
    end
})

-- Dropdown để chọn giá trị Speed Potential
StatsPotentialSection:AddDropdown("SpeedDropdown", {
    Title = "Speed",
    Values = potentialValues,
    Multi = true,
    Default = {},
    Callback = function(Values)
        selectedSpeedValues = Values
        ConfigSystem.CurrentConfig.SelectedSpeedValues = Values
        ConfigSystem.SaveConfig()
        
        local selectedText = ""
        for value, isSelected in pairs(Values) do
            if isSelected then
                selectedText = selectedText .. value .. ", "
            end
        end
        
        if selectedText ~= "" then
            selectedText = selectedText:sub(1, -3)
            print("Mục tiêu Speed: " .. selectedText)
        else
            print("Không có mục tiêu Speed nào được chọn")
        end
    end
})

-- Dropdown để chọn giá trị Range Potential
StatsPotentialSection:AddDropdown("RangeDropdown", {
    Title = "Range",
    Values = potentialValues,
    Multi = true,
    Default = {},
    Callback = function(Values)
        selectedRangeValues = Values
        ConfigSystem.CurrentConfig.SelectedRangeValues = Values
        ConfigSystem.SaveConfig()
        
        local selectedText = ""
        for value, isSelected in pairs(Values) do
            if isSelected then
                selectedText = selectedText .. value .. ", "
            end
        end
        
        if selectedText ~= "" then
            selectedText = selectedText:sub(1, -3)
            print("Mục tiêu Range: " .. selectedText)
        else
            print("Không có mục tiêu Range nào được chọn")
        end
    end
})

-- Dropdown để chọn giá trị Cooldown Potential
StatsPotentialSection:AddDropdown("CooldownDropdown", {
    Title = "Cooldown",
    Values = potentialValues,
    Multi = true,
    Default = {},
    Callback = function(Values)
        selectedCooldownValues = Values
        ConfigSystem.CurrentConfig.SelectedCooldownValues = Values
        ConfigSystem.SaveConfig()
        
        local selectedText = ""
        for value, isSelected in pairs(Values) do
            if isSelected then
                selectedText = selectedText .. value .. ", "
            end
        end
        
        if selectedText ~= "" then
            selectedText = selectedText:sub(1, -3)
            print("Mục tiêu Cooldown: " .. selectedText)
        else
            print("Không có mục tiêu Cooldown nào được chọn")
        end
    end
})

-- Toggle Roll Stats Potential
StatsPotentialSection:AddToggle("RollStatsPotentialToggle", {
    Title = "Roll Stats Potential",
    Default = autoRollStatsEnabled,
    Callback = function(Value)
        autoRollStatsEnabled = Value
        ConfigSystem.CurrentConfig.AutoRollStats = Value
        ConfigSystem.SaveConfig()
        
        if Value then
            if not selectedUnit then
                print("Vui lòng chọn unit trước khi bật Roll Stats Potential")
                -- Trả về toggle về trạng thái tắt
                StatsPotentialSection:GetComponent("RollStatsPotentialToggle"):Set(false)
                return
            end
            
            print("Roll Stats Potential đã được bật cho unit: " .. selectedUnit.name)
            
            -- Thực hiện roll ngay lập tức
            rollStatsPotential()
            
            -- Tạo vòng lặp để kiểm tra và roll nếu cần
            if autoRollStatsLoop then
                autoRollStatsLoop:Disconnect()
                autoRollStatsLoop = nil
            end
            
            spawn(function()
                while autoRollStatsEnabled and wait(0.5) do
                    if selectedUnit then
                        -- Quét lại thông tin unit để lấy potential hiện tại
                        local currentUnits = scanAvailableUnits()
                        local updatedUnit = nil
                        
                        -- Tìm unit có cùng tag với unit đang chọn
                        for _, unit in ipairs(currentUnits) do
                            if unit.tag == selectedUnitTag then
                                updatedUnit = unit
                                break
                            end
                        end
                        
                        -- Cập nhật unit nếu tìm thấy
                        if updatedUnit then
                            selectedUnit = updatedUnit
                            
                            -- Hiển thị thông tin chi tiết về potential hiện tại sau mỗi lần roll
                            local unitRef = selectedUnit.ref
                            if unitRef then
                                local damageValue = unitRef:FindFirstChild("DamagePotential") and unitRef.DamagePotential.Value or "N/A"
                                local healthValue = unitRef:FindFirstChild("HealthPotential") and unitRef.HealthPotential.Value or "N/A"
                                local speedValue = unitRef:FindFirstChild("SpeedPotential") and unitRef.SpeedPotential.Value or "N/A"
                                local rangeValue = unitRef:FindFirstChild("RangePotential") and unitRef.RangePotential.Value or "N/A"
                                local cooldownValue = unitRef:FindFirstChild("AttackCooldownPotential") and unitRef.AttackCooldownPotential.Value or "N/A"
                                
                                print("Stats Potential hiện tại của " .. selectedUnit.name .. ":")
                                print("- Damage: " .. damageValue)
                                print("- Health: " .. healthValue)
                                print("- Speed: " .. speedValue)
                                print("- Range: " .. rangeValue)
                                print("- Cooldown: " .. cooldownValue)
                            end
                        end
                        
                        rollStatsPotential()
                    else
                        print("Không có unit nào được chọn để roll stats")
                        autoRollStatsEnabled = false
                        StatsPotentialSection:GetComponent("RollStatsPotentialToggle"):Set(false)
                        break
                    end
                end
            end)
        else
            print("Roll Stats Potential đã được tắt")
            
            if autoRollStatsLoop then
                autoRollStatsLoop:Disconnect()
                autoRollStatsLoop = nil
            end
        end
    end
})

-- Thêm section Trait Reroll trong tab Unit
local TraitRerollSection = UnitTab:AddSection("Trait Reroll")

-- Hàm lấy danh sách unit và PrimaryTrait
local function getUnitListWithTraits()
    local player = game:GetService("Players").LocalPlayer
    local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
    local collectionFolder = playerData and playerData:FindFirstChild(player.Name) and playerData[player.Name]:FindFirstChild("Collection")

    if not collectionFolder then
        warn("Không tìm thấy thư mục Collection của người chơi!")
        return {}
    end

    local unitList = {}
    local unitCountMap = {}

    -- Lặp qua các unit trong Collection
    for _, unit in pairs(collectionFolder:GetChildren()) do
        if unit:IsA("Folder") or unit:IsA("Model") then
            local unitName = unit.Name
            local primaryTrait = unit:FindFirstChild("PrimaryTrait") and unit.PrimaryTrait.Value or "None"

            -- Đếm số lượng unit trùng tên
            unitCountMap[unitName] = (unitCountMap[unitName] or 0) + 1
            local displayName = unitName .. " (Trait: " .. primaryTrait .. ")"

            -- Nếu có trùng tên, thêm số thứ tự
            if unitCountMap[unitName] > 1 then
                displayName = displayName .. " #" .. unitCountMap[unitName]
            end

            table.insert(unitList, displayName)
        end
    end

    table.sort(unitList) -- Sắp xếp danh sách theo thứ tự bảng chữ cái
    return unitList
end

-- Biến lưu unit được chọn từ dropdown
local selectedUnitForReroll = nil

-- Dropdown hiển thị danh sách unit và PrimaryTrait
TraitRerollSection:AddDropdown("UnitDropdownWithTraits", {
    Title = "Choose Unit (with Traits)",
    Values = getUnitListWithTraits(),
    Multi = false,
    Default = "",
    Callback = function(selectedUnit)
        selectedUnitForReroll = selectedUnit
        print("Đã chọn unit:", selectedUnit)
    end
})

-- Danh sách các trait hiện tại
local availableTraits = {
    "Brute",
    "Sniper",
    "Colossal",
    "Investor",
    "Jokester",
    "Blitz",
    "Juggernaut",
    "Millionaire",
    "Violent",
    "Seraph",
    "Capitalist",
    "Duplicator",
    "Sovereign"
}

-- Biến lưu các trait được chọn
local selectedTraits = {}

-- Dropdown cho phép chọn nhiều trait
TraitRerollSection:AddDropdown("TraitSelectionDropdown", {
    Title = "Select Traits",
    Values = availableTraits,
    Multi = true, -- Cho phép chọn nhiều
    Default = {}, -- Không chọn gì mặc định
    Callback = function(selectedValues)
        selectedTraits = {} -- Reset danh sách trước khi cập nhật
        for trait, isSelected in pairs(selectedValues) do
            if isSelected then
                table.insert(selectedTraits, trait)
            end
        end

        if #selectedTraits > 0 then
            print("Các trait đã chọn (" .. #selectedTraits .. "): " .. table.concat(selectedTraits, ", "))
        else
            print("Không có trait nào được chọn.")
        end
    end
})

-- Hàm thực hiện reroll bằng Shards
local function rerollTraitWithShards()
    if not selectedUnitForReroll then
        warn("Vui lòng chọn unit trước khi thực hiện reroll bằng Shards.")
        return false
    end

    local unitName = selectedUnitForReroll:match("^(.-) %(") -- Lấy tên unit từ chuỗi
    if not unitName then
        warn("Không thể lấy tên unit từ lựa chọn.")
        return false
    end

    local player = game:GetService("Players").LocalPlayer
    local unit = game:GetService("ReplicatedStorage").Player_Data:FindFirstChild(player.Name).Collection:FindFirstChild(unitName)
    if not unit then
        warn("Không tìm thấy unit trong Collection.")
        return false
    end

    local currentTrait = unit:FindFirstChild("PrimaryTrait") and unit.PrimaryTrait.Value or "None"
    if table.find(selectedTraits, currentTrait) then
        print("Unit đã đạt trait mong muốn:", currentTrait)
        return true -- Dừng reroll nếu đạt trait mong muốn
    end

    local args = {
        [1] = unit,
        [2] = "Reroll",
        [3] = "Main",
        [4] = "Shards"
    }

    game:GetService("ReplicatedStorage").Remote.Server.Gambling.RerollTrait:FireServer(unpack(args))
    print("Đã reroll trait cho unit:", unitName, "bằng Shards. Trait hiện tại:", currentTrait)
    return false -- Tiếp tục reroll nếu chưa đạt trait mong muốn
end

-- Toggle Auto Reroll Trait với Shards
TraitRerollSection:AddToggle("AutoRerollShardsToggle", {
    Title = "Auto Reroll with Shards",
    Default = false,
    Callback = function(enabled)
        autoRerollShardsEnabled = enabled -- Sử dụng biến toàn cục
        if enabled then
            print("Auto Reroll with Shards đã được bật.")
            spawn(function()
                while autoRerollShardsEnabled do
                    local success = rerollTraitWithShards()
                    if success or not autoRerollShardsEnabled then
                        print("Đã đạt trait mong muốn hoặc Auto Reroll đã bị tắt. Dừng Auto Reroll.")
                        break -- Thoát vòng lặp nếu đạt trait mong muốn hoặc người chơi tắt
                    end
                    wait(1) -- Thời gian chờ giữa các lần reroll
                end
            end)
        else
            print("Auto Reroll with Shards đã được tắt.")
        end
    end
})
