-- KAMIAPA BYPASS VERSION (FULL)
task.spawn(function() 
    repeat task.wait() until game:IsLoaded()
    local p = game:GetService("Players").LocalPlayer
    local vu = game:GetService("VirtualUser")
    local pps = game:GetService("ProximityPromptService")
    local HP = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) -- 
    local RD = 2
    local lh = 100

    -- ANTI-AFK SAFE METHOD (Menggantikan VirtualInputManager)
    p.Idled:Connect(function() 
        pcall(function() 
            vu:CaptureController() 
            vu:ClickButton2(Vector2.new(0,0)) 
        end) 
    end)

    -- STAY AT HOME & AUTO RETURN
    task.spawn(function() 
        while task.wait(0.2) do 
            pcall(function() 
                local c = p.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then 
                    local tp = Vector3.new(HP.X, r.Position.Y, HP.Z)
                    if h.Health < lh then r.CFrame = CFrame.new(tp) end -- Return on hit 
                    if (r.Position - tp).Magnitude >= RD then h:MoveTo(tp) end -- Keep at pos 
                    lh = h.Health 
                end 
            end) 
        end 
    end)

    -- AUTO PURCHASE (Metode Signal untuk cegah Nil Error)
    pps.PromptShown:Connect(function(pr) 
        pcall(function() 
            local m = pr:FindFirstAncestorOfClass("Model")
            local targets = getgenv().TARGET_LIST or {}
            if m then
                local n = string.lower(m:GetAttribute("Index") or m.Name)
                local isT = false
                for _, t in ipairs(targets) do 
                    if string.find(n, string.lower(t)) then isT = true break end 
                end
                if isT then 
                    task.wait(0.15) 
                    pr:InputHoldBegin() 
                    task.wait(pr.HoldDuration + 0.02) 
                    pr:InputHoldEnd() 
                end 
            end
        end) 
    end)

    -- AUTO SPEED COIL
    task.spawn(function() 
        while task.wait(5) do 
            pcall(function() 
                local c = p.Character
                local b = p:FindFirstChildOfClass("Backpack")
                if c and b then 
                    local h = c:FindFirstChildOfClass("Humanoid")
                    local coil = c:FindFirstChild("Speed Coil") or c:FindFirstChild("Coil")
                    if not coil and h then 
                        for _, t in ipairs(b:GetChildren()) do 
                            if t:IsA("Tool") and (string.find(string.lower(t.Name), "speed") or string.find(string.lower(t.Name), "coil")) then 
                                h:EquipTool(t) -- Equip otomatis 
                                break 
                            end 
                        end 
                    end 
                end 
            end) 
        end 
    end)

    print("KAMIAPA: Script Loaded - Anti-AFK & Anti-Nil Active")
end)
