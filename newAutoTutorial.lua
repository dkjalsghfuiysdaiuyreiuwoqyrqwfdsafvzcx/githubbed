loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
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

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("SettingsAPI/SetSetting"):FireServer("theme_color", "red")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/ChooseTeam"):InvokeServer("Parents", {["source_for_logging"] = "intro_sequence", ["dont_enter_location"] = true})
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Tutorial Started")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Editor Opened")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/SubmitAvatarAnalyticsEvent"):FireServer("opened")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/SetGender"):FireServer("male")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Editor Closed")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Housing Tutorial Started")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Housing Editor Opened")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SendHousingOnePointOneLog"):FireServer("edit_state_entered", {["house_type"] = "mine"})
local args = {
    [1] = {}
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/PushFurnitureChanges"):FireServer(unpack(args))
local args = {
    [1] = "edit_state_exited",
    [2] = {}
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SendHousingOnePointOneLog"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("House Exited")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Nursery Tutorial Started")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Nursery Entered")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/EquipTutorialEgg"):FireServer()
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Started Egg Received")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/AddTutorialQuest"):FireServer()
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Tutorial Ailment Spawned")
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/AddHungryAilmentToTutorialEgg"):FireServer()
local args = {
    [1] = workspace:WaitForChild("Pets"):WaitForChild("Starter Egg")
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/FocusPet"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/MarkTutorialCompleted"):FireServer()



getgenv().PetFarmGui = true
_G.key = "admins0000"
loadstring(game:HttpGet('https://raw.githubusercontent.com/dkjalsghfuiysdaiuyreiuwoqyrqwfdsafvzcx/Tests/refs/heads/main/guitest.lua'))()

getgenv().eggToFarm = "moon_2025_egg"
getgenv().AutoBuyEggs = true
loadstring(game:HttpGet('https://raw.githubusercontent.com/dkjalsghfuiysdaiuyreiuwoqyrqwfdsafvzcx/Tests/refs/heads/main/OldEggFarm1.lua'))()


getgenv().eggToFarm = "moon_2025_egg"
getgenv().AutoBuyEggs = true
getgenv().PrioritizeLegs = false
loadstring(game:HttpGet('https://raw.githubusercontent.com/dkjalsghfuiysdaiuyreiuwoqyrqwfdsafvzcx/Tests/refs/heads/main/Top10fix4.lua'))()


local function getAilments(tbl)
    PetAilmentsArray = {}
    for key, value in pairs(tbl) do
        if key == petToEquip then
            for subKey, subValue in pairs(value) do
                table.insert(PetAilmentsArray, subValue.kind)
                print("ailment added: ", subValue.kind)
            end
        end
    end
end

local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local ailments = ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets
for x, y in pairs(ailments) do
    print(y.kind)
end

local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local Cash = ClientData.get_data()[game.Players.LocalPlayer.Name].money
print(Cash)

local args = {
    [1] = workspace:WaitForChild("Pets"):WaitForChild("Moon Egg")
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/HoldBaby"):FireServer(unpack(args))
















local args = {
    [1] = "npc_interaction"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))

local args = {
    [1] = "dog"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ChoosePet"):FireServer(unpack(args))
local args = {
    [1] = 2,
    [2] = {
        ["chosen_pet"] = "dog"
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
local args = {
    [1] = 3,
    [2] = {
        ["named_pet"] = false
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectAllHeldBabies"):FireServer()
local args = {
    [1] = "pet_me"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/SpawnTutorialAilment"):FireServer(unpack(args))
local args = {
    [1] = "focused_pet"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
local args = {
    [1] = "selected_pet_me_ailment"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
local args = {
    [1] = 4
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
local args = {
    [1] = 5
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/SpawnPetTreat"):FireServer()
local args = {
    [1] = "hungry"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/SpawnTutorialAilment"):FireServer(unpack(args))
local args = {
    [1] = "focused_pet_2"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
local args = {
    [1] = "selected_hungry_ailment"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
local args = {
    [1] = 6
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
local args = {
    [1] = 7
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/AddTutorialQuest"):FireServer()
local args = {
    [1] = "opened_taskboard"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("QuestAPI/MarkQuestsViewed"):FireServer()
local args = {
    [1] = 8
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(unpack(args))
local args = {
    [1] = "play"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/SpawnTutorialAilment"):FireServer(unpack(args))
local args = {
    [1] = "focused_pet_3"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
local args = {
    [1] = "started_playground_nav"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer(unpack(args))
