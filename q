-- 创建一个屏幕Gui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- 创建一个Frame作为加载界面
local loadingFrame = Instance.new("Frame")
loadingFrame.Parent = screenGui
loadingFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
loadingFrame.Position = UDim2.new(0.35, 0, 0.45, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- 在加载Frame上添加TextLabel用于显示加载百分比
local loadingTextLabel = Instance.new("TextLabel")
loadingTextLabel.Parent = loadingFrame
loadingTextLabel.Size = UDim2.new(1, 0, 1, 0)
loadingTextLabel.Text = "加载中: 0%"
loadingTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
loadingTextLabel.TextXAlignment = Enum.TextXAlignment.Center
loadingTextLabel.TextYAlignment = Enum.TextYAlignment.Center

-- 创建一个Frame作为白板界面
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0.2, 0, 0.2, 0)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- 白色背景，类似白板

-- 在Frame上添加TextLabel作为字幕
local textLabel = Instance.new("TextLabel")
textLabel.Parent = frame
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "小丑你还玩上脚本了"
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- 黑色文字
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.TextYAlignment = Enum.TextYAlignment.Center

-- 自动移动的函数
local function moveFrame()
    local tweenService = game:GetService("TweenService")
    local newPosition = UDim2.new(0.6, 0, 0.6, 0)
    local tweenInfo = TweenInfo.new(
        5, -- 移动时间为5秒
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )
    local tween = tweenService:Create(frame, tweenInfo, {Position = newPosition})
    tween:Play()
end

-- 加载进度更新函数
local function updateLoading()
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        5, -- 加载时间为5秒
        Enum.EasingStyle.Linear
    )
    local goal = {Text = "加载中: 100%"}
    local tween = tweenService:Create(loadingTextLabel, tweenInfo, goal)
    tween:Play()
    tween.Completed:Connect(function()
        -- 加载完成后显示白板界面，隐藏加载界面
        loadingFrame.Visible = false
        frame.Visible = true
        moveFrame()
    end)
end

-- 开始加载
updateLoading()
