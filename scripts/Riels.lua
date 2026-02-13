-- TODO: fix auto brainrots ( im not fixing xd )
repeat print'loading' until game:IsLoaded()

-- ============================================================================
-- SERVICES / GLOBALS
-- ============================================================================
local p = game:GetService'Players'
local TweenService = game:GetService'TweenService'
local reps = game:GetService'ReplicatedStorage'
local rf = reps.RemoteFunctions
local lp = p.LocalPlayer

local version = '1.0.01'
local tier = ''

-- ============================================================================
-- WORLD HELPERS
-- ============================================================================
local function getbase()
 local bases = workspace.Bases
 for i, v in pairs(bases:GetChildren()) do
  if v:IsA'Model' and v:GetAttribute'Holder' == lp.UserId then
   return v
  end
 end
 return nil
end

local function home()
 local base = getbase()
 if not base then return end
 local part = base.Home
 if not part then return end
 pcall(function()
  game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
 end)
end

local function speedchanger()
 local speed = getgenv().Scv or 16
 lp:SetAttribute('CurrentSpeed', speed)
end

local function tween_to(cf, duration)
 local character = lp.Character
 if not character then return end
 local hrp = character:FindFirstChild('HumanoidRootPart')
 if not hrp then return end
 local tween = TweenService:Create(
  hrp,
  TweenInfo.new(duration or 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
  {CFrame = cf}
 )
 tween:Play()
 tween.Completed:Wait()
end

-- ============================================================================
-- TSUNAMI HELPERS
-- ============================================================================
local function godmode()
 local at = workspace.ActiveTsunamis
 if not at then return end
 for i, v in pairs(at:GetDescendants()) do
  if v:IsA'BasePart' and v.Name == 'Hitbox' then
   v:Destroy()
  end
 end
end

local function notsu()
 local at = workspace.ActiveTsunamis
 if not at then return end
 for i, v in pairs(at:GetDescendants()) do
  if v:IsA'BasePart' then
   v.Transparency = 1
  end
 end
end

local function get_nearest_tsunami_distance(origin)
 local at = workspace:FindFirstChild('ActiveTsunamis')
 if not at then return nil end
 local nearest
 for i, v in pairs(at:GetDescendants()) do
  if v:IsA'BasePart' and v.Name == 'Hitbox' then
   local dist = (v.Position - origin).Magnitude
   if not nearest or dist < nearest then
    nearest = dist
   end
  end
 end
 return nearest
end

local function wait_until_tsunami_safe(min_dist)
 local character = lp.Character
 if not character then return end
 local hrp = character:FindFirstChild('HumanoidRootPart')
 if not hrp then return end
 while true do
  local nearest = get_nearest_tsunami_distance(hrp.Position)
  if not nearest or nearest > min_dist then
   return
  end
  task.wait(0.2)
 end
end

local function enable_noclip()
 local character = lp.Character
 if not character then return end
 for i, v in pairs(character:GetDescendants()) do
  if v:IsA'BasePart' then
   v.CanCollide = false
  end
 end
end

local function disable_noclip()
 local character = lp.Character
 if not character then return end
 for i, v in pairs(character:GetDescendants()) do
  if v:IsA'BasePart' then
   v.CanCollide = true
  end
 end
end

-- ============================================================================
-- WALL HELPERS
-- ============================================================================
local function remove_walls()
 local walls = workspace:FindFirstChild('Walls')
 if walls then
  walls:Destroy()
 end
 local vipwalls = workspace:FindFirstChild('VIPWalls')
 if vipwalls then
  vipwalls:Destroy()
 end
end

-- ============================================================================
-- REMOTE ACTIONS
-- ============================================================================
local function upgradespeed()
 local remote = rf.UpgradeSpeed
 remote:InvokeServer(5)
end

local function rebirth()
 local remote = rf.Rebirth
 remote:InvokeServer()
end

local function upgrade()
 local remote = rf.UpgradeBase
 remote:InvokeServer()
end

local function upgradec()
 local remote = rf.UpgradeCarry
 remote:InvokeServer()
end

local function sellall()
 local remote = rf.SellAll
 remote:InvokeServer()
end

local function upgradeb(slot)
 --"Slot1"
 local remote = rf.UpgradeBrainrot
 remote:InvokeServer(slot)
end

local function upgradeallb()
 local base = getbase()
 if not base then print'nobase'return end
 for i, v in pairs(base.Slots:GetChildren()) do
  if v:IsA'Model' and v.Name:lower():find'slot' and v:FindFirstChildWhichIsA'Tool' then
   upgradeb(v.Name)
  end
 end
end

-- ============================================================================
-- AUTO BRAINROTS
-- ============================================================================
local function gettiers()
 local tiers = {}
 local ab = workspace.ActiveBrainrots
 if not ab then return end
 for i, v in pairs(ab:GetChildren()) do
  if v:IsA'Folder' then
   table.insert(tiers, v.Name)
  end
 end
 return tiers
end

local function gayfunc()
 local plrgui = lp.PlayerGui
 if not plrgui then return end
 for i, v in pairs(plrgui:GetDescendants()) do
  if v:IsA'TextLabel' and v.Text == 'Carry limit reached!' then
   local safearea = workspace.Misc.Ground
   game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame = safearea.CFrame + CFrame.new(0,5,0)
  end
 end
end

local function autobrainrot()
 if not tier or tier == '' then print'line 84'return end
 local ab = workspace.ActiveBrainrots
 if not ab then print'line 85'return end
 local folder = ab:FindFirstChild(tier)
 if not folder then print'line 87'return end
 for i, v in pairs(folder:GetChildren()) do
  if v:IsA'Model' and not v:GetAttribute'Fahh' then
   v:SetAttribute('Fahh','dih')
    if v.PrimaryPart then
     pcall(function()
       wait_until_tsunami_safe(5)
      enable_noclip()
      local current_speed = lp:GetAttribute('CurrentSpeed') or 16
      local target_pos = v.PrimaryPart.Position
      local start_pos = CFrame.new(137, 5, -134)
      local staging = CFrame.new(target_pos.X, 5, -134)
      local dist1 = (start_pos.Position - lp.Character.HumanoidRootPart.Position).Magnitude
      local dist2 = (staging.Position - start_pos.Position).Magnitude
      local dist3 = (target_pos - staging.Position).Magnitude
      tween_to(start_pos, dist1 / current_speed)
      tween_to(staging, dist2 / current_speed)
      tween_to(v.PrimaryPart.CFrame, dist3 / current_speed)
      disable_noclip()
     end)
    end
   task.wait(1)
    local handle = v:FindFirstChild'Handle'
    if handle then
     local prompt = handle.TakePrompt
     if prompt then
      pcall(function()
        prompt.HoldDuration = 0
        fireproximityprompt(prompt)
      end)
     end
    end
  end
 end
end
-- ============================================================================
-- UI
-- ============================================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:SetNotificationLower(true)
local Window = WindUI:CreateWindow({
 Title = "Escape Tsumami For Brainrots! v" .. version,
 Icon = "sparkles",
 Author = "by rizuuu",
})
Window:SetToggleKey(Enum.KeyCode.L)
local Main = Window:Tab({
 Title = "Main",
 Icon = "sparkles",
 Locked = false,
})
local AutoB = Window:Tab({
 Title = "Auto Brainrots",
 Icon = "sparkles",
 Locked = false,
})
Main:Select()
local Tth = Main:Button({
 Title = "Tp to home",
 Locked = false,
 Callback = function()
  pcall(function()
   home()
  end)
 end
})
local Gm = Main:Toggle({
 Title = "Godmode",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Gm = state
 end
})
local Nt = Main:Toggle({
 Title = "No tsumani [ u can still die ]",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Nt = state
 end
})
local Aus = Main:Toggle({
 Title = "Auto upgrade speed",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Aus = state
 end
})
local Auc = Main:Toggle({
 Title = "Auto upgrade carry",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Auc = state
 end
})
local Asa = Main:Toggle({
 Title = "Auto sell all",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Asa = state
 end
})
local Rw = Main:Toggle({
 Title = "Remove walls",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Rw = state
 end
})
local Ar = Main:Toggle({
 Title = "Auto rebirth",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Ar = state
 end
})
local Aub = Main:Toggle({
 Title = "Auto upgrade base",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Aub = state
 end
})
local Aub2 = Main:Toggle({
 Title = "Auto upgrade brainrots",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Aub2 = state
 end
})
local Sc = Main:Toggle({
 Title = "Speed changer",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().Sc = state
 end
})
local Scv = Main:Slider({
 Title = "Speed",
 Step = 1,
 Value = {
  Min = 16,
  Max = 300,
  Default = 16,
 },
 Callback = function(value)
  getgenv().Scv = tonumber(value) or 16
 end
})
local AB = AutoB:Toggle({
 Title = "Auto brainrots",
 Icon = "sparkles",
 Type = "Toggle",
 Value = false,
 Callback = function(state)
  getgenv().AutoBrainrots = state
 end
})
local Tiers = AutoB:Dropdown({
 Title = "Tier",
 Values = gettiers(),
 Value = "Secret",
 Callback = function(option) 
  tier = tostring(option)
  print(tier)
 end
})
-- ============================================================================
-- MAIN LOOP
-- ============================================================================
spawn(function()
 while true do
  task.wait()
  if getgenv().Gm then
   spawn(function()
    pcall(function()
     godmode()
    end)
   end)
  end
  if getgenv().Nt then
   spawn(function()
    pcall(function()
     notsu()
    end)
   end)
  end
  if getgenv().Aus then
   spawn(function()
    pcall(function()
     upgradespeed()
    end)
   end)
  end
  if getgenv().Auc then
   spawn(function()
    pcall(function()
     upgradec()
    end)
   end)
  end
  if getgenv().Asa then
   spawn(function()
    pcall(function()
     sellall()
    end)
   end)
  end
  if getgenv().Rw then
   spawn(function()
    pcall(function()
     remove_walls()
    end)
   end)
  end
  if getgenv().Ar then
   spawn(function()
    pcall(function()
     rebirth()
    end)
   end)
  end
  if getgenv().Aub then
   spawn(function()
    pcall(function()
     upgrade()
    end)
   end)
  end
  if getgenv().Aub2 then
   spawn(function()
    pcall(function()
     upgradeallb()
    end)
   end)
  end
  if getgenv().Sc then
   spawn(function()
    pcall(function()
     speedchanger()
    end)
   end)
  end
  if getgenv().AutoBrainrots then
   spawn(function()
    pcall(function()
     spawn(gayfunc)
     spawn(autobrainrot)
    end)
   end)
  end
 end
end)
