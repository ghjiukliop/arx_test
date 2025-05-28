
-- Hàm để tham gia Cid Event
local function joinCidEvent()
    local success, err = pcall(function()
        local level = game:GetService("ReplicatedStorage").Values.Game.Level
        if level and level.Value == "Cid_Event" then
            print("Không tham gia sự kiện Cid Event vì Level hiện tại đã là Cid_Event")
            return false
        end

        if isPlayerInMap() then
            print("Đang ở trong map, không thể tham gia Cid Event")
            return false
        end

        local args = { "Boss-Event" }
        game:GetService("ReplicatedStorage").Remote.Server.PlayRoom.Event:FireServer(unpack(args))
        print("Tham gia sự kiện Cid Event thành công!")
        return true
    end)

    if not success then
        warn("Lỗi khi tham gia Cid Event: " .. tostring(err))
        return false
    end

    return success
end

-- Kiểm tra PlayTab trước khi thêm section Cid Event
if PlayTab then
    local CidEventSection = PlayTab:AddSection("Cid Event")

    -- Toggle Auto Join Cid Event
    CidEventSection:AddToggle("AutoJoinCidEventToggle", {
        Title = "Auto Join Cid Event",
        Default = ConfigSystem.CurrentConfig.AutoJoinCidEvent or false,
        Callback = function(Value)
            autoJoinCidEventEnabled = Value
            ConfigSystem.CurrentConfig.AutoJoinCidEvent = Value
            ConfigSystem.SaveConfig()

            if Value then
                print("Auto Join Cid Event đã được bật")

                if isPlayerInMap() then
                    print("Đang ở trong map, Auto Join Cid Event sẽ hoạt động khi bạn rời khỏi map")
                else
                    print("Auto Join Cid Event sẽ bắt đầu sau " .. cidEventTimer .. " giây")
                    spawn(function()
                        wait(cidEventTimer)
                        if autoJoinCidEventEnabled and not isPlayerInMap() then
                            joinCidEvent()
                        end
                    end)
                end

                autoJoinCidEventLoop = spawn(function()
                    while autoJoinCidEventEnabled do
                        if not isPlayerInMap() then
                            print("Đợi " .. cidEventTimer .. " giây trước khi tham gia Cid Event")
                            wait(cidEventTimer)
                            if autoJoinCidEventEnabled and not isPlayerInMap() then
                                joinCidEvent()
                            end
                        else
                            print("Đang ở trong map, đợi đến khi rời khỏi map để tham gia Cid Event")
                        end
                        wait(10)
                    end
                end)
            else
                print("Auto Join Cid Event đã được tắt")
                if autoJoinCidEventLoop then
                    task.cancel(autoJoinCidEventLoop)
                    autoJoinCidEventLoop = nil
                end
            end
        end
    })

    -- Ô nhập liệu cho thời gian chờ Cid Event
    CidEventSection:AddInput("CidEventTimerInput", {
        Title = "Cid Event Timer (giây)",
        Description = "Nhập thời gian chờ (1-99 giây)",
        Default = tostring(ConfigSystem.CurrentConfig.CidEventTimer or 10),
        Placeholder = "Nhập số từ 1-99",
        Numeric = true,
        Callback = function(Value)
            local numValue = tonumber(Value)
            if numValue and numValue >= 1 and numValue <= 99 then
                cidEventTimer = numValue
                ConfigSystem.CurrentConfig.CidEventTimer = numValue
                ConfigSystem.SaveConfig()
                print("Đã đặt timer cho Cid Event: " .. numValue .. " giây")
            else
                print("Giá trị không hợp lệ! Vui lòng nhập số từ 1 đến 99.")
                -- Đặt lại giá trị mặc định nếu nhập sai
                CidEventSection:GetComponent("CidEventTimerInput"):Set(tostring(ConfigSystem.CurrentConfig.CidEventTimer or 10))
            end
        end
    })
else
    warn("PlayTab không tồn tại! Không thể thêm section Cid Event.")
end
