local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function createTween(instance, properties, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "HitboxGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(200, 50, 50)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Text = "But Mohammad can"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ToggleButton.Text = "Enable Hitbox"
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)

local SizeLabel = Instance.new("TextLabel", Frame)
SizeLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
SizeLabel.Size = UDim2.new(0.8, 0, 0.15, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Hitbox Size: 5"
SizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeLabel.TextScaled = true
SizeLabel.Font = Enum.Font.GothamBold

local IncreaseButton = Instance.new("TextButton", Frame)
IncreaseButton.Position = UDim2.new(0.1, 0, 0.7, 0)
IncreaseButton.Size = UDim2.new(0.35, 0, 0.15, 0)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
IncreaseButton.Text = "+"
IncreaseButton.TextScaled = true
IncreaseButton.Font = Enum.Font.GothamBold
IncreaseButton.TextColor3 = Color3.new(1, 1, 1)

local DecreaseButton = Instance.new("TextButton", Frame)
DecreaseButton.Position = UDim2.new(0.55, 0, 0.7, 0)
DecreaseButton.Size = UDim2.new(0.35, 0, 0.15, 0)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
DecreaseButton.Text = "-"
DecreaseButton.TextScaled = true
DecreaseButton.Font = Enum.Font.GothamBold
DecreaseButton.TextColor3 = Color3.new(1, 1, 1)

local CreditsLabel = Instance.new("TextLabel", Frame)
CreditsLabel.Position = UDim2.new(0, 0, 0.9, 0)
CreditsLabel.Size = UDim2.new(1, 0, 0.1, 0)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "Credits: Mohammad Khan"
CreditsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
CreditsLabel.TextScaled = true
CreditsLabel.Font = Enum.Font.Gotham

local MinimizeButton = Instance.new("TextButton", Frame)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.GothamBold

-- Logic
local hitboxEnabled = false
local hitboxSize = 5
local hitboxes = {}

local function applyHitbox(part)
	part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	part.Transparency = 0.7
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Material = Enum.Material.ForceField
	part.Anchored = false
	part.CanCollide = false
end

local function enableHitboxes()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name == "HumanoidRootPart" and v.Parent:FindFirstChildOfClass("Humanoid") then
			if not hitboxes[v] then
				local box = Instance.new("BoxHandleAdornment")
				box.Adornee = v
				box.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				box.AlwaysOnTop = true
				box.ZIndex = 5
				box.Color3 = Color3.fromRGB(255, 0, 0)
				box.Transparency = 0.5
				box.Parent = v
				hitboxes[v] = box
			end
		end
	end
end

local function disableHitboxes()
	for part, adornment in pairs(hitboxes) do
		if adornment then
			adornment:Destroy()
		end
	end
	hitboxes = {}
end

local function updateHitboxSize(newSize)
	for part, adornment in pairs(hitboxes) do
		if adornment then
			adornment.Size = Vector3.new(newSize, newSize, newSize)
		end
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	if hitboxEnabled then
		ToggleButton.Text = "Disable Hitbox"
		createTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(100, 200, 100)}, 0.3)
		enableHitboxes()
	else
		ToggleButton.Text = "Enable Hitbox"
		createTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(180, 60, 60)}, 0.3)
		disableHitboxes()
	end
end)

IncreaseButton.MouseButton1Click:Connect(function()
	hitboxSize = hitboxSize + 1
	SizeLabel.Text = "Hitbox Size: " .. hitboxSize
	updateHitboxSize(hitboxSize)
end)

DecreaseButton.MouseButton1Click:Connect(function()
	hitboxSize = math.max(1, hitboxSize - 1)
	SizeLabel.Text = "Hitbox Size: " .. hitboxSize
	updateHitboxSize(hitboxSize)
end)

MinimizeButton.MouseButton1Click:Connect(function()
	local isVisible = ToggleButton.Visible
	for _, v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			if v ~= MinimizeButton and v ~= TitleBar and v ~= TitleLabel then
				v.Visible = not isVisible
			end
		end
	end
	MinimizeButton.Text = isVisible and "+" or "-"
end)
