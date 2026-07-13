--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
repeat wait() until game:IsLoaded() wait()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new());
end);
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Drifter0507/Shamrock/main/MainLibrary", true))();
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
pcall(function()
    for i, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        v:Disable();
    end;
end);
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local Workspace = game:GetService('Workspace');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local Players = game:GetService('Players');
local Client = Players.LocalPlayer;
local RunService = game:GetService('RunService');
local Lighting = game:GetService("Lighting");
local UIS = game:GetService("UserInputService");
local Teams = game:GetService("Teams");
local ScriptContext = game:GetService("ScriptContext");
local CoreGui = game:GetService("CoreGui");
local Camera = Workspace.CurrentCamera;
local Mouse = Client:GetMouse();
local Terrain = Workspace.Terrain;
local VirtualUser = game:GetService("VirtualUser");
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local Modules = ReplicatedStorage.Modules;
local EmoteModule = Modules.EmoteModule;
local Emotes = Client.PlayerGui.MainGUI.Game:FindFirstChild("Emotes");
local EmoteList = {"headless","zombie","zen","ninja","floss","dab"};

local Origins = {{2,0,0},{-2,0,0},{0,2,0},{0,-2,0},{0,0,1},{0,0,-1}};

local GunHighlight = Instance.new("Highlight");
local GunHandleAdornment = Instance.new("SphereHandleAdornment");

GunHighlight.FillColor = Color3.fromRGB(248, 241, 174);
GunHighlight.Adornee = Workspace:FindFirstChild("GunDrop");
GunHighlight.OutlineTransparency = 1;
GunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
GunHighlight.RobloxLocked = true;

GunHandleAdornment.Color3 = Color3.fromRGB(248, 241, 174);
GunHandleAdornment.Transparency = 0.2;
GunHandleAdornment.Adornee = Workspace:FindFirstChild("GunDrop");
GunHandleAdornment.AlwaysOnTop = true;
GunHandleAdornment.AdornCullingMode = Enum.AdornCullingMode.Never;
GunHandleAdornment.RobloxLocked = true;

GunHighlight.Parent = CoreGui;
GunHandleAdornment.Parent = CoreGui;

local TeleportDict = {
    ["Lobby"] = Vector3.new(-121.12338256836, 138.27394104004, 38.946128845215),
    ["Map"] = Vector3.new(-107.90824127197266, 138.34988403320312, -10.622464179992676),
};
local TeleportTable = {}
for i, v in pairs(TeleportDict) do
    table.insert(TeleportTable,i);
end;

local Murderer, Sheriff = nil, nil;

function GetMurderer()
    for i,v in pairs(Players:GetChildren()) do 
        if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") then
            return v.Name;
        end;
    end;
    return nil;
end;

function GetSheriff()
    for i,v in pairs(Players:GetChildren()) do 
        if v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then
            return v.Name;
        end;
    end;
    return nil;
end;
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local Character = nil;
local RootPart = nil;
local Humanoid = nil;

getgenv().WS = 16
getgenv().JP = 50
function SetCharVars()
	Character = Client.Character;
	Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid");
	RootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart");
	if getgenv().Speed then
		Humanoid.WalkSpeed = getgenv().WS;
	end;
	Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if getgenv().Speed then
			Humanoid.WalkSpeed = getgenv().WS;
		end;
	end);
    if getgenv().Jump then
		Humanoid.JumpPower = getgenv().JP;
	end;
	Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if getgenv().Jump then
			Humanoid.JumpPower = getgenv().JP;
		end;
	end);
end;
SetCharVars();
Client.CharacterAdded:Connect(SetCharVars);

--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local Window = Library:CreateWindow({Title = "Murder Mystery 2"});
local Tab1 = Window:CreateTab({Title = "Main", ScrollBar = false});
local Tab2 = Window:CreateTab({Title = "Economy", ScrollBar = false});
local Tab3 = Window:CreateTab({Title = "Roles", ScrollBar = false});

--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local ClientSection = Tab1:CreateSection({
	Title = "Client"
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local WorldSection = Tab1:CreateSection({
	Title = "World"
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local AutofarmSection = Tab2:CreateSection({
	Title = "Autofarm"
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local MurderSection = Tab3:CreateSection({
	Title = "Murderer"
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local SheriffSection = Tab3:CreateSection({
	Title = "Sheriff"
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
ClientSection:CreateToggle({
	Title = "CTRL click tp",
	Default = false,
	Callback = function(state)
        getgenv().ClickTP = state;
	end;
});
Mouse.Button1Down:connect(function()
    if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then return end;
    if not Mouse.Target then return end;
    if not getgenv().ClickTP then return end;
    Character:MoveTo(Mouse.Hit.p);
end)
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

ClientSection:CreateSlider({
	Title = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Callback = function(val)
		getgenv().WS = tonumber(val);
        getgenv().Speed = true;
        Humanoid.WalkSpeed = val;
    end
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
ClientSection:CreateSlider({
	Title = "JumpPower",
	Min = 50,
	Max = 200,
	Default = 50,
	Callback = function(val)
		getgenv().JP = tonumber(val);
        getgenv().Jump = true;
        Humanoid.JumpPower = val;
    end
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local c;
local h;
local bv;
local bav;
local cam;
local flying;
local p = Client;
local buttons = {W = false, S = false, A = false, D = false, Moving = false};

local StartFly = function ()
    if not Client.Character or not Character.Head or flying then return end;
    c = Character;
    h = Humanoid;
    h.PlatformStand = true;
    cam = workspace:WaitForChild('Camera');
    bv = Instance.new("BodyVelocity");
    bav = Instance.new("BodyAngularVelocity");
    bv.Velocity, bv.MaxForce, bv.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000;
    bav.AngularVelocity, bav.MaxTorque, bav.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000;
    bv.Parent = c.Head;
    bav.Parent = c.Head;
    flying = true;
    h.Died:connect(function() flying = false end);
end;

local EndFly = function ()
    if not p.Character or not flying then return end
    h.PlatformStand = false;
    bv:Destroy();
    bav:Destroy();
    flying = false;
end;

game:GetService("UserInputService").InputBegan:connect(function (input, GPE) 
    if GPE then return end;
    for i, e in pairs(buttons) do
        if i ~= "Moving" and input.KeyCode == Enum.KeyCode[i] then
            buttons[i] = true;
            buttons.Moving = true;
        end;
    end;
end);

game:GetService("UserInputService").InputEnded:connect(function (input, GPE) 
    if GPE then return end;
    local a = false;
    for i, e in pairs(buttons) do
        if i ~= "Moving" then
            if input.KeyCode == Enum.KeyCode[i] then
                buttons[i] = false;
            end;
            if buttons[i] then a = true end;
        end;
    end;
    buttons.Moving = a;
end);

local setVec = function (vec)
    return vec * ((getgenv().FlySpeed or 50) / vec.Magnitude);
end;

game:GetService("RunService").Heartbeat:connect(function (step) -- The actual fly function, called every frame
    if flying and c and c.PrimaryPart then
        local p = c.PrimaryPart.Position;
        local cf = cam.CFrame;
        local ax, ay, az = cf:toEulerAnglesXYZ();
        c:SetPrimaryPartCFrame(CFrame.new(p.x, p.y, p.z) * CFrame.Angles(ax, ay, az));
        if buttons.Moving then
            local t = Vector3.new();
            if buttons.W then t = t + (setVec(cf.lookVector)) end;
            if buttons.S then t = t - (setVec(cf.lookVector)) end;
            if buttons.A then t = t - (setVec(cf.rightVector)) end;
            if buttons.D then t = t + (setVec(cf.rightVector)) end;
            c:TranslateBy(t * step);
        end;
    end;
end);

ClientSection:CreateToggle({
	Title = "Fly",
	Default = false,
	Callback = function(state)
        getgenv().Flying = state;
        if getgenv().Flying then
            StartFly();
        else
            EndFly();
        end;
	end
});

ClientSection:CreateSlider({
	Title = "Fly speed",
	Min = 20,
	Max = 150,
	Default = 50,
	Callback = function(val)
        getgenv().FlySpeed = tonumber(val) or 50;
    end
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
ClientSection:CreateButton({
    Title = "Btools",
    Callback = function()
        if not Client.Backpack:FindFirstChildOfClass("HopperBin") then
            local tool1 = Instance.new("HopperBin",Client.Backpack);
            local tool2 = Instance.new("HopperBin",Client.Backpack);
            local tool3 = Instance.new("HopperBin",Client.Backpack);
            local tool4 = Instance.new("HopperBin",Client.Backpack);
            local tool5 = Instance.new("HopperBin",Client.Backpack);
            tool1.BinType = "Clone";
            tool2.BinType = "GameTool";
            tool3.BinType = "Hammer";
            tool4.BinType = "Script";
            tool5.BinType = "Grab";
        end
    end
})
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
local accessories = {}
function GodMode()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            for _, accessory in pairs(game.Players.LocalPlayer.Character.Humanoid:GetAccessories()) do
                table.insert(accessories, accessory:Clone())
            end
            game.Players.LocalPlayer.Character.Humanoid.Name = "boop"
        end
        local v = game.Players.LocalPlayer.Character["boop"]:Clone()
        v.Parent = game.Players.LocalPlayer.Character
        v.Name = "Humanoid"
        wait(0.1)
        game.Players.LocalPlayer.Character["boop"]:Destroy()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        for _, accessory in pairs(accessories) do
            game.Players.LocalPlayer.Character.Humanoid:AddAccessory(accessory)
        end
        game.Players.LocalPlayer.Character.Animate.Disabled = true
        wait(0.1)
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    end
end


ClientSection:CreateButton({
    Title = "Godmode",
    Callback = function()
        GodMode()
    end
})

ClientSection:CreateButton({
	Title = "Force respawn",
	Callback = function()
		Character.Head:Remove();
		Humanoid.BreakJointsOnDeath = false;
		Humanoid.Health = 0;
	end;
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
ClientSection:CreateButton({
    Title = "Get all emotes",
    Callback = function()
		require(EmoteModule).GeneratePage(EmoteList,Emotes,'Free Emotes');
    end
})
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

local folder = Instance.new("Folder",CoreGui);
folder.Name = "ESP Holder";
	
local function AddBillboard(player)
    local billboard = Instance.new("BillboardGui",folder);
    billboard.Name = player.Name;
    billboard.AlwaysOnTop = true;
    billboard.Size = UDim2.fromOffset(200,50);
    billboard.ExtentsOffset = Vector3.new(0,3,0);
    billboard.Enabled = false

    local textLabel = Instance.new("TextLabel",billboard);
    textLabel.TextSize = 20;
    textLabel.Text = player.Name;
    textLabel.Font = Enum.Font.SourceSans;
    textLabel.BackgroundTransparency = 1;
    textLabel.Size = UDim2.fromScale(1,1);

    if getgenv().AllEsp then
        billboard.Enabled = true
    end
    repeat
        wait()
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Head") then
                billboard.Adornee = player.Character.Head;
            end
            if player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
                textLabel.TextColor3 = Color3.new(1,0,0);
                if not billboard.Enabled and getgenv().MurderEsp then
                    billboard.Enabled = true
                end
            elseif player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
                textLabel.TextColor3 = Color3.new(0,0,1);
                if not billboard.Enabled and getgenv().SheriffEsp then
                    billboard.Enabled = true
                end
            else
                textLabel.TextColor3 = Color3.new(0,1,0);
            end;
        end);
    until not player.Parent;
end;

for _,player in pairs(Players:GetPlayers()) do
    if player ~= Client then
        coroutine.wrap(AddBillboard)(player);
    end;
end;
Players.PlayerAdded:Connect(AddBillboard);

Players.PlayerRemoving:Connect(function(player)
    if folder:FindFirstChild(player.Name) then
        folder[player.Name]:Destroy();
    end
end);


WorldSection:CreateToggle({
	Title = "Player ESP",
	Default = false,
	Callback = function(state)
        getgenv().AllEsp = state;
        for i, v in pairs(folder:GetChildren()) do
            if v:IsA("BillboardGui") and Players[tostring(v.Name)] then
                if getgenv().AllEsp then
                    v.Enabled = true;
                else
                    v.Enabled = false;
                end;
            end;
        end;
	end
});

WorldSection:CreateToggle({
	Title = "Murderer ESP",
	Default = false,
	Callback = function(state)
        getgenv().MurderEsp = state;
        while getgenv().MurderEsp do
            wait()
            pcall(function()
                for i, v in pairs(folder:GetChildren()) do
                    if v:IsA("BillboardGui") and Players[tostring(v.Name)] then
                        local player = Players[tostring(v.Name)]
                        if player.Character and (player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")) then
                            if getgenv().MurderEsp then
                                v.Enabled = true;
                            else
                                v.Enabled = false;
                            end;
                        end
                    end;
                end;
            end);
        end;
	end
});

WorldSection:CreateToggle({
	Title = "Sheriff ESP",
	Default = false,
	Callback = function(state)
        getgenv().SheriffEsp = state;
        while getgenv().SheriffEsp do
            wait()
            pcall(function()
                for i, v in pairs(folder:GetChildren()) do
                    if v:IsA("BillboardGui") and Players[tostring(v.Name)] then
                        local player = Players[tostring(v.Name)]
                        if player.Character and (player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")) then
                            if getgenv().SheriffEsp then
                                v.Enabled = true;
                            else
                                v.Enabled = false;
                            end;
                        end
                    end;
                end;
            end);
        end;
	end
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
SheriffSection:CreateToggle({
	Title = "Gun ESP",
	Default = false,
    Order = 50,
	Callback = function(state)
        getgenv().GunESP = state;
	end
});

coroutine.wrap(function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if getgenv().GunESP then
                local gundrop = Workspace:FindFirstChild("GunDrop");
                GunHighlight.Adornee = gundrop;
                GunHandleAdornment.Adornee = gundrop;
                if gundrop then 
                    GunHandleAdornment.Size = gundrop.Size + Vector3.new(0.05, 0.05, 0.05) ;
                end;
        
                GunHighlight.Enabled = getgenv().GunESP;
                GunHandleAdornment.Visible = getgenv().GunESP;
            else
                GunHighlight.Enabled = false;
                GunHandleAdornment.Visible = false;
            end;
        end);
    end);
end)();
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--

function XrayOn(obj)
    for _,v in pairs(obj:GetChildren()) do
        if (v:IsA("BasePart")) and not v.Parent:FindFirstChild("Humanoid") then
            v.LocalTransparencyModifier = 0.75;
        end;
        XrayOn(v);
    end;
end;

function XrayOff(obj)
    for _,v in pairs(obj:GetChildren()) do
        if (v:IsA("BasePart")) and not v.Parent:FindFirstChild("Humanoid") then
            v.LocalTransparencyModifier = 0;
        end ;
        XrayOff(v);
    end;
end;

WorldSection:CreateToggle({
	Title = "Xray",
	Default = false,
	Callback = function(state)
        getgenv().Xray = state;
        if getgenv().Xray then
            XrayOn(Workspace);
        else
            XrayOff(Workspace);
        end;
	end
});
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
WorldSection:CreateButton({
    Title = "Unlock workspace",
    Callback = function()
        function unlock(obj)
			for i,v in pairs(obj:GetChildren()) do
				if v:IsA("BasePart") then
					v.Locked = false;
				end;
				unlock(v);
			end;
		end;
		unlock(workspace);
    end
})
--<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>----<>--
WorldSection:CreateDropdown({
	Text = "Teleports",
	Array = TeleportTable,
	Callback = function(val)
        if val == "Map" then
            for _,child in pairs(Workspace:GetDescendants()) do
                if child:IsA("BasePart") and child.Name == "Coin_Server" then
  