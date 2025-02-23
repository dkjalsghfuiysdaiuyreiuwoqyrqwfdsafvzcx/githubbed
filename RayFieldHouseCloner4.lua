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

-- Dropdown for available pastes (initially shows "Not Loaded")
local pasteDropdown = Tab:CreateDropdown({
    Name = "Available Pastes",
    Options = {"Not Loaded"},
    Callback = function(Option)
        print("Selected paste:", Option)
    end,
})

-- Function to load available pastes and update the dropdown
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

    -- Request paste list
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
    local pasteOptions = {}  -- table of strings in "title - url" format
    for pasteData in body:gmatch("<paste>(.-)</paste>") do
        local title = pasteData:match("<paste_title>(.-)</paste_title>")
        local url = pasteData:match("<paste_url>(.-)</paste_url>")
        if title and url then
            table.insert(pasteOptions, title .. " - " .. url)
        end
    end

    if #pasteOptions == 0 then
        pasteOptions = {"No pastes found"}
    end

    if pasteDropdown.SetOptions then
        pasteDropdown:SetOptions(pasteOptions)
    else
        warn("SetOptions method not available on your dropdown!")
    end
end

-- Button to manually load available pastes
Tab:CreateButton({
    Name = "Load Available Pastes",
    Callback = loadAvailablePastes,
})

-- Optionally auto-load available pastes after a short delay (if credentials are already filled)
spawn(function()
    wait(2)
    loadAvailablePastes()
end)
