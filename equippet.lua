local function equipPet()
    if getgenv().PrioritizeLegs then
        local success, fsys = pcall(function()
            return require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
        end)
        
        if not success or not fsys then
            warn("Failed to require fsys")
            return
        end
        
            local equipManager = fsys.get("equip_manager")
            local equipManagerPets = equipManager and equipManager.pets
            local inventory = fsys.get("inventory")
            local inventoryPets = inventory and inventory.pets
        
            if equipManagerPets and equipManagerPets[1] and equipManagerPets[1].kind then
                local currentPetKind = equipManagerPets[1].kind
                local currentPetUnique = equipManagerPets[1].unique
                local currentPetAge = equipManagerPets[1].properties.age
                local eggToFarmExist = false

                for x, y in pairs(inventoryPets) do
                    if y.kind == getgenv().eggToFarm then
                        eggToFarmExist = true
                        break
                    else
                        eggToFarmExist = false
                    end
                end

                -- Check if we need to set petToEquip

                if petToEquip == nil or (currentPetUnique ~= petToEquip) or (eggToFarmExist and getgenv().eggToFarm ~= currentPetKind) or (not currentPetKind:lower():match("egg$") and Cash > 750 and getgenv().AutoBuyEggs) or (CheckRarity(currentPetKind) ~= "legendary") or (CheckRarity(currentPetKind) == "legendary" and currentPetAge == 6) then
            
                    local foundPet = false
                    for _, pet in pairs(inventoryPets or {}) do
                        if pet.kind == "moon_2025_sunglider" or pet.kind == "moon_2025_dimension_drifter" then
                            petToEquip = pet.unique
                            foundPet = true
                            break
                        end
                        if pet.kind == getgenv().eggToFarm then
                            petToEquip = pet.unique
                            foundPet = true
                            break
                        end
                    end
                    
                    if not foundPet then
                        if Cash > 750 and getgenv().AutoBuyEggs then
                            local args = {
                                [1] = "pets",
                                [2] = getgenv().eggToFarm,
                                [3] = {
                                    ["buy_count"] = 1
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
                            task.wait(1)
                            for _, pet in pairs(inventoryPets or {}) do
                                if pet.kind == getgenv().eggToFarm then
                                    petToEquip = pet.unique
                                    foundPet = true
                                    break
                                end
                            end
                        else
                            petToEquip = getHighestLevelPet() -- Fallback to highest level pet
                        end
                    end      

                    PetAilmentsArray = {}  
                elseif (CheckRarity(currentPetKind) == "legendary" and currentPetAge < 6) then
                    petToEquip = currentPetUnique
                end
            else
                warn("equip_manager or equip_manager.pets[1] is nil")
                for _, pet in pairs(inventoryPets or {}) do
                    if pet.kind == getgenv().eggToFarm then
                        petToEquip = pet.unique
                        foundPet = true
                        break
                    end
                end
                
                if not foundPet then
                    if Cash > 750 and getgenv().AutoBuyEggs then
                        local args = {
                            [1] = "pets",
                            [2] = getgenv().eggToFarm,
                            [3] = {
                                ["buy_count"] = 1
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
                        task.wait(1)
                        for _, pet in pairs(inventoryPets or {}) do
                            if pet.kind == getgenv().eggToFarm then
                                petToEquip = pet.unique
                                foundPet = true
                                break
                            end
                        end
                    else
                        petToEquip = getHighestLevelPet() -- Fallback to highest level pet
                    end
                end
            end
        

        if petToEquip then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(petToEquip, {["use_sound_delay"] = true, ["equip_as_last"] = false})
            task.wait(.3)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(petToEquip, {["use_sound_delay"] = true, ["equip_as_last"] = false})
        end
        PetAilmentsArray = {}
        --print(petToEquip)
    else
        local success, fsys = pcall(function()
            return require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
        end)
        
        if not success or not fsys then
            warn("Failed to require fsys")
            return
        end
        
            local equipManager = fsys.get("equip_manager")
            local equipManagerPets = equipManager and equipManager.pets
            local inventory = fsys.get("inventory")
            local inventoryPets = inventory and inventory.pets
        
            if equipManagerPets and equipManagerPets[1] and equipManagerPets[1].kind then
                local currentPetKind = equipManagerPets[1].kind
                local currentPetUnique = equipManagerPets[1].unique
                local eggToFarmExist = false

                for x, y in pairs(inventoryPets) do
                    if y.kind == getgenv().eggToFarm then
                        eggToFarmExist = true
                        break
                    else
                        eggToFarmExist = false
                    end
                end

                -- Check if we need to set petToEquip

                if petToEquip == nil or (currentPetUnique ~= petToEquip) or (eggToFarmExist and getgenv().eggToFarm ~= currentPetKind) or (not currentPetKind:lower():match("egg$") and Cash > 750 and getgenv().AutoBuyEggs) then
                    
                    local foundPet = false
                    for _, pet in pairs(inventoryPets or {}) do
                        if pet.kind == getgenv().eggToFarm then
                            petToEquip = pet.unique
                            foundPet = true
                            break
                        elseif pet.kind:lower():match("egg$") then -- Matches 'egg' only at the end of the string
                            petToEquip = pet.unique
                            foundPet = true
                            break
                        end
                    end
                    
                    if not foundPet then
                        if Cash > 750 and getgenv().AutoBuyEggs then
                            local args = {
                                [1] = "pets",
                                [2] = getgenv().eggToFarm,
                                [3] = {
                                    ["buy_count"] = 1
                                }
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
                        else
                            petToEquip = getHighestLevelPet() -- Fallback to highest level pet
                        end
                    end      

                    PetAilmentsArray = {}              
                end
            else
                warn("equip_manager or equip_manager.pets[1] is nil")
                for _, pet in pairs(inventoryPets or {}) do
                    if pet.kind == getgenv().eggToFarm then
                        petToEquip = pet.unique
                        foundPet = true
                        break
                    elseif pet.kind:lower():match("egg$") then -- Matches 'egg' only at the end of the string
                        petToEquip = pet.unique
                        foundPet = true
                        break
                    end
                end
                
                if not foundPet then
                    if Cash > 750 and getgenv().AutoBuyEggs then
                        local args = {
                            [1] = "pets",
                            [2] = getgenv().eggToFarm,
                            [3] = {
                                ["buy_count"] = 1
                            }
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
                    else
                        petToEquip = getHighestLevelPet() -- Fallback to highest level pet
                    end
                end
            end
        

        if petToEquip then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(petToEquip, {["use_sound_delay"] = true, ["equip_as_last"] = false})
            task.wait(.3)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(petToEquip, {["use_sound_delay"] = true, ["equip_as_last"] = false})
        end
        PetAilmentsArray = {}
        --print(petToEquip)
    end
end