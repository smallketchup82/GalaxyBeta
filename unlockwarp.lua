if game.PlaceId ~= 263135585 then print("run this in galaxy beta you monkey 🐒") return end
local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local YourTeam = game.Players.LocalPlayer.Team
local YourMiner = game.Players.LocalPlayer.ActiveShip.Value

if not YourMiner then print("spawn a ship you monkey 🐒") return end
local ship = game.Workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner))

if ship.Configuration:FindFirstChild("NoWarp") ~= null then
    ship.Configuration.NoWarp.Value = false
    
    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    print("Unlocked Warping")
end