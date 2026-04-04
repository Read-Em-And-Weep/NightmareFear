local newHelpTextOrder =
{
    "Id",
    "InheritFrom",
    "DisplayName",
    "Description",
}

local newHelpTextData = {
    {
      Id = "AllElementsWithCountNoPlural",
      InheritFrom = "BaseTooltip",
      DisplayName = "{!Icons.EarthNoTooltip} {!Icons.WaterNoTooltip} {!Icons.AirNoTooltip} {!Icons.FireNoTooltip} Element",
      Description = "Essences that enhances certain {$Keywords.GodBoonPlural}. You have {#BoldFormat}{$CurrentRun.Hero.Elements.Earth}{#Prev}{!Icons.CurseEarth}, {#BoldFormat}{$CurrentRun.Hero.Elements.Water}{#Prev}{!Icons.CurseWater}, {#BoldFormat}{$CurrentRun.Hero.Elements.Air}{#Prev}{!Icons.CurseAir}, and {#BoldFormat}{$CurrentRun.Hero.Elements.Fire}{#Prev}{!Icons.CurseFire} now.",
    },
    {
      Id = "PomNoPlural",
      DisplayName = "Pom of Power",
      Description = "Underworld fruit that can enhance the effects of most {$Keywords.GodBoonPlural}.",
    },
    {
      Id = "NightmareFearExpiringTrait",
      InheritFrom = "BaseTooltip",
      DisplayName = "{#MemFormatBold}Expiring",
      Description = "Blessing imbued with limited power, that will disappear after vanquishing 2 {$Keywords.BossPlural}."
    },
    {
      Id = "NightmareFearExpiringTraitTooltipBase",
      InheritFrom = "BaseTooltip",
      DisplayName = "{#MemFormatBold}Expiring",
      Description = "Should you take it, this blessing will disappear after vanquishing {$ExpiringTraitData.NightmareFearExpiringRemaining} {$Keywords.BossPluralAlt_NoTooltip}."
    },
    {
      Id = "NightmareFearExpiringTraitTooltip",
      InheritFrom = "BaseTooltip",
      DisplayName = "{$Keywords.NightmareFearExpiringTraitTooltipBase}",
    },
    {
      Id = "NightmareFearExpirationMetaUpgrade_Active",
      DisplayName = "{#CombatTextHighlightFormat}Vow of Expiry{#Prev}!",
    },
}

local helpTextFile = rom.path.combine(rom.paths.Content(), 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
    for _, newHelpText in ipairs(newHelpTextData) do
        table.insert(data.Texts, sjson.to_object(newHelpText, newHelpTextOrder))
    end
end)

table.insert(game.KeywordList, "AllElementsWithCountNoPlural")
table.insert(game.KeywordList, "PomNoPlural")
table.insert(game.KeywordList, "NightmareFearExpiringTrait")
table.insert(game.KeywordList, "NightmareFearExpiringTraitTooltipBase")
ResetKeywords()