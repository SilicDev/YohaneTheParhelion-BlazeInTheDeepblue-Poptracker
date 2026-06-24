recipes = {}

-- lua hack: a table with true values can be used to check if a value exists in a set
rare_materials = { 
    [226] = true,
    [270] = true,
    [284] = true,
    [311] = true,
    [320] = true,
    [321] = true,
    [322] = true,
    [323] = true,
    [324] = true,
    [325] = true,
    [326] = true,
    [327] = true,
    [328] = true,
    [329] = true,
    [330] = true,
    [331] = true,
    [332] = true,
    [333] = true,
    [334] = true,
    [335] = true,
    [336] = true,
}

element_materials = {
    [296] = "Riko",
    [297] = "Mari",
    [298] = "Dia"
}

-- use this in the json via "^$can_craft_recipe|id"
function can_craft_recipe(recipe_id)
    local recipe = recipes[tonumber(recipe_id)]
    if recipe == nil then
        return ACCESS_NONE
    end
    local can_craft = ACCESS_NORMAL
    for _,ingredient in ipairs(recipe) do
        id = ingredient.id
        if id ~= 0 then
            if rare_materials[id] then
                can_craft = ALL(can_craft, HAS(ITEM_MAPPING[id][1][1], ingredient.amount))
                if access == ACCESS_NONE then
                    return ACCESS_NONE
                end
            elseif id > 400 and id < 500 then -- Consumables
                if id == 403 or id == 406 then -- Shinestew and Fallen Angel's Tear
                    can_craft = ALL(can_craft, HAS("Mari"))
                else
                    can_craft = ALL(can_craft, true) -- no added rules
                end
            elseif id > 200 and id < 400 then
                if element_materials[id] ~= nil then
                    can_craft = ALL(can_craft, HAS(element_materials[id]))
                end
                -- TODO: implement normal material logic
            else
                -- unknown material
                return ACCESS_NONE
            end
        end
    end
    return can_craft
end