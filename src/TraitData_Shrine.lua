local newMetaUpgrades = {
    NightmareFearNoManaMetaUpgrade = {
        Name = "NightmareFearNoManaMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Naivety",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				Multiply = 100,
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 0.25 },
			{ Points = 1, ChangeValue = 0.5 },
			{Points = 1, ChangeValue = 0.75},
			{Points = 2, ChangeValue = 1}
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearNoManaMetaUpgrade_Flavor",
    },
	NightmareFearHammerlessMetaUpgrade = {
        Name = "NightmareFearHammerlessMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Simplicity",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 3, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearHammerlessMetaUpgrade_Flavor",
    },
	NightmareFearLowManaStartMetaUpgrade = {
        Name = "NightmareFearLowManaStartMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Panic",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Multiply = -100,
				Add = 100,
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearLowManaStartMetaUpgrade_Flavor",
    },
	NightmareFearEnemyDodgeMetaUpgrade = {
        Name = "NightmareFearEnemyDodgeMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Riposte",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				Multiply = 100,
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 0.03 },
			{ Points = 1, ChangeValue = 0.06 },
			{ Points = 2, ChangeValue = 0.09 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearEnemyDodgeMetaUpgrade_Flavor",
    },
	NightmareFearEclipseMetaUpgrade = {
        Name = "NightmareFearEclipseMetaUpgrade",
		IneligibleForCirceRemoval = true,
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Eclipse",
		InactiveChangeValue = 0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearEclipseMetaUpgrade_Flavor",
    },
	NightmareFearFirstHitMetaUpgrade = {
        Name = "NightmareFearFirstHitMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Arrogance",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				Multiply = 100,
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 1 },
			{ Points = 2, ChangeValue = 3 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearFirstHitMetaUpgrade_Flavor",
    },
	NightmareFearBlindRewardMetaUpgrade = {
        Name = "NightmareFearBlindRewardMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Secrets",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				Multiply = 100,
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 0.25 },
			{ Points = 2, ChangeValue = 0.5 },
			{Points = 2, ChangeValue = 0.75},
			{Points = 3, ChangeValue = 1}
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearBlindRewardMetaUpgrade_Flavor",
    },
	NightmareFearPurgingMetaUpgrade = {
        Name = "NightmareFearPurgingMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Purging",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearPurgingMetaUpgrade_Flavor",
    },
	NightmareFearNoElementsMetaUpgrade = {
        Name = "NightmareFearNoElementsMetaUpgrade",
		IneligibleForCirceRemoval = true,
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Rudiments",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 2, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearNoElementsMetaUpgrade_Flavor",
    },
	NightmareFearTaxMetaUpgrade = {
        Name = "NightmareFearTaxMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Taxation",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 5 },
			{ Points = 1, ChangeValue = 10 },
			{ Points = 2, ChangeValue = 15 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearTaxMetaUpgrade_Flavor",
    },
	NightmareFearNoHelpMetaUpgrade = {
        Name = "NightmareFearNoHelpMetaUpgrade",
		IneligibleForCirceRemoval = true,
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Isolation",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 2, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearNoHelpMetaUpgrade_Flavor",
    },
	NightmareFearPomLevelsMetaUpgrade = {
        Name = "NightmareFearPomLevelsMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Decay",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 2, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearPomLevelsMetaUpgrade_Flavor",
    },
	NightmareFearExpirationMetaUpgrade = {
        Name = "NightmareFearExpirationMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Expiry",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				Multiply = 100,
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 0.25 },
			{ Points = 1, ChangeValue = 0.5 },
			{ Points = 2, ChangeValue = 0.75 },
			{ Points = 2, ChangeValue = 1 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearExpirationMetaUpgrade_Flavor",
    },
	NightmareFearKeepsakeLevelMetaUpgrade = {
        Name = "NightmareFearKeepsakeLevelMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Vanity",
		InactiveChangeValue = 0.0,
		IneligibleForCirceRemoval = true,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 2, ChangeValue = 1 },
			{ Points = 3, ChangeValue = 2 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		OnDisabledFunctionName = _PLUGIN.guid..".ReupgradeKeepsake",
		FlavorText = "NightmareFearKeepsakeLevelMetaUpgrade_Flavor",
    },
	NightmareFearLoweredRarityMetaUpgrade = {
        Name = "NightmareFearLoweredRarityMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Fealty",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 3, ChangeValue = 1 },
			{ Points = 1, ChangeValue = 2 },
			{Points = 1, ChangeValue = 3}
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearLoweredRarityMetaUpgrade_Flavor",
    },
	NightmareFearLessChoicesMetaUpgrade = {
        Name = "NightmareFearLessChoicesMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Forsaking",
		InactiveChangeValue = 0.0,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 2, ChangeValue = 1 },
			{ Points = 3, ChangeValue = 2 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearLessChoicesMetaUpgrade_Flavor",
    },
	NightmareFearDevotionWeaponMetaUpgrade = {
        Name = "NightmareFearDevotionWeaponMetaUpgrade",
        InheritFrom = { "BaseMetaUpgrade", },
		Icon = "NightmareFearShrineIcon_Betrayal",
		InactiveChangeValue = 0.0,
		UseWideAnimations = true,
		IneligibleForCirceRemoval = true,
		SimpleExtractValues =
		{
			{
				Property = "ChangeValue",
				NewProperty = "DisplayValue",
			},
		},
		Ranks =
		{
			{ Points = 1, ChangeValue = 1 },
			{ Points = 2, ChangeValue = 2 },
			{ Points = 3, ChangeValue = 3 },
			{ Points = 4, ChangeValue = 4 },
		},
		SelectedVoiceLines =
		{
			PlayOnceFromTableThisRun = true,
			PreLineWait = 0.65,
			UsePlayerSource = true,
			SkipAnim = true,
			SuccessiveChanceToPlay = 0.35,
			Cooldowns =
			{
				{ Name = "MelinoeShrineUpgradeSpeech", Time = 4 },
			},

			-- { Cue = "/VO/Melinoe_2893", Text = "{#Emph}Bask in Pain." },
		},
		FlavorText = "NightmareFearDevotionWeaponMetaUpgrade_Flavor",
    },
}

for newMetaUpgradeName, newMetaUpgradeData in pairs(newMetaUpgrades) do
    game.ProcessDataInheritance(newMetaUpgradeData, game.MetaUpgradeData)
    game.MetaUpgradeData[newMetaUpgradeName]=newMetaUpgradeData
	game.MetaUpgradeData[newMetaUpgradeName].Name = newMetaUpgradeName
end

modutil.mod.Path.Wrap("ProcessSimpleExtractValues", function(base,data)
	if Contains({"NightmareFearHammerlessMetaUpgrade","NightmareFearEclipseMetaUpgrade", "NightmareFearNoHelpMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			if newValue == 1 then
				newValue = "will not"
			else
				newValue = "may"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end
	elseif Contains({"NightmareFearPurgingMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			if newValue == 1 then
				newValue = "be forced"
			else
				newValue = "not be forced"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end
	elseif Contains({"NightmareFearNoElementsMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			if newValue == 1 then
				newValue = "will no longer"
			else
				newValue = "will"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end
	--[[elseif Contains({ "NightmareFearBlindRewardMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			if newValue == 1 then
				newValue = "will"
			else
				newValue = "will not"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end]]
	elseif Contains({"NightmareFearPomLevelsMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			if newValue == 1 then
				newValue = "will"
			else
				newValue = "will not"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end
	elseif Contains({"NightmareFearLoweredRarityMetaUpgrade"}, data.Name) then
		for i, extractData in ipairs( data.SimpleExtractValues ) do
			local originalValue = data[extractData.Property]
			local newValue = originalValue
			
			if newValue == 1 then
				newValue = "{#EpicFormat}Epic{#Prev}"
			elseif newValue == 2 then
				newValue = "{#RareFormat}Rare{#Prev}"
			elseif newValue == 3 then
				newValue = "{#CommonFormat}{#BoldFormat}Common{#Prev}{#Prev}"
			else
				newValue = "{#LegendaryFormat}Legendary{#Prev}"
			end
			--DebugPrint({ Text = "newValue = "..newValue })
			data[extractData.NewProperty] = newValue
		end
	else
		return base(data)
	end
end)