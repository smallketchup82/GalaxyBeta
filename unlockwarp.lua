local YourTeam = game.Players.LocalPlayer.Team
local YourMiner = game.Players.LocalPlayer.ActiveShip.Value
local ship = game.Workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner))

if ship.Configuration:FindFirstChild("NoWarp") ~= null then
    ship.Configuration.NoWarp.Value = false

    game.Players.LocalPlayer.Character.Humanoid.Jumping = true
end