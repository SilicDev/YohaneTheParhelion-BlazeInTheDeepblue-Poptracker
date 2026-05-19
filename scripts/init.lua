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
