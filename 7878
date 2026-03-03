--[[ 
    YC GUI Library - Final Release
    Author: BeiHai
    
    更新内容:
    1. [优化] 移除了设置页面的所有测试控件，保持严谨。
    2. [修复] 开启 UI 时，全屏遮罩层(Backdrop)现在会拦截所有点击，防止操作穿透到游戏世界。
    3. [保留] 颜色选择器拖拽修复、自定义宽高设置、完整主题库。
]]

local Library = {}
local ConfigName = "YCUI/settings_final.json"

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// 辅助函数 //--
local function GetFirstChar(str)
	local first = ""
	for _, code in utf8.codes(str) do first = utf8.char(code); break end
	return first ~= "" and first or string.sub(str, 1, 1)
end

local function ToHSV(color)
	local h, s, v = Color3.toHSV(color)
	return h, s, v
end

local function FromHSV(h, s, v)
	return Color3.fromHSV(h, s, v)
end

--// 默认配置 //--
local DefaultConfig = {
	ShowHUD = true,
	ShowNotifs = true,
	NotifDuration = 3,
	UIScale = 1.0,
	WindowWidth = 200, 
	WindowMaxHeight = 350,
	ItemHeight = 34,
	Theme = "Default",
	UIVisible = true,
	UseCorners = true, 
	UseStroke = true   
}

Library.Config = HttpService:JSONDecode(HttpService:JSONEncode(DefaultConfig))

Library.Globals = {
	Windows = {},
	Elements = {},
	ThemeObjects = {},
	StyleObjects = {}, 
	ActiveNotifs = {},
	BoundKeys = {},
	IslandPosition = Vector2.new(0,0),
	IslandObject = nil,
	HUDGradients = {},
	SubWindows = {},
	TopZIndex = 100,
    ActivePicker = nil 
}

--// 主题系统 //--
Library.Themes = {
	["Default"] = { 
		Name = "紫罗兰 (Default)",
		Main = Color3.fromRGB(20, 20, 25), MainTrans = 0.1, Gradient1 = Color3.fromRGB(140, 40, 255),
		Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(160, 160, 170),
		SettingBg = Color3.fromRGB(25, 25, 30), Accent = Color3.fromRGB(100, 20, 220),
		Scroll = Color3.fromRGB(80, 60, 100), PickerBg = Color3.fromRGB(30, 30, 35)
	},
	["Ocean"] = { 
		Name = "深海蓝 (Ocean)",
		Main = Color3.fromRGB(15, 25, 30), MainTrans = 0.1, Gradient1 = Color3.fromRGB(0, 160, 255),
		Text = Color3.fromRGB(240, 255, 255), TextDark = Color3.fromRGB(140, 160, 170),
		SettingBg = Color3.fromRGB(20, 30, 35), Accent = Color3.fromRGB(0, 100, 180),
		Scroll = Color3.fromRGB(50, 70, 90), PickerBg = Color3.fromRGB(20, 35, 40)
	},
	["Rose"] = { 
		Name = "暗红玫瑰 (Rose)",
		Main = Color3.fromRGB(25, 15, 15), MainTrans = 0.1, Gradient1 = Color3.fromRGB(220, 20, 60),
		Text = Color3.fromRGB(255, 230, 230), TextDark = Color3.fromRGB(180, 120, 120),
		SettingBg = Color3.fromRGB(35, 20, 20), Accent = Color3.fromRGB(150, 0, 40),
		Scroll = Color3.fromRGB(90, 50, 50), PickerBg = Color3.fromRGB(40, 25, 25)
	},
	["Sakura"] = { 
		Name = "家乡樱花 (Sakura)",
		Main = Color3.fromRGB(30, 25, 35), MainTrans = 0.1, Gradient1 = Color3.fromRGB(255, 160, 200),
		Text = Color3.fromRGB(255, 245, 250), TextDark = Color3.fromRGB(180, 150, 170),
		SettingBg = Color3.fromRGB(40, 30, 45), Accent = Color3.fromRGB(255, 105, 180),
		Scroll = Color3.fromRGB(90, 60, 80), PickerBg = Color3.fromRGB(45, 35, 40)
	},
	["Mint"] = { 
		Name = "薄荷绿 (Mint)",
		Main = Color3.fromRGB(20, 30, 25), MainTrans = 0.1, Gradient1 = Color3.fromRGB(50, 255, 150),
		Text = Color3.fromRGB(240, 255, 240), TextDark = Color3.fromRGB(150, 180, 160),
		SettingBg = Color3.fromRGB(25, 40, 30), Accent = Color3.fromRGB(0, 180, 100),
		Scroll = Color3.fromRGB(40, 90, 60), PickerBg = Color3.fromRGB(25, 35, 30)
	},
	["Midnight"] = { 
		Name = "午夜 (Midnight)",
		Main = Color3.fromRGB(10, 10, 12), MainTrans = 0.05, Gradient1 = Color3.fromRGB(255, 140, 0),
		Text = Color3.fromRGB(220, 220, 220), TextDark = Color3.fromRGB(100, 100, 100),
		SettingBg = Color3.fromRGB(15, 15, 20), Accent = Color3.fromRGB(255, 100, 0),
		Scroll = Color3.fromRGB(60, 40, 20), PickerBg = Color3.fromRGB(18, 18, 22)
	},
	["Sunset"] = { 
		Name = "日落 (Sunset)",
		Main = Color3.fromRGB(30, 20, 30), MainTrans = 0.1, Gradient1 = Color3.fromRGB(255, 69, 0),
		Text = Color3.fromRGB(255, 240, 230), TextDark = Color3.fromRGB(180, 140, 140),
		SettingBg = Color3.fromRGB(40, 25, 35), Accent = Color3.fromRGB(180, 50, 100),
		Scroll = Color3.fromRGB(100, 60, 80), PickerBg = Color3.fromRGB(40, 30, 35)
	}
}
local CurrentThemeData = Library.Themes["Default"]

local function CheckFolder() if not isfolder("YCUI") then makefolder("YCUI") end end
local function SaveConfig() CheckFolder(); pcall(function() writefile(ConfigName, HttpService:JSONEncode(Library.Config)) end) end
local function LoadConfig()
	CheckFolder()
	if isfile(ConfigName) then
		local s, r = pcall(function() return HttpService:JSONDecode(readfile(ConfigName)) end)
		if s and r then for k,v in pairs(r) do Library.Config[k]=v end; CurrentThemeData = Library.Themes[Library.Config.Theme] or Library.Themes["Default"] end
	end
end
LoadConfig()

if game.CoreGui:FindFirstChild("YC_GUI_Final") then game.CoreGui.YC_GUI_Final:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YC_GUI_Final"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false 
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- [核心修改] 防止穿透
-- Active = true 会吞噬所有点击事件，防止其传递到游戏世界
local Backdrop = Instance.new("Frame"); 
Backdrop.Name="Backdrop"; 
Backdrop.Parent=ScreenGui
Backdrop.BackgroundColor3=Color3.new(0,0,0); 
Backdrop.BackgroundTransparency=1; 
Backdrop.Size=UDim2.new(1,0,1,0); 
Backdrop.ZIndex=0; 
Backdrop.Visible=false
Backdrop.Active = true -- [重要] 开启输入拦截

--// HUD 垂直流光 //--
local function UpdateHUDGradients()
    local theme = CurrentThemeData
    local t = tick() * 2
    local phase = (math.sin(t) + 1) / 2 
    local c1 = theme.Accent:Lerp(theme.Gradient1, phase)
    local c2 = theme.Gradient1:Lerp(Color3.new(1,1,1), phase * 0.3) 
    local c3 = theme.Accent:Lerp(theme.Gradient1, 1 - phase) 
    local seq = ColorSequence.new{ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3)}
    for _, gradient in pairs(Library.Globals.HUDGradients) do
        if gradient and gradient.Parent then gradient.Color = seq; gradient.Rotation = -90 end
    end
end
RunService.RenderStepped:Connect(UpdateHUDGradients)

--// Loader //--
function Library:LoadLoader()
	local Loader = Instance.new("ScreenGui"); Loader.Name="YC_Loader"; Loader.IgnoreGuiInset=true; Loader.DisplayOrder=10000; Loader.Parent=CoreGui
	local Main = Instance.new("Frame"); Main.Parent=Loader; Main.BackgroundColor3=Color3.new(0,0,0); Main.BackgroundTransparency=0; Main.Size=UDim2.new(1,0,1,0); Main.ZIndex=1
	local Cen = Instance.new("Frame"); Cen.Parent=Main; Cen.Size=UDim2.new(0,400,0,150); Cen.AnchorPoint=Vector2.new(0.5,0.5); Cen.Position=UDim2.new(0.5,0,0.5,0); Cen.BackgroundTransparency=1; Cen.ZIndex=2
	
	local MainTitle = Instance.new("TextLabel"); MainTitle.Parent = Cen; MainTitle.Text = "YC GUI"; MainTitle.Font = Enum.Font.GothamBlack; MainTitle.TextSize = 60; MainTitle.TextColor3 = Color3.new(1,1,1); MainTitle.Size = UDim2.new(1, 0, 0, 70); MainTitle.Position = UDim2.new(0, 0, 0.5, -40); MainTitle.AnchorPoint = Vector2.new(0, 0.5); MainTitle.BackgroundTransparency = 1; MainTitle.TextTransparency = 1
	local TitleScale = Instance.new("UIScale"); TitleScale.Parent = MainTitle; TitleScale.Scale = 1.1
	local MainGradient = Instance.new("UIGradient"); MainGradient.Parent = MainTitle; MainGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))}
	
    local SubTitle = Instance.new("TextLabel"); SubTitle.Parent = Cen; SubTitle.Text = "By BeiHai"; SubTitle.Font = Enum.Font.Gotham; SubTitle.TextSize = 16; SubTitle.TextColor3 = Color3.fromRGB(220, 220, 220); SubTitle.Size = UDim2.new(1, 0, 0, 20); SubTitle.AnchorPoint = Vector2.new(1, 0); SubTitle.Position = UDim2.new(1, -20, 0.5, 25); SubTitle.TextXAlignment = Enum.TextXAlignment.Right; SubTitle.BackgroundTransparency = 1; SubTitle.TextTransparency = 1

	Main.BackgroundTransparency = 0.3
	local t1 = TweenService:Create(MainTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
	local t2 = TweenService:Create(TitleScale, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1.0})
	t1:Play(); t2:Play()
	task.wait(0.4)
	local subPosFinal = UDim2.new(1, -20, 0.5, 15)
	local t3 = TweenService:Create(SubTitle, TweenInfo.new(1.0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0, Position = subPosFinal})
	t3:Play()
	task.spawn(function() local s = tick(); while Loader.Parent do MainGradient.Rotation = math.sin(tick()) * 15; RunService.RenderStepped:Wait() end end)
	task.wait(1.5)
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
	TweenService:Create(MainTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
	TweenService:Create(TitleScale, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 1.1}):Play()
	TweenService:Create(SubTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, Position = subPosFinal + UDim2.new(0,0,0,10)}):Play()
	task.wait(0.5)
	ScreenGui.Enabled = true
	Loader:Destroy()
end

--// 样式系统 //--
local function RegisterStyle(obj, hasStroke, cornerRadius)
	table.insert(Library.Globals.StyleObjects, {Object = obj, HasStroke = hasStroke, Radius = cornerRadius})
	local Corner = obj:FindFirstChild("UICorner") or Instance.new("UICorner")
	Corner.Parent = obj
	Corner.CornerRadius = UDim.new(0, Library.Config.UseCorners and cornerRadius or 0)
	if hasStroke then
		local Stroke = obj:FindFirstChild("UIStroke") or Instance.new("UIStroke")
		Stroke.Parent = obj
		Stroke.Thickness = 1.5
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Color = CurrentThemeData.Accent 
		Stroke.Transparency = Library.Config.UseStroke and 0 or 1
	end
end

function Library:RefreshStyle()
	local useCorners = Library.Config.UseCorners
	local useStroke = Library.Config.UseStroke
	
	for _, data in ipairs(Library.Globals.StyleObjects) do
		local obj = data.Object
		if obj and obj.Parent then
			local Corner = obj:FindFirstChild("UICorner")
			if Corner then
				TweenService:Create(Corner, TweenInfo.new(0.3), {CornerRadius = UDim.new(0, useCorners and data.Radius or 0)}):Play()
			end
			if data.HasStroke then
				local Stroke = obj:FindFirstChild("UIStroke")
				if Stroke then
					TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = useStroke and 0 or 1, Color = CurrentThemeData.Accent}):Play()
				end
			end
		end
	end
end

--// 主题更新 //--
local function RegisterObject(obj, type)
	table.insert(Library.Globals.ThemeObjects, {Object = obj, Type = type})
	local theme = CurrentThemeData
	if type == "Window" then obj.BackgroundColor3 = theme.Main; obj.BackgroundTransparency = theme.MainTrans
	elseif type == "Text" then obj.TextColor3 = theme.Text
	elseif type == "TextDark" then obj.TextColor3 = theme.TextDark
	elseif type == "SettingBg" then obj.BackgroundColor3 = theme.SettingBg
	elseif type == "Accent" then obj.BackgroundColor3 = theme.Accent
    elseif type == "PickerBg" then obj.BackgroundColor3 = theme.PickerBg
	elseif type == "Scroll" then obj.ScrollBarImageColor3 = theme.Scroll
	elseif type == "NotifGradient" then 
		obj.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, theme.Accent), ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, theme.Accent)}
	end
end

function Library:RefreshTheme()
	local theme = CurrentThemeData
	for _, data in ipairs(Library.Globals.ThemeObjects) do
		local obj = data.Object
		if obj and obj.Parent then
			if data.Type == "Window" then TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundColor3 = theme.Main}):Play()
			elseif data.Type == "Text" then TweenService:Create(obj, TweenInfo.new(0.5), {TextColor3 = theme.Text}):Play()
			elseif data.Type == "TextDark" then TweenService:Create(obj, TweenInfo.new(0.5), {TextColor3 = theme.TextDark}):Play()
			elseif data.Type == "Accent" then TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundColor3 = theme.Accent}):Play()
            elseif data.Type == "PickerBg" then TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundColor3 = theme.PickerBg}):Play()
			elseif data.Type == "Scroll" then TweenService:Create(obj, TweenInfo.new(0.5), {ScrollBarImageColor3 = theme.Scroll}):Play()
			elseif data.Type == "NotifGradient" then
				obj.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, theme.Accent), ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, theme.Accent)}
			end
		end
	end
	Library:RefreshStyle()
end

function Library:RefreshDimensions()
	local conf = Library.Config
	for _, win in ipairs(Library.Globals.Windows) do
		local scale = win.Main:FindFirstChild("UIScale")
		if scale then TweenService:Create(scale, TweenInfo.new(0.3), {Scale = conf.UIScale}):Play() end
		if win.RefreshHeight then win.RefreshHeight() end
		local headerH = conf.ItemHeight + 6 
		win.Header.Size = UDim2.new(1, 0, 0, headerH)
		win.Title.TextSize = math.clamp(headerH * 0.45, 12, 24)
	end
end

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Library:RefreshDimensions()
end)

--// 灵动岛 //--
local function ToggleInterface(visible)
	Library.Config.UIVisible = visible
	Backdrop.Visible = visible
	TweenService:Create(Backdrop, TweenInfo.new(0.5), {BackgroundTransparency = visible and 0.4 or 1}):Play()
    
    if not visible and Library.Globals.ActivePicker then
        Library.Globals.ActivePicker:Destroy()
        Library.Globals.ActivePicker = nil
    end
	
	if Library.Globals.IslandObject then
		local Island = Library.Globals.IslandObject
		if visible then
			TweenService:Create(Island, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
			if not Library.Config.UseStroke then
				TweenService:Create(Island.UIStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
			end
		else
			TweenService:Create(Island, TweenInfo.new(0.3), {BackgroundTransparency = 0.6}):Play()
			if not Library.Config.UseStroke then
				TweenService:Create(Island.UIStroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
			end
		end
	end
	
	local Origin = Library.Globals.IslandPosition
	local ScreenSize = ScreenGui.AbsoluteSize
	local MaxRadius = math.sqrt(ScreenSize.X^2 + ScreenSize.Y^2)
	
	if visible then
		local Ripple = Instance.new("Frame"); Ripple.Name="FullRipple"; Ripple.Parent=ScreenGui
		Ripple.AnchorPoint=Vector2.new(0.5,0.5); Ripple.Position=UDim2.new(0,Origin.X,0,Origin.Y)
		Ripple.BackgroundColor3=CurrentThemeData.Accent; Ripple.BackgroundTransparency=0.8; Ripple.BorderSizePixel=0; Ripple.ZIndex=1
		local Corner = Instance.new("UICorner"); Corner.CornerRadius=UDim.new(1,0); Corner.Parent=Ripple
		Ripple.Size=UDim2.new(0,0,0,0)
		local tween=TweenService:Create(Ripple, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(0,MaxRadius*2,0,MaxRadius*2), BackgroundTransparency=1})
		tween:Play(); tween.Completed:Connect(function() Ripple:Destroy() end)

		local Duration = 0.6; local StartTime = tick()
		for _, winData in ipairs(Library.Globals.Windows) do 
			if winData.IsOpen then winData.Main.Visible = false; winData.Main.BackgroundTransparency = 1 end
		end
		local connection
		connection = RunService.RenderStepped:Connect(function()
			local elapsed = tick() - StartTime; local progress = math.clamp(elapsed / Duration, 0, 1)
			local currentRadius = progress * MaxRadius * 1.2
			for _, winData in ipairs(Library.Globals.Windows) do
				if winData.IsOpen then
					local winPos = winData.Main.AbsolutePosition + (winData.Main.AbsoluteSize / 2)
					local dist = (winPos - Origin).Magnitude
					if currentRadius >= dist and not winData.Main.Visible then
						winData.Main.Visible = true
						TweenService:Create(winData.Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = CurrentThemeData.MainTrans}):Play()
						for _, d in ipairs(winData.Main:GetDescendants()) do
							if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("ImageLabel") or d:IsA("TextBox")) and d.Name ~= "Backdrop" then
								local targetT = (d:IsA("TextButton") and d.Name == "Main") and 1 or 0
                                if d:IsA("TextBox") then targetT = 0 end 
								d.TextTransparency = 1
								TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = targetT}):Play()
							end
						end
					end
				end
			end
			if progress >= 1 then connection:Disconnect() end
		end)
	else
		for _, winData in ipairs(Library.Globals.Windows) do
			if winData.Main.Visible then
				TweenService:Create(winData.Main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				for _, d in ipairs(winData.Main:GetDescendants()) do
					if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then TweenService:Create(d, TweenInfo.new(0.2), {TextTransparency = 1}):Play() end
				end
			end
		end
		task.delay(0.2, function()
			if not Library.Config.UIVisible then for _, w in ipairs(Library.Globals.Windows) do w.Main.Visible = false end; Backdrop.Visible = false end
		end)
	end
end

local function CreateDynamicIsland()
	local Island = Instance.new("TextButton"); Island.Name="DynamicIsland"; Island.Parent=ScreenGui
	Island.Size=UDim2.new(0,100,0,30); Island.Position=UDim2.new(0.5,0,0,10); Island.AnchorPoint=Vector2.new(0.5,0)
	Island.BackgroundColor3=Color3.new(0,0,0); 
	Island.BackgroundTransparency = Library.Config.UIVisible and 0.1 or 0.6
	Island.Text="YC GUI"; Island.Font=Enum.Font.GothamBold; Island.TextSize=14; Island.TextColor3=Color3.new(1,1,1); Island.AutoButtonColor=false; Island.ZIndex=100
	
	local UICorner = Instance.new("UICorner"); 
    UICorner.CornerRadius = UDim.new(1,0) 
    UICorner.Parent = Island
	
	local UIStroke = Instance.new("UIStroke"); UIStroke.Thickness=1.5; UIStroke.Color=Color3.fromRGB(255,255,255); 
	UIStroke.Transparency = Library.Config.UIVisible and 0.5 or 0.9; UIStroke.Parent=Island
	
	Library.Globals.IslandObject = Island
	
	local function UpdatePos() Library.Globals.IslandPosition = Island.AbsolutePosition + (Island.AbsoluteSize / 2) end
	Island:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdatePos); task.defer(UpdatePos)
	Island.MouseButton1Click:Connect(function()
		TweenService:Create(Island, TweenInfo.new(0.1), {Size=UDim2.new(0,90,0,25)}):Play()
		task.delay(0.1, function() TweenService:Create(Island, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Size=UDim2.new(0,100,0,30)}):Play() end)
		ToggleInterface(not Library.Config.UIVisible)
	end)
end
CreateDynamicIsland()

--// 涟漪 //--
local function CreateRipple(btn, isCenter)
	btn.ClipsDescendants = true
	spawn(function()
		local ripple = Instance.new("Frame"); ripple.Parent=btn; ripple.BackgroundColor3=Color3.fromRGB(255,255,255); ripple.BackgroundTransparency=0.8; ripple.BorderSizePixel=0; ripple.AnchorPoint=Vector2.new(0.5,0.5)
		local corner = Instance.new("UICorner"); corner.CornerRadius=UDim.new(1,0); corner.Parent=ripple
		local pos = isCenter and UDim2.new(0.5,0,0.5,0) or UDim2.new(0,UserInputService:GetMouseLocation().X-btn.AbsolutePosition.X,0,UserInputService:GetMouseLocation().Y-btn.AbsolutePosition.Y)
		ripple.Position=pos; ripple.Size=UDim2.new(0,0,0,0)
		local size = math.max(btn.AbsoluteSize.X,btn.AbsoluteSize.Y)*1.5
		TweenService:Create(ripple,TweenInfo.new(0.4),{Size=UDim2.new(0,size,0,size),BackgroundTransparency=1}):Play()
		task.wait(0.45); ripple:Destroy()
	end)
end

--// HUD & Notify //--
local HUDFrame = Instance.new("Frame"); HUDFrame.Name="HUD"; HUDFrame.Parent=ScreenGui
HUDFrame.Position=UDim2.new(1,-10,0,50); HUDFrame.AnchorPoint=Vector2.new(1,0)
HUDFrame.Size=UDim2.new(0,300,1,-60); HUDFrame.BackgroundTransparency=1; HUDFrame.Visible=Library.Config.ShowHUD
local HUDLayout = Instance.new("UIListLayout"); HUDLayout.Parent=HUDFrame; HUDLayout.HorizontalAlignment=Enum.HorizontalAlignment.Right; HUDLayout.Padding=UDim.new(0,0); HUDLayout.SortOrder=Enum.SortOrder.LayoutOrder
local function UpdateHUD(name, enabled)
	if not Library.Config.ShowHUD then return end
	local old = HUDFrame:FindFirstChild(name)
	if enabled then
		if old then return end
		local font = Enum.Font.GothamBold; local textSize = 18
		local w = TextService:GetTextSize(name, textSize, font, Vector2.new(1000, 1000)).X
		local Wrap = Instance.new("Frame"); Wrap.Name = name; Wrap.Parent = HUDFrame; Wrap.BackgroundTransparency = 1; Wrap.Size = UDim2.new(0, w + 14, 0, 22); Wrap.LayoutOrder = -math.floor(w)
		local Cont = Instance.new("Frame"); Cont.Name = "Container"; Cont.Parent = Wrap; Cont.BackgroundColor3 = Color3.new(0,0,0); Cont.BackgroundTransparency = 0.4; Cont.Size = UDim2.new(1, 0, 1, 0); Cont.Position = UDim2.new(1, 50, 0, 0); Cont.BorderSizePixel = 0
		local Bar = Instance.new("Frame"); Bar.Name = "FlowBar"; Bar.Parent = Cont; Bar.Size = UDim2.new(0, 3, 1, 0); Bar.Position = UDim2.new(1, -3, 0, 0); Bar.BorderSizePixel = 0; Bar.BackgroundColor3 = Color3.new(1,1,1)
		local Grad = Instance.new("UIGradient"); Grad.Parent = Bar; Grad.Rotation = -90; table.insert(Library.Globals.HUDGradients, Grad)
		local Lab = Instance.new("TextLabel"); Lab.Parent = Cont; Lab.Text = name; Lab.Font = font; Lab.TextSize = textSize; Lab.TextColor3 = Color3.new(1,1,1); Lab.BackgroundTransparency = 1; Lab.Size = UDim2.new(1, -8, 1, 0); Lab.Position = UDim2.new(0, 0, 0, 0); Lab.TextXAlignment = Enum.TextXAlignment.Right; RegisterObject(Lab, "Text")
		TweenService:Create(Cont, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position=UDim2.new(0,0,0,0)}):Play()
	else 
		if old then 
			local bar = old:FindFirstChild("Container") and old.Container:FindFirstChild("FlowBar")
			if bar and bar:FindFirstChild("UIGradient") then for i, g in ipairs(Library.Globals.HUDGradients) do if g == bar.UIGradient then table.remove(Library.Globals.HUDGradients, i) break end end end
			local cont = old:FindFirstChild("Container")
			if cont then local out = TweenService:Create(cont, TweenInfo.new(0.3), {Position=UDim2.new(1,50,0,0)}); out:Play(); out.Completed:Connect(function() old:Destroy() end) else old:Destroy() end
		end 
	end
end
function Library:SetHUDVisible(visible) Library.Config.ShowHUD = visible; HUDFrame.Visible = visible; SaveConfig() end
function Library:SetNotifsVisible(visible) Library.Config.ShowNotifs = visible; SaveConfig() end
function Library:SetTheme(themeName) if Library.Themes[themeName] then CurrentThemeData = Library.Themes[themeName]; Library.Config.Theme = themeName; Library:RefreshTheme(); SaveConfig() end end
function Library:Notify(title, status)
	if not Library.Config.ShowNotifs then return end
	local Frame = Instance.new("Frame"); Frame.Parent=ScreenGui; Frame.BackgroundColor3=Color3.fromRGB(20,20,20); Frame.BackgroundTransparency=0.15; Frame.BorderSizePixel=0; Frame.Size=UDim2.new(0,200,0,35); Frame.Position=UDim2.new(1,50,1,-50)
	local Bar = Instance.new("Frame"); Bar.Parent=Frame; Bar.Size=UDim2.new(0,2,1,0); Bar.BorderSizePixel=0; RegisterObject(Bar, "Accent")
	local TitleLab = Instance.new("TextLabel"); TitleLab.Parent=Frame; TitleLab.Text=title; TitleLab.Font=Enum.Font.GothamBold; TitleLab.TextSize=14; TitleLab.TextColor3=Color3.fromRGB(255,255,255); TitleLab.BackgroundTransparency=1; TitleLab.Size=UDim2.new(1,-10,0.5,0); TitleLab.Position=UDim2.new(0,10,0,3); TitleLab.TextXAlignment=Enum.TextXAlignment.Left
	local StateLab = Instance.new("TextLabel"); StateLab.Parent=Frame; StateLab.Text=status and "已开启" or "已关闭"; StateLab.Font=Enum.Font.Gotham; StateLab.TextSize=11; StateLab.TextColor3=status and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80); StateLab.BackgroundTransparency=1; StateLab.Size=UDim2.new(1,-10,0.5,0); StateLab.Position=UDim2.new(0,10,0.5,-2); StateLab.TextXAlignment=Enum.TextXAlignment.Left
	local TimerFrame = Instance.new("Frame"); TimerFrame.Parent=Frame; TimerFrame.BorderSizePixel=0; TimerFrame.Position=UDim2.new(0,0,1,-2); TimerFrame.Size=UDim2.new(1,0,0,2); TimerFrame.BackgroundColor3 = Color3.new(1,1,1) 
	
	local TimerGradient = Instance.new("UIGradient"); TimerGradient.Parent = TimerFrame
	TimerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentThemeData.Accent), ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, CurrentThemeData.Accent)}
	RegisterObject(TimerGradient, "NotifGradient") 
	
	local yOffset = 0; for i=#Library.Globals.ActiveNotifs,1,-1 do local n=Library.Globals.ActiveNotifs[i]; if n.Parent then TweenService:Create(n,TweenInfo.new(0.3),{Position=UDim2.new(1,-210,1,-50-yOffset)}):Play(); yOffset=yOffset+40 end end
	table.insert(Library.Globals.ActiveNotifs, Frame); TweenService:Create(Frame,TweenInfo.new(0.3),{Position=UDim2.new(1,-210,1,-50-yOffset)}):Play()
	local timerTween = TweenService:Create(TimerFrame, TweenInfo.new(Library.Config.NotifDuration, Enum.EasingStyle.Linear), {Size=UDim2.new(0,0,0,2)}); timerTween:Play()
	timerTween.Completed:Connect(function() for i,v in ipairs(Library.Globals.ActiveNotifs) do if v==Frame then table.remove(Library.Globals.ActiveNotifs, i) break end end; local out = TweenService:Create(Frame,TweenInfo.new(0.3),{Position=Frame.Position+UDim2.new(0,250,0,0)}); out:Play(); task.wait(0.3); Frame:Destroy() end)
end
local function CreateMobileWidget(name, toggleFunc, getEnabledState)
	if ScreenGui:FindFirstChild("Float_"..name) then return end
	local Widget = Instance.new("TextButton"); Widget.Name="Float_"..name; Widget.Parent=ScreenGui; Widget.Size=UDim2.new(0,50,0,50); Widget.Position=UDim2.new(0.5,-25,0.5,-25); Widget.BackgroundColor3=Color3.fromRGB(25,20,35); Widget.BackgroundTransparency=0.3; Widget.Text=GetFirstChar(name); Widget.TextSize=20; Widget.Font=Enum.Font.GothamBold; Widget.TextColor3=Color3.fromRGB(255,255,255); Widget.AutoButtonColor=false; Widget.ZIndex=50
	local Corner = Instance.new("UICorner"); Corner.CornerRadius=UDim.new(0,12); Corner.Parent=Widget
	local Stroke = Instance.new("UIStroke"); Stroke.Parent=Widget; Stroke.Thickness=2
	local Close = Instance.new("TextButton"); Close.Parent=Widget; Close.Size=UDim2.new(0,15,0,15); Close.Position=UDim2.new(1,-5,0,-5); Close.AnchorPoint=Vector2.new(0.5,0.5); Close.BackgroundTransparency=1; Close.Text="X"; Close.TextColor3=Color3.fromRGB(255,80,80); Close.Font=Enum.Font.GothamBlack
	Close.MouseButton1Click:Connect(function() Widget:Destroy() end)
	local dragging, dragStart, startPos
	Widget.InputBegan:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("MouseButton1") then dragging=true; dragStart=i.Position; startPos=Widget.Position end end)
	Widget.InputChanged:Connect(function(i) if dragging and (i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse")) then local d=i.Position-dragStart; Widget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
	Widget.InputEnded:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("MouseButton1") then dragging=false end end)
	local c; c=RunService.Heartbeat:Connect(function() if not Widget.Parent then c:Disconnect() return end; Stroke.Color=getEnabledState() and CurrentThemeData.Accent or Color3.fromRGB(60,60,60) end)
	Widget.MouseButton1Click:Connect(function() toggleFunc(true) end)
end
UserInputService.InputBegan:Connect(function(i,p) if not p and Library.Globals.BoundKeys[i.KeyCode] then Library.Globals.BoundKeys[i.KeyCode](true) end end)

--// 窗口系统 //--
function Library:CreateWindow(title, pos, isMain, isSub)
	local Window = {}
	local isFolded = false
	local isOpen = not isSub 
	if isSub and not Library.Config.UIVisible then isOpen = false end
	
	local HeaderH = Library.Config.ItemHeight + 6
	local Main = Instance.new("Frame"); Main.Name = "Window_"..title
	Main.Parent = ScreenGui; Main.Position = pos; Main.Size = UDim2.new(0,Library.Config.WindowWidth,0,HeaderH); 
	Main.BorderSizePixel = 0; Main.Visible = isOpen; Main.ZIndex = 10
	RegisterObject(Main, "Window")
	RegisterStyle(Main, true, 10)
	
	local Scale = Instance.new("UIScale"); Scale.Parent = Main; Scale.Scale = Library.Config.UIScale
	local Header = Instance.new("Frame"); Header.Parent = Main; Header.BackgroundTransparency = 1; Header.Size = UDim2.new(1,0,0,HeaderH)
	local Title = Instance.new("TextLabel"); Title.Parent = Header; Title.Text = title; Title.Font = Enum.Font.GothamBlack; 
	Title.TextSize = math.clamp(HeaderH * 0.45, 12, 24) 
	Title.Size = UDim2.new(1,-10,1,0); Title.Position = UDim2.new(0,10,0,0); Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; RegisterObject(Title, "Text")
	
	local Container = Instance.new("ScrollingFrame"); Container.Name = "Container"
	Container.Parent = Main; Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0
	Container.Position = UDim2.new(0,0,0,HeaderH); Container.Size = UDim2.new(1,0,0,0)
	Container.ScrollBarThickness = 3; Container.CanvasSize = UDim2.new(0,0,0,0)
	Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	RegisterObject(Container, "Scroll")
	
	local List = Instance.new("UIListLayout"); List.Parent = Container; List.SortOrder = Enum.SortOrder.LayoutOrder; List.Padding = UDim.new(0,0)
	local winData = {Main = Main, Header = Header, Title = Title, Container = Container, List = List, IsOpen = isOpen, IsSub = isSub}
	table.insert(Library.Globals.Windows, winData)
	if isSub then Library.Globals.SubWindows[title] = winData end
	
	local function RefreshH()
		local contentH = List.AbsoluteContentSize.Y
		local screenHeight = Camera.ViewportSize.Y / (Library.Config.UIScale > 0 and Library.Config.UIScale or 1)
		local maxPerScreen = screenHeight - 100 
		if maxPerScreen < 100 then maxPerScreen = 100 end 
		local actualMax = math.min(Library.Config.WindowMaxHeight, maxPerScreen)
		local curHeadH = Library.Config.ItemHeight + 6
		if isFolded then
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size=UDim2.new(0,Library.Config.WindowWidth,0,curHeadH)}):Play()
			Container.Visible = false
		else
			Container.Visible = true
			local finalH = math.min(contentH, actualMax)
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size=UDim2.new(0,Library.Config.WindowWidth,0,curHeadH + finalH)}):Play()
			Container.Size = UDim2.new(1, 0, 0, finalH)
			Container.ScrollingEnabled = contentH > actualMax
		end
	end
	winData.RefreshHeight = RefreshH
	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshH)
	
	local drag, dStart, sPos, sTime
	Header.Active = true 
	Header.InputBegan:Connect(function(i) 
		if i.UserInputType.Name:match("Mouse") or i.UserInputType.Name:match("Touch") then 
			Library.Globals.TopZIndex = Library.Globals.TopZIndex + 1
			Main.ZIndex = Library.Globals.TopZIndex
			drag = true; dStart = i.Position; sPos = Main.Position; sTime = tick() 
            if Library.Globals.ActivePicker then Library.Globals.ActivePicker:Destroy(); Library.Globals.ActivePicker = nil end
		end 
	end)
	UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType.Name:match("Mouse") or i.UserInputType.Name:match("Touch")) then local d=i.Position-dStart; TweenService:Create(Main,TweenInfo.new(0.05),{Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)}):Play() end end)
	Header.InputEnded:Connect(function(i) if i.UserInputType.Name:match("Mouse") or i.UserInputType.Name:match("Touch") then drag=false; if (i.Position-dStart).Magnitude < 5 and tick()-sTime < 0.3 then isFolded=not isFolded; RefreshH() end end end)
	
	local function RegElem(inst, lbl, dots) table.insert(Library.Globals.Elements, {Instance=inst, Label=lbl, Dots=dots}) end
	
	function Window:CreateButton(name, callback)
		local H = Library.Config.ItemHeight
		local Btn = Instance.new("TextButton"); Btn.Parent=Container; Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,0,0,H); Btn.Text=""; Btn.BorderSizePixel=0
		Btn.ClipsDescendants = true
		RegisterStyle(Btn, false, 6)
		local Txt = Instance.new("TextLabel"); Txt.Parent=Btn; Txt.Text=name; Txt.Font=Enum.Font.GothamSemibold; Txt.TextSize=math.clamp(H*0.42, 10, 20); Txt.BackgroundTransparency=1; Txt.Size=UDim2.new(1,-10,1,0); Txt.Position=UDim2.new(0,10,0,0); Txt.TextXAlignment=Enum.TextXAlignment.Left; RegisterObject(Txt, "TextDark")
		Btn.MouseButton1Click:Connect(function() CreateRipple(Btn); pcall(callback) end)
		RegElem(Btn, Txt, nil)
	end

	function Window:BindWindow(subWindowName, defaultState)
		local Mod = self:CreateModule(subWindowName, function(bool)
			local target = Library.Globals.SubWindows[subWindowName]
			if target then
				target.IsOpen = bool
				target.Main.Visible = bool and Library.Config.UIVisible
				if bool and Library.Config.UIVisible then
					if target.Main.Position.X.Offset == 0 and target.Main.Position.Y.Offset == 0 then
						target.Main.Position = UDim2.new(0.5, -Library.Config.WindowWidth/2, 0.5, -100)
					end
					TweenService:Create(target.Main, TweenInfo.new(0.3), {BackgroundTransparency = CurrentThemeData.MainTrans}):Play()
				else
					target.Main.Visible = false
				end
			else
				Library:Notify("未找到: "..subWindowName, false)
			end
		end, false)
		if defaultState then Mod:Set(true) end
	end

	function Window:CreateModule(name, callback, allowBind)
		if allowBind == nil then allowBind = true end
		local Mod = {}; local enabled = false; local setOpen = false; local bindKey = nil
		local H = Library.Config.ItemHeight
		local Btn = Instance.new("TextButton"); Btn.Parent=Container; Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,0,0,H); Btn.Text=""; Btn.BorderSizePixel=0; Btn.ClipsDescendants=true
		RegisterStyle(Btn, false, 6)
		local Txt = Instance.new("TextLabel"); Txt.Parent=Btn; Txt.Text=name; Txt.Font=Enum.Font.GothamSemibold; Txt.TextSize=math.clamp(H*0.42, 10, 20); Txt.BackgroundTransparency=1; Txt.Size=UDim2.new(1,-35,1,0); Txt.Position=UDim2.new(0,10,0,0); Txt.TextXAlignment=Enum.TextXAlignment.Left; RegisterObject(Txt, "TextDark")
		local Dots = Instance.new("TextButton"); Dots.Parent=Btn; Dots.Text="..."; Dots.Font=Enum.Font.GothamBold; Dots.TextSize=math.clamp(H*0.42, 10, 20)+4; Dots.BackgroundTransparency=1; Dots.Size=UDim2.new(0,H,1,0); Dots.Position=UDim2.new(1,-H,0,0); Dots.Visible=allowBind; RegisterObject(Dots, "TextDark")
		RegElem(Btn, Txt, Dots)
		local SetFrame = Instance.new("Frame"); SetFrame.Parent=Container; SetFrame.BackgroundTransparency=0.5; RegisterObject(SetFrame, "SettingBg"); SetFrame.Size=UDim2.new(1,0,0,0); SetFrame.ClipsDescendants=true; SetFrame.Visible=false; SetFrame.BorderSizePixel=0
		local SetList = Instance.new("UIListLayout"); SetList.Parent=SetFrame; SetList.Padding=UDim.new(0,0)
		local function Toggle(isRemote)
			enabled = not enabled
			if enabled then RegisterObject(Txt, "Text"); RegisterObject(Dots, "Text"); TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundTransparency=0.8, BackgroundColor3=Color3.new(1,1,1)}):Play()
			else RegisterObject(Txt, "TextDark"); RegisterObject(Dots, "TextDark"); TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play() end
			if isRemote then CreateRipple(Btn, true) end
			UpdateHUD(name, enabled); Library:Notify(name, enabled); pcall(callback, enabled)
		end
		function Mod:Set(bool) if bool ~= enabled then Toggle() end end

		if allowBind then
			local KB = Instance.new("TextButton"); KB.Parent=SetFrame; KB.Size=UDim2.new(1,0,0,24); KB.BackgroundTransparency=1; KB.Text=""; KB.BorderSizePixel=0
			local KL = Instance.new("TextLabel"); KL.Parent=KB; KL.Text="绑定: 无"; KL.Font=Enum.Font.Gotham; KL.TextSize=11; KL.BackgroundTransparency=1; KL.Size=UDim2.new(1,-20,1,0); KL.Position=UDim2.new(0,10,0,0); KL.TextXAlignment=Enum.TextXAlignment.Left; RegisterObject(KL, "TextDark")
			local listening = false
			KB.MouseButton1Click:Connect(function()
				if listening then return end; listening=true; KL.Text="按下按键..."
				local c; c=UserInputService.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Keyboard then listening=false; c:Disconnect(); if i.KeyCode.Name=="Backspace" or i.KeyCode.Name=="Delete" then if bindKey then Library.Globals.BoundKeys[bindKey]=nil end; bindKey=nil; KL.Text="绑定: 无" else if bindKey then Library.Globals.BoundKeys[bindKey]=nil end; bindKey=i.KeyCode; Library.Globals.BoundKeys[bindKey]=Toggle; KL.Text="绑定: "..i.KeyCode.Name end end end)
			end)
			local pt, ip = 0, false
			Btn.InputBegan:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse") then ip=true; pt=tick(); task.spawn(function() task.wait(0.6); if ip and tick()-pt>=0.6 then CreateMobileWidget(name, Toggle, function() return enabled end); Library:Notify("悬浮窗已创建", true); ip=false end end) end end)
			Btn.InputEnded:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse") then if ip and tick()-pt<0.6 then CreateRipple(Btn); Toggle() end; ip=false end end)
		else Btn.MouseButton1Click:Connect(function() CreateRipple(Btn); Toggle() end) end
		Dots.MouseButton1Click:Connect(function()
			setOpen = not setOpen; SetFrame.Visible=true; local th = setOpen and SetList.AbsoluteContentSize.Y or 0
			TweenService:Create(SetFrame, TweenInfo.new(0.3), {Size=UDim2.new(1,0,0,th)}):Play()
			local c; c=RunService.RenderStepped:Connect(function() List:ApplyLayout(); if winData.RefreshHeight then winData.RefreshHeight() end; if math.abs(SetFrame.Size.Y.Offset-th)<1 then c:Disconnect() end end)
			if not setOpen then task.delay(0.3, function() SetFrame.Visible=false end) end
		end)
		
        -- [滑块 Slider]
        function Mod:CreateSlider(txt, min, max, def, call)
			if not Dots.Visible then Dots.Visible=true end; local v = def
			local F = Instance.new("Frame"); F.Parent=SetFrame; F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,30); F.BorderSizePixel=0
			local L = Instance.new("TextLabel"); L.Parent=F; L.Text=txt..": "..v; L.Font=Enum.Font.Gotham; L.TextSize=11; L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,14); RegisterObject(L,"TextDark")
			local B = Instance.new("Frame"); B.Parent=F; B.BackgroundColor3=Color3.fromRGB(60,60,60); B.BorderSizePixel=0; B.Position=UDim2.new(0,8,0,18); B.Size=UDim2.new(1,-16,0,4)
			local Fil = Instance.new("Frame"); Fil.Parent=B; Fil.BorderSizePixel=0; Fil.Size=UDim2.new((def-min)/(max-min),0,1,0); RegisterObject(Fil,"Accent")
			local T = Instance.new("TextButton"); T.Parent=F; T.BackgroundTransparency=1; T.Text=""; T.Size=UDim2.new(1,0,0,25); T.Position=UDim2.new(0,0,0,5); T.ZIndex=10
			local d=false; T.InputBegan:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse") then d=true end end); UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse") then d=false end end)
			UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType.Name:match("Touch") or i.UserInputType.Name:match("Mouse")) then local p=math.clamp((i.Position.X-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1); v=math.floor(min+(max-min)*p); L.Text=txt..": "..v; Fil.Size=UDim2.new(p,0,1,0); pcall(call,v) end end)
			pcall(call, v)
		end

        -- [开关 Switch]
		function Mod:CreateSwitch(txt, call, defaultState)
			if not Dots.Visible then Dots.Visible=true end; local on=defaultState or false
			local B=Instance.new("TextButton"); B.Parent=SetFrame; B.BackgroundTransparency=1; B.Size=UDim2.new(1,0,0,24); B.Text=""; B.BorderSizePixel=0
			local L=Instance.new("TextLabel"); L.Parent=B; L.Text=txt; L.Font=Enum.Font.Gotham; L.TextSize=11; L.BackgroundTransparency=1; L.Size=UDim2.new(1,-30,1,0); L.Position=UDim2.new(0,10,0,0); L.TextXAlignment=Enum.TextXAlignment.Left; RegisterObject(L,"TextDark")
			local Box=Instance.new("Frame"); Box.Parent=B; Box.Size=UDim2.new(0,12,0,12); Box.Position=UDim2.new(1,-20,0.5,-6); Box.BackgroundColor3=Color3.fromRGB(60,60,60); Box.BorderSizePixel=0
			local Ind=Instance.new("Frame"); Ind.Parent=Box; Ind.Size=UDim2.new(1,-2,1,-2); Ind.Position=UDim2.new(0,1,0,1); Ind.Visible=on; Ind.BorderSizePixel=0; RegisterObject(Ind,"Accent")
			B.MouseButton1Click:Connect(function() on=not on; Ind.Visible=on; pcall(call, on) end)
			if on then pcall(call, on) end
		end

        -- [下拉框 Dropdown]
		function Mod:CreateDropdown(txt, opts, call)
			if not Dots.Visible then Dots.Visible=true end; local open=false; local H=26
			local Base=Instance.new("Frame"); Base.Parent=SetFrame; Base.BackgroundTransparency=1; Base.Size=UDim2.new(1,0,0,H); Base.ClipsDescendants=true; Base.BorderSizePixel=0
			local Main=Instance.new("TextButton"); Main.Parent=Base; Main.BackgroundTransparency=1; Main.Size=UDim2.new(1,0,0,H); Main.Text=""; Main.AutoButtonColor=false; Main.BorderSizePixel=0
			local L=Instance.new("TextLabel"); L.Parent=Main; L.Text=txt.." >"; L.Font=Enum.Font.Gotham; L.TextSize=11; L.BackgroundTransparency=1; L.Size=UDim2.new(1,-20,1,0); L.Position=UDim2.new(0,10,0,0); L.TextXAlignment=Enum.TextXAlignment.Left; RegisterObject(L,"TextDark")
			local Opts=Instance.new("Frame"); Opts.Parent=Base; Opts.Position=UDim2.new(0,0,0,H); Opts.Size=UDim2.new(1,0,0,0); Opts.BackgroundTransparency=1; Opts.BorderSizePixel=0
			local OList=Instance.new("UIListLayout"); OList.Parent=Opts; OList.Padding=UDim.new(0,0)
			for _,o in ipairs(opts) do
				local Ob=Instance.new("TextButton"); Ob.Parent=Opts; Ob.Size=UDim2.new(1,0,0,22); Ob.BackgroundTransparency=1; Ob.BorderSizePixel=0; Ob.Text=o; Ob.Font=Enum.Font.Gotham; Ob.TextSize=11; Ob.TextColor3=Color3.fromRGB(200,200,200)
				Ob.MouseButton1Click:Connect(function() L.Text=txt..": "..o; open=false; local nh=H; local d=nh-Base.Size.Y.Offset; local nsh=SetFrame.Size.Y.Offset+d; TweenService:Create(Base,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,nh)}):Play(); TweenService:Create(SetFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,nsh)}):Play(); local c; c=RunService.RenderStepped:Connect(function() List:ApplyLayout(); if winData.RefreshHeight then winData.RefreshHeight() end; if Base.Size.Y.Offset==nh then c:Disconnect() end end); pcall(call,o) end)
			end
			Main.MouseButton1Click:Connect(function() open=not open; local nh=open and (H+(#opts*22)) or H; local d=nh-Base.Size.Y.Offset; local nsh=SetFrame.Size.Y.Offset+d; TweenService:Create(Base,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,nh)}):Play(); TweenService:Create(SetFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,nsh)}):Play(); local c; c=RunService.RenderStepped:Connect(function() List:ApplyLayout(); if winData.RefreshHeight then winData.RefreshHeight() end; if math.abs(Base.Size.Y.Offset-nh)<1 then c:Disconnect() end end) end)
		end

        -- [输入框 Input]
        function Mod:CreateInput(text, placeholder, callback)
            if not Dots.Visible then Dots.Visible=true end
            local BoxH = 26
            local Container = Instance.new("Frame"); Container.Parent = SetFrame; Container.BackgroundTransparency = 1; Container.Size = UDim2.new(1, 0, 0, BoxH + 4); Container.BorderSizePixel = 0
            
            local Label = Instance.new("TextLabel"); Label.Parent = Container; Label.Text = text..":"; Label.Font = Enum.Font.Gotham; Label.TextSize = 11; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(0, 60, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.TextXAlignment = Enum.TextXAlignment.Left; RegisterObject(Label, "TextDark")
            
            local InputBg = Instance.new("Frame"); InputBg.Parent = Container; InputBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45); InputBg.Size = UDim2.new(1, -80, 0, BoxH); InputBg.Position = UDim2.new(0, 70, 0.5, 0); InputBg.AnchorPoint = Vector2.new(0, 0.5); InputBg.BorderSizePixel = 0
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 4); Corner.Parent = InputBg
            
            local TextBox = Instance.new("TextBox"); TextBox.Parent = InputBg; TextBox.BackgroundTransparency = 1; TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.Font = Enum.Font.Gotham; TextBox.Text = ""; TextBox.PlaceholderText = placeholder or "输入..."; TextBox.TextSize = 12; TextBox.TextColor3 = Color3.new(1,1,1); TextBox.PlaceholderColor3 = Color3.fromRGB(150,150,150); TextBox.TextXAlignment = Enum.TextXAlignment.Left; TextBox.ClearTextOnFocus = false
            
            TextBox.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, TextBox.Text)
                    Library:Notify("输入已应用", true)
                end
            end)
        end

        -- [外置颜色选择器 ColorPicker]
        function Mod:CreateColorPicker(text, defaultColor, callback)
            if not Dots.Visible then Dots.Visible=true end
            local h, s, v = ToHSV(defaultColor or Color3.fromRGB(255,255,255))
            local currentColor = defaultColor or Color3.fromRGB(255,255,255)
            
            local Container = Instance.new("TextButton"); Container.Parent = SetFrame; Container.BackgroundTransparency = 1; Container.Size = UDim2.new(1, 0, 0, 24); Container.Text = ""; Container.AutoButtonColor = false
            
            local Label = Instance.new("TextLabel"); Label.Parent = Container; Label.Text = text; Label.Font = Enum.Font.Gotham; Label.TextSize = 11; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, -40, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.TextXAlignment = Enum.TextXAlignment.Left; RegisterObject(Label, "TextDark")
            
            local Preview = Instance.new("Frame"); Preview.Parent = Container; Preview.Size = UDim2.new(0, 30, 0, 14); Preview.Position = UDim2.new(1, -40, 0.5, 0); Preview.AnchorPoint = Vector2.new(0, 0.5); Preview.BackgroundColor3 = currentColor; Preview.BorderSizePixel = 0
            local PStroke = Instance.new("UIStroke"); PStroke.Parent = Preview; PStroke.Thickness = 1; PStroke.Color = Color3.fromRGB(100,100,100); PStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local PCorner = Instance.new("UICorner"); PCorner.CornerRadius = UDim.new(0, 3); PCorner.Parent = Preview
            
            Container.MouseButton1Click:Connect(function()
                if Library.Globals.ActivePicker then Library.Globals.ActivePicker:Destroy(); Library.Globals.ActivePicker = nil end
                
                local PickerFrame = Instance.new("Frame"); PickerFrame.Name = "ColorPicker_PopOut"; PickerFrame.Parent = ScreenGui; PickerFrame.Size = UDim2.new(0, 180, 0, 200); PickerFrame.ZIndex = Library.Globals.TopZIndex + 100; PickerFrame.BorderSizePixel = 0
                RegisterObject(PickerFrame, "PickerBg")
                RegisterStyle(PickerFrame, true, 8)
                
                local btnAbsPos = Container.AbsolutePosition
                local btnAbsSize = Container.AbsoluteSize
                local screenWidth = ScreenGui.AbsoluteSize.X
                local xPos = btnAbsPos.X + btnAbsSize.X + 10
                if xPos + 180 > screenWidth then xPos = btnAbsPos.X - 190 end
                
                PickerFrame.Position = UDim2.new(0, xPos, 0, btnAbsPos.Y - 50)
                Library.Globals.ActivePicker = PickerFrame
                
                PickerFrame.Size = UDim2.new(0,0,0,0)
                TweenService:Create(PickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 180, 0, 210)}):Play()
                
                local MainPadding = Instance.new("UIPadding"); MainPadding.Parent = PickerFrame; MainPadding.PaddingTop = UDim.new(0,10); MainPadding.PaddingBottom = UDim.new(0,10); MainPadding.PaddingLeft = UDim.new(0,10); MainPadding.PaddingRight = UDim.new(0,10)
                
                local SVBox = Instance.new("TextButton"); SVBox.Parent = PickerFrame; SVBox.Size = UDim2.new(1, -25, 0, 120); SVBox.Text = ""; SVBox.AutoButtonColor = false; SVBox.BorderSizePixel = 0; SVBox.ZIndex = PickerFrame.ZIndex + 1
                local SVGrad = Instance.new("UIGradient"); SVGrad.Parent = SVBox; SVGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))}
                local SVImg = Instance.new("ImageLabel"); SVImg.Parent = SVBox; SVImg.Size = UDim2.new(1,0,1,0); SVImg.BackgroundTransparency = 1; SVImg.Image = "rbxassetid://4155801252"; SVImg.ZIndex = SVBox.ZIndex
                
                local PickerPoint = Instance.new("Frame"); PickerPoint.Parent = SVBox; PickerPoint.Size = UDim2.new(0,6,0,6); PickerPoint.AnchorPoint = Vector2.new(0.5,0.5); PickerPoint.BackgroundColor3 = Color3.new(1,1,1); PickerPoint.BorderSizePixel = 0; PickerPoint.ZIndex = SVBox.ZIndex + 2
                local PS = Instance.new("UIStroke"); PS.Parent = PickerPoint; PS.Thickness = 1; PS.Color = Color3.new(0,0,0)
                local PC = Instance.new("UICorner"); PC.Parent = PickerPoint; PC.CornerRadius = UDim.new(1,0)
                
                local HueBox = Instance.new("TextButton"); HueBox.Parent = PickerFrame; HueBox.Size = UDim2.new(0, 15, 0, 120); HueBox.Position = UDim2.new(1, -15, 0, 0); HueBox.Text = ""; HueBox.AutoButtonColor = false; HueBox.BorderSizePixel = 0; HueBox.BackgroundColor3 = Color3.new(1,1,1); HueBox.ZIndex = PickerFrame.ZIndex + 1
                local HueGrad = Instance.new("UIGradient"); HueGrad.Parent = HueBox; HueGrad.Rotation = 90; HueGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(1,1,1)), ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.833,1,1)), ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.667,1,1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)), ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.333,1,1)), ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.167,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0,1,1))
                }
                local HuePoint = Instance.new("Frame"); HuePoint.Parent = HueBox; HuePoint.Size = UDim2.new(1,0,0,2); HuePoint.BackgroundColor3 = Color3.new(1,1,1); HuePoint.BorderSizePixel = 0; HuePoint.ZIndex = HueBox.ZIndex + 2
                local HS = Instance.new("UIStroke"); HS.Parent = HuePoint; HS.Thickness = 1; HS.Color = Color3.new(0,0,0)
                
                local InputFrame = Instance.new("Frame"); InputFrame.Parent = PickerFrame; InputFrame.BackgroundTransparency = 1; InputFrame.Size = UDim2.new(1, 0, 0, 20); InputFrame.Position = UDim2.new(0, 0, 0, 130); InputFrame.ZIndex = PickerFrame.ZIndex + 1
                local Layout = Instance.new("UIListLayout"); Layout.Parent = InputFrame; Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.Padding = UDim.new(0, 5)
                
                local RBox = Instance.new("TextBox"); RBox.Parent = InputFrame; RBox.Size = UDim2.new(0.3, 0, 1, 0); RBox.BackgroundColor3 = Color3.fromRGB(40,40,40); RBox.TextColor3 = Color3.new(1,1,1); RBox.Text = math.floor(currentColor.R*255); RBox.Font = Enum.Font.Gotham; RBox.TextSize = 12; RBox.ZIndex = InputFrame.ZIndex
                local GBox = RBox:Clone(); GBox.Parent = InputFrame; GBox.Text = math.floor(currentColor.G*255)
                local BBox = RBox:Clone(); BBox.Parent = InputFrame; BBox.Text = math.floor(currentColor.B*255)
                local CornerR = Instance.new("UICorner"); CornerR.Parent = RBox; CornerR.CornerRadius = UDim.new(0,4)
                local CornerG = Instance.new("UICorner"); CornerG.Parent = GBox; CornerG.CornerRadius = UDim.new(0,4)
                local CornerB = Instance.new("UICorner"); CornerB.Parent = BBox; CornerB.CornerRadius = UDim.new(0,4)
                
                local ConfirmBtn = Instance.new("TextButton"); ConfirmBtn.Parent = PickerFrame; ConfirmBtn.Size = UDim2.new(1, 0, 0, 25); ConfirmBtn.Position = UDim2.new(0, 0, 1, -25); ConfirmBtn.BackgroundColor3 = CurrentThemeData.Accent; ConfirmBtn.Text = "确定"; ConfirmBtn.Font = Enum.Font.GothamBold; ConfirmBtn.TextColor3 = Color3.new(1,1,1); ConfirmBtn.TextSize = 12; ConfirmBtn.ZIndex = PickerFrame.ZIndex + 1
                local CB_Corner = Instance.new("UICorner"); CB_Corner.Parent = ConfirmBtn; CB_Corner.CornerRadius = UDim.new(0, 4)
                
                local function UpdateColor(notify)
                    currentColor = FromHSV(h, s, v)
                    SVGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, FromHSV(h, 1, 1))}
                    Preview.BackgroundColor3 = currentColor
                    RBox.Text = math.floor(currentColor.R*255)
                    GBox.Text = math.floor(currentColor.G*255)
                    BBox.Text = math.floor(currentColor.B*255)
                    
                    PickerPoint.Position = UDim2.new(s, 0, 1-v, 0)
                    HuePoint.Position = UDim2.new(0, 0, 1-h, 0)
                    
                    if notify then pcall(callback, currentColor) end
                end
                
                UpdateColor(false)
                
                local dragHue, dragSV = false, false
                HueBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragHue = true
                    end
                end)
                SVBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragSV = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragHue = false
                        dragSV = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if dragHue then
                            local y = math.clamp((input.Position.Y - HueBox.AbsolutePosition.Y) / HueBox.AbsoluteSize.Y, 0, 1)
                            h = 1 - y
                            UpdateColor(true)
                        elseif dragSV then
                            local x = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            local y = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            s = x
                            v = 1 - y
                            UpdateColor(true)
                        end
                    end
                end)
                
                local function UpdateFromRGB()
                    local r, g, b = tonumber(RBox.Text) or 0, tonumber(GBox.Text) or 0, tonumber(BBox.Text) or 0
                    currentColor = Color3.fromRGB(r, g, b)
                    h, s, v = ToHSV(currentColor)
                    UpdateColor(true)
                end
                RBox.FocusLost:Connect(UpdateFromRGB); GBox.FocusLost:Connect(UpdateFromRGB); BBox.FocusLost:Connect(UpdateFromRGB)
                
                ConfirmBtn.MouseButton1Click:Connect(function()
                    PickerFrame:Destroy()
                    Library.Globals.ActivePicker = nil
                end)
            end)
        end

		return Mod
	end
	return Window
end

--// 内置设置窗口 (纯净版) //--
function Library:SetupSettings()
	local Sets = Library:CreateWindow("UI设置", UDim2.new(0.5, -100, 0.5, -100))
	
	local UIConf = Sets:CreateModule("界面配置", function() end, false)
	UIConf:CreateDropdown("主题选择", {"Default", "Ocean", "Rose", "Sakura", "Mint", "Midnight", "Sunset"}, function(v) 
		Library:SetTheme(v)
		Library:Notify("主题切换", v)
	end)
    
	UIConf:CreateSlider("整体缩放(%)", 50, 150, math.floor(Library.Config.UIScale * 100), function(v) 
		Library.Config.UIScale = v / 100; Library:RefreshDimensions() 
	end)
    
	UIConf:CreateSlider("窗口宽度", 100, 300, Library.Config.WindowWidth, function(v)
		Library.Config.WindowWidth = v; Library:RefreshDimensions()
	end)
    
    UIConf:CreateSlider("窗口最大高度", 200, 600, Library.Config.WindowMaxHeight, function(v)
        Library.Config.WindowMaxHeight = v; Library:RefreshDimensions()
    end)
    
	local StyleConf = Sets:CreateModule("样式设置", function() end, false)
	StyleConf:CreateSwitch("圆角风格", function(v) 
		Library.Config.UseCorners = v; Library:RefreshStyle(); SaveConfig() 
	end, Library.Config.UseCorners)
	StyleConf:CreateSwitch("UI 描边", function(v) 
		Library.Config.UseStroke = v; Library:RefreshStyle(); SaveConfig() 
	end, Library.Config.UseStroke)

	local FuncConf = Sets:CreateModule("功能开关", function() end, false)
	FuncConf:CreateSwitch("显示 HUD", function(v) Library:SetHUDVisible(v) end, Library.Config.ShowHUD)
	FuncConf:CreateSwitch("显示 通知", function(v) Library:SetNotifsVisible(v) end, Library.Config.ShowNotifs)
    
	Sets:CreateButton("保存当前配置", function() SaveConfig(); Library:Notify("配置已保存", true) end)
    return Sets
end

function Library:CreateMainControl(title) return self:CreateWindow(title, UDim2.new(0, 20, 0, 60), true, false) end
function Library:CreateChildWindow(title) return self:CreateWindow(title, UDim2.new(0.5, -Library.Config.WindowWidth/2, 0.5, -100), false, true) end

--// 初始化加载动画 //--
task.spawn(function() Library:LoadLoader() end)

return Library
