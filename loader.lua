-- [[ KAMIAPA MAIN SCRIPT - COORDINATE & SPEED COIL ]]
if getgenv().__KAMI_APA_MAIN_RUNNING then return end [cite: 1]
getgenv().__KAMI_APA_MAIN_RUNNING = true [cite: 1]

task.wait(2) [cite: 1]
repeat task.wait() until game:IsLoaded() [cite: 1]

local Players = game:GetService("Players") [cite: 1]
local VirtualUser = game:GetService("VirtualUser") -- Pengganti VirtualInputManager agar tidak terdeteksi
local ProximityPromptService = game:GetService("ProximityPromptService") [cite: 1]
local player = Players.LocalPlayer [cite: 1]

-- [[ KOORDINAT TITIK AMAN BARU ]]
-- Diperbarui berdasarkan image_0d073d.png 
local HOME_POS = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) [cite: 1]
local RETURN_DISTANCE = 2 [cite: 1]

-- [[ FUNGSI DETEKSI TARGET ]]
local function isTarget(model) [cite: 1]
    if not getgenv().TARGET_LIST then return false end [cite: 1]
    local name = model:GetAttribute("Index") or model.Name [cite: 1]
    local billboard = model:FindFirstChildOfClass("BillboardGui") [cite: 1]
    local textLabel = billboard and billboard:FindFirstChildOfClass("TextLabel") [cite: 1]
    local screenName = textLabel and textLabel.Text or "" [cite: 2]

    for _, targetName in ipairs(getgenv().TARGET_LIST) do [cite: 2]
        if string.find(string.lower(name), string.lower(targetName)) or 
           string.find(string.lower(screenName), string.lower(targetName)) then [cite: 2]
            return true [cite: 2]
        end
    end
    return false [cite: 2]
end

-- [[ STAY AT HOME & RETURN ON HIT ]]
task.spawn(function() [cite: 2]
    local lastHealth = 100 [cite: 2]
    while true do [cite: 2]
        local char = player.Character [cite: 3]
        local hum = char and char:FindFirstChildOfClass("Humanoid") [cite: 3]
        local root = char and char:FindFirstChild("HumanoidRootPart") [cite: 3]

        if hum and root and hum.Health > 0 then [cite: 3]
            local targetPos = Vector3.new(HOME_POS.X, root.Position.Y, HOME_POS.Z) [cite: 3]
            if hum.Health < lastHealth then [cite: 3]
                root.CFrame = CFrame.new(targetPos) [cite: 4]
            end [cite: 4]
            if (root.Position - targetPos).Magnitude >= RETURN_DISTANCE then [cite: 4]
                hum:MoveTo(targetPos) [cite: 4]
            end [cite: 4]
            lastHealth = hum.Health [cite: 4]
        end
        task.wait(0.1) [cite: 4]
    end
end)

-- [[ AUTO PURCHASE ]]
ProximityPromptService.PromptShown:Connect(function(prompt) [cite: 4]
    local model = prompt:FindFirstAncestorOfClass("Model") [cite: 4]
    
    if model and isTarget(model) then [cite: 5]
        task.wait(0.15) [cite: 5]
        fireproximityprompt(prompt) [cite: 5]
    end
end)

-- [[ FITUR AUTO SPEED COIL ]]
task.spawn(function() [cite: 5]
    while true do [cite: 5]
        local char = player.Character [cite: 5]
        local backpack = player:FindFirstChildOfClass("Backpack") [cite: 5]
        
        if char and backpack then [cite: 5]
            local hum = char:FindFirstChildOfClass("Humanoid") [cite: 5]
            local holdingCoil = false [cite: 6]
            
            -- Cek apakah sudah pegang coil di tangan
            for _, tool in ipairs(char:GetChildren()) do [cite: 6]
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then [cite: 6]
                    holdingCoil = true [cite: 7]
                    break [cite: 7]
                end
            end

            -- Jika belum pegang, ambil dari tas
            if not holdingCoil then [cite: 7]
                for _, tool in ipairs(backpack:GetChildren()) do [cite: 8]
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then [cite: 8]
                        hum:EquipTool(tool) [cite: 8]
                        break [cite: 8]
                    end [cite: 9]
                end
            end
        end
        task.wait(5) -- Cek setiap 5 detik [cite: 9]
    end
end)

-- [[ ANTI-AFK (VERSI AMAN) ]]
task.spawn(function()
    -- Menggunakan event Idled untuk mendeteksi saat pemain diam
    player.Idled:Connect(function()
        -- Mensimulasikan klik mouse kecil di layar untuk me-reset timer AFK
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

print("KAMIAPA: Koordinat Fixed & Auto Speed Coil Aktif (Anti-Detection Ready!)") [cite: 10]
