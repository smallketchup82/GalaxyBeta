if game.PlaceId ~= 263135585 then print("run this in galaxy beta you monkey 🐒") return end
if not game:IsLoaded() then
	print("Galaxy Beta Utilities: Waiting for game to load")
	game.Loaded:Wait()
end
print("Running Galaxy Beta Utilities!")
print("WARNING: THIS SCRIPT MAY CRASH YOUR SYNAPSE. IN THIS CASE PLEASE EXECUTE IT USING INTERNAL UI")


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/UILibrary.lua"))()
-- https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/documentation.txt

local maingui = library.new("Galaxy Beta Utilities")

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

local mainpage = maingui:addPage("Main")
local farmingpage = maingui:addPage("Autofarm")
local autobuildpage = maingui:addPage("AutoBuild")
local combatpage = maingui:addPage("Combat")
local progressionpage = maingui:addPage("Progression")
local shippage = maingui:addPage("Ship")
local miscpage = maingui:addPage("Misc")

local bases = game.Workspace.Bases
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

local warehousecosts = {
	[2] = 2000,
	[3] = 4000,
	[4] = 6000,
	[5] = 8000,
	[6] = 10000,
	[7] = 12000,
	[8] = 14000,
	[9] = 16000,
	[10] = 18000,
	[11] = 20000,
	[12] = 22000,
	[13] = 24000,
	[14] = 26000,
	[15] = 28000,
	[16] = 30000,
	[17] = 32000,
	[18] = 35000,
	[19] = 40000,
	[20] = 50000,
	[21] = 60000
}

local allships = {
	"Tango",
	"Harvester",
	"Advanced Miner",
	"Industrial Miner",
    "Wyrm",
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
	"Rhino",
	"Swarmer"
}

local materialspace = {
	[3] = 1,
	[5] = 1.25,
	[7] = 1.5,
	[9] = 2,
	[11] = 2,
	[13] = 2,
	[15] = 2
}

local warehousespace = {
	[1] = 1000,
	[2] = 2500,
	[3] = 5000,
	[4] = 7500,
	[5] = 10000,
	[6] = 12500,
	[7] = 15000,
	[8] = 17500,
	[9] = 20000,
	[10] = 22500,
	[11] = 25000,
	[12] = 27500,
	[13] = 30000,
	[14] = 32500,
	[15] = 35000,
	[16] = 37500,
	[17] = 40000,
	[18] = 45000,
	[19] = 50000,
	[20] = 55000,
	[21] = 60000
}
-- farming page

local autominesection = farmingpage:addSection("Automine")

local currentenabled = false
local upgradewarehousewhileautomining = false

local ore = "Silicate Ore"

local function checkandupgradewarehouse()
	local warehouselvl = game.Players.LocalPlayer.WarehouseLevel.Value
	local credits = game.Players.LocalPlayer.Credits.Value
	
	if warehouselvl == 21 then return end
	local nextwarelvl = tonumber(warehouselvl) + 1

	if credits > warehousecosts[nextwarelvl] then
		local args = {
    	[1] = nextwarelvl
	}

		game:GetService("ReplicatedStorage").Remote.UpgradeWarehouse:InvokeServer(unpack(args))
	end
end

autominesection:addToggle("Enable Automine", false, function(value)

	if currentenabled == false and value == true then
		currentenabled = true

		local YourTeam = game.Players.LocalPlayer.Team
		local YourMiner = game.Players.LocalPlayer.ActiveShip.Value
        if not YourMiner then 
            currentenabled = false
            maingui:Notify("No miner currently spawned!", "Please spawn a miner to use automine", function(val) 
            end)
            autominesection:updateToggle("Enable Automine", "Enable Automine", false)
        end
		for _, i in ipairs(YourMiner:GetDescendants()) do
			if not i:IsA("BoolValue") then continue end
			if i.Name ~= "Miner" then continue end
			local ShipTurret = i.Parent
			ShipTurret.ReloadTime.Value = 0.1
			spawn(function()
				while currentenabled do
					if not YourMiner then
                        currentenabled = false
                        maingui:Notify("No miner currently spawned!", "Please spawn a miner to use automine", function(val) 
                        end)
                        autominesection:updateToggle("Enable Automine", "Enable Automine", false)
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
						if upgradewarehousewhileautomining == true then checkandupgradewarehouse() end
					elseif workspace.Bases:FindFirstChild(dockedbase):FindFirstChild("Starbase") then
						workspace.Bases:FindFirstChild(dockedbase).Starbase.DumpOre:InvokeServer()
						if upgradewarehousewhileautomining == true then checkandupgradewarehouse() end
					else
					    currentenabled = false
                        maingui:Notify("Error!", "Cannot find a starbase to dump at. Please dock at either Mega Base or a Starbase")
                        autominesection:updateToggle("Enable Automine", "Enable Automine", false)
					end
				end
			end)
		end
	else
		currentenabled = false
	end
end)

 autominesection:addDropdown("Ore", {
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

autominesection:addToggle("Upgrade Warehouse while Automining", false, function(val)
	if val == true then
		upgradewarehousewhileautomining = true
	else
		upgradewarehousewhileautomining = false
	end
end)

-- autobuild page

local autobuilding = autobuildpage:addSection("Main")

local shiptobuild
local autobuilddeb = false



autobuilding:addDropdown("Ship", allships, function(val)
	shiptobuild = val
end)

autobuilding:addButton("Auto Build", function()
	if not shiptobuild then maingui:Notify("You did not select a ship to build", "Please select a ship to build and press again!") return end
	
	if autobuilddeb == true then print("Please wait until you can use this again!") return end
	autobuilddeb = true
	
	local function autobuild(shipname) 
		if game.Players.LocalPlayer.ShipInventory:FindFirstChild(shipname) then maingui:Notify("", "You already have the " .. shipname .. "!") return end
		
		local warehouse = game.Players.LocalPlayer.Warehouse

		if game.Players.LocalPlayer.WarehouseLevel.Value ~= 21 then
			maingui:Notify("Level 21 Warehouse Recommended!", "You need to have a level 21 warehouse to prevent data loss or the script breaking while autobuilding. Warehouse checking will come soon")
		end
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

		if game.Players.LocalPlayer.PlayerGui.MyScreenGui:FindFirstChild("EconomyFrame") then
			game.Players.LocalPlayer.PlayerGui.MyScreenGui:FindFirstChild("EconomyFrame"):Destroy()
		end
	
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
	
		if not mb then maingui:Notify("Error while calculating Megabase Prices!", "Please contact a developer of this script for support.") return end
	
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

		function comma_value(amount)
			local formatted = amount
			while true do  
			  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
			  if (k==0) then
				break
			  end
			end
			return formatted
		  end

		if pricesum >= game.Players.LocalPlayer.Credits.Value then maingui:Notify("Not enough credits!", "You do not have enough credits to buy the " .. shipname .. "!" .. "\nEstimated Amount Required: $" .. comma_value(tonumber(pricesum))) return end

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
        maingui:Notify("Done!", "Finished building " .. shipname .. "!")
	end
	
	autobuild(shiptobuild)
	autobuilddeb = false
end)

-- combat page

local combatmainsec = combatpage:addSection("Main")

combatmainsec:addButton("Turret TP UI", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/turret_tp.lua"))()
end)

local espsec = combatpage:addSection("ESP")

local shipespenabled = false
local espcolor = Color3.new(255,255,255)
local shiplistener1

espsec:addToggle("Ship ESP (BUGGY)", false, function(val)
	local team = game.Players.LocalPlayer.Team
	local ships = game.workspace.Ships

	if val == true then 
		if shipespenabled == false then shipespenabled = true end
		local function shipesp()
			for _, shipteam in ipairs(ships:GetChildren()) do
		
				for _, ship in ipairs(shipteam:GetChildren()) do 
					if not ship.CenterPoint:FindFirstChild("ESP") then 
					local BillboardGui = Instance.new("BillboardGui", ship.CenterPoint)
					local TextLabel = Instance.new("TextLabel", BillboardGui)
						BillboardGui.Adornee = ship.CenterPoint
						BillboardGui.Name = "ESP"
						BillboardGui.Size = UDim2.new(0, 100, 0, 150)
						BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
						BillboardGui.AlwaysOnTop = true
						TextLabel.BackgroundTransparency = 1
						TextLabel.Position = UDim2.new(0, 0, 0, -50)
						TextLabel.Size = UDim2.new(0, 100, 0, 100)
						TextLabel.Font = Enum.Font.SourceSansSemibold
						TextLabel.TextSize = 20
						TextLabel.TextColor3 = Color3.new(1, 1, 1)
						TextLabel.TextStrokeTransparency = 0
						TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
						TextLabel.Text = 'Name: ' .. ship.Name .. " | Owner: " .. tostring(ship.Owner.Value) .. " | Shield: " .. math.floor(ship.Shield.Value) .. " | Hull: " .. math.floor(ship.Hull.Value)
						TextLabel.ZIndex = 10
					
						game:GetService("RunService").RenderStepped:Connect(function()
							TextLabel.Text = 'Name: ' .. ship.Name .. " | Owner: " .. tostring(ship.Owner.Value) .. " | Shield: " .. math.floor(ship.Shield.Value) .. " | Hull: " .. math.floor(ship.Hull.Value)
						end)
					end
				
				if ship:FindFirstChild("ShipParts") then 
					for _, part in ipairs(ship["ShipParts"]:GetDescendants()) do
				   if not part:IsA("BasePart") then continue end
				   if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
					
					local a = Instance.new("BoxHandleAdornment")
						a.Name = part.Name:lower().."_ESP"
						a.Parent = part
						a.Adornee = part
						a.AlwaysOnTop = true
						a.ZIndex = 0
						a.Size = part.Size
						a.Transparency = 0.3
						a.Color3 = espcolor
					end
					return
				else
				
				for _, part in ipairs(ship["Ship Parts"]:GetDescendants()) do
				   if not part:IsA("BasePart") then continue end
				   if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
				
					local a = Instance.new("BoxHandleAdornment")
						a.Name = part.Name:lower().."_ESP"
						a.Parent = part
						a.Adornee = part
						a.AlwaysOnTop = true
						a.ZIndex = 0
						a.Size = part.Size
						a.Transparency = 0.3
						a.Color3 = espcolor
				end
				end
				end
			end
		end

		shipesp()

		print("esp enabled: " .. tostring(shipespenabled))
		shiplistener1 = ships.ChildAdded:Connect(function(shipteam)
			local listener2 = shipteam.ChildAdded:Connect(function(ship)
				print("esp enabled: " .. tostring(shipespenabled))
				if shipespenabled == false and listener2 then listener2:Disconnect() return end
			
		    	if ship.Parent == "Alien" then return end
		    	wait(5)
				shipesp()
		    end)
		end)
	else -- if off

		if shiplistener1 then shiplistener1:Disconnect() end
		shipespenabled = false

		for _, shipteam in ipairs(ships:GetChildren()) do
		
		    for _, ship in ipairs(shipteam:GetChildren()) do 
		        if ship.CenterPoint:FindFirstChild("ESP") then 
					ship.CenterPoint:FindFirstChild("ESP"):Destroy()
		        end
			
		    if ship:FindFirstChild("ShipParts") then 
		        for _, part in ipairs(ship["ShipParts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
				end
		    else
			
		    for _, part in ipairs(ship["Ship Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
		    end
		    end
		    end
		end
	end
end)

local baseesptoggled = true

local baselistener

espsec:addToggle("Base ESP", false, function(val)

	if val == true then

		if baseesptoggled == false then baseesptoggled = true end

		local team = game.Players.LocalPlayer.Team
		local bases = game.workspace.Bases

		local ignoreteam = false

		for _, base in ipairs(bases:GetChildren()) do
		    if base.Name == "Mega Base" then continue end
		    if ignoreteam == true and base.Name == tostring(team) then continue end
		
		    if not base.Starbase.CenterPoint:FindFirstChild("ESP") then 
		        local BillboardGui = Instance.new("BillboardGui", base.Starbase.CenterPoint)
		        local TextLabel = Instance.new("TextLabel", BillboardGui)
		            BillboardGui.Adornee = base.Starbase.CenterPoint
		            BillboardGui.Name = "ESP"
		            BillboardGui.Size = UDim2.new(0, 100, 0, 150)
		            BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
		            BillboardGui.AlwaysOnTop = true
		            TextLabel.BackgroundTransparency = 1
		            TextLabel.Position = UDim2.new(0, 0, 0, -50)
		            TextLabel.Size = UDim2.new(0, 100, 0, 100)
		            TextLabel.Font = Enum.Font.SourceSansSemibold
		            TextLabel.TextSize = 20
		            TextLabel.TextColor3 = Color3.new(1, 1, 1)
		            TextLabel.TextStrokeTransparency = 0
		            TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		            TextLabel.Text = 'Name: ' .. base.Name .. " | Shield: " .. math.floor(base.Starbase.Shield.Value) .. " | Hull: " .. math.floor(base.Starbase.Hull.Value)
		            TextLabel.ZIndex = 10
			
		            game:GetService("RunService").RenderStepped:Connect(function()
		                TextLabel.Text = 'Name: ' .. base.Name .. " | Shield: " .. math.floor(base.Starbase.Shield.Value) .. " | Hull: " .. math.floor(base.Starbase.Hull.Value)
		            end)
		    end
		
		    for _, part in ipairs(base.Starbase["Base Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
			
		        local a = Instance.new("BoxHandleAdornment")
		            a.Name = part.Name:lower().."_ESP"
		            a.Parent = part
		            a.Adornee = part
		            a.AlwaysOnTop = true
		            a.ZIndex = 0
		            a.Size = part.Size
		            a.Transparency = 0.3
		            a.Color = BrickColor.new("White")
		    end
		end

		baselistener = bases.ChildAdded:Connect(function(base)
		
		    wait(5)
		
		    if base.Name == "Mega Base" then return end
		
		    if ignoreteam == true and base.Name == tostring(game.Players.LocalPlayer.Team) then return end
		
		    local model = base:WaitForChild("Starbase")
		
		
		        if not base.Starbase.CenterPoint:FindFirstChild("ESP") then
		            local BillboardGui = Instance.new("BillboardGui", model.CenterPoint)
		            local TextLabel = Instance.new("TextLabel", BillboardGui)
		                BillboardGui.Adornee = model.CenterPoint
		                BillboardGui.Name = "ESP"
		                BillboardGui.Size = UDim2.new(0, 100, 0, 150)
		                BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
		                BillboardGui.AlwaysOnTop = true
		                TextLabel.BackgroundTransparency = 1
		                TextLabel.Position = UDim2.new(0, 0, 0, -50)
		                TextLabel.Size = UDim2.new(0, 100, 0, 100)
		                TextLabel.Font = Enum.Font.SourceSansSemibold
		                TextLabel.TextSize = 20
		                TextLabel.TextColor3 = Color3.new(1, 1, 1)
		                TextLabel.TextStrokeTransparency = 0
		                TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		                TextLabel.Text = 'Name: ' .. base.Name .. " | Shield: " .. math.floor(model.Shield.Value) .. " | Hull: " .. math.floor(model.Hull.Value)
		                TextLabel.ZIndex = 10
				
		            game:GetService("RunService").RenderStepped:Connect(function()
		                TextLabel.Text = 'Name: ' .. base.Name .. " | Shield: " .. math.floor(model.Shield.Value) .. " | Hull: " .. math.floor(model.Hull.Value)
		            end)
		        end
			
		    for _, part in ipairs(model["Base Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end

		        local a = Instance.new("BoxHandleAdornment")
		            a.Name = part.Name:lower().."_ESP"
		            a.Parent = part
		            a.Adornee = part
		            a.AlwaysOnTop = true
		            a.ZIndex = 0
		            a.Size = part.Size
		            a.Transparency = 0.3
		            a.Color = BrickColor.new("White")    
		    end
		end)
	else
		baselistener:Disconnect()

		for _, base in ipairs(bases:GetChildren()) do
		    if base.Name == "Mega Base" then continue end
		
		    if base.Starbase.CenterPoint:FindFirstChild("ESP") then 
				base.Starbase.CenterPoint:FindFirstChild("ESP"):Destroy()
		    end
		
		    for _, part in ipairs(base.Starbase["Base Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then part:FindFirstChildWhichIsA("BoxHandleAdornment"):Destroy() end
		    end
		end
	end
end)

espsec:addColorPicker("ESP Color", espcolor, function(val)

	espcolor = val

	local team = game.Players.LocalPlayer.Team
	local ships = game.workspace.Ships

		for _, shipteam in ipairs(ships:GetChildren()) do

			for _, ship in ipairs(shipteam:GetChildren()) do 
		    if ship:FindFirstChild("ShipParts") then 
		    	for _, part in ipairs(ship["ShipParts"]:GetDescendants()) do
		       		if not part:IsA("BasePart") then continue end

		       		if part:FindFirstChildWhichIsA("BoxHandleAdornment") then
						part:FindFirstChildWhichIsA("BoxHandleAdornment").Color3 = espcolor
			   		end

				end
		    else
			
		    for _, part in ipairs(ship["Ship Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end

			   if part:FindFirstChildWhichIsA("BoxHandleAdornment") then
				part:FindFirstChildWhichIsA("BoxHandleAdornment").Color3 = espcolor
			   end

		    end
		    end
		end
		end

		for _, base in ipairs(bases:GetChildren()) do
		    if base.Name == "Mega Base" then continue end
		    if ignoreteam == true and base.Name == tostring(team) then continue end
		
		    for _, part in ipairs(base.Starbase["Base Parts"]:GetDescendants()) do
		       if not part:IsA("BasePart") then continue end
		       if part:FindFirstChildWhichIsA("BoxHandleAdornment") then
					part:FindFirstChildWhichIsA("BoxHandleAdornment").Color3 = espcolor
				end
		end
	end

end)

-- progression page

-- ship page

local shipmainsec = shippage:addSection("Main")

shipmainsec:addButton("Unlock Warp", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/unlockwarp.lua"))()
end)
shipmainsec:addButton("Force Despawn", function()
	workspace.Bases:FindFirstChild(tostring(game.Players.LocalPlayer.Team)).Starbase.DeSpawnShip:InvokeServer()
end)
shipmainsec:addButton("Navigation (InstaTP, Quickdock, etc)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/smallketchup82/GalaxyBeta/main/navigation.lua"))()
end)

local shipmovementsection = shippage:addSection("Ship Movement")

local Players = game.Players
function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end
IYMouse = Players.LocalPlayer:GetMouse()

FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChild('Humanoid')
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

shipmovementsection:addToggle("VFly", false, function(val)
	if val == true then
		NOFLY()
		wait()
		sFLY(true)
	else
		NOFLY()
	end
end)
shipmovementsection:addSlider("VFly Speed", 1, 1, 100, function(val)
	vehicleflyspeed = tonumber(val)
end)

-- misc page

local miscsection = miscpage:addSection("Misc")

miscsection:addToggle("Side Shiplist", false, function(value)

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
		Main.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Main.ScrollBarThickness = 0
		Main.ScrollBarImageTransparency = 1

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

local settings = miscpage:addSection("Settings")

settings:addKeybind("Toggle GUI", Enum.KeyCode.RightShift, function()
    maingui:toggle()
end, function()
end)

local theme = maingui:addPage("Theme")
local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
    colors:addColorPicker(theme, color, function(color3)
    maingui:setTheme(theme, color3)
end)
end

maingui:SelectPage(maingui.pages[2], true)