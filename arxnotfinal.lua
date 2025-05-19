-- Priority tab
local PrioritySection = PriorityTab:AddSection("Priority Settings")

-- Biến lưu trạng thái Auto Join Priority
local autoJoinPriorityEnabled = ConfigSystem.CurrentConfig.AutoJoinPriority or false
local autoJoinPriorityLoop = nil

-- Danh sách các mode, đã thêm "Highest Story"
local availableModes = {"Highest Story", "Story", "Ranger Stage", "Boss Event", "Challenge", "Easter Egg", "None"}

-- Biến lưu thứ tự ưu tiên
local priorityOrder = {"None", "None", "None", "None", "None"}

-- Tạo 5 dropdown cho thứ tự ưu tiên
for i = 1, 5 do
    PrioritySection:AddDropdown("PriorityDropdown" .. i, {
        Title = "Priority Slot " .. i,
        Values = availableModes,
        Multi = false,
        Default = ConfigSystem.CurrentConfig["PrioritySlot" .. i] or "None",
        Callback = function(Value)
            priorityOrder[i] = Value
            ConfigSystem.CurrentConfig["PrioritySlot" .. i] = Value
            ConfigSystem.SaveConfig()

            print("Đã chọn Priority Slot " .. i .. ": " .. Value)
        end
    })
end

-- Hàm tìm Highest Story
local function findHighestStory()
    local player = game:GetService("Players").LocalPlayer
    local playerData = game:GetService("ReplicatedStorage"):FindFirstChild("Player_Data")
    local playerFolder = playerData and playerData:FindFirstChild(player.Name)
    local chapterLevels = playerFolder and playerFolder:FindFirstChild("ChapterLevels")

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

    return highestMap, highestChapter
end

-- Hàm Join Map
local function joinMap(map, chapter)
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Remote"):FindFirstChild("Server"):FindFirstChild("PlayRoom"):FindFirstChild("Event")

    if not Event then
        warn("Không tìm thấy Event để join map.")
        return false
    end

    Event:FireServer("Create")
    wait(0.5)

    Event:FireServer("Change-World", {["World"] = map})
    wait(0.5)

    Event:FireServer("Change-Chapter", {["Chapter"] = map .. "_" .. chapter})
    wait(0.5)

    Event:FireServer("Change-Difficulty", {["Difficulty"] = "Normal"})
    wait(0.5)

    Event:FireServer("Submit")
    wait(1)

    Event:FireServer("Start")
    print("Đã join map: " .. map .. " - " .. chapter)
    return true
end

-- Cập nhật hàm Auto Join Priority để xử lý "Highest Story"
local function autoJoinPriority()
    if not autoJoinPriorityEnabled or isPlayerInMap() then
        return
    end

    -- Duyệt qua thứ tự ưu tiên và bỏ qua "None"
    for _, mode in ipairs(priorityOrder) do
        if mode ~= "None" then
            local success = false

            if mode == "Highest Story" then
                local map, chapter = findHighestStory()
                if map and chapter then
                    print("Đang join Highest Story: " .. map .. " - " .. chapter)
                    success = joinMap(map, chapter)
                else
                    print("Không tìm thấy Highest Story để join.")
                end

            elseif mode == "Story" then
                success = joinMap("OnePiece", "Chapter1")  -- Thay bằng logic Story cụ thể

            elseif mode == "Ranger Stage" then
                success = joinRangerStage()

            elseif mode == "Boss Event" then
                success = joinBossEvent()

            elseif mode == "Challenge" then
                success = joinChallenge()

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
    wait(1)
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
                task.cancel(autoJoinPriorityLoop)
            end

            autoJoinPriorityLoop = task.spawn(function()
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

            if autoJoinPriorityLoop then
                task.cancel(autoJoinPriorityLoop)
            end
        end
    end
})

-- Tự động tải trạng thái Auto Join Priority và Priority List khi khởi động
spawn(function()
    wait(1)
    autoJoinPriorityEnabled = ConfigSystem.CurrentConfig.AutoJoinPriority or false
    priorityOrder = {
        ConfigSystem.CurrentConfig["PrioritySlot1"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot2"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot3"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot4"] or "None",
        ConfigSystem.CurrentConfig["PrioritySlot5"] or "None"
    }

    print("Đã tải trạng thái Auto Join Priority và Priority List từ cấu hình.")
end)
