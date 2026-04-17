-- [[ KAMIAPA MAIN SCRIPT - MINIMALIST VERSION ]]
repeat task.wait() until game:IsLoaded()

-- Simpan servis ke variabel lokal secara langsung
local p = game:GetService("Players").LocalPlayer
local vu = game:GetService("VirtualUser")
local pps = game:GetService("ProximityPromptService")

-- KOORDINAT (Diperbarui)
local HP = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) [cite: 1]
local RD = 2 [cite: 1]

-- ANTI-AFK (Metode paling dasar)
p.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new(0,0))
end)

-- STAY AT HOME
task.spawn(function()
    local lh = 100
    while task.wait(0.2) do
        local c = p.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 then
            local tp = Vector3.new(HP.X, r.Position.Y, HP.Z)
            if h.Health < lh then r.CFrame = CFrame.new(tp) end [cite: 3, 4]
            if (r.Position - tp).Magnitude >= RD then h:MoveTo(tp) end [cite: 4]
            lh = h.Health
        end
    end
end)

-- AUTO PURCHASE (Target detection disatukan agar tidak error nil)
pps.PromptShown:Connect(function(pr)
    local m = pr:FindFirstAncestorOfClass("Model")
    if m and getgenv().TARGET_LIST then [cite: 5]
        local found = false
        local n = string.lower(m:GetAttribute("Index") or m.Name)
        for _, t in ipairs(getgenv().TARGET_LIST) do
            if string.find(n, string.lower(t)) then found = true break end [cite: 2]
        end
        
        if found then
            task.wait(0.15)
            pr:InputHoldBegin()
            task.wait(pr.HoldDuration + 0.01)
            pr:InputHoldEnd()
        end
    end
end)

-- AUTO SPEED COIL
task.spawn(function()
    while task.wait(5) do
        local c = p.Character
        local b = p:FindFirstChildOfClass("Backpack")
        if c and b then
            local h = c:FindFirstChildOfClass("Humanoid")
            local coil = c:FindFirstChild("Speed Coil") or c:FindFirstChild("Coil")
            if not coil and h then
                for _, t in ipairs(b:GetChildren()) do
                    if t:IsA("Tool") and (string.find(string.lower(t.Name), "speed") or string.find(string.lower(t.Name), "coil")) then [cite: 8]
                        h:EquipTool(t) [cite: 8]
                        break
                    end
                end
            end
        end
    end
end)

print("KAMIAPA: Minimalist Version Active") [cite: 10]
