DEBUG = {"errors"}

local variant = Tracker.ActiveVariantUID

-- Items
require("scripts/items_import")

-- Maps
if Tracker.ActiveVariantUID == "maps-u" then
    Tracker:AddMaps("maps/maps-u.json")  
else
    Tracker:AddMaps("maps/maps.json")  
end  

-- Layout
require("scripts/layouts_import")

-- Locations
require("scripts/locations_import")

-- Logic
require("scripts/logic/logic_helper")
require("scripts/logic/base_logic")
require("scripts/logic/graph_logic/logic_main")
require("scripts/logic/recipe_logic")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.26.0" then
    require("scripts/autotracking")
end

function OnFrameHandler()
    if SLOT_DATA['early_chika_blocks_moved'] then
        local early_chika_blocks_moved = Tracker:FindObjectForCode("early_chika_blocks_moved")
        early_chika_blocks_moved.Active = (SLOT_DATA['early_chika_blocks_moved'])
    end
	if SLOT_DATA['potsanity'] then
        local potsanity = Tracker:FindObjectForCode("potsanity")
        potsanity.Active = (SLOT_DATA['potsanity'])
    end
    if SLOT_DATA['enable_you_skips'] then
        local enable_you_skips = Tracker:FindObjectForCode("enable_you_skips")
        enable_you_skips.Active = (SLOT_DATA['enable_you_skips'])
    end
    if SLOT_DATA['craftsanity'] and string.len(SLOT_DATA['recipes']) ~= 0 then
        local recipe_data = SLOT_DATA['recipes']
        for i=1,93 do
            recipe = {}
            for j=1,4 do
                ingredient = tonumber(string.sub(recipe_data, 3, 4)..string.sub(recipe_data, 1, 2), 16)
                id = ingredient & 0x3FF
                amount = (ingredient & 0xFC00) >> 10
                --print("ID: "..tostring(id).." x"..tostring(amount))
                recipe_data = string.sub(recipe_data, 5)
                table.insert(recipe, {["id"] = id, ["amount"] = amount})
            end
            table.insert(recipes, recipe)
        end
    end
    ScriptHost:RemoveOnFrameHandler("load handler")
    -- stuff
    ScriptHost:AddWatchForCode("StateChanged", "*", StateChanged)
    ScriptHost:AddOnLocationSectionChangedHandler("location_section_change_handler", LocationHandler)
    CreateLuaManualStorageItem("manual_location_storage")
    ForceUpdate()
end

require("scripts/luaitems")
require("scripts/watches")
ScriptHost:AddOnFrameHandler("load handler", OnFrameHandler)
