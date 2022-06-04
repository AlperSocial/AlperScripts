if (_G.replayScriptRan) then return end;
_G.replayScriptRan = true;

local target = 'YOUR_TARGET_NAME_HERE'; -- Change this to your target's name.
local bindKey = {Enum.KeyCode.LeftControl, Enum.KeyCode.Q}; -- By default it's left control + Q (qwerty) or (A) azerty.
local bindKey2 = {Enum.KeyCode.LeftControl, Enum.KeyCode.Z}; -- By default it's left control + Z (qwerty) or (W) azerty.

local Maid = {};

do -- // Maid
    Maid.ClassName = "Maid"

    function Maid.new()
        return setmetatable({
            _tasks = {}
        }, Maid)
    end

    function Maid.isMaid(value)
        return type(value) == "table" and value.ClassName == "Maid"
    end

    function Maid.__index(self, index)
        if Maid[index] then
            return Maid[index]
        else
            return self._tasks[index]
        end
    end

    function Maid:__newindex(index, newTask)
        if Maid[index] ~= nil then
            error(("'%s' is reserved"):format(tostring(index)), 2)
        end

        local tasks = self._tasks
        local oldTask = tasks[index]

        if oldTask == newTask then
            return
        end

        tasks[index] = newTask

        if oldTask then
            if type(oldTask) == "function" then
                oldTask()
            elseif typeof(oldTask) == "RBXScriptConnection" then
                oldTask:Disconnect()
            elseif typeof(oldTask) == 'table' then
                oldTask:Remove();
            elseif oldTask.Destroy then
                oldTask:Destroy()
            end
        end
    end

    function Maid:GiveTask(task)
        if not task then
            error("Task cannot be false or nil", 2)
        end

        local taskId = #self._tasks+1
        self[taskId] = task

        if typeof(task) == 'table' and not task.Remove then
            warn("[Maid.GiveTask] - Gave table task without .Remove\n\n" .. debug.traceback())
        end

        return taskId
    end

    function Maid:DoCleaning()
        local tasks = self._tasks

        for index, task in pairs(tasks) do
            if typeof(task) == "RBXScriptConnection" then
                tasks[index] = nil
                task:Disconnect()
            end
        end

        local index, task = next(tasks)
        while task ~= nil do
            tasks[index] = nil
            if type(task) == "function" then
                task()
            elseif typeof(task) == "RBXScriptConnection" then
                task:Disconnect()
            elseif typeof(task) == 'table' then
                task:Remove();
            elseif task.Destroy then
                task:Destroy()
            end
            index, task = next(tasks)
        end
    end

    Maid.Destroy = Maid.DoCleaning
end;

local runService = game:GetService('RunService');
local players = game:GetService('Players');
local userInputService = game:GetService('UserInputService');

local localPlayer = players.LocalPlayer;
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait();

local maid = Maid.new();
local isRecording = false;

local frameRate = 60;

local playerCF = {};
local playerAnims = {};

local recordLabel = Drawing.new('Text');
recordLabel.Visible = true;
recordLabel.Size = 30;
recordLabel.Color = Color3.fromHex('ffffff');
recordLabel.Transparency = 1;
recordLabel.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 50);
recordLabel.Center = true;

local function reverseTable(t)
	local newT = {};

	for i = #t, 1, -1 do
		table.insert(newT, t[i]);
	end;

	return newT;
end;

local function startRecording()
	table.clear(playerAnims);
	table.clear(playerCF);

	local rootPart = character.HumanoidRootPart;
	local humanoid = character.Humanoid;
	
	local startedAt = tick();
    local lastRanAt = 0;

	maid:GiveTask(runService.Heartbeat:Connect(function()
        if (tick() - lastRanAt < 1/frameRate) then return end;
        lastRanAt = tick();

		local cframe = rootPart.CFrame;
		
		table.insert(playerCF, cframe);
	end));

    for _, animTrack in next, humanoid:GetPlayingAnimationTracks() do
        task.spawn(function()
            local animData = {};
    
            animData.animation = animTrack.Animation.AnimationId;
            animData.startedAt = 0;
            animData.position = animTrack.TimePosition;
            animData.looped = animTrack.Looped;
            animData.speed = animTrack.Speed;
            animData.priority = animTrack.Priority;
            animData.weightTarget = animTrack.WeightTarget;

            animTrack.Stopped:Wait();

            animData.stoppedAt = tick() - startedAt;
            table.insert(playerAnims, animData);
        end);
    end;
	
	maid:GiveTask(humanoid.Animator.AnimationPlayed:Connect(function(animTrack)
        task.wait();
		local animData = {};
    
		animData.animation = animTrack.Animation.AnimationId;
		animData.startedAt = tick() - startedAt;
		animData.looped = animTrack.Looped;
        animData.speed = animTrack.Speed;
		animData.priority = animTrack.Priority;
        animData.weightTarget = animTrack.WeightTarget;

		animTrack.Stopped:Wait();

		animData.stoppedAt = tick() - startedAt;
		table.insert(playerAnims, animData);
	end));
end;

local function playRecord()
    local realPlayerCF = reverseTable(playerCF);
    local targetChar = players:FindFirstChild(target) and players:FindFirstChild(target).Character;

    if (not targetChar) then
        return messagebox('Target not found', 'Error', 0);
    end;

    targetChar.Archivable = true;

    local newCharacter = targetChar:Clone();

    for i, v in next, newCharacter:GetDescendants() do
        if (v:IsA('LuaSourceContainer')) then
            v:Destroy();
        end;
    end;

    local fakeCharRoot = newCharacter.HumanoidRootPart;
    local fakeCharHumanoid = newCharacter.Humanoid;

    fakeCharRoot.Anchored = true;
    fakeCharRoot.CFrame = table.remove(realPlayerCF);

    newCharacter.Parent = workspace;

    local lastRanAt = 0;

    maid:GiveTask(runService.Heartbeat:Connect(function()
        if (tick() - lastRanAt < 1/frameRate) then return end;
        lastRanAt = tick();
        local cf = table.remove(realPlayerCF);
        if (not cf) then return maid:Destroy() end;
        fakeCharRoot.CFrame = cf;
    end));

    for i, v in next, playerAnims do
        local animInstance = Instance.new('Animation');
        animInstance.AnimationId = v.animation;

        task.delay(v.startedAt, function()
            local anim = newCharacter.Humanoid.Animator:LoadAnimation(animInstance);

            anim.Priority = v.priority;
            anim.Looped = v.looped;
            anim.TimePosition = v.position or 0;

            anim:Play(nil, v.weightTarget, v.speed);
            task.wait(v.stoppedAt - v.startedAt);
            anim:Stop();
            animInstance:Destroy();
        end);
    end;
end;

local function toggleRecord()
	if (isRecording) then
		maid:DoCleaning();
        recordLabel.Visible = false;
	else
        recordLabel.Visible = true;
        recordLabel.Text = 'Recording...';
		startRecording();
	end;

	isRecording = not isRecording;
end;

local function isKeyComboPressed(comboTable)
    for _, key in next, comboTable do
        if (not userInputService:IsKeyDown(key)) then
            return false;
        end;
    end;

    return true;
end;

local function onInputBegan(inputObject, gpe)
    if (inputObject.KeyCode == Enum.KeyCode.Unknown) then return end;

    if (isKeyComboPressed(bindKey)) then
        toggleRecord();
    elseif (isKeyComboPressed(bindKey2)) then
        playRecord();
    end;
end;

userInputService.InputBegan:Connect(onInputBegan);
