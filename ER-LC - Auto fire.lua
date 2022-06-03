if not game.PlaceId == 2534724415 then return end

local function AutoFire()
	-- Variables
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local CurrentCamera = workspace.CurrentCamera
	local UserInputService = game:GetService("UserInputService")

	 -- Whitelist
	local Whitelist = {}; table.insert(Whitelist, LocalPlayer)
	local function SortWhitelist()
    	for i, Player in pairs(Players:GetPlayers()) do
			if Player ~= LocalPlayer then
				if Player:IsFriendsWith(LocalPlayer.UserId) then
					if not table.find(Whitelist, Player) then
						table.insert(Whitelist, Player)
					end
				else
					if table.find(Whitelist, Player) then
						table.remove(Whitelist, table.find(Whitelist, Player))
					end
				end 
			end
		end
	end
	Players.PlayerAdded:Connect(function(Player)
		if Player:IsFriendsWith(LocalPlayer.UserId) then
			table.insert(Whitelist, Player)
		end 
	end)

    SortWhitelist()
    coroutine.wrap(function()
        while wait(5) do
           pcall(SortWhitelist) 
        end
    end)()

	-- Return whether Player is in Whitelist
	local function PlayerInWhitelist(Player)
		return table.find(Whitelist, Player) ~= nil
	end

	-- Return whether Player has a weapon
	local function PlayerHasWeapon(Player)
		local Backpack = Player:FindFirstChild("Backpack")
		if not Backpack then return false end
		for i, v in pairs(Backpack:GetChildren()) do
			if v:IsA("Tool") and (v:FindFirstChild("Core", true) or v.Name == "Taser" or v.Name == "Handcuffs") then
				return true
			end 
		end

		local Character = Player.Character
		if not Character then return false end
		local Tool = Character:FindFirstChildOfClass("Tool", true)
		if not Tool then return false end
		if Tool:FindFirstChild("Core", true) then return true end
		
		return false
	end

	-- Defines what the mouse is targetting/checks if it is a valid target
	local function DefineMouseTarget(MouseTarget)
		local Target, TargetType = nil, nil

        if not MouseTarget then return nil end
        
		-- Identify Target as Humanoid 
		if MouseTarget and MouseTarget.Parent:IsA("Model") then
			Target = Players:GetPlayerFromCharacter(MouseTarget.Parent); TargetType = "Player";
		end;
		if not CurrentCamera and MouseTarget and MouseTarget.Parent ~= workspace and MouseTarget.Parent.Parent:IsA("Model") then
			Target = Players:GetPlayerFromCharacter(MouseTarget.Parent.Parent); TargetType = "Player";
		end;

		-- Identify Target as Wheel
		if not MouseTarget.Parent or not MouseTarget.Parent.Parent then return nil end
		if MouseTarget.Name == "Base" and MouseTarget.Parent.Parent.Name == "Wheels" then
			Target = MouseTarget; TargetType = "Tire"
		end

		return Target, TargetType
	end
	local function CheckTargetIsValid(Target, TargetType)
		if TargetType == "Player" then
			return (not PlayerInWhitelist(Target) and PlayerHasWeapon(Target) and (Target.Character:FindFirstChild("Humanoid").Health > 0))
		elseif TargetType == "Tire" then
			-- Check Tire has Vehicle Ancestor
			local Vehicle = Target.Parent.Parent.Parent
			if not Vehicle:IsA("Model") then return false end

			-- Check Vehicle has 'Owner'
			local Control_Values = Vehicle:FindFirstChild("Control_Values")
			if not Control_Values then return false end
			local Owner = Control_Values:FindFirstChild("Owner", true)
			if not Owner then return false end 
			Target = Players:FindFirstChild(Owner.Value)
			local Health = Control_Values:FindFirstChild("Health", true)
			if not Health then return false end

			return (not PlayerInWhitelist(Target) and PlayerHasWeapon(Target) and (Health.Value > 0))
		end
		return false
	end

	game:GetService("RunService").Heartbeat:Connect(function()
		-- Sanity checks
		local Mouse = LocalPlayer:GetMouse()
		local Character = LocalPlayer.Character
			if not Character then return end
		local Tool = Character:FindFirstChildOfClass("Tool", true)
			if not Tool or not Tool:FindFirstChild("Core", true) then Mouse.Icon = ""; return end
		

		local Target, TargetType = DefineMouseTarget(Mouse.Target)
		-- If the mouse is on a definable target
		if (Target and TargetType) then
			-- If the target is valid: (click)
			if CheckTargetIsValid(Target, TargetType) then
				Mouse.Icon = "rbxassetid://3007984466" -- Red
			    mouse1press(); wait(); mouse1release()
			-- If the target is invalid: (no click, green crosshair)
			else
				Mouse.Icon = "rbxassetid://3007984467" -- Green
			end
		-- If the mouse is not on a definable target:
		else
			Mouse.Icon = "rbxassetid://2973432460" -- White
    	end
	end)
end


repeat wait(0.2) until game:IsLoaded();
AutoFire()
warn("Auto-fire is enabled.")
