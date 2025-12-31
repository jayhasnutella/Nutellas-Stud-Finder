local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent to trigger lag on target client
local LagEvent = Instance.new("RemoteEvent")
LagEvent.Name = "LagEvent"
LagEvent.Parent = ReplicatedStorage

-- Client-side lag handler
LagEvent.OnClientEvent:Connect(function()
	spawn(function()
		while true do
			local a = {}
			for j = 1, 100 do
				a[j] = math.sqrt(j) * math.sin(j)
			end
			wait(0)
		end
	end)
end)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealABrainrotGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = "Steal A Brainrot"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

-- Player list
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, -20, 1, -110)
playerListFrame.Position = UDim2.new(0, 10, 0, 40)
playerListFrame.CanvasSize = UDim2.new()
playerListFrame.ScrollBarThickness = 6
playerListFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = playerListFrame

local selectedPlayer

local function updateCanvas()
	playerListFrame.CanvasSize = UDim2.new(
		0, 0,
		0, uiListLayout.AbsoluteContentSize.Y + 10
	)
end

uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function updatePlayerList()
	for _, child in ipairs(playerListFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			btn.Text = player.Name
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 18
			btn.Parent = playerListFrame

			btn.MouseButton1Click:Connect(function()
				selectedPlayer = player
				for _, b in ipairs(playerListFrame:GetChildren()) do
					if b:IsA("TextButton") then
						b.BackgroundColor3 = Color3.fromRGB(60,60,60)
					end
				end
				btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
			end)
		end
	end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Button
local lagButton = Instance.new("TextButton")
lagButton.Size = UDim2.new(1, -20, 0, 40)
lagButton.Position = UDim2.new(0, 10, 1, -55)
lagButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
lagButton.Text = "ACTION"
lagButton.TextColor3 = Color3.new(1,1,1)
lagButton.Font = Enum.Font.SourceSansBold
lagButton.TextSize = 24
lagButton.Parent = mainFrame

lagButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end

	StarterGui:SetCore("SendNotification", {
		Title = "Selected Player",
		Text = selectedPlayer.Name .. " selected",
		Duration = 2
	})

	-- Fire the lag event only to the selected player
	LagEvent:FireClient(selectedPlayer)
end)
