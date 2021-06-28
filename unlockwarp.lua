local YourTeam = game.Players.LocalPlayer.Team
local YourMiner = game.Players.LocalPlayer.ActiveShip.Value
local ship = workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner))

if ship.Configuration:FindFirstChild("NoWarp") ~= null then
    ship.Configuration.NoWarp.Value = false
else
    print("Ship already has warp enabled")
end