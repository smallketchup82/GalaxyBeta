local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local YourTeam = game.Players.LocalPlayer.Team
local YourMiner = game.Players.LocalPlayer.ActiveShip.Value
local ship = game.Workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner))

if ship.Configuration:FindFirstChild("NoWarp") ~= null then
    ship.Configuration.NoWarp.Value = false
    
    local humanoid = character.Humanoid
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    print("Unlocked Warping")
end