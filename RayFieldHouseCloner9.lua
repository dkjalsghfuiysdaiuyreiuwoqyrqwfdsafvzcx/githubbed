
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

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EDixe House Cloner",
    Icon = 0,
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

local Tab = Window:CreateTab("House Cloner", "rewind")
Tab:CreateSection("Pastebin Settings")

-- Input Fields for Pastebin Credentials
Tab:CreateInput({
    Name = "Api Dev Key",
    CurrentValue = "",
    PlaceholderText = "Enter the Dev Key",
    RemoveTextAfterFocusLost = false,
    Flag = "DevKey",
    Callback = function(Text)
       _G.PASTEBIN_DEV_KEY = Text
    end,
})

Tab:CreateInput({
    Name = "Username",
    CurrentValue = "",
    PlaceholderText = "Enter the Username",
    RemoveTextAfterFocusLost = false,
    Flag = "Username",
    Callback = function(Text)
       _G.pastebinUsername = Text
    end,
})

Tab:CreateInput({
    Name = "Password",
    CurrentValue = "",
    PlaceholderText = "Enter the Password",
    RemoveTextAfterFocusLost = false,
    Flag = "Password",
    Callback = function(Text)
       _G.pastebinPassword = Text
    end,
})

Tab:CreateInput({
    Name = "House Name",
    CurrentValue = "",
    PlaceholderText = "Enter the House Name",
    RemoveTextAfterFocusLost = false,
    Flag = "HouseName",
    Callback = function(Text)
       _G.api_paste_name = Text
    end,
})

-- Dropdown for available pastes
local pasteDropdown
pasteDropdown = Tab:CreateDropdown({
    Name = "Available Pastes",
    Options = {"Not Loaded"},  -- Initial list
    CurrentOption = {"Not Loaded"}, -- Initial selection
    MultipleOptions = false,       -- Single selection
    Flag = "PasteDropdown",        -- For config saving
    Callback = function(Selected)
        print("Selected paste:", Selected[1])
    end,
})

-- Reusable function to log into Pastebin and get a userKey
local function pastebinLogin()
    local HttpService = game:GetService("HttpService")
    if not _G.PASTEBIN_DEV_KEY or not _G.pastebinUsername or not _G.pastebinPassword then
        warn("Please enter all Pastebin credentials first!")
        return nil
    end

    local loginData = {
        api_dev_key = _G.PASTEBIN_DEV_KEY,
        api_user_name = _G.pastebinUsername,
        api_user_password = _G.pastebinPassword
    }
    local loginBodyParts = {}
    for key, value in pairs(loginData) do
        table.insert(loginBodyParts, key .. "=" .. HttpService:UrlEncode(tostring(value)))
    end
    local loginBody = table.concat(loginBodyParts, "&")

    local loginReq = {
        Url = "https://pastebin.com/api/api_login.php",
        Method = "POST",
        Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
        Body = loginBody
    }
    local userKeyResponse = http_request(loginReq)
    print("Login response:", userKeyResponse.StatusMessage, userKeyResponse.Body)

    if userKeyResponse.Body:find("Bad API request") then
        warn("Login failed: " .. userKeyResponse.Body)
        return nil
    end

    return userKeyResponse.Body
end

-- Function to load available pastes and update the dropdown
local function loadAvailablePastes()
    local HttpService = game:GetService("HttpService")
    local userKey = pastebinLogin()
    if not userKey then return end

    local postData = {
        api_dev_key = _G.PASTEBIN_DEV_KEY,
        api_user_key = userKey,
        api_option = "list",
        api_results_limit = "100"
    }
    local formBodyParts = {}
    for key, value in pairs(postData) do
        table.insert(formBodyParts, key .. "=" .. HttpService:UrlEncode(tostring(value)))
    end
    local formBody = table.concat(formBodyParts, "&")

    local listReq = {
        Url = "https://pastebin.com/api/api_post.php",
        Method = "POST",
        Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
        Body = formBody
    }
    local listResponse = http_request(listReq)
    if not listResponse or not listResponse.Body then
        warn("Failed to retrieve paste list")
        return
    end

    local body = listResponse.Body
    local newOptions = {}
    for pasteData in body:gmatch("<paste>(.-)</paste>") do
        local title = pasteData:match("<paste_title>(.-)</paste_title>")
        local url   = pasteData:match("<paste_url>(.-)</paste_url>")
        if title and url then
            table.insert(newOptions, title .. " - " .. url)
        end
    end

    if #newOptions == 0 then
        newOptions = {"No pastes found"}
    end

    pasteDropdown:Refresh(newOptions)
    pasteDropdown:Set({newOptions[1]})
end

-- Button to manually load available pastes
Tab:CreateButton({
    Name = "Load Available Pastes",
    Callback = loadAvailablePastes,
})

-- House scanning logic + Pastebin upload, then refresh available pastes
Tab:CreateButton({
    Name = "Scan House",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
        local playerName = game.Players.LocalPlayer.Name

        local TextureData = ClientData.get_data()[playerName].house_interior.textures
        local FurnitureData = ClientData.get_data()[playerName].house_interior.furniture

        local function rebuildCFrame(cf)
            local comps = {cf:GetComponents()}
            return CFrame.new(unpack(comps))
        end

        local SaveData = {
            textures = TextureData,
            furniture = {}
        }

        for index, item in pairs(FurnitureData) do
            local cframeValue = rebuildCFrame(item.cframe)
            table.insert(SaveData.furniture, {
                id = item.id,
                scale = item.scale,
                cframe = { cframeValue:GetComponents() },
                colors = item.colors
            })
        end

        local jsonData = HttpService:JSONEncode(SaveData)
        local userKey = pastebinLogin()
        if not userKey then return end

        local postData = {
            api_dev_key = _G.PASTEBIN_DEV_KEY,
            api_user_key = userKey,
            api_option = "paste",
            api_paste_private = "1", -- 0=Public, 1=Unlisted, 2=Private
            api_paste_name = _G.api_paste_name or "Unnamed House",
            api_paste_code = jsonData
        }
        local formBodyParts = {}
        for key, value in pairs(postData) do
            table.insert(formBodyParts, key .. "=" .. HttpService:UrlEncode(tostring(value)))
        end
        local formBody = table.concat(formBodyParts, "&")
        local pasteReq = {
            Url = "https://pastebin.com/api/api_post.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
            Body = formBody
        }
        local pasteResponse = http_request(pasteReq)
        print("Pastebin response:", pasteResponse.StatusMessage, pasteResponse.Body)

        Rayfield:Notify({
            Title = "House Successfully Scanned",
            Content = "Data uploaded to Pastebin",
            Duration = 6.5,
            Image = 4483362458,
        })

        loadAvailablePastes()
    end,
})

-- "Clone House" button: fetches and executes code from the selected paste using http_request
Tab:CreateButton({
    Name = "Clone House",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BuyTexture = ReplicatedStorage:WaitForChild("API"):WaitForChild("HousingAPI/BuyTexture")
        local BuyFurnitures = ReplicatedStorage:WaitForChild("API"):WaitForChild("HousingAPI/BuyFurnitures")

        -- Get the currently selected paste from the dropdown
        local selectedOption = pasteDropdown.CurrentOption[1]
        if not selectedOption or selectedOption == "Not Loaded" or selectedOption == "No pastes found" then
            warn("No valid paste selected!")
            return
        end

        -- Expected format: "My House Data - https://pastebin.com/abc123"
        local splitted = selectedOption:split(" - ")
        local pasteUrl = splitted[2]  -- the URL portion

        if not pasteUrl or not pasteUrl:find("pastebin.com") then
            warn("Invalid paste URL!")
            return
        end

        -- Convert to raw URL: "https://pastebin.com/abc123" -> "https://pastebin.com/raw/abc123"
        local rawUrl = pasteUrl:gsub("pastebin%.com/", "pastebin.com/raw/")

        local req = {
            Url = rawUrl,
            Method = "GET"
        }
        local response = http_request(req)
        if not response or not response.Body then
            warn("Failed to fetch data from Pastebin!")
            return
        end

        -- Attempt to parse the fetched text as JSON (since it's house data, not raw Lua)
        local success, houseData = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not success then
            warn("Error parsing JSON from Pastebin: " .. tostring(houseData))
            return
        end

        -- Now we rebuild _G.HouseData in the format the “texture & furniture” code expects
        _G.HouseData = {}
        _G.HouseData.TextureData = houseData.textures

        -- Convert the stored furniture data into the FurnitureArgs structure
        local furnitureArgs = { [1] = {} }
        local i = 1
        for _, item in pairs(houseData.furniture) do
            -- Rebuild the CFrame from stored components
            local cframeValue = CFrame.new(unpack(item.cframe))
            furnitureArgs[1][i] = {
                ["kind"] = item.id,
                ["properties"] = {
                    ["scale"] = item.scale,
                    ["cframe"] = cframeValue,
                    ["colors"] = {}
                }
            }
            for colorIndex, colorValue in pairs(item.colors) do
                furnitureArgs[1][i].properties.colors[colorIndex] = colorValue
            end
            i = i + 1
        end
        _G.HouseData.FurnitureArgs = furnitureArgs

        -- Finally, run the same logic you had in the “PASTE THE TEXTURE AND FURNITURE” code
        -- Wait briefly to ensure everything is set
        task.wait(1)

        -- Apply textures
        if _G.HouseData and _G.HouseData.TextureData then
            for roomName, textureInfo in pairs(_G.HouseData.TextureData) do
                if textureInfo.walls then
                    BuyTexture:FireServer(roomName, "walls", textureInfo.walls)
                end
                if textureInfo.floors then
                    BuyTexture:FireServer(roomName, "floors", textureInfo.floors)
                end
            end
        end

        -- Apply furniture
        if _G.HouseData and _G.HouseData.FurnitureArgs then
            local furnitureArgsToSend = _G.HouseData.FurnitureArgs
            BuyFurnitures:InvokeServer(unpack(furnitureArgsToSend))
        end

        Rayfield:Notify({
            Title = "Clone House",
            Content = "Successfully loaded house data from Pastebin and applied it!",
            Duration = 6.5,
            Image = 4483362458,
        })
    end,
})


-- (Optional) Auto-load available pastes after a short delay if credentials are pre-filled
spawn(function()
    wait(2)
    loadAvailablePastes()
end)
