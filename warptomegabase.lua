-- WARNING: DO NOT USE THIS SCRIPT ITS CURRENTLY EXPERIMENTAL
local YourTeam = game.Players.LocalPlayer.Team
local YourMiner = game.Players.LocalPlayer.ActiveShip.Value

local rs = game:GetService("RunService")

local ship = workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner))
if not YourMiner or not ship then print("Please spawn a ship!") return end
local shippoint = workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).CenterPoint
local basepoint = game.workspace.Bases:FindFirstChild("Mega Base").Model.CenterPoint

if ship.Configuration:FindFirstChild("NoWarp") ~= null then
   ship.Configuration.NoWarp.Value = false 
end

local args = {
    [1] = "Teleport",
    [2] = workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).PilotSeat
}

workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).ButtonPress:FireServer(unpack(args))

wait(1)

shippoint.BodyGyro.CFrame = CFrame.new(shippoint.Position, basepoint.Position)

repeat 
    ship.PilotSeat.Throttle = 1
    rs.Heartbeat:Wait()
until ship.PilotSeat.Velocity.magnitude >= ship.PilotSeat.MaxSpeed-5

ship.PilotSeat.Throttle = 0

local args = {
    [1] = "ShipWarp"
}
workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).ButtonPress:FireServer(unpack(args))

while wait() do
    local distance = (shippoint.Position - basepoint.Position).Magnitude
    
    if distance <= 1000 then
        local funnything = false
        
        coroutine.resume(coroutine.create(function()
        wait(1)
        funnything = true
        end))
        
        while funnything == false do
            ship.PilotSeat.Throttle = -1
            wait()
        end
        
        ship.PilotSeat.Throttle = 0
        
        wait(1)
        
        local args = {
            [1] = "ShipDock"
        }

        workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).ButtonPress:FireServer(unpack(args))

        break
    end
end
