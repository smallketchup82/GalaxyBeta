if ship.Configuration:FindFirstChild("NoWarp") then
    ship.Configuration.NoWarp.Value = false 
else
    print("Ship already has warp enabled")
end