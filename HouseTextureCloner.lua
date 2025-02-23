local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local FurnitureData = ClientData.get_data()[game.Players.LocalPlayer.Name].house_interior.furniture

local function cframeToString(cf)
    return {cf:components()}  -- or keep it as a CFrame if your remote can handle it directly
end

local newArgs = { [1] = {} }

for i, item in ipairs(FurnitureData) do
    local colorsTable = {}
    for colorIndex, colorValue in pairs(item.colors) do
        colorsTable[colorIndex] = colorValue
    end

    newArgs[1][i] = {
        kind = item.id,
        properties = {
            scale = item.scale,
            cframe = item.cframe,  -- you can use item.cframe directly if the server expects a CFrame
            colors = colorsTable
        }
    }
end

game:GetService("ReplicatedStorage"):WaitForChild("API")
    :WaitForChild("HousingAPI/BuyFurnitures")
    :InvokeServer(unpack(newArgs))



    

print("======================================================")
local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)

local FurnitureData = ClientData.get_data()[game.Players.LocalPlayer.Name].house_interior.furniture
for x,y in pairs(FurnitureData) do
    print("kind: ", y.id)
    print("scale: ", y.scale)
    print("cframe: ", y.cframe)
    for q,w in pairs(y.colors) do
        print("colors: ", w)
    end
end


print("======================================================")
local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)

local HouseData = ClientData.get_data()[game.Players.LocalPlayer.Name].house_interior
for x,y in pairs(HouseData) do
    print(x,y)
end

print("======================================================")
local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)

local TextureData = ClientData.get_data()[game.Players.LocalPlayer.Name].house_interior.textures
for x,y in pairs(TextureData) do
    print("Room number: ", x)
    print("floor: ", y.floors)
    print("walls: ", y.walls)
end

--Setting Walls
local args = {
    [1] = "Room3",
    [2] = "walls",
    [3] = "green"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/BuyTexture"):FireServer(unpack(args))

--Setting Floors
local args = {
    [1] = "Room3",
    [2] = "floors",
    [3] = "redcarpet"
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/BuyTexture"):FireServer(unpack(args))





local args = {
    [1] = {
        [1] = {
            ["kind"] = "small_cloud_light",
            ["properties"] = {
                ["scale"] = 1,
                ["cframe"] = CFrame.new(14, 0, -28.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                ["colors"] = {}
            }
        },
        [2] = {
            ["kind"] = "basicbed",
            ["properties"] = {
                ["scale"] = 1,
                ["cframe"] = CFrame.new(9.800048828125, 0, -21.2001953125, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                ["colors"] = {
                    [1] = Color3.new(0.48235294222831726, 0.7137255072593689, 0.9098039269447327),
                    [2] = Color3.new(0.4588235318660736, 0, 0),
                    [3] = Color3.new(0.8039215803146362, 0.3843137323856354, 0.5960784554481506),
                    [4] = Color3.new(1, 0, 0.7490196228027344),
                    [5] = Color3.new(0.29411765933036804, 0.5921568870544434, 0.29411765933036804)
                }
            }
        },
        [3] = {
            ["kind"] = "basicbed",
            ["properties"] = {
                ["scale"] = 1,
                ["cframe"] = CFrame.new(9.800048828125, 0, -21.2001953125, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                ["colors"] = {
                    [1] = Color3.new(0.48235294222831726, 0.7137255072593689, 0.9098039269447327),
                    [2] = Color3.new(0.4588235318660736, 0, 0),
                    [3] = Color3.new(0.8039215803146362, 0.3843137323856354, 0.5960784554481506),
                    [4] = Color3.new(1, 0, 0.7490196228027344),
                    [5] = Color3.new(0.29411765933036804, 0.5921568870544434, 0.29411765933036804)
                }
            }
        }
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/BuyFurnitures"):InvokeServer(unpack(args))
