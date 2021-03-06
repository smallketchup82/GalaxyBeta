--[[
strings-override

...
]]
if game.PlaceId ~= 263135585 then print("run this in galaxy beta you monkey") return end
print("Running Galaxy Beta Utilities!")
local UILibrary = loadstring(game:HttpGet("https://descended.glitch.me/lualibs/twilight.lua"))()

local MainUI = UILibrary.Load("Roblox Galaxy Beta Utilities")

local mainpage = MainUI.AddPage("Main", false)
local farmingpage = MainUI.AddPage("Autofarm", false)
local autobuildpage = MainUI.AddPage("AutoBuild", false)
local combatpage = MainUI.AddPage("Combat", false)
local progressionpage = MainUI.AddPage("Progression", false)
local shippage = MainUI.AddPage("Ship", false)
local teleportpage = MainUI.AddPage("Teleports", true)
local dockpage = MainUI.AddPage("Dock", true)
local miscpage = MainUI.AddPage("Misc", false)

local bases = game.Workspace.Bases
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

-- farming page
farmingpage.AddLabel("Automine")

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

--farmingpage.AddLabel("Make sure you are docked at Mega Base or a Starbase.\nMake sure you have a miner out")

-- autobuild

-- warehouse logic:

-- silicate ID: 3
-- carbon ID: 5
-- iridium ID: 7
-- adamantite ID: 9
-- palladium ID: 11
-- titanium ID: 13
-- quantium ID: 15

local shiptobuild
local autobuilddeb = false

autobuildpage.AddDropdown("Ship", {
	"Tango",
	"Harvester",
	"Advanced Miner",
	"Industrial Miner",
	"Tempura",
	"Argonaut",
	"Prospector",
	"Hercules",
	"Prepravca",
	"Starblade",
	"Dropship",
	"Avenger",
	"Osprey",
	"Raven",
	"Python",
	"Archangel",
	"Viper",
	"Abyss",
	"Corvid",
	"Phantom",
	"Centurion",
	"Zero",
	"Scimitar",
	"Cobra",
	"Sabre Tooth",
	"Xenon",
	"Gunslinger",
	"Reaver",
	"Gideon",
	"Orion",
	"Invictus",
	"Spectre",
	"Nova",
	"Sixfold",
	"Bastion",
	"Dire Wolf",
	"Aeaphiel",
	"Radiance",
	"Hecate",
	"Razor Wing",
	"Belvat",
	"Black Flare",
	"Grievion",
	"Sovereign",
	"Hasatan",
	"Hawklight",
	"Aegis",
	"Ampharos",
	"Warlock",
	"Archeon",
	"Sagittarius",
	"Naglfar",
	"Ridgebreaker",
	"Cyclops",
	"Leviathan",
	"Apocalypse",
	"Nemesis",
	"Tempest",
	"Tennhausen",
	"Zeus",
	"Hevnetier",
	"Revelation",
	"Stormbringer",
	"Rhino"
}, function(val)
	shiptobuild = val
end)

autobuildpage.AddButton("Auto Build", function()
	if not shiptobuild then print("Please select a ship to build and press again!") return end

	if autobuilddeb == true then print("Please wait until you can use this again!") return end
	autobuilddeb = true

	local warehouse = game.Players.LocalPlayer.Warehouse
	-- clear warehouse

	for _, item in ipairs(warehouse:GetDescendants()) do
		if not item:IsA("NumberValue") then return end

		local args = {
    		[1] = tonumber(item.Name),
    		[2] = item.Value,
    		[3] = "Warehouse"
		}

		workspace.Bases:FindFirstChild("Mega Base").Model.Sell:InvokeServer(unpack(args))
	end

	-- check megabase prices
	local hasenoughcredits

	local ecoframe = game.ReplicatedStorage.Gui.EconomyFrame:Clone()

	ecoframe.Visible = false
	ecoframe.Parent = game.Players.LocalPlayer.PlayerGui.MyScreenGui

	game:GetService("ReplicatedStorage").Remote.GetGridData:InvokeServer()

	wait(2)

	local mb

	for _, obj in ipairs(ecoframe:GetDescendants()) do
		if not obj:IsA("TextLabel") then continue end

		if obj.Name ~= "FactionName" then continue end
		
		if obj.Text ~= "Mega Base" then continue end

		mb = obj.Parent
		break
	end

	if not mb then print("Error while calculating Megabase Prices, please contact a developer of this script for support.") return end

	local prices = {
		[3] = tonumber(mb:FindFirstChild("3").Text) + 0.1,
		[5] = tonumber(mb:FindFirstChild("5").Text) + 0.1,
		[7] = tonumber(mb:FindFirstChild("7").Text) + 0.1,
		[9] = tonumber(mb:FindFirstChild("9").Text) + 0.1,
		[11] = tonumber(mb:FindFirstChild("11").Text) + 0.1,
		[13] = tonumber(mb:FindFirstChild("13").Text) + 0.1,
		[15] = tonumber(mb:FindFirstChild("15").Text) + 0.1
	}

	ecoframe:Destroy()

	local function autobuild(shipname) 

		if game.Players.LocalPlayer.ShipInventory:FindFirstChild(shipname) then print("You already have the " .. shipname .. "!") return end

		local args = {
			[1] = shipname
		}
		
		local result = game:GetService("ReplicatedStorage").Remote.GetShipInfo:InvokeServer(unpack(args))
		
		local function getstatsthingy(id)
			local found = false
			local quantity = nil
			for _, val in ipairs(result) do
				if val[1] == id then
					found = true
					quantity = val[2]
					break
				end
			end
			
			return found, quantity
		end
		
		local silicateexists, silicatequantity = getstatsthingy(3)
		local carbonexists, carbonquantity = getstatsthingy(5)
		local iridiumexists, iridiumquantity = getstatsthingy(7)
		local adamexists, adamquantity = getstatsthingy(9)
		local pallaexists, pallaquantity = getstatsthingy(11)
		local titanexists, titanquantity = getstatsthingy(13)
		local quantexists, quantquantity = getstatsthingy(15)

		local pricesum = 0

		if silicateexists then pricesum = pricesum + prices[3]*silicatequantity end
		if carbonexists then pricesum = pricesum + prices[5]*carbonquantity end
		if iridiumexists then pricesum = pricesum + prices[7]*iridiumquantity end
		if adamexists then pricesum = pricesum + prices[9]*adamquantity end
		if pallaexists then pricesum = pricesum + prices[11]*pallaquantity end
		if titanexists then pricesum = pricesum + prices[13]*pallaquantity end
		if quantexists then pricesum = pricesum + prices[15]*quantquantity end

		pricesum += (pricesum*0.08)

		print(pricesum)

		if pricesum >= game.Players.LocalPlayer.Credits.Value then print("You do not have enough credits to buy the " .. shipname .. "!") return end

		if silicateexists then
			local args = {
    			[1] = 3,
    			[2] = silicatequantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if carbonexists then
			local args = {
    			[1] = 5,
    			[2] = carbonquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if iridiumexists then
			local args = {
    			[1] = 7,
    			[2] = iridiumquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if adamexists then
			local args = {
    			[1] = 9,
    			[2] = adamquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if pallaexists then
			local args = {
    			[1] = 11,
    			[2] = pallaquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if titanexists then
			local args = {
    			[1] = 13,
    			[2] = titanquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		if quantexists then
			local args = {
    			[1] = 15,
    			[2] = quantquantity,
    			[3] = "Warehouse"
			}

			workspace.Bases:FindFirstChild("Mega Base").Model.Buy:InvokeServer(unpack(args))
		end

		local args = {
    		[1] = shipname
		}

		workspace.Bases:FindFirstChild("Mega Base").Model.BuyShip:InvokeServer(unpack(args))
	end
	
	autobuild(shiptobuild)
	autobuilddeb = false
end)

-- combat page

combatpage.AddButton("Turret TP UI", function(value)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/turret_tp.lua"))()
end)

-- progression page

local abortedwarehouselvls = false
local unlockwarehousebtn = progressionpage.AddButton("Unlock All Warehouse Levels [UNSTABLE]", function()
	print("This is very glitchy or cause data loss, so at the moment it is disabled")

    -- local warehouselvl = game.Players.LocalPlayer.WarehouseLevel.Value

    -- while wait() do
    --     warehouselvl = game.Players.LocalPlayer.WarehouseLevel.Value
    --     if abortedwarehouselvls == true then print("Aborted buying all warehouses") break end

    --     if warehouselvl == 21 then print("Finished buying all warehouse levels") break end

    --     local args = {
    --         [1] = warehouselvl+1
    --     }
        
    --     game:GetService("ReplicatedStorage").Remote.UpgradeWarehouse:InvokeServer(unpack(args))
        
    -- end
end)

local abortwarehousebtn = progressionpage.AddButton("Abort unlocking all Warehouse Levels", function()
	print("This is very glitchy or cause data loss, so at the moment it is disabled.")
    -- abortedwarehouselvls = true
end)

-- ship page

shippage.AddButton("Unlock Warp", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/unlockwarp.lua"))()
end)


-- tp page
local function handlebasetp(base)
	if base.Parent.Parent ~= bases then return end

	local removebasebutton = teleportpage.AddButton(base.Parent.Name, function()

		if game.Players.LocalPlayer.Character.Humanoid.Sit then print("You are seated! Teleporting is not available while you are seated or pilotting a ship.") return end

		local args = {
    		[1] = base.CenterPoint,
			[2] = nil --[[Vector3]]
		}

		game:GetService("ReplicatedStorage").Remote.TeleportTo:InvokeServer(unpack(args))

	end)
	local listener1 = base.Parent.ChildRemoved:Connect(function()
		if base.Parent then return end
		removebasebutton()
	end)
	local listener2; listener2 = base:GetPropertyChangedSignal("Name"):Connect(function()
		listener1:Disconnect()
		listener2:Disconnect()
		removebasebutton()
		handlebasetp(base)
	end)
end

bases.DescendantAdded:Connect(handlebasetp)
for _, base in ipairs(bases:GetDescendants()) do
	handlebasetp(base)
end

-- docks page

local dockdeb = false
local function handlebase(base)
	if base.Parent.Parent ~= bases then return end

	local removebasebutton = dockpage.AddButton(base.Parent.Name, function()
		if dockdeb == true then return end
		dockdeb = true
		local myship = game.Players.LocalPlayer.ActiveShip.Value

        if not myship then
            print("Failed to TP Ship: You should spawn a ship first ????")
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

miscpage.AddToggle("Side Shiplist", false, function(value)

	if value == true then 

		for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
			if gui.Name == "SideShipList" then
				gui:Destroy()
			end
		end

		local SideShipList = Instance.new("ScreenGui")
		local Main = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")

		SideShipList.Name = "SideShipList"
		SideShipList.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		SideShipList.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		Main.Name = "Main"
		Main.Parent = SideShipList
		Main.Active = true
		Main.AnchorPoint = Vector2.new(0.5, 0.5)
		Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Main.BackgroundTransparency = 1.000
		Main.BorderSizePixel = 0
		Main.Position = UDim2.new(0.150000006, 0, 0.5, 0)
		Main.Selectable = false
		Main.Size = UDim2.new(0.25, 0, 1, 0)
		Main.CanvasSize = UDim2.new(0, 0, 1, 0)

		UIListLayout.Parent = Main
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 10)

		local function addshiptolist(shipname)
			local Ship = Instance.new("TextLabel")
			Ship.Name = shipname
			Ship.Parent = Main
			Ship.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Ship.BackgroundTransparency = 1.000
			Ship.Size = UDim2.new(1, 0, 0, 50)
			Ship.Font = Enum.Font.Cartoon
			Ship.Text = shipname
			Ship.TextColor3 = Color3.fromRGB(255, 255, 255)
			Ship.TextScaled = true
			Ship.TextSize = 14.000
			Ship.TextWrapped = true
			Ship.TextXAlignment = Enum.TextXAlignment.Left
		end

		local function removeshipfromlist(shipname)
			if Main:FindFirstChild(shipname) then
				Main:FindFirstChild(shipname):Destroy()
			end
	end

	for _, ship in ipairs(game.Players.LocalPlayer.ShipInventory:GetChildren()) do
		addshiptolist(ship.Name)
	end

	game.Players.LocalPlayer.ShipInventory.ChildAdded:Connect(function(val)
		addshiptolist(val.Name)
	end)

	game.Players.LocalPlayer.ShipInventory.ChildRemoved:Connect(function(val)
		removeshipfromlist(val.Name)
	end)

	else
		for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
			if gui.Name == "SideShipList" then
				gui:Destroy()
			end
		end
	end
end)

miscpage.AddLabel("Created by benthealien20")
miscpage.AddLabel("With help from Descended & BoyImmaGetChu")


print("Successfully ran Galaxy Beta Utilities")