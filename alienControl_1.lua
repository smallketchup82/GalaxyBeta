--made by melon cult
-- to use spawn a ship, make sure you're the only one with said ship spawned
-- change ship name
-- and change "team" to your team name. 
-- Note: if you copy your ownerID manually you can use the alien's guns,
-- if you don't, you can v-fly and guide the alien to what you want to shoot.
local team = "poop"
local ship = "Wasp"
local name = game.Players.LocalPlayer.Name
local punisher = false -- true if you want to get a punisher
local plrships = game.workspace.Ships:FindFirstChild(team):GetChildren()

for i=1, #plrships do 
if plrships[i].Name == ship then
     if punisher == true then 
         alien = game.workspace.Ships.Alien:FindFirstChild("Punisher")
         else alien = game.workspace.Ships.Alien:FindFirstChild("Swarmer")
     end
   
   local clone = plrships[i].Owner.Parent:Clone()alien.Owner:Destroy()
   clone.Parent = alien
    alien.PilotSeat.Disabled = false
    local seat = alien.PilotSeat
	alien.Name = "test"
	wait(1)
  game.Workspace:FindFirstChild(name).HumanoidRootPart.CFrame = CFrame.new(Vector3.new(seat.Position.X,seat.Position.Y,seat.Position.Z))
end
end