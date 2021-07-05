if game.PlaceId ~= 263135585 then print("run this in galaxy beta you monkey") return end
print("Running Galaxy Beta Utilities!")
local UILibrary = loadstring(game:HttpGet("https://descended.glitch.me/lualibs/twilight.lua"))()

local MainUI = UILibrary.Load("Roblox Galaxy Beta Utilities - Navigation")

local teleportpage = MainUI.AddPage("Teleports", true)
local dockpage = MainUI.AddPage("Dock", true)

local bases = game.Workspace.Bases
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

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