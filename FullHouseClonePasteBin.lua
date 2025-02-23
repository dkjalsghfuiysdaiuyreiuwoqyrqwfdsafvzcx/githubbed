-----------------------------
-- 1. Collect the Data     --
-----------------------------
local HttpService = game:GetService("HttpService")
local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local playerName = game.Players.LocalPlayer.Name

local TextureData = ClientData.get_data()[playerName].house_interior.textures
local FurnitureData = ClientData.get_data()[playerName].house_interior.furniture

-- Optional: rebuild CFrames so they're fully numeric.
local function rebuildCFrame(cf)
    local comps = {cf:GetComponents()}
    return CFrame.new(unpack(comps))
end

-- Build a table that holds everything we want to save
local SaveData = {
    textures = TextureData,
    furniture = {}
}

-- Convert furniture data to a simpler structure if needed
for index, item in pairs(FurnitureData) do
    local cframeValue = rebuildCFrame(item.cframe)
    table.insert(SaveData.furniture, {
        id = item.id,
        scale = item.scale,
        cframe = { cframeValue:GetComponents() },  -- Numeric array of CFrame components
        colors = item.colors
    })
end

-- Convert the SaveData table to JSON
local jsonData = HttpService:JSONEncode(SaveData)

-----------------------------
-- 2. Login to Pastebin    --
-----------------------------
local PASTEBIN_DEV_KEY = "ZYex0D05MMss2V3BLofC_GnxBrfPSrMw"
local pastebinUsername = "nakakadown"
local pastebinPassword = "Nakakadown123!"

local loginData = {
    api_dev_key = PASTEBIN_DEV_KEY,
    api_user_name = pastebinUsername,
    api_user_password = pastebinPassword
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

local userKey = userKeyResponse.Body  -- Use the response as the API user key

-----------------------------
-- 3. Upload to Pastebin   --
-----------------------------
local postData = {
    api_dev_key = PASTEBIN_DEV_KEY,
    api_user_key = userKey,  -- Now included so the paste is saved under your account
    api_option = "paste",
    api_paste_private = "1",       -- 0 = Public, 1 = Unlisted, 2 = Private
    api_paste_name = "My House Data",
    api_paste_code = jsonData       -- Your full JSON data
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
