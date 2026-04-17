-- KAMIAPA: ABSOLUTE ZERO VERSION
task.wait(0.5)

local function START_SCRIPT()
    -- Cek ketersediaan servis dasar secara aman
    local success, Players = pcall(game.GetService, game, "Players")
    if not success or not Players then return end
    
    local lp = Players.LocalPlayer
    local vu = game:GetService("VirtualUser")
    local pps = game:GetService("ProximityPromptService")

    -- KOORDINAT TETAP
    local HP = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375)
    local RD = 2

    -- STAY AT HOME & RETURN
    task.spawn(function()
        local lh = 100
        while task.wait(0.5) do
            pcall(function()
                local char = lp.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if hum and root and hum.Health > 0 then
                    local targetPos = Vector3.new(HP.X, root.Position.Y, HP.Z)
                    if hum.Health < lh then root.CFrame = CFrame.new(targetPos) end
                    if (root.Position - targetPos).Magnitude >= RD then hum:MoveTo(targetPos) end
                    lh = hum.Health
                end
            end)
        end
    end)

    -- AUTO PURCHASE (SIGNAL BASED)
    if pps then
        pps.PromptShown:Connect(function(prompt)
            pcall(function()
                local model = prompt:FindFirstAncestorOfClass("Model")
                local targets = getgenv and getgenv().TARGET_LIST or {}
                local name = string.lower(model.Name)
                
                local isTarget = false
                for _, t in ipairs(targets) do
                    if string.find(name, string.lower(t)) then isTarget = true break end
                end

                if isTarget then
                    task.wait(0.2)
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration + 0.02)
                    prompt:InputHoldEnd()
                end
            end)
        end)
    end

    -- ANTI-AFK
    lp.Idled:Connect(function()
        pcall(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new(0,0))
        end)
    end)

    print("KAMIAPA: Running on Safe Mode")
end

-- Jalankan dengan pcall agar tidak ada error merah di console
pcall(START_SCRIPT)
