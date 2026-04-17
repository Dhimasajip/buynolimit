-- [[ KAMIAPA MAIN SCRIPT - COORDINATE & SPEED COIL ]]
if getgenv().__KAMI_APA_MAIN_RUNNING then return end
getgenv().__KAMI_APA_MAIN_RUNNING = true

task.wait(2)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser") 
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer

-- [[ KOORDINAT TITIK AMAN ]]
local HOME_POS = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) [cite: 1]
local RETURN_DISTANCE = 2 [cite: 1]

-- [[ FUNGSI DETEKSI TARGET ]]
local function isTarget(model)
    if not getgenv().TARGET_LIST then return false end [cite: 1]
    local name = model:GetAttribute("Index") or model.Name [cite: 1]
    local billboard = model:FindFirstChildOfClass("BillboardGui") [cite: 1]
    local textLabel = billboard and billboard:FindFirstChildOfClass("TextLabel") [cite: 1]
    local screenName = textLabel and textLabel.Text or "" [cite: 2]

    for _, targetName in ipairs(getgenv().TARGET_LIST) do [cite: 2]
        if string.find(string.lower(name), string.lower(targetName)) or 
           string.find(string.lower(screenName), string.lower(targetName)) then [cite: 2]
            return true
        end
    end
    return false
end

-- [[ STAY AT HOME & RETURN ON HIT ]]
task.spawn(function()
    local lastHealth = 100 [cite: 2]
    while true do
        local char = player.Character [cite: 3]
        local hum = char and char:FindFirstChildOfClass("Humanoid") [cite: 3]
        local root = char and char:FindFirstChild("HumanoidRootPart") [cite: 3]

        if hum and root and hum.Health > 0 then [cite: 3]
            local targetPos = Vector3.new(HOME_POS.X, root.Position.Y, HOME_POS.Z) [cite: 3]
            if hum.Health < lastHealth then [cite: 3]
                root.CFrame = CFrame.new(targetPos) [cite: 3]
            end
            if (root.Position - targetPos).Magnitude >= RETURN_DISTANCE then [cite: 4]
                hum:MoveTo(targetPos) [cite: 4]
            end
            lastHealth = hum.Health [cite: 4]
        end
        task.wait(0.1) [cite: 4]
    end
end)

-- [[ AUTO PURCHASE - METODE UNIVERSAL ]]
ProximityPromptService.PromptShown:Connect(function(prompt)
    local model = prompt:FindFirstAncestorOfClass("Model") [cite: 4]
    
    if model and isTarget(model) then [cite: 5]
        task.wait(0.15) [cite: 5]
        
        -- Menggunakan pcall agar jika executor tidak support tidak akan error merah (nil)
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            else
                -- Cara manual Roblox: simulasi input tanpa fungsi executor khusus
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration + 0.05)
                prompt:InputHoldEnd()
            end
        end)
    end
end)

-- [[ FITUR AUTO SPEED COIL ]]
task.spawn(function()
    while true do
        local char = player.Character [cite: 5]
        local backpack = player:FindFirstChildOfClass("Backpack") [cite: 5]
        
        if char and backpack then [cite: 5]
            local hum = char:FindFirstChildOfClass("Humanoid") [cite: 6]
            local holdingCoil = false [cite: 6]
            
            for _, tool in ipairs(char:GetChildren()) do [cite: 6]
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then [cite: 6]
                    holdingCoil = true [cite: 7]
                    break
                end
            end

            if not holdingCoil then [cite: 7]
                for _, tool in ipairs(backpack:GetChildren()) do [cite: 8]
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then [cite: 8]
                        hum:EquipTool(tool) [cite: 8]
                        break
                    end [cite: 9]
                end
            end
        end
        task.wait(5) [cite: 9]
    end
end)

-- [[ ANTI-AFK - METODE VIRTUALUSER (LEBIH AMAN) ]]
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

print("KAMIAPA: Script Reloaded - Bypass Nil Error Aktif!") [cite: 10]
