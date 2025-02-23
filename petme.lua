
local router

for i, v in next, getgc(true) do
    if type(v) == 'table' and rawget(v, 'get_remote_from_cache') then
        router = v
    end
end

local function rename(remotename, hashedremote)
    hashedremote.Name = remotename
end
-- Apply renaming to upvalues of the RouterClient.init function
table.foreach(debug.getupvalue(router.get_remote_from_cache, 1), rename)

local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local args = {
    [1] = workspace:WaitForChild("Pets"):WaitForChild("Starter Egg")
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/FocusPet"):FireServer(unpack(args))


local args = {
    [1] = ClientData.get("pet_char_wrappers")[1].pet_unique
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AilmentsAPI/ProgressPetMeAilment"):FireServer(unpack(args))


