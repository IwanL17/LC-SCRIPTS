local _VERSION_ = "1.0a"

if game.PlaceId == 2534724415 then 
    repeat wait(0.2) until game:IsLoaded()
    
    local function autoPickLock()
        local UI = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameMenus"):WaitForChild("Lockpick")
            
            -- Function to auto pick lock
            local pick = UI:WaitForChild("Pick")
            local c1
            for i, v in pairs(pick:GetChildren()) do
                c1 = v:GetPropertyChangedSignal("Position"):Connect(function()
                    if v.Position.Y.Scale > 0.48 and v.Position.Y.Scale < 0.52 then
                        mouse1click();
                    end
                end)
            end
        
        -- Handle UI reset
        local c2; c2 = pick:GetPropertyChangedSignal("Parent"):Connect(function()
            c1:Disconnect(); c2:Disconnect(); autoPickLock()
        end)
    end
    
    local function autoRobJewlery()
        local UI = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameMenus"):WaitForChild("RobJewelry")
        
            -- Function to auto rob jewlery
            local bar = UI:WaitForChild("Drill"):WaitForChild("Bar")
            local c1; c1 = bar:GetPropertyChangedSignal("Position"):Connect(function()
                if bar.Position.X.Scale < 0.5 then 
                    mouse1press()
                elseif bar.Position.X.Scale > 0.5 then
                    mouse1release()
                end
            end)
        
        -- Handle UI reset
        local c; c = bar:GetPropertyChangedSignal("Parent"):Connect(function()
           c:Disconnect(); c1:Disconnect(); autoRobJewlery() 
        end)
    end
    
    local function autoRobATM()
        local UI = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameMenus"):WaitForChild("ATM"):WaitForChild("Hacking")
    
            -- Function to auto rob ATM
            local SelectingCode = UI:WaitForChild("SelectingCode")
    
            local c3
            local function findAndClickCode()
                if UI.Visible == false then return end
                
                -- Cycle through all the given codes for a match
                for i, v in pairs(UI:WaitForChild("CycleFrame"):GetDescendants()) do
                    if v:IsA("TextLabel") then
                        if v.Text == SelectingCode.Text then
                            -- When match is found, wait for background colour change, then click!
                            c3 = v:GetPropertyChangedSignal("TextColor3"):Connect(function()
                                if v.TextColor3 == Color3.new(0, 0, 0) then mouse1click() end
                            end)
                        end
                    end
                end
            end
            
            -- When a new code is to be found:
            findAndClickCode()
            local c1; c1 = SelectingCode:GetPropertyChangedSignal("Text"):Connect(function()
                if c3 then c3:Disconnect() end; findAndClickCode()
            end)
    
        -- Handle UI reset
        local c2; c2 = UI:GetPropertyChangedSignal("Parent"):Connect(function()
            c1:Disconnect(); c2:Disconnect(); if c3 then c3:Disconnect() end; autoRobATM() 
        end)
    end
    
    
    autoPickLock(); warn("Auto pick-lock activated. (V".._VERSION_..")")
    autoRobJewlery(); warn("Auto-rob jewlery activated. (V".._VERSION_..")")
    autoRobATM(); warn("Auto-rob ATM activated. (V".._VERSION_..")")
end
