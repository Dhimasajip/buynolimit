-- [[ KAMIAPA MAIN SCRIPT - COORDINATE & SPEED COIL ]]
if getgenv().__KAMI_APA_MAIN_RUNNING then return end
getgenv().__KAMI_APA_MAIN_RUNNING = true [cite: 1]

task.wait(2)
repeat task.wait() until game:IsLoaded() [cite: 1]

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser") 
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer [cite: 2]

-- [[ KOORDINAT TITIK AMAN BARU ]]
local HOME_POS = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) [cite: 2]
local RETURN_DISTANCE = 2 [cite: 2]

-- [[ FUNGSI DETEKSI TARGET ]]
local function isTarget(model)
    if not getgenv().TARGET_LIST then return false end [cite: 2]
    local name = model:GetAttribute("Index") or model.Name [cite: 2]
    local billboard = model:FindFirstChildOfClass("BillboardGui")
    local textLabel = billboard and billboard:FindFirstChildOfClass("TextLabel")
    local screenName = textLabel and textLabel.Text or "" [cite: 2]

    for _, targetName in ipairs(getgenv().TARGET_LIST) do
        if string.find(string.lower(name), string.lower(targetName)) or 
           string.find(string.lower(screenName), string.lower(targetName)) then
            return true
        end
    end
    return false [cite: 2]
end

-- [[ STAY AT HOME & RETURN ON HIT ]]
task.spawn(function()
    local lastHealth = 100
    while true do
        local char = player.Character [cite: 3]
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if hum and root and hum.Health > 0 then
            local targetPos = Vector3.new(HOME_POS.X, root.Position.Y, HOME_POS.Z)
            if hum.Health < lastHealth then
                root.CFrame = CFrame.new(targetPos) [cite: 3]
            end
            if (root.Position - targetPos).Magnitude >= RETURN_DISTANCE then
                hum:MoveTo(targetPos)
            end
            lastHealth = hum.Health [cite: 3]
        end
        task.wait(0.1)
    end
end)

-- [[ AUTO PURCHASE - UNIVERSAL METHOD (FIX NIL ERROR) ]]
ProximityPromptService.PromptShown:Connect(function(prompt)
    local model = prompt:FindFirstAncestorOfClass("Model")
    
    if model and isTarget(model) then [cite: 5]
        task.wait(0.15) 
        -- Menggunakan pcall agar jika terjadi error, script tetap berjalan
        pcall(function()
            -- Metode Simulasi Sinyal: Paling stabil untuk semua executor
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration)
            prompt:InputHoldEnd()
            -- Memicu fungsi Triggered secara manual
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end
end)

-- [[ FITUR AUTO SPEED COIL ]]
task.spawn(function()
    while true do
        local char = player.Character [cite: 6]
        local backpack = player:FindFirstChildOfClass("Backpack")
        
        if char and backpack then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local holdingCoil = false
            
            for _, tool in ipairs(char:GetChildren()) do [cite: 6]
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then
                    holdingCoil = true [cite: 7]
                    break
                end
            end

            if not holdingCoil then
                for _, tool in ipairs(backpack:GetChildren()) do [cite: 8]
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then
                        hum:EquipTool(tool) [cite: 9]
                        break
                    end
                end
            end
        end
        task.wait(5) [cite: 9]
    end
end)

-- [[ ANTI-AFK (VERSI AMAN TANPA VIRTUALINPUTMANAGER) ]]
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

print("KAMIAPA: Script Reloaded & Nil Error Patched!") [cite: 10]
