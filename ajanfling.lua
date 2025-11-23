local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
repeat wait() until lp and lp:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

local h = Instance.new("ScreenGui")
h.Name = "h"
pcall(function() h.Parent = game:GetService("CoreGui") end)
if not h.Parent then h.Parent = lp:WaitForChild("PlayerGui") end
h.ResetOnSpawn = false

local function gplr(str)
	local Found = {}
	local strl = str:lower()
	for _, v in pairs(Players:GetPlayers()) do
		local uname = v.Name:lower()
		local dname = v.DisplayName:lower()
		if strl == "all" then
			table.insert(Found, v)
		elseif strl == "others" and v.Name ~= lp.Name then
			table.insert(Found, v)
		elseif strl == "me" and v.Name == lp.Name then
			table.insert(Found, v)
		elseif uname:sub(1, #strl) == strl or dname:sub(1, #strl) == strl then
			table.insert(Found, v)
		end
	end
	return Found
end

local function notif(str, dur)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Ajan's Fling",
		Text = str,
		Icon = "rbxassetid://6023426926",
		Duration = dur or 3
	})
end

-- Main Frame scaled 3x
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = h
Main.Active = true
Main.Draggable = true
Main.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 1560, 0, 1020) -- 3x original 520x340
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0.05
Main.BorderColor3 = Color3.fromRGB(50,50,50)

-- Top Bar
local Top = Instance.new("Frame")
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Top.Size = UDim2.new(1, 0, 0, 120) -- 3x height

local Title = Instance.new("TextLabel")
Title.Parent = Top
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 30, 0, 15)
Title.Size = UDim2.new(1, -60, 0, 90)
Title.Font = Enum.Font.GothamBold
Title.Text = "Ajan's Fling"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Parent = Top
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.Position = UDim2.new(1, -120, 0, 15) -- 3x
Close.Size = UDim2.new(0, 105, 0, 90) -- 3x
Close.Font = Enum.Font.GothamBold
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextScaled = true
Close.MouseButton1Click:Connect(function() h:Destroy() end)

-- Minimize button 3x
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = Main
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Position = UDim2.new(1, -270, 0, 15)
MinimizeButton.Size = UDim2.new(0, 105, 0, 90)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

UIS.InputBegan:Connect(function(i, gpe)
	if gpe then return end
	if i.KeyCode == Enum.KeyCode.M then Main.Visible = not Main.Visible end
end)

-- TextBox 3x
local TextBox = Instance.new("TextBox")
TextBox.Parent = Main
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.Size = UDim2.new(0, 1320, 0, 180) -- 3x
TextBox.Font = Enum.Font.Gotham
TextBox.PlaceholderText = "Fling Username/Name"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextScaled = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown ScrollingFrame 3x and centered
local Drop = Instance.new("ScrollingFrame")
Drop.Parent = Main
Drop.BackgroundColor3 = Color3.fromRGB(30,30,30)
Drop.Position = UDim2.new(0.5, -600, 0.45, 0) -- center horizontally (Main.Size.X/2 - Drop.Width/2)
Drop.Size = UDim2.new(0, 1200, 0, 180) -- 3x
Drop.CanvasSize = UDim2.new(0,0,0,0)
Drop.ScrollBarThickness = 12 -- 3x
Drop.ClipsDescendants = false

local UIList = Instance.new("UIListLayout")
UIList.Parent = Drop
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Drop.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)
end)

local function refreshPlayers()
	for _,v in pairs(Drop:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _,v in ipairs(Players:GetPlayers()) do
		local B = Instance.new("TextButton")
		B.Parent = Drop
		B.Size = UDim2.new(1,-12,0,75) -- 3x 25
		B.BackgroundColor3 = Color3.fromRGB(50,50,50)
		B.BorderSizePixel = 0
		B.Font = Enum.Font.Gotham
		B.TextColor3 = Color3.fromRGB(255,255,255)
		B.TextScaled = true
		B.Text = v.Name
		B.MouseButton1Click:Connect(function()
			TextBox.Text = v.Name
		end)
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
coroutine.wrap(refreshPlayers)()
