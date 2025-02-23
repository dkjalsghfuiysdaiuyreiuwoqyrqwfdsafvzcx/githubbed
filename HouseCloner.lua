-- Function to pretty-print a table (optional)
local function PrintTable(tbl, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    if type(tbl) ~= "table" then
        print(prefix .. tostring(tbl))
        return
    end
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(prefix .. tostring(k) .. " = {")
            PrintTable(v, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

-- Advanced snake_case conversion that handles digits as well.
local function convertToSnakeCase(str)
    -- Insert underscore between letter and digit.
    str = str:gsub("([A-Za-z])([0-9])", "%1_%2")
    -- Insert underscore between digit and letter.
    str = str:gsub("([0-9])([A-Za-z])", "%1_%2")
    -- Insert underscore between lowercase/digit and uppercase letter.
    str = str:gsub("([a-z0-9])([A-Z])", "%1_%2")
    return str:lower()
end

-- Set up global variables for external access.
getgenv().blueprintFolder = workspace.HouseInteriors:WaitForChild("blueprint")
getgenv().childModel = getgenv().blueprintFolder:GetChildren()[1]
getgenv().WorldPivot = nil

if getgenv().childModel and getgenv().childModel:IsA("Model") then
    getgenv().WorldPivot = getgenv().childModel:GetPivot()
    print("Blueprint's WorldPivot CFrame:", getgenv().WorldPivot)
else
    warn("No valid Model found in the blueprint folder!")
end

-- Create a global table to store the API call arguments.
getgenv().FurnitureAPICalls = {}
local callIndex = 1

-- Process the furniture folder to compute each furniture model's adjusted pivot.
if getgenv().WorldPivot then
    getgenv().furnitureFolder = workspace.HouseInteriors:WaitForChild("furniture")
    
    for _, subFolder in ipairs(getgenv().furnitureFolder:GetChildren()) do
        if subFolder:IsA("Folder") then
            local furnitureModel = subFolder:GetChildren()[1]
            if furnitureModel and furnitureModel:IsA("Model") then
                local FurniturePivot = furnitureModel:GetPivot()
                local fpx, fpy, fpz,
                      fr00, fr01, fr02,
                      fr10, fr11, fr12,
                      fr20, fr21, fr22 = FurniturePivot:GetComponents()
                
                local wpx, wpy, wpz = getgenv().WorldPivot.X, getgenv().WorldPivot.Y, getgenv().WorldPivot.Z
                
                -- Calculate the relative pivot components.
                local rx = fpx - wpx
                local ry = fpy - wpy
                local rz = fpz - wpz
                
                local pivotComponents = {rx, ry, rz, fr00, fr01, fr02, fr10, fr11, fr12, fr20, fr21, fr22}
                
                -- Find the "Colorable" part (if it exists) to get its color.
                local colorablePart = furnitureModel:FindFirstChild("Colorable")
                local color3
                if colorablePart and colorablePart:IsA("BasePart") then
                    color3 = colorablePart.Color
                end
                
                -- Generate both naming formats.
                local lowerName = furnitureModel.Name:lower()
                local snakeName = convertToSnakeCase(furnitureModel.Name)
                local furnitureNames = {lowerName, snakeName}
                
                -- Create an API call argument for each name.
                for _, furnitureName in ipairs(furnitureNames) do
                    local args = {
                        [1] = {
                            [1] = {
                                ["kind"] = furnitureName,
                                ["properties"] = {
                                    scale = 1,
                                    cframe = CFrame.new(unpack(pivotComponents)),
                                    colors = {
                                        [1] = color3,
                                    }
                                }
                            }
                        }
                    }
                    
                    -- Store the argument table in a global variable.
                    getgenv().FurnitureAPICalls[callIndex] = args
                    callIndex = callIndex + 1
                end
            end
        end
    end
else
    warn("WorldPivot is nil, cannot process furniture.")
end

print("Furniture API call arguments stored in getgenv().FurnitureAPICalls")







-- Ensure the global variable is available
if not getgenv().FurnitureAPICalls then
    warn("No furniture API call arguments found!")
    return
end

for _, args in ipairs(getgenv().FurnitureAPICalls) do
    print("Sending API call for furniture with args:")
    -- Optionally, you can call PrintTable(args) to see the structure.
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("API")
            :WaitForChild("HousingAPI/BuyFurnitures")
            :InvokeServer(unpack(args))
    end)
    
    if success then
        print("API call succeeded.")
    else
        warn("Error sending API call.\nError:", err)
    end
end

print("All API calls attempted.")





local args = {
    [1] = "Room1",
    [2] = "walls",
    [3] = "snowflakes"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/BuyTexture"):FireServer(unpack(args))
