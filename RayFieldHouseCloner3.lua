-- verison 1.1
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
local Section = Tab:CreateSection("Pastebin Settings")

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

-- Create a dropdown for available pastes (initially empty)
local pasteDropdown = Tab:CreateDropdown({
    Name = "Available Pastes",
    Options = {"Not Loaded"},
    Callback = function(Option)
        print("Selected paste:", Option)
    end,
})

-- Function to load and update the dropdown with paste titles and URLs from your account
local function loadAvailablePastes()
    local HttpService = game:GetService("HttpService")
    if not _G.PASTEBIN_DEV_KEY or not _G.pastebinUsername or not _G.pastebinPassword then
        warn("Please enter all Pastebin credentials first!")
        return
    end

    -- Login to Pastebin
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
        return
    end
    local userKey = userKeyResponse.Body

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
    local pastes = {}
    for pasteData in body:gmatch("<paste>(.-)</paste>") do
        local title = pasteData:match("<paste_title>(.-)</paste_title>")
        local url = pasteData:match("<paste_url>(.-)</paste_url>")
        if title and url then
            table.insert(pastes, title .. " - " .. url)
        end
    end

    if #pastes == 0 then
        pastes = {"No pastes found"}
    end

    if pasteDropdown.SetOptions then
        pasteDropdown:SetOptions(pastes)
    else
        warn("SetOptions method not available on your dropdown!")
    end
end

-- Button to manually load available pastes
Tab:CreateButton({
    Name = "Load Available Pastes",
    Callback = function()
        loadAvailablePastes()
    end,
})

-- (Optional) Auto-load available pastes after a short delay (if credentials are pre-filled)
spawn(function()
    wait(2)  -- Wait 2 seconds for UI & credential input initialization
    loadAvailablePastes()
end)

-- Button to perform the House scan, upload data, and then refresh the available pastes
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

        -- Login to Pastebin for uploading
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
            return
        end
        local userKey = userKeyResponse.Body

        local postData = {
            api_dev_key = _G.PASTEBIN_DEV_KEY,
            api_user_key = userKey,
            api_option = "paste",
            api_paste_private = "1",
            api_paste_name = _G.api_paste_name,
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
            Content = "Notification Content",
            Duration = 6.5,
            Image = 4483362458,
        })
        -- Refresh the available pastes after uploading
        loadAvailablePastes()
    end,
})
