if game.PlaceId ~= 263135585 then print("run this in galaxy beta you monkey") return end
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
	"Sagittarius",
	"Naglfar",
	"Ridgebreaker",
	"Cyclops",
	"Leviathan",
	"Apocalypse",
	"Nemesis",
	"Tempest",
	"Tennhausen",
	"Zeus"
}, function(val)
	shiptobuild = val
end)

autobuildpage.AddButton("Auto Build", function()
	if not shiptobuild then print("Please select a ship to build and press again!") return end

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

		if silicateexists then pricesum += prices[3]*silicatequantity end
		if carbonexists then pricesum += prices[5]*carbonquantity end
		if iridiumexists then pricesum += prices[7]*iridiumquantity end
		if adamexists then pricesum += prices[9]*adamquantity end
		if pallaexists then pricesum += prices[11]*pallaquantity end
		if titanexists then pricesum += prices[13]*pallaquantity end
		if quantexists then pricesum += prices[15]*quantquantity end

		pricesum += (pricesum*0.8)

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

	function comparefunny(shipname)
		return shiptobuild == shipname
	end

	if comparefunny("Tango") then autobuild("Tango")
	elseif comparefunny("Harvester") then autobuild("Harvester")
	elseif comparefunny("Advanced Miner") then autobuild("Advanced Miner")
	elseif comparefunny("Industrial Miner") then autobuild("Industrial Miner")
	elseif comparefunny("Tempura") then autobuild("Tempura")
	elseif comparefunny("Argonaut") then autobuild("Argonaut")
	elseif comparefunny("Prospector") then autobuild("Prospector")
	elseif comparefunny("Hercules") then autobuild("Hercules")
	elseif comparefunny("Prepravca") then autobuild("Prepravca")
	elseif comparefunny("Starblade") then autobuild("Starblade")
	elseif comparefunny("Dropship") then autobuild("Dropship")
	elseif comparefunny("Avenger") then autobuild("Avenger")
	elseif comparefunny("Osprey") then autobuild("Osprey")
	elseif comparefunny("Raven") then autobuild("Raven")
	elseif comparefunny("Python") then autobuild("Python")
	elseif comparefunny("Archangel") then autobuild("Archangel")
	elseif comparefunny("Viper") then autobuild("Viper")
	elseif comparefunny("Abyss") then autobuild("Abyss")
	elseif comparefunny("Sagittarius") then autobuild("Sagittarius")
	elseif comparefunny("Naglfar") then autobuild("Naglfar")
	elseif comparefunny("Ridgebreaker") then autobuild("Ridgebreaker")
	elseif comparefunny("Cyclops") then autobuild("Cyclops")
	elseif comparefunny("Leviathan") then autobuild("Leviathan")
	elseif comparefunny("Apocalypse") then autobuild("Apocalypse")
	elseif comparefunny("Nemesis") then autobuild("Nemesis")
	elseif comparefunny("Tempest") then autobuild("Tempest")
	elseif comparefunny("Tennhausen") then autobuild("Tennhausen")
	elseif comparefunny("Zeus") then autobuild("Zeus")
	end

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
            print("Failed to TP Ship: You should spawn a ship first 🐒")
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