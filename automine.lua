local AutoMineBeta = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local title = Instance.new("TextLabel")
local enabledindicator = Instance.new("TextLabel")
local enabled = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local killswitch = Instance.new("TextButton")
local instructiontitle = Instance.new("TextLabel")
local instructions = Instance.new("TextLabel")
local minimize = Instance.new("TextButton")

AutoMineBeta.Name = "AutoMineBeta"
AutoMineBeta.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Main.Name = "Main"
Main.Parent = AutoMineBeta
Main.Active = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Selectable = true
Main.Size = UDim2.new(0.300000012, 0, 0.400000006, 0)
Main.Draggable = true

title.Name = "title"
title.Parent = Main
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1.000
title.BorderSizePixel = 0
title.ClipsDescendants = true
title.Position = UDim2.new(0.500263333, 0, 0, 0)
title.Size = UDim2.new(1, 0, 0.100000001, 0)
title.Font = Enum.Font.ArialBold
title.Text = "Galaxy Beta Automine"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextSize = 14.000
title.TextStrokeTransparency = 0.000
title.TextWrapped = true

enabledindicator.Name = "enabledindicator"
enabledindicator.Parent = Main
enabledindicator.AnchorPoint = Vector2.new(0.5, 0.5)
enabledindicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
enabledindicator.BackgroundTransparency = 1.000
enabledindicator.BorderSizePixel = 0
enabledindicator.Position = UDim2.new(0.5, 0, 0.400000006, 0)
enabledindicator.Size = UDim2.new(0.5, 0, 0.100000001, 0)
enabledindicator.Font = Enum.Font.ArialBold
enabledindicator.Text = "Enabled:"
enabledindicator.TextColor3 = Color3.fromRGB(255, 255, 255)
enabledindicator.TextScaled = true
enabledindicator.TextSize = 14.000
enabledindicator.TextStrokeTransparency = 0.000
enabledindicator.TextWrapped = true

enabled.Name = "enabled"
enabled.Parent = Main
enabled.AnchorPoint = Vector2.new(0.5, 0.5)
enabled.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
enabled.Position = UDim2.new(0.5, 0, 0.5, 0)
enabled.Size = UDim2.new(0.5, 0, 0.100000001, 0)
enabled.Font = Enum.Font.ArialBold
enabled.Text = "✖"
enabled.TextColor3 = Color3.fromRGB(255, 255, 255)
enabled.TextScaled = true
enabled.TextSize = 14.000
enabled.TextStrokeTransparency = 0.000
enabled.TextWrapped = true

UICorner.Parent = enabled

UICorner_2.CornerRadius = UDim.new(0.0500000007, 0)
UICorner_2.Parent = Main

killswitch.Name = "killswitch"
killswitch.Parent = Main
killswitch.AnchorPoint = Vector2.new(0.5, 0)
killswitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
killswitch.BackgroundTransparency = 1.000
killswitch.ClipsDescendants = true
killswitch.Position = UDim2.new(0.949999988, 0, 0.0199999996, 0)
killswitch.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
killswitch.AutoButtonColor = false
killswitch.Font = Enum.Font.ArialBold
killswitch.Text = "X"
killswitch.TextColor3 = Color3.fromRGB(255, 255, 255)
killswitch.TextScaled = true
killswitch.TextSize = 14.000
killswitch.TextStrokeTransparency = 0.000
killswitch.TextWrapped = true

instructiontitle.Name = "instructiontitle"
instructiontitle.Parent = Main
instructiontitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
instructiontitle.BackgroundTransparency = 1.000
instructiontitle.BorderSizePixel = 0
instructiontitle.Position = UDim2.new(0, 0, 0.600000024, 0)
instructiontitle.Size = UDim2.new(1, 0, 0.100000001, 0)
instructiontitle.Font = Enum.Font.ArialBold
instructiontitle.Text = "Instructions:"
instructiontitle.TextColor3 = Color3.fromRGB(255, 255, 255)
instructiontitle.TextScaled = true
instructiontitle.TextSize = 14.000
instructiontitle.TextWrapped = true

instructions.Name = "instructions"
instructions.Parent = Main
instructions.AnchorPoint = Vector2.new(0.5, 1)
instructions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
instructions.BackgroundTransparency = 1.000
instructions.BorderSizePixel = 0
instructions.Position = UDim2.new(0.5, 0, 1, 0)
instructions.Size = UDim2.new(1, 0, 0.300000012, 0)
instructions.Font = Enum.Font.ArialBold
instructions.Text = "In order for this script to work, you must be docked at mega base and have a miner spawned. For the best results do not be inside of the ship while it is AutoMining. If the script fails for any reason, press the X in the top right corner which will kill the script. Then re-execute the script."
instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
instructions.TextScaled = true
instructions.TextSize = 14.000
instructions.TextStrokeTransparency = 0.000
instructions.TextWrapped = true

minimize.Name = "minimize"
minimize.Parent = Main
minimize.AnchorPoint = Vector2.new(0.5, 0)
minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimize.BackgroundTransparency = 1.000
minimize.ClipsDescendants = true
minimize.Position = UDim2.new(0.899973631, 0, 0.0199999996, 0)
minimize.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
minimize.AutoButtonColor = false
minimize.Font = Enum.Font.ArialBold
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextScaled = true
minimize.TextSize = 14.000
minimize.TextStrokeTransparency = 0.000
minimize.TextWrapped = true

local currentenabled = false

killswitch.Activated:Connect(function()
	currentenabled = false
	AutoMineBeta:Destroy()
	script:Destroy()
end)

minimize.Visible = false -- in testing
minimize.Activated:Connect(function()
    if Main.Visible == true then
        Main.Visible = false
    else
        Main.Visible = true
    end
end)

local function disableautomine()
	enabled.Text = "✖"
	currentenabled = false
end

local function enableautomine()
	enabled.Text = "✓"
	currentenabled = true
end


enabled.Activated:Connect(function()
	if currentenabled == false then 
		enableautomine()

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
						disableautomine()
						print("No miner currently spawned!")
                        break
					end

					for i = 1, 100 do
						coroutine.resume(coroutine.create(function()
							local args = {
								[1] = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0.031546838581562, 0.82163470983505, -0.56914073228836)),
								[2] = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0.56289011240005, -0.021682156249881, 0.82624727487564)),
								[3] = 1144.869140625,
								[4] = workspace.Asteroids:FindFirstChild("Silicate Ore"),
								[5] = workspace.Asteroids:FindFirstChild("Silicate Ore").CenterPoint
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
					end
				end
			end)
		end
	else
	    enabled.Text = "✖"
		currentenabled = false
	end
end)
