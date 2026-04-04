local newTraitTextOrder =
{
    "Id",
    "InheritFrom",
    "DisplayName",
    "Description",
}

local newTraitTextData = {
    {
      Id = "NightmareFearNoManaMetaUpgrade",
      DisplayName = "Vow of Naivety",
      Description = "You will have access to {#ShrinePenaltyFormat}-{$MetaUpgradeData.NightmareFearNoManaMetaUpgrade.DisplayValue}% {#Prev}of your {!Icons.ManaUp} this night.",
    },
    {
      Id = "NightmareFearNoManaMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I forget my teachings, that Fear may spread.”",
    },
    {
      Id = "NightmareFearNoManaMetaUpgrade_Short",
      DisplayName = "Naivety"
    },
    {
      Id = "NightmareFearHammerlessMetaUpgrade",
      DisplayName = "Vow of Simplicity",
      Description = "You {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearHammerlessMetaUpgrade.DisplayValue} {#Prev}run into {!Icons.Hammer} this night.",
    },
    {
      Id = "NightmareFearHammerlessMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I eschew sharpening my blade, that Fear may spread.”",
    },
    {
      Id = "NightmareFearHammerlessMetaUpgrade_Short",
      DisplayName = "Simplicity"
    },
    {
      Id = "NightmareFearLowManaStartMetaUpgrade",
      DisplayName = "Vow of Panic",
      Description = "You start {$Keywords.RoomPlural} with {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearLowManaStartMetaUpgrade.DisplayValue}%{#Prev}{!Icons.Mana}.",
    },
    {
      Id = "NightmareFearLowManaStartMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I regularly do not prepare myself, that Fear may spread.”",
    },
    {
      Id = "NightmareFearLowManaStartMetaUpgrade_Short",
      DisplayName = "Panic"
    },
    {
      Id = "NightmareFearEnemyDodgeMetaUpgrade",
      DisplayName = "Vow of Riposte",
      Description = "Foes have a {#ShrinePenaltyFormat}+{$MetaUpgradeData.NightmareFearEnemyDodgeMetaUpgrade.DisplayValue}% {#Prev}chance to dodge your attacks.",
    },
    {
      Id = "NightmareFearEnemyDodgeMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I telegraph my attacks clearly, that Fear may spread.”",
    },
    {
      Id = "NightmareFearEnemyDodgeMetaUpgrade_Short",
      DisplayName = "Riposte"
    },
    {
      Id = "NightmareFearEclipseMetaUpgrade",
      DisplayName = "Vow of Eclipse",
      Description = "You {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearEclipseMetaUpgrade.DisplayValue} {#Prev} run into any rewards from {#BoldFormat}Selene {#Prev}this night.",
    },
    {
      Id = "NightmareFearEclipseMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I reject the light, that Fear may spread.”",
    },
    {
      Id = "NightmareFearEclipseMetaUpgrade_Short",
      DisplayName = "Eclipse"
    },
    {
      Id = "NightmareFearFirstHitMetaUpgrade",
      DisplayName = "Vow of Arrogance",
      Description = "In each {$Keywords.EncounterAlt}, the first hit you take deals {#ShrinePenaltyFormat}+{$MetaUpgradeData.NightmareFearFirstHitMetaUpgrade.DisplayValue}% {#Prev}bonus damage.",
    },
    {
      Id = "NightmareFearFirstHitMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I am felled for my hubris, that Fear may spread.”",
    },
    {
      Id = "NightmareFearFirstHitMetaUpgrade_Short",
      DisplayName = "Arrogance"
    },
    {
      Id = "NightmareFearBlindRewardMetaUpgrade",
      DisplayName = "Vow of Secrets",
      Description = "{$Keywords.RoomAlt} {#BoldFormat}Reward {#Prev}previews have a {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearBlindRewardMetaUpgrade.DisplayValue}% {#Prev}chance to be hidden this night.",
    },
    {
      Id = "NightmareFearBlindRewardMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I reject my foresight, that Fear may spread.”",
    },
    {
      Id = "NightmareFearBlindRewardMetaUpgrade_Short",
      DisplayName = "Secrets"
    },
    {
      Id = "NightmareFearPurgingMetaUpgrade",
      DisplayName = "Vow of Purging",
      Description = "After vanquishing a {$Keywords.Boss}, you will {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearPurgingMetaUpgrade.DisplayValue} {#Prev}to purge a {$Keywords.GodBoon} to move on.",
    },
    {
      Id = "NightmareFearPurgingMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I will sacrifice my strength, that Fear may spread.”",
    },
    {
      Id = "NightmareFearPurgingMetaUpgrade_Short",
      DisplayName = "Purging"
    },
    {
      Id = "NightmareFearNoElementsMetaUpgrade",
      DisplayName = "Vow of Rudiments",
      Description = "{$Keywords.GodBoonPlural} {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearNoElementsMetaUpgrade.DisplayValue} {#Prev}have elemental affinities.",
    },
    {
      Id = "NightmareFearNoElementsMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I forego my connection to the Earth, that Fear may spread.”",
    },
    {
      Id = "NightmareFearNoElementsMetaUpgrade_Short",
      DisplayName = "Rudiments"
    },
    {
      Id = "NightmareFearTaxMetaUpgrade",
      DisplayName = "Vow of Taxes",
      Description = "Every {$Keywords.RoomAlt} costs {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearTaxMetaUpgrade.DisplayValue}{#Prev}{!Icons.Currency} to move through, if you have it.",
    },
    {
      Id = "NightmareFearTaxMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I abide by a universal certainty, that Fear may spread.”",
    },
    {
      Id = "NightmareFearTaxMetaUpgrade_Short",
      DisplayName = "Taxes"
    },
    {
      Id = "NightmareFearNoHelpMetaUpgrade",
      DisplayName = "Vow of Isolation",
      Description = "You {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearNoHelpMetaUpgrade.DisplayValue} {#Prev}encounter various allies in person this night.",
    },
    {
      Id = "NightmareFearNoHelpMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I stand by myself, that Fear may spread.”",
    },
    {
      Id = "NightmareFearNoHelpMetaUpgrade_Short",
      DisplayName = "Isolation"
    },
    {
      Id = "NightmareFearPomLevelsMetaUpgrade",
      DisplayName = "Vow of Decay",
      Description = "The first {$Keywords.PomNoPlural} in each {$Keywords.Biome} {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearPomLevelsMetaUpgrade.DisplayValue} {#Prev}become {!Icons.Onion} instead.",
    },
    {
      Id = "NightmareFearPomLevelsMetaUpgrade_Flavor",
      DisplayName = "“Upon this night my mother's power wanes, that Fear may spread.”",
    },
    {
      Id = "NightmareFearPomLevelsMetaUpgrade_Short",
      DisplayName = "Decay"
    },
    {
      Id = "NightmareFearExpirationMetaUpgrade",
      DisplayName = "Vow of Expiry",
      Description = "{$Keywords.GodBoonPlural} have a {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearExpirationMetaUpgrade.DisplayValue}% {#Prev}chance to be {$Keywords.NightmareFearExpiringTrait}.",
    },
    {
      Id = "NightmareFearExpirationMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I make transient agreements, that Fear may spread.”",
    },
    {
      Id = "NightmareFearExpirationMetaUpgrade_Short",
      DisplayName = "Expiry"
    },
    {
      Id = "NightmareFearKeepsakeLevelMetaUpgrade",
      DisplayName = "Vow of Vanity",
      Description = "Your {$Keywords.Keepsakes} are will have {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearKeepsakeLevelMetaUpgrade.DisplayValue} {#Prev}less rank(s) {#ItalicFormat}(if possible){#Prev}.",
    },
    {
      Id = "NightmareFearKeepsakeLevelMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I weaken my bonds, that Fear may spread.”",
    },
    {
      Id = "NightmareFearKeepsakeLevelMetaUpgrade_Short",
      DisplayName = "Vanity"
    },
    {
      Id = "NightmareFearLoweredRarityMetaUpgrade",
      DisplayName = "Vow of Fealty",
      Description = "{$Keywords.GodBoonPlural} will be at most {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearLoweredRarityMetaUpgrade.DisplayValue}{#Prev}{#Prev}{#Prev}. {$Keywords.Duo} blessings are also possible.",
    },
    {
      Id = "NightmareFearLoweredRarityMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I devote myself to the gods, that Fear may spread.”",
    },
    {
      Id = "NightmareFearLoweredRarityMetaUpgrade_Short",
      DisplayName = "Fealty"
    },
    {
      Id = "NightmareFearLessChoicesMetaUpgrade",
      DisplayName = "Vow of Forsaking",
      Description = "{$Keywords.GodBoonPlural} will offer {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearLessChoicesMetaUpgrade.DisplayValue} {#Prev}fewer blessings to choose from.",
    },
    {
      Id = "NightmareFearLessChoicesMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I limit my choices, that Fear may spread.”",
    },
    {
      Id = "NightmareFearLessChoicesMetaUpgrade_Short",
      DisplayName = "Forsaking"
    },
    {
      Id = "NightmareFearDevotionWeaponMetaUpgrade",
      DisplayName = "Vow of Betrayal",
      Description = "A random god will aid the {$Keywords.Boss} of the first {#ShrinePenaltyFormat}{$MetaUpgradeData.NightmareFearDevotionWeaponMetaUpgrade.DisplayValue} {#Prev}{$Keywords.BiomePlural}.",
    },
    {
      Id = "NightmareFearDevotionWeaponMetaUpgrade_Flavor",
      DisplayName = "“Upon this night I am betrayed by my allies, that Fear may spread.”",
    },
    {
      Id = "NightmareFearDevotionWeaponMetaUpgrade_Short",
      DisplayName = "Betrayal"
    },
    {
      Id = "NightmareFearExpiringStatLine",
      InheritFrom = "BaseStatLine",
      DisplayName = "{!Icons.Bullet}{#PropertyFormat}{$Keywords.BossPluralAlt} Remaining:",
      Description = "{#UpgradeFormat}{$TooltipData.NightmareFearExpiringRemaining}",
    }
}

local traitTextFile = rom.path.combine(rom.paths.Content(), 'Game/Text/en/TraitText.en.sjson')

sjson.hook(traitTextFile, function(data)
    for _, newScreenText in ipairs(newTraitTextData) do
        table.insert(data.Texts, sjson.to_object(newScreenText, newTraitTextOrder))
    end
end)
