local console = {}
local function RandomString(t)
	return t[math.random(1, #t)]
end

print(RandomString(table))

while true do
	thing = math.random(10, 120)
	wait(thing)
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end

while true do
	thing = math.random(10, 120)
	tooslow = math.random(1, 10)
	wait(thing)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (tooslow)
	wait(0.5)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (16)
end

while true do
	thing = math.random(10, 120)
	highjump = math.random(50, 100)
	wait(thing)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = (highjump)
	wait(0.1)
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
	wait(1)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end

while true do
    thing = math.random(10, 120)
    wait(thing)
    x = game.Players.LocalPlayer.Character.UpperTorso.Position.x
    y = game.Players.LocalPlayer.Character.UpperTorso.Position.y
    z = game.Players.LocalPlayer.Character.UpperTorso.Position.z

    randomy = math.random(y, 200)

    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(x, randomy, z))
end

while true do
	thing = math.random(10, 120)
	wait(thing)
	game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.gkeoOoa:FireServer()
end

