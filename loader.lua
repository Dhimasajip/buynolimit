-- [[ KAMIAPA MAIN SCRIPT - COORDINATE & SPEED COIL ]]
-- Menggunakan variabel lokal sederhana agar tidak memicu nil error di awal [cite: 1]
local RUNNING_KEY = "KAMI_APA_ACTIVE"
if _G[RUNNING_KEY] then return end
_G[RUNNING_KEY] = true

task.wait(1)

-- Proteksi pemanggilan servis agar tidak nil [cite: 2]
local function getService(name)
    local s, res = pcall(game.GetService, game, name)
    return s and res or nil
end

local Players = getService("Players")
local VirtualUser = getService("VirtualUser")
local ProximityPromptService = getService("ProximityPromptService")
local player = Players and Players.LocalPlayer

-- [[ KOORDINAT TITIK AMAN ]]
-- Diperbarui berdasarkan image_0d073d.png [cite: 1]
local HOME_POS = Vector3.new(-410.2870788574219, -6.403680801391602, -68.40277099609375) 
local RETURN_DISTANCE = 2 

-- [[ FUNGSI DETEKSI TARGET ]]
local function isTarget(model)
    local targets = getgenv and getgenv().TARGET_LIST or {}
    local name = model:GetAttribute("Index") or model.Name
    local billboard = model:FindFirstChildOfClass("BillboardGui")
    local textLabel = billboard and billboard:FindFirstChildOfClass("TextLabel")
    local screenName = textLabel and textLabel.Text or ""

    for _, targetName in ipairs(targets) do
        if string.find(string.lower(name), string.lower(targetName)) or 
           string.find(string.lower(screenName), string.lower(targetName)) then
            return true
        end
    end
    return false
end

-- [[ STAY AT HOME & RETURN ON HIT ]]
task.spawn(function()
    local lastHealth = 100
    while task.wait(0.2) do
        if not player or not player.Character then continue end
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if hum and root and hum.Health > 0 then
            local targetPos = Vector3.new(HOME_POS.X, root.Position.Y, HOME_POS.Z)
            if hum.Health < lastHealth then
                root.CFrame = CFrame.new(targetPos) [cite: 3]
            end
            if (root.Position - targetPos).Magnitude >= RETURN_DISTANCE then
                hum:MoveTo(targetPos) [cite: 4]
            end
            lastHealth = hum.Health
        end
    end
end)

-- [[ AUTO PURCHASE - METODE SINYAL (PALING AMAN DARI ERROR NIL) ]]
if ProximityPromptService then
    ProximityPromptService.PromptShown:Connect(function(prompt)
        local model = prompt:FindFirstAncestorOfClass("Model")
        if model and isTarget(model) then
            task.wait(0.2)
            -- Menjalankan simulasi input tanpa memanggil fungsi executor khusus [cite: 5]
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration + 0.05)
                prompt:InputHoldEnd()
            end)
        end
    end)
end

-- [[ FITUR AUTO SPEED COIL ]]
task.spawn(function()
    while task.wait(5) do
        if not player or not player.Character then continue end
        local char = player.Character
        local backpack = player:FindFirstChildOfClass("Backpack")
        
        if char and backpack then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local coil = char:FindFirstChild("Speed Coil") or char:FindFirstChild("Coil")
            
            if not coil and hum then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "speed") or string.find(string.lower(tool.Name), "coil")) then
                        hum:EquipTool(tool) [cite: 8, 9]
                        break
                    end
                end
            end
        end
    end
end)

-- [[ ANTI-AFK (METODE INTERNAL ROBLOX) ]]
if player then
    player.Idled:Connect(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end
    end)
end

print("KAMIAPA: Script Ultra-Safe Loaded!")
