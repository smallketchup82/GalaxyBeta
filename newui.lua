local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
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
local teleportpage = maingui:addPage("Teleports")
local dockpage = maingui:addPage("Dock")
local miscpage = maingui:addPage("Misc")

local theme = maingui:addPage("Theme", 5012544693)
local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
    colors:addColorPicker(theme, color, function(color3)
    maingui:setTheme(theme, color3)
end)
end