local UILibrary = loadstring(game:HttpGet("https://descended.glitch.me/lualibs/twilight.lua"))()
local UI = UILibrary.Load("Descended's Turret TP")

local PageMain = UI.AddPage("Main", false)
local PageTurretTP = UI.AddPage("Turret TP", true)

local Ships = game.Workspace.Ships
local function handleship(ship)
    if ship.Parent.Parent ~= Ships then return end
    local owner = ship:WaitForChild("Owner").Value.Name
    if owner == game.Players.LocalPlayer.Name then return end
    local removebutton = PageTurretTP.AddButton(owner .. " " .. ship.Name, function()
        local myship = game.Players.LocalPlayer.ActiveShip.Value
        if not myship then
            print("Failed to turret tp: you should spawn a ship first 🐒")
            return
        end
        local target = myship.CenterPoint.Position + Vector3.new(0, 100, 0)
        for _, part in ipairs(ship:GetDescendants()) do
            if not part:IsA("BasePart") then continue end
            part.Anchored = true
            part.Position = target
        end
    end)
    local listener1 = ship.Parent.ChildRemoved:Connect(function()
        if ship.Parent then return end
        removebutton()
    end)
    local listener2; listener2 = ship:GetPropertyChangedSignal("Name"):Connect(function()
        listener1:Disconnect()
        listener2:Disconnect()
        removebutton()
        handleship(ship)
    end)
end

Ships.DescendantAdded:Connect(handleship)
for _, ship in ipairs(Ships:GetDescendants()) do
    handleship(ship)
end
