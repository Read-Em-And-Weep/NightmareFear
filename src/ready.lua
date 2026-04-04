---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

function mod.InsertBeforeInTable(tableArg, insertBefore, value)
    local index = mod.FindTableIndex(tableArg, insertBefore)
    if index then
        return table.insert(tableArg, index, value)
    else
        return table.insert(tableArg, value)
    end
end

function mod.FindTableIndex(tableArg, value)
    for k, v in ipairs(tableArg) do
        if v == value then
            return k
        end
    end
    return nil
end
import 'Animations/GUI_Screens_VFX.sjson.lua'
import 'ShrineScreenData.lua'
import 'Text/HelpText.en.sjson.lua'
import 'Text/ScreenText.en.sjson.lua'
import 'Text/TraitText.en.sjson.lua'

modutil.mod.Path.Wrap("SetupMap", function(base)
	game.LoadPackages({ Name ="ReadEmAndWeep-Nightmare_FearNewIcons" })
	return base()
end)