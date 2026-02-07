local Players =game:GetService("Players")
local player = Players.LocalPlayer

local getService = setmetatable({}, {
    __index = function(selff, serviceName)
        local service = cloneref(game:GetService(serviceName))
        rawset(selff, serviceName, service)
        return service
    end;
})

local hopServer = function()
    local req = (request or http_request)({Url = string.format('https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true', game.PlaceId)})
    local body = getService.HttpService:JSONDecode(req.Body)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == 'table' and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                task.wait(0.2)
                getService.TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
            end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if getgenv().autofarm then
            pcall(function()
                for _,v in next,workspace:GetChildren() do
                    if v:IsA("BasePart") and v.Name:find("GatePad") and player.Team.Name ~= "Winners" then
                        firetouchinterest(player.Character.HumanoidRootPart,v,0)
                        task.wait(0.3)
                        firetouchinterest(player.Character.HumanoidRootPart,v,1)
                    elseif player.Team.Name == "Winners" then
                        task.wait(0.7)
                        hopServer()
                        break
                    end
                end
            end)
        end
    end
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dynamic Hub " .. Fluent.Version,
    SubTitle = "by gugamedes_001",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

    Fluent:Notify({
        Title = "Dynamic Hub",
        Content = "by.gugamedes_001",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })



    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Farm", Default = true })

    Toggle:OnChanged(function(v)
        getgenv().autofarm = v
    end)
