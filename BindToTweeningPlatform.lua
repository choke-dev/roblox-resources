local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local partstomoveon = {
	"MovingPart"
}

local FindParts
local PlayerDiedEvent

local character = LocalPlayer.Character
local humanoid = character:WaitForChild("Humanoid")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lastFrame

FindParts = RunService.Heartbeat:Connect(function()
	local RaycastParameters = RaycastParams.new()
	RaycastParameters.FilterType = Enum.RaycastFilterType.Blacklist
	RaycastParameters.FilterDescendantsInstances = {character}

	local Ray = workspace:Raycast(HumanoidRootPart.Position, -HumanoidRootPart.CFrame.UpVector * 50, RaycastParameters)

	if Ray then
		local RayInstance = Ray.Instance

		if table.find(partstomoveon, RayInstance.Name) then
			if lastFrame == nil then
				lastFrame = RayInstance.CFrame
			end

			local diff = RayInstance.CFrame * lastFrame:Inverse()
			lastFrame = RayInstance.CFrame

			HumanoidRootPart.CFrame = diff * HumanoidRootPart.CFrame
		else
			lastFrame = nil
		end
	end

	PlayerDiedEvent = humanoid.Died:Connect(function()
		FindParts:Disconnect()
		PlayerDiedEvent:Disconnect()
	end)
end)
