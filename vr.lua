local LocalPlayer = game:GetService("Players").LocalPlayer
local Heartbeat = game:GetService("RunService").Heartbeat

Heartbeat:Connect(function()
    LocalPlayer.MaximumSimulationRadius = math.huge
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
end)

wait(0.3)

    -- when you reset make sure to re-execute this or just make this execute in a loop
for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
    if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
    game:GetService("RunService").Heartbeat:connect(function()
    v.Velocity = Vector3.new(-30,0,0)
    end)
    end
    end


    game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "Netless Ran";
        Text = "Now Running VR";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
    Duration = 16;
    
	game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "Credits";
        Text = "VR Script made by ShownApe#7272 in the ONEReverseCard's Discord and Netless by Nullware";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
    Duration = 16;

wait(0.5)


game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "Credits";
        Text = "ONEReverseCard's Discord is copied to your clipboard.";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
    Duration = 16;


setclipboard("https://discord.gg/Hbq3TgAJbB")

wait(1)

loadstring(game:HttpGet("https://raw.githubusercontent.com/ShownApe/VR-Scripts/main/clovr_tool_holding_netless.lua"))() 
