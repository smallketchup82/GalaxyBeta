local UILibrary = loadstring(game:HttpGet("https://descended.glitch.me/lualibs/twilight.lua"))()

local MainUI = UILibrary.Load("Roblox Galaxy Beta Utilities")

local mainpage = MainUI.AddPage("Main", false)
local farmingpage = MainUI.AddPage("Autofarm", false)
local combatpage = MainUI.AddPage("Combat", false)
local progressionpage = MainUI.AddPage("Progression", false)
local teleportpage = MainUI.AddPage("Teleports", true)
local dockpage = MainUI.AddPage("Dock", true)
local miscpage = MainUI.AddPage("Misc", false)

-- farming page
local autominesection = farmingpage.AddLabel("Automine")

local currentenabled = false

local ore = "Silicate Ore"

local autominetoggle = farmingpage.AddToggle("Enable Automine", false, function(value)

	if currentenabled == false and value == true then
		currentenabled = true

		local YourTeam = game.Players.LocalPlayer.Team
		local YourMiner = game.Players.LocalPlayer.ActiveShip.Value
		for _, i in ipairs(YourMiner:GetDescendants()) do
			if not i:IsA("BoolValue") then continue end
			if i.Name ~= "Miner" then continue end
			local ShipTurret = i.Parent
			ShipTurret.ReloadTime.Value = 0.1
			spawn(function()
				while currentenabled do
					if not YourMiner then
						print("No miner currently spawned!")
						currentenabled = false
						break
					end
	
					for i = 1, 100 do
						coroutine.resume(coroutine.create(function()
							local args = {
								[1] = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0.031546838581562, 0.82163470983505, -0.56914073228836)),
								[2] = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0.56289011240005, -0.021682156249881, 0.82624727487564)),
								[3] = 1144.869140625,
								[4] = workspace.Asteroids:FindFirstChild(ore),
								[5] = workspace.Asteroids:FindFirstChild(ore).CenterPoint
							}
							ShipTurret.RemoteFireCommand:InvokeServer(unpack(args))
						end))
					end
					wait(3)
	
					local dockedat = game.workspace.Ships:FindFirstChild(tostring(YourTeam)):FindFirstChild(tostring(YourMiner)).DockedAt.Value
					local dockedbase = dockedat.Parent.Parent.Name
	
					if workspace.Bases:FindFirstChild(dockedbase):FindFirstChild("Model") ~= nil then
						workspace.Bases:FindFirstChild(dockedbase).Model.DumpOre:InvokeServer()
					elseif workspace.Bases:FindFirstChild(dockedbase):FindFirstChild("Starbase") then
						workspace.Bases:FindFirstChild(dockedbase).Starbase.DumpOre:InvokeServer()
					else 
						print("Error! Cannot find a starbase to dump at. Please dock at either Mega Base or a Starbase")
					    currentenabled = false
					end
				end
			end)
		end
	else
		currentenabled = false
	end
end)

local oredropdown = farmingpage.AddDropdown("Ore", {
	"Silicate Ore",
	"Carbon Ore",
	"Iridium Ore",
	"Adamantite Ore",
	"Palladium Ore",
	"Titanium Ore",
	"Quantium Ore"
}, function(value)
ore = tostring(value)
end)

farmingpage.AddLabel("Make sure you are docked at Mega Base or a Starbase.\nMake sure you have a miner out")

-- combat page

combatpage.AddButton("Turret TP UI", function(value)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/turret_tp.lua"))()
end)

-- progression page

local abortedwarehouselvls = false
local unlockwarehousebtn = progressionpage.AddButton("Unlock All Warehouse Levels (You need a lot of money)", function(value)
    local warehouselvl = game.Players.LocalPlayer.WarehouseLevel.Value

    while wait() do
        warehouselvl = game.Players.LocalPlayer.WarehouseLevel.Value
        if abortedwarehouselvls == true then print("Aborted buying all warehouses") break end

        if warehouselvl == 21 then print("Finished buying all warehouse levels") break end

        local args = {
            [1] = warehouselvl+1
        }
        
        game:GetService("ReplicatedStorage").Remote.UpgradeWarehouse:InvokeServer(unpack(args))
        
    end
end)

local abortwarehousebtn = progressionpage.AddButton("Abort unlocking all Warehouse Levels", function(value)    
    abortedwarehouselvls = true
end)

-- tp page

-- docks page

local dockdeb = false
local bases = game.Workspace.Bases
local function handlebase(base)
	if base.Parent.Parent ~= bases then return end

	local removebasebutton = dockpage.AddButton(base.Parent.Name, function()
		if dockdeb == true then return end
		dockdeb = true
		local myship = game.Players.LocalPlayer.ActiveShip.Value

        if not myship then
            print("Failed to turret tp: you should spawn a ship first 🐒")
			dockdeb = false
            return
        end

		myship:SetPrimaryPartCFrame(CFrame.new(base.PrimaryPart.CFrame.Position.X, base.PrimaryPart.CFrame.Position.Y+250, base.PrimaryPart.CFrame.Position.Z))

		wait(0.5)
		local dockinitialized = false
		
		coroutine.resume(coroutine.create(function()
		    repeat
		        myship.PilotSeat.Throttle = 1
		        game:GetService("RunService").Heartbeat:Wait()
		    until dockinitialized == true
		end))
		
		wait(2)

		local args = {
    		[1] = "ShipDock"
		}

		myship.ButtonPress:FireServer(unpack(args))
		dockinitialized = true
		wait(15)
		dockdeb = false
	end)
	local listener1 = base.Parent.ChildRemoved:Connect(function()
		if base.Parent then return end
		removebasebutton()
	end)
	local listener2; listener2 = base:GetPropertyChangedSignal("Name"):Connect(function()
		listener1:Disconnect()
		listener2:Disconnect()
		removebasebutton()
		handlebase(base)
	end)
end

bases.DescendantAdded:Connect(handlebase)
for _, base in ipairs(bases:GetDescendants()) do
	handlebase(base)
end

-- misc page