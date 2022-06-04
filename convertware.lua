--// Enjoy! Join the discord for info on how to use https://discord.gg/eTTjPKBdfT
loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/CONVERTWARE/main/UI/main.lua',true))()

_G.loopnetbypass = true;
local LocalPlayer = game:GetService("Players").LocalPlayer
local Heartbeat = game:GetService("RunService").Heartbeat

spawn(function()
    function doloop()
        while _G.loopnetbypass == true do

            Heartbeat:Connect(function()
                LocalPlayer.MaximumSimulationRadius = math.huge
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end)

    -- when you reset make sure to re-execute this or just make this execute in a loop
            for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
                if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
                game:GetService("RunService").Heartbeat:connect(function()
                v.Velocity = Vector3.new(-30,0,0)
                end)
                end
                end
            end
        end
    end)