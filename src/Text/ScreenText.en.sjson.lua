local newScreenTextOrder =
{
    "Id",
    "InheritFrom",
    "DisplayName",
    "Description",
}

local newScreenTextData = {
      {
      Id = "NightmareFearShrineScreen_NextPage",
      DisplayName = "{CF} NEXT PAGE",
    },
}

local screenTextFile = rom.path.combine(rom.paths.Content(), 'Game/Text/en/ScreenText.en.sjson')

sjson.hook(screenTextFile, function(data)
    for _, newScreenText in ipairs(newScreenTextData) do
        table.insert(data.Texts, sjson.to_object(newScreenText, newScreenTextOrder))
    end
end)
