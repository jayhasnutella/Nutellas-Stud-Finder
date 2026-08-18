-- Nutella Coordinate Copier
-- Put this LocalScript inside StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "CoordinateCopier"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 150)
Main.Position = UDim2.new(0.5, -150, 0.5, -75)
Main.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
Main.BorderSizePixel = 0
Main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = Main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 70, 255)
stroke.Thickness = 2
stroke.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "Nutella Coordinates"
Title.TextColor3 = Color3.fromRGB(220, 170, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- Coordinates
local Coords = Instance.new("TextLabel")
Coords.Size = UDim2.new(1, -20, 0, 35)
Coords.Position = UDim2.new(0, 10, 0, 38)
Coords.BackgroundTransparency = 1
Coords.Text = "X: 0 | Y: 0 | Z: 0"
Coords.TextColor3 = Color3.fromRGB(255, 255, 255)
Coords.TextSize = 15
Coords.Font = Enum.Font.Gotham
Coords.Parent = Main

-- Copy button
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -40, 0, 45)
CopyButton.Position = UDim2.new(0, 20, 0, 88)
CopyButton.BackgroundColor3 = Color3.fromRGB(115, 35, 190)
CopyButton.BorderSizePixel = 0
CopyButton.Text = "COPY COORDINATES"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 15
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = Main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = CopyButton

-- Update coordinates
local function updateCoordinates()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then
		local pos = root.Position

		Coords.Text = string.format(
			"X: %.2f | Y: %.2f | Z: %.2f",
			pos.X,
			pos.Y,
			pos.Z
		)
	end
end

task.spawn(function()
	while true do
		updateCoordinates()
		task.wait(0.1)
	end
end)

-- Copy
CopyButton.MouseButton1Click:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then
		local pos = root.Position

		local text = string.format(
			"Vector3.new(%.2f, %.2f, %.2f)",
			pos.X,
			pos.Y,
			pos.Z
		)

		-- Roblox Studio / supported environments
		if setclipboard then
			setclipboard(text)
		end

		CopyButton.Text = "Copied!"

		task.wait(1)

		CopyButton.Text = "COPY COORDINATES"
	end
end)

--==================================================
-- DRAGGABLE UI
--==================================================

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

Main.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

Main.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if dragging then

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end
end)
