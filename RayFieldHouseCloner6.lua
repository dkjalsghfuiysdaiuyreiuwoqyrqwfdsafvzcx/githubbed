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
        -- 'Selected' is a table containing the currently selected option(s).
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

-- Function to load the available pastes and update the dropdown
local function loadAvailablePastes()
    local HttpService = game:GetService("HttpService")
    local userKey = pastebinLogin()
    if not userKey then return end  -- If login failed, stop here

    -- Fetch Paste List
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

    -- Refresh the dropdown's list
    pasteDropdown:Refresh(newOptions)
    -- Optionally set the current selection to the first item
    pasteDropdown:Set({newOptions[1]})
end

-- Button to manually load available pastes
Tab:CreateButton({
    Name = "Load Available Pastes",
    Callback = loadAvailablePastes,
})

-- House scanning logic + Pastebin upload, then refresh
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

        -- Log in to Pastebin
        local userKey = pastebinLogin()
        if not userKey then return end

        -- Upload data to Pastebin
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

        -- After uploading, refresh the paste list
        loadAvailablePastes()
    end,
})

-- "Clone House" button to fetch & execute the code from the currently selected paste
Tab:CreateButton({
    Name = "Clone House",
    Callback = function()
        local HttpService = game:GetService("HttpService")

        -- Get the currently selected option from the dropdown
        local selectedOption = pasteDropdown.CurrentOption[1]
        if not selectedOption or selectedOption == "Not Loaded" or selectedOption == "No pastes found" then
            warn("No valid paste selected!")
            return
        end

        -- selectedOption is something like "MyHouse - https://pastebin.com/abc123"
        -- We'll parse out the URL
        local splitted = selectedOption:split(" - ")
        local pasteUrl = splitted[2] -- The part after " - "

        if not pasteUrl or not pasteUrl:find("pastebin.com") then
            warn("Invalid paste URL!")
            return
        end

        -- Convert normal paste URL to a raw link if needed
        -- e.g. "https://pastebin.com/abc123" -> "https://pastebin.com/raw/abc123"
        local rawUrl = pasteUrl:gsub("pastebin%.com/", "pastebin.com/raw/")

        -- Now fetch and execute the code
        local success, code = pcall(function()
            return HttpService:GetAsync(rawUrl)
        end)

        if not success then
            warn("Failed to fetch code from Pastebin: " .. tostring(code))
            return
        end

        local func, loadErr = loadstring(code)
        if not func then
            warn("Error loading the paste code: " .. tostring(loadErr))
            return
        end

        local execSuccess, execErr = pcall(func)
        if not execSuccess then
            warn("Error executing the paste code: " .. tostring(execErr))
        else
            Rayfield:Notify({
                Title = "Clone House",
                Content = "Successfully cloned house script from the selected paste!",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

-- (Optional) Auto-load available pastes after a short delay if credentials are pre-filled
spawn(function()
    wait(2)
    loadAvailablePastes()
end)
