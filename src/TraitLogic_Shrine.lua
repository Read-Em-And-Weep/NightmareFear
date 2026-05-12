import 'ScreenData_Purge.lua'
--Naivety

modutil.mod.Path.Wrap("GetExpectedMaxMana", function(base)
	local expectedMaxMana = base()
	if GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") >= 1 then
		expectedMaxMana = expectedMaxMana - GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") * 0.25 * expectedMaxMana
	end
	expectedMaxMana = round(expectedMaxMana)
	return expectedMaxMana
end)

--[[modutil.mod.Path.Wrap("ChooseRoomReward", function(base, run, room, rewardStoreName, previouslyChosenRewards, args)
	args = args or {}
	local roomData = RoomData[room.Name] or room
	if room.Starting and not args.IgnoreForcedReward then return base(run, room, rewardStoreName, previouslyChosenRewards, args) end
	if not args.IgnoreForcedReward then
		if room.NoReward then
			return nil
		end

		if CurrentRun.ActiveBounty ~= nil then
			local bountyData = BountyData[CurrentRun.ActiveBounty]
			if bountyData ~= nil and bountyData.LootOptions == nil and ContainsAny( room.LegalEncounters, bountyData.Encounters ) then
				if GameState.PackagedBountyClears[bountyData.Name] ~= nil then
					return bountyData.ForcedRewardRepeat
				else
					return bountyData.ForcedReward
				end
			end
		end

		if room.ForcedReward ~= nil then
			return room.ForcedReward
		end
		if room.ForcedFirstReward ~= nil then
			local foundFirstReward = false
			if CurrentRun.CurrentRoom ~= nil and CurrentRun.CurrentRoom.OfferedRewards ~= nil then
				for k, rewardData in pairs(CurrentRun.CurrentRoom.OfferedRewards) do
					if rewardData.Type == room.ForcedFirstReward then
						foundFirstReward = true
						break
					end
				end
			end
			if not foundFirstReward then
				return room.ForcedFirstReward
			end
		end

		if run.CurrentRoom ~= nil and run.CurrentRoom.DeferReward then
			return run.CurrentRoom.ChosenRewardType
		end

		if run.CurrentRoom ~= nil and run.CurrentRoom.PersistentExitDoorRewards and run.CurrentRoom.TimesVisited > 1 and args.Door ~= nil then
			for roomIndex = #run.RoomHistory, 1, -1 do
				local prevRoom = run.RoomHistory[roomIndex]
				if run.CurrentRoom.Name == prevRoom.Name and prevRoom.OfferedRewards ~= nil and prevRoom.OfferedRewards[args.Door.ObjectId] ~= nil then
					room.Reward = prevRoom.Reward
					return prevRoom.OfferedRewards[args.Door.ObjectId].Type
				end
			end
		end

		if room.ChooseRewardRequirements ~= nil then
			if not IsGameStateEligible( room, room.ChooseRewardRequirements ) then
				return nil
			end
		end

		local forcedRewards = args.ForcedRewards or roomData.ForcedRewards
		if forcedRewards ~= nil and room.TimerBlock == "StoryRoom" then
			for k, forcedReward in pairs( forcedRewards ) do
				if forcedReward.GameStateRequirements == nil or IsGameStateEligible( forcedReward, forcedReward.GameStateRequirements ) then
					room.ForceLootName = forcedReward.LootName
					room.ForcedReward = forcedReward
					room.Reward = room.ForcedReward
					DebugPrint({ Text = "Forced Reward: "..forcedReward.Name })
					return forcedReward.Name
				end
			end
		end
	end

	if args.IgnoreForcedReward and rewardStoreName == "RunProgress" and previouslyChosenRewards ==  { { RewardType = "Devotion" }, { RewardType = "SpellDrop" } } then
		return base(run, room, rewardStoreName, previouslyChosenRewards, args)
	end

	if GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") >= 1 then
		if RandomChance(GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") * 0.25) and not Contains({ "InvalidOverrides", "Secrets", "PreHubRewards", "SubRoomRewards", "MinorRunProgress", "FieldsCombatRewards", "FieldsOptionalRewards", }, rewardStoreName) then
			if CurrentRun.RewardPriorities then
				local rewardKey = nil
				local eligibleRewardKeys = {}
				for key, reward in ipairs(run.RewardStores[rewardStoreName]) do
					if IsRoomRewardEligible(CurrentRun, room, reward, previouslyChosenRewards, args) then
						table.insert(eligibleRewardKeys, key)
					end
				end
				for i, priorityName in ipairs(CurrentRun.RewardPriorities) do
					for j, eligibleRewardKey in ipairs(eligibleRewardKeys) do
						local eligibleReward = run.RewardStores[rewardStoreName][eligibleRewardKey]
						if eligibleReward ~= nil and eligibleReward.Name == priorityName then
							DebugPrint({ Text = "Priority Reward: " .. priorityName })
							rewardKey = eligibleRewardKey
							RemoveValueAndCollapse(CurrentRun.RewardPriorities, priorityName)
							return eligibleReward
						end
					end
				end
			end
			return base(run, room, "MetaProgress", previouslyChosenRewards, args)
		end
	end
	return base(run, room, rewardStoreName, previouslyChosenRewards, args)
end)]]

--[[modutil.mod.Path.Wrap("ChooseNextRewardStore", function(base, run)
	if GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") >= 1 then
		if RandomChance(GetNumShrineUpgrades("NightmareFearNoManaMetaUpgrade") * 0.25) then
			RandomSynchronize()

			
			--DebugPrint({ Text = "minorRunProgressChance = "..minorRunProgressChance })
			local rewardStoreName = "MetaProgress"
			--DebugPrint({ Text = "rewardStoreName = "..rewardStoreName })
			run.NextRewardStoreName = rewardStoreName
			return rewardStoreName
		end
	end
	return base(run)
end)]]

-- Simplicity
table.insert(NamedRequirementsData.HammerLootRequirements, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearHammerlessMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
table.insert(NamedRequirementsData.LateHammerLootRequirements, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearHammerlessMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})

modutil.mod.Path.Wrap("RequiredNotInStore", function(base, source, args )
    if args.Name == "WeaponUpgradeDrop" and GetNumShrineUpgrades("NightmareFearHammerlessMetaUpgrade") >= 1 then
                                return false
                            end
    return base(source, args)
end)

-- Eclipse
modutil.mod.Path.Wrap("RequiredNotInStore", function(base, source, args )
    if args.Name == "SpellDrop" and GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 then
                                return false
    end
    if args.Name == "TalentDrop" and GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 then
                                return false
    end
    return base(source, args)
end)
--[[table.insert(NamedRequirementsData.SpellDropRequirements, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
table.insert(NamedRequirementsData.TalentLegal, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})

for i, data in ipairs(StoreData.SurfaceShop.GroupsOf) do
	for _, options in ipairs(data.OptionsData) do
		if options.Name == "SpellDrop" then
			table.insert(options.ReplaceRequirements, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = ">=",
								Value = 1,
							},
						})
		elseif options.Name == "TalentDrop" then
			table.insert(options.ReplaceRequirements, {
							FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = ">=",
								Value = 1,
							},
						})
		end
	end	
end]]



modutil.mod.Path.Wrap("StoreItemEligible", function(base, itemData, args)
	itemData = itemData or {}
	if (itemData.Name == "SpellDrop" or itemData.Name == "TalentDrop") and GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 then
		return false
	end
	if itemData.Name == "WeaponUpgradeDrop"  and GetNumShrineUpgrades("NightmareFearHammerlessMetaUpgrade") >= 1 then
		return false
	end
return base(itemData, args)
end)

modutil.mod.Path.Wrap("IsGameStateEligible", function(base,source, requirements, args)
	source = source or {}
	if (source.Name == "SpellDrop" or source.Name == "TalentDrop") and GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 then
		return false
	end
	if source.Name == "WeaponUpgradeDrop"  and GetNumShrineUpgrades("NightmareFearHammerlessMetaUpgrade") >= 1 then
		return false
	end
	return base(source,requirements, args)
end)

modutil.mod.Path.Wrap("FillInShopOptions", function(base,args)
	args = args or {}
	args.ExclusionNames = args.ExclusionNames or {}
	if GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 then
		table.insert(args.ExclusionNames, "SpellDrop")
		table.insert(args.ExclusionNames, "TalentDrop")
	end
	if GetNumShrineUpgrades("NightmareFearHammerlessMetaUpgrade") >= 1 then
		table.insert(args.ExclusionNames, "WeaponUpgradeDrop")
	end
	return base(args)
end)
-- Riposte

modutil.mod.Path.Wrap("DamageEnemy", function(base,victim, triggerArgs)
		local sourceWeaponData = triggerArgs.AttackerWeaponData
	local attacker = triggerArgs.AttackerTable

	-- Used to detect death via artemis vulnerability crit even though it's cleared on a crit
	victim.ActiveEffectsAtDamageStart = {}
	if victim.ActiveEffects then
		victim.ActiveEffectsAtDamageStart = ShallowCopyTable( victim.ActiveEffects )
	end

	if triggerArgs.EffectName ~= nil then
		local effectData = EffectData[triggerArgs.EffectName] 
		if effectData ~= nil and effectData.NonPlayerDamageMultiplier ~= nil then
			triggerArgs.DamageAmount = triggerArgs.DamageAmount * effectData.NonPlayerDamageMultiplier
		end
	end

	if sourceWeaponData ~= nil then
		if sourceWeaponData.ForceCrit then
			triggerArgs.IsCrit = true
		end
	end

	if triggerArgs.DamageAmount == 0 then
		return
	end
	
	if GetNumShrineUpgrades("NightmareFearEnemyDodgeMetaUpgrade") >= 1 then
		if RandomChance(0.03*GetNumShrineUpgrades("NightmareFearEnemyDodgeMetaUpgrade")) then
			return EnemyDodgePresentation(victim, triggerArgs)
		end
	end

	return base(victim, triggerArgs)
end)

--Decay 
modutil.mod.Path.Wrap("CreateStackLoot", function(base, args)
	local reward = mod.CheckPomSkipShrineUpgrade({}, args)
	if reward then
		return reward
	end
	return base(args)
end)

function mod.CheckPomSkipShrineUpgrade(source, args)
	local currentRoom = CurrentRun.CurrentRoom or {}
	CurrentRun.NightmareFearPomSkips = CurrentRun.NightmareFearPomSkips or 0
	if GetNumShrineUpgrades( "NightmareFearPomLevelsMetaUpgrade" ) > CurrentRun.NightmareFearPomSkips then
		CurrentRun.NightmareFearPomSkips = CurrentRun.NightmareFearPomSkips + 1
		local consumableId = SpawnObstacle({ Name = "RoomRewardConsolationPrize", DestinationId = args.SpawnPoint, Group = "Standing", OffsetX = args.OffsetX, OffsetY = args.OffsetY })
		local reward = CreateConsumableItem( consumableId, "RoomRewardConsolationPrize", 0, { IgnoreSounds = currentRoom.SuppressRewardSpawnSounds or false } )
		MapState.RoomRequiredObjects[reward.ObjectId] = reward
		thread( BoonSkipShrineUpgradePresentation, reward, args )
		return reward
	end 
	return nil
end

modutil.mod.Path.Wrap("EndBiomeRecords", function(base,source, args)
	base(source, args)
	CurrentRun.NightmareFearPomSkips = 0
end)

modutil.mod.Path.Wrap("PopulateDoorRewardPreviewSubIcons", function(base,exitDoor, args)
	local subIcons = base(exitDoor, args) or {}
	local hasOnion = false
	if not args.RewardHidden and not args.SkipRoomSubIcons then	
		local chosenRewardTypes = {}
		if args.CageRewards ~= nil then
			for i, cageReward in ipairs( args.CageRewards ) do
				table.insert( chosenRewardTypes, cageReward.RewardType )
			end
		else
			table.insert( chosenRewardTypes, args.ChosenRewardType )
		end
	for i, rewardType in ipairs( chosenRewardTypes ) do
			if rewardType == "StackUpgrade" then
				CurrentRun.NightmareFearPomSkips = CurrentRun.NightmareFearPomSkips or 0
				if GetNumShrineUpgrades( "NightmareFearPomLevelsMetaUpgrade" ) > CurrentRun.NightmareFearPomSkips then
					hasOnion = true
					table.insert( subIcons, { Name = "RoomRewardSubIcon_Onion" } )
					break
				end
			end
		end

		local existingOnionIconId = exitDoor.AdditionalIcons.RoomRewardSubIcon_Onion
		if existingOnionIconId ~= nil then
			if hasOnion then
				SetAlpha({ Id = existingOnionIconId, Fraction = 1.0, Duration = 0.2 })
			else
				SetAlpha({ Id = existingOnionIconId, Fraction = 0.0, Duration = 0.2 })
			end
		end
	end
	return subIcons
end)

-- Panic & Tax

modutil.mod.Path.Wrap("LeaveRoom", function(base, currentRun, door)
	if GetNumShrineUpgrades("NightmareFearTaxMetaUpgrade") >=1 then
		mod.DoTaxLoss(GetNumShrineUpgrades( "NightmareFearTaxMetaUpgrade" ))
	end
	base(currentRun, door)
end)

modutil.mod.Path.Context.Wrap.Static("StartRoom", function(base, currentRun,currentRoom)
	modutil.mod.Path.Wrap("RefillMana", function(base)
	if GetNumShrineUpgrades( "NightmareFearLowManaStartMetaUpgrade" ) >= 1 then
		base()
		mod.EmptyMana()
	else
		return base()
	end
	end)
end)

function mod.EmptyMana()
	if CurrentRun.Hero.Mana > 0 then
	 CurrentRun.Hero.Mana = 0
		return UpdateManaMeterUI() 
		--ManaDelta(-GetHeroMaxAvailableMana())
	else
		return
	end
end

function mod.DoTaxLoss(shrineLevel)
	if shrineLevel < 1 then return end
	local moneyToLose = 5*shrineLevel
	if GetResourceAmount( "Money" ) < moneyToLose then
		moneyToLose = GetResourceAmount("Money")
	end
	SpendResource("Money", moneyToLose, {Silent = true})
end

-- Secrets
modutil.mod.Path.Wrap("CreateDoorRewardPreview", function(base,exitDoor, chosenRewardType, chosenLootName, index, args)
    if GetNumShrineUpgrades( "NightmareFearBlindRewardMetaUpgrade" ) >= 1 then
        local shrineLevel = GetNumShrineUpgrades( "NightmareFearBlindRewardMetaUpgrade" )
        if RandomChance(shrineLevel * 0.25) then
            exitDoor.Room.RewardPreviewOverride = "ChaosPreview"
            args = args or {}
            args.SkipRoomSubIcons = true
        end
    end

    return base(exitDoor, chosenRewardType, chosenLootName, index, args)
end)

-- Vanity
modutil.mod.Path.Wrap("GetKeepsakeLevel", function(base, traitName, unmodified)
	local level = base(traitName, unmodified)
	if GetNumShrineUpgrades( "NightmareFearKeepsakeLevelMetaUpgrade" ) >= 1 and not unmodified then
		level = level - GetNumShrineUpgrades( "NightmareFearKeepsakeLevelMetaUpgrade" )
		level = math.max(level, 1)
	end
	if GetNumShrineUpgrades( "NightmareFearKeepsakeLevelMetaUpgrade" ) >= 1 and not unmodified and HasHeroTraitValue("KeepsakeLevelBonus") then
		level = level + 1
	end
	level = math.max(level, 1)
	if KeepsakeHasHeroicRarity(traitName) then
		level = math.min(level, 4)
	else
		level = math.min(level, 3)
	end
	return level
end)

function mod.ReupgradeKeepsake()
	local traitName = GameState.LastAwardTrait
	if not traitName then return end
	local timesToUpgrade = GetKeepsakeLevel(traitName, true) - GetKeepsakeLevel(traitName)
	for i = 1, timesToUpgrade do
		AdvanceKeepsake( true )
	end
end

-- Forsaking
modutil.mod.Path.Wrap("CalcNumLootChoices", function(base,lootData)
	local numChoices = base(lootData)
	local isGodLoot = lootData.GodLoot
	local treatAsGodLootByShops = lootData.TreatAsGodLootByShops
	if (isGodLoot or treatAsGodLootByShops) and GetNumShrineUpgrades( "NightmareFearLessChoicesMetaUpgrade" ) >= 1 then
		local shrineRestriction = GetNumShrineUpgrades("NightmareFearLessChoicesMetaUpgrade")
		numChoices = numChoices - shrineRestriction
	end
	numChoices = math.max(numChoices, 1)
	return numChoices
 end)

 TraitData.ChaosRestrictBoonCurse.GameStateRequirements = TraitData.ChaosRestrictBoonCurse.GameStateRequirements or {}
 table.insert(TraitData.ChaosRestrictBoonCurse.GameStateRequirements, {{
								ShrineUpgradeName = "NightmareFearLessChoicesMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},})

-- Purging

function mod.OpenForcePurgeTraitMenu( delay, args )
	if delay then 
		waitUnmodified( delay, "NightmareFearOpenForcePurgeTraitMenu" )
	end
	if IsScreenOpen("NightmareFearSellTraits") then
		return
	end
	args = args or {}
	mod.GenerateSellTraitShop( CurrentRun.CurrentRoom )

	AltAspectRatioFramesShow()

	local screen = DeepCopyTable( ScreenData.NightmareFearSellTraits )

	SetPlayerInvulnerable( screen.Name )
	OnScreenOpened( screen )
	HideCombatUI( screen.Name, screen.TraitTrayArgs )
	CreateScreenFromData( screen, screen.ComponentData )	

	screen.ShopItemStartX = screen.ShopItemStartX + ScreenCenterNativeOffsetX
	screen.ShopItemStartY = screen.ShopItemStartY + ScreenCenterNativeOffsetY

	local outdatedData = false
	if CurrentRun.CurrentRoom.NightmareFearSellOptions == nil then
		outdatedData = true
	else
		for itemIndex, sellData in pairs( CurrentRun.CurrentRoom.NightmareFearSellOptions ) do
			if sellData.Name then
				if not HeroHasTrait( sellData.Name ) then
					outdatedData = true
					break
				end
				local trait = GetHeroTrait( sellData.Name ) 
				if trait.Rarity ~= sellData.Rarity then
					outdatedData = true
					break
				end
			end
		end
	end
	if outdatedData then
		CurrentRun.CurrentRoom.NightmareFearSellOptions = nil
		mod.GenerateSellTraitShop( CurrentRun.CurrentRoom )
	end

	if TableLength(CurrentRun.CurrentRoom.NightmareFearSellOptions) < 1 then
		return mod.CloseForceSellScreen(screen)
	end

	for i, data in pairs(CurrentRun.CurrentRoom.NightmareFearSellOptions) do
		if not data.Value then
			data.Value = GetTraitValue( GetHeroTrait( data.Name ))
		end	
	end

	wait( 0.2 )
	mod.CreateForceSellButtons( screen )

	if TableLength( CurrentRun.CurrentRoom.NightmareFearSellOptions ) > 0 then
		thread( PlayVoiceLines, HeroVoiceLines.SellTraitShopUsedVoiceLines, true )
	else
		thread( PlayVoiceLines, HeroVoiceLines.SellTraitShopSoldOutVoiceLines, true )
	end

	screen.KeepOpen = true
	HandleScreenInput( screen )

end

function mod.GenerateSellTraitValues( currentRoom, args )
	args = args or {}
	currentRoom.NightmareFearSellValues = {}
	for index, traitData in ipairs( CurrentRun.Hero.Traits ) do
		if IsGodTrait( traitData.Name, { ForShop = true }) and traitData.Rarity and not Contains( args.ExclusionNames, traitData.Name ) then
			currentRoom.NightmareFearSellValues[traitData.Name] = { Name = traitData.Name, Value = GetTraitValue( traitData ), Rarity = traitData.Rarity }
		end
	end
end

function mod.CreateForceSellButtons( screen )

	local itemLocationStartY = screen.ShopItemStartY
	local itemLocationYSpacer = screen.ShopItemSpacerY
	local itemLocationMaxY = itemLocationStartY + 4 * itemLocationYSpacer

	local itemLocationStartX = screen.ShopItemStartX
	local itemLocationXSpacer = screen.ShopItemSpacerX
	local itemLocationMaxX = itemLocationStartX + 1 * itemLocationXSpacer

	local itemLocationX = itemLocationStartX
	local itemLocationY = itemLocationStartY

	local components = screen.Components

	local firstOption = true
	local sellList = {}
	local upgradeOptionsTable = {}

	if IsEmpty(CurrentRun.CurrentRoom.NightmareFearSellOptions) then
		mod.GenerateSellTraitShop( CurrentRun.CurrentRoom )
		for i, data in pairs(CurrentRun.CurrentRoom.NightmareFearSellOptions) do
		if not data.Value then
			data.Value = GetTraitValue( GetHeroTrait( data.Name ))
		end	
	end
	end

		if IsEmpty(CurrentRun.CurrentRoom.NightmareFearSellOptions) then
		return mod.CloseForceSellScreen(screen)
		end

	for itemIndex, sellData in pairs( CurrentRun.CurrentRoom.NightmareFearSellOptions ) do
		for index, traitData in ipairs( CurrentRun.Hero.Traits ) do
			if sellData.Name == traitData.Name and traitData.Rarity and ( upgradeOptionsTable[traitData.Name] == nil or GetRarityValue( upgradeOptionsTable[traitData.Name].Rarity ) > GetRarityValue( traitData.Rarity ) ) then
				upgradeOptionsTable[traitData.Name] = { Data = traitData, Value = sellData.Value }
			end
		end
	end

	for i, value in pairs( upgradeOptionsTable ) do
		table.insert( sellList, value )
	end

	if IsEmpty(sellList) then
		return mod.CloseForceSellScreen(screen)
	end

	local screenData = ScreenData.UpgradeChoice

	local hasButton = false
	for itemIndex, sellData in ipairs( sellList ) do
		local upgradeData = sellData.Data
		if upgradeData ~= nil then
			local tooltipData = upgradeData
			local traitData = upgradeData
			SetTraitTextData( traitData )

			local purchaseButtonKey = "PurchaseButton"..itemIndex		
			local purchaseButton = DeepCopyTable( ScreenData.UpgradeChoice.PurchaseButton )
			purchaseButton.X = itemLocationX
			purchaseButton.Y = itemLocationY
			components[purchaseButtonKey] = CreateScreenComponent( purchaseButton )
			SetAlpha({ Id = components[purchaseButtonKey].Id, Fraction = 0.1 })
			SetAlpha({ Id = components[purchaseButtonKey].Id, Fraction = 1, Duration = 0.05 * itemIndex, EaseIn = 0, EaseOut = 1 })
			local button = components[purchaseButtonKey]
			button.Value = sellData.Value
			button.UpgradeName = traitData.Name
			button.ItemIndex = itemIndex

			local title = GetTraitTooltipTitle( traitData )
			local traitCount = GetTraitCount( CurrentRun.Hero, { TraitData = traitData } )
			if traitCount > 1 then
				title = "TraitLevel_Current"
				traitData.OldLevel = traitCount
				if not traitData.Title then
					traitData.Title = GetTraitTooltipTitle( traitData )
				end
			end

			local titleColor = Color.White
			local rarityPatchColor = Color.Transparent
	
			if traitData.CustomRarityColor then
				rarityPatchColor = traitData.CustomRarityColor
				titleColor = traitData.CustomRarityColor
			elseif button.OverrideRarity ~= nil and button.OverrideRarity ~= "Common" then
				rarityPatchColor = Color["BoonPatch"..button.OverrideRarity]
				titleColor = Color["BoonPatch"..button.OverrideRarity]
			elseif traitData.Rarity ~= nil and traitData.Rarity ~= "Common" then
				rarityPatchColor = Color["BoonPatch"..traitData.Rarity]
				titleColor = Color["BoonPatch"..traitData.Rarity]
			else
				local rarityLevel = GetNumShrineUpgrades( traitData.Name )
				if rarityLevel > 0 then
					local rarityName = TraitRarityData.WeaponRarityUpgradeOrder[rarityLevel]
					titleColor = Color["BoonPatch"..rarityName]
				end
			end

			local highlight = ShallowCopyTable( ScreenData.UpgradeChoice.Highlight )
			highlight.X = purchaseButton.X
			highlight.Y = purchaseButton.Y
			components[purchaseButtonKey.."Highlight"] = CreateScreenComponent( highlight )
			components[purchaseButtonKey].Highlight = components[purchaseButtonKey.."Highlight"]
	
			local icon = ShallowCopyTable( ScreenData.UpgradeChoice.Icon )
			icon.X = itemLocationX + ScreenData.UpgradeChoice.IconOffsetX
			icon.Y = itemLocationY + ScreenData.UpgradeChoice.IconOffsetY 
			icon.Animation = upgradeData.Icon
			components[purchaseButtonKey.."Icon"] = CreateScreenComponent( icon )

			local frame = ShallowCopyTable( ScreenData.UpgradeChoice.Frame )
			frame.X = itemLocationX + ScreenData.UpgradeChoice.IconOffsetX
			frame.Y = itemLocationY + ScreenData.UpgradeChoice.IconOffsetY 
			frame.Animation = GetTraitFrame( upgradeData )
			components[purchaseButtonKey.."Frame"] = CreateScreenComponent( frame )

			if IsGameStateEligible( screen, TraitRarityData.ElementalGameStateRequirements ) and not IsEmpty( traitData.Elements ) then
				local elementName = GetFirstValue( traitData.Elements )
				local elementIcon = ShallowCopyTable( screenData.ElementIcon )
				elementIcon.Group = screenData.ComponentData.DefaultGroup
				elementIcon.Name = TraitElementData[elementName].Icon
				elementIcon.X = itemLocationX + elementIcon.XShift - 350
				elementIcon.Y = itemLocationY + elementIcon.YShift
				components[purchaseButtonKey.."ElementIcon"] = CreateScreenComponent( elementIcon )
			end

			local rarity = upgradeData.Rarity
			if not rarity then
				rarity = "Common"
			end
			local text = "Boon_"..rarity
			local overlayLayer = ""
			if upgradeData.CustomRarityName then
				text = upgradeData.CustomRarityName
			end
			local color = Color["BoonPatch"..rarity]
			if upgradeData.CustomRarityColor then
				color = upgradeData.CustomRarityColor
			end

			local rarityText = ShallowCopyTable( screenData.RarityText )
			rarityText.Id = button.Id
			rarityText.Text = text
			rarityText.Color = color
			CreateTextBox( rarityText )

			local titleText = ShallowCopyTable( screenData.TitleText )
			titleText.Id = button.Id
			titleText.Text = title
			titleText.Color = titleColor
			titleText.LuaValue = traitData
			CreateTextBox( titleText )

			local descriptionText = ShallowCopyTable( screenData.DescriptionText )
			descriptionText.Id = button.Id
			descriptionText.Text = GetTraitTooltip( upgradeData )
			descriptionText.LuaKey = "TooltipData"
			descriptionText.LuaValue = upgradeData
			CreateTextBoxWithFormat( descriptionText )
			
			SetInteractProperty({ DestinationId = button.Id, Property = "TooltipOffsetX", Value = ScreenData.UpgradeChoice.TooltipOffsetX })

			
			local sellTextAnchor = DeepCopyTable( ScreenData.UpgradeChoice.PurchaseButton )
			sellTextAnchor.Name = "BlankObstacle"
			sellTextAnchor.X = itemLocationX
			sellTextAnchor.Y = itemLocationY
			components[purchaseButtonKey.."SellText"] = CreateScreenComponent( sellTextAnchor )
			
			local sellAmountFormat = ShallowCopyTable( screen.SellAmountFormat )
			sellAmountFormat.Id = components[purchaseButtonKey.."SellText"].Id
			sellAmountFormat.Text = "Sell_ItemCost"
			sellAmountFormat.LuaKey = "TempTextData"
			sellAmountFormat.LuaValue = { Amount = button.Value }
			CreateTextBox( sellAmountFormat )
			
			local statLines = upgradeData.StatLines
			local statLineData = upgradeData
			if statLines ~= nil then
				for lineNum, statLine in ipairs( statLines ) do
					if statLine ~= "" then

						local offsetY = (lineNum - 1) * ScreenData.UpgradeChoice.LineHeight

						local statLineLeft = DeepCopyTable(ScreenData.UpgradeChoice.StatLineLeft)
						statLineLeft.Id = components[purchaseButtonKey].Id
						statLineLeft.Text = statLine
						statLineLeft.OffsetY = offsetY
						statLineLeft.LuaValue = statLineData
						statLineLeft.AppendToId = descriptionText.Id
						CreateTextBoxWithFormat( statLineLeft )

						local statLineRight = DeepCopyTable(ScreenData.UpgradeChoice.StatLineRight)
						statLineRight.Id = components[purchaseButtonKey].Id
						statLineRight.Text = statLine
						statLineRight.OffsetY = offsetY
						statLineRight.AppendToId = descriptionText.Id
						statLineRight.LuaValue = statLineData
						CreateTextBoxWithFormat( statLineRight )

					end
				end
			end

			button.Screen = screen
			AttachLua({ Id = button.Id, Table = button })
			button.Data = upgradeData
			button.WeaponName = currentWeapon
			button.Index = itemIndex
			button.OnPressedFunctionName = _PLUGIN.guid..".HandleForceSellChoiceSelection"
			button.OnMouseOverFunctionName = "MouseOverSellShopButton"
			button.OnMouseOffFunctionName = "MouseOffSellShopButton"

			if firstOption then
				TeleportCursor({ OffsetX = itemLocationX, OffsetY = itemLocationY, ForceUseCheck = true })
				firstOption = false
			end
			hasButton = true
		end

		itemLocationX = itemLocationX + itemLocationXSpacer
		if itemLocationX >= itemLocationMaxX then
			itemLocationX = itemLocationStartX
			itemLocationY = itemLocationY + itemLocationYSpacer
		end
	end

	if not hasButton then return mod.CloseForceSellScreen(screen) end

	UpdateStoreReroll( screen, CurrentRun.CurrentRoom.NightmareFearSellOptions, _PLUGIN.guid .. ".ForceSellTraitScreenReroll" )

end

function mod.HandleForceSellChoiceSelection( screen, button )
	RemoveWeaponTrait( button.UpgradeName, { Silent = true } )
	AddResource( "Money", button.Value, "TraitSell" )

	for index, sellData in pairs( CurrentRun.CurrentRoom.NightmareFearSellOptions ) do
		if sellData.Name == button.UpgradeName then
			CurrentRun.CurrentRoom.NightmareFearSellOptions[index] = nil
		end
	end
	
	CurrentRun.CurrentRoom.TraitsSold = (CurrentRun.CurrentRoom.TraitsSold or 0) + 1
	CurrentRun.TraitsSold = (CurrentRun.TraitsSold or 0) + 1
	GameState.TraitsSold = (GameState.TraitsSold or 0) + 1

	local purchaseButtonKey = "PurchaseButton"..button.ItemIndex
	local clearIds = {}
	if screen.Components[purchaseButtonKey] ~= nil then
		table.insert( clearIds, screen.Components[purchaseButtonKey].Id )
	end
	if screen.Components[purchaseButtonKey.."Highlight"] ~= nil then
		table.insert( clearIds, screen.Components[purchaseButtonKey.."Highlight"].Id )
	end
	if screen.Components[purchaseButtonKey.."Icon"] ~= nil then
		table.insert( clearIds, screen.Components[purchaseButtonKey.."Icon"].Id )
	end
	if screen.Components[purchaseButtonKey.."Frame"] ~= nil then
		table.insert(clearIds, screen.Components[purchaseButtonKey.."Frame"].Id )
	end
	if screen.Components[purchaseButtonKey.."ElementIcon"] ~= nil then
		table.insert(clearIds, screen.Components[purchaseButtonKey.."ElementIcon"].Id )
	end
	if screen.Components[purchaseButtonKey.."SellText"] ~= nil then
		table.insert(clearIds, screen.Components[purchaseButtonKey.."SellText"].Id )
	end
	
	SetAlpha({ Id = screen.Components.SelectButton.Id, Fraction = 0, Duration = 0.2 })
	CreateAnimation({ Name = "BoonSlotPurchase", DestinationId = screen.Components[purchaseButtonKey].Id, OffsetX = 0 })
	SetColor({ Ids = clearIds, Color = {0,0,0,0}, Duration = 0.15, EaseIn = 0.9, EaseOut = 1 })
	SetScale({ Id = screen.Components[purchaseButtonKey].Id, Fraction = 0.9, Duration = 0.15, EaseIn = 0.9, EaseOut = 1.0})
	screen.Components[purchaseButtonKey].OnPressedFunctionName = nil
	
	PlaySound({ Name = "/SFX/Menu Sounds/SellTraitShopConfirm" })
	thread( PlayVoiceLines, HeroVoiceLines.SoldTraitVoiceLines, true )

	if not IsEmpty( clearIds ) then
		thread(DestroyOnDelay, clearIds, 1.25 )
	end

	mod.CloseForceSellScreen(screen)
end

function mod.CloseForceSellScreen(screen)
	local components = screen.Components
	local useableOffButtonIds = {}
	for index = 1, 3 do
		if components["PurchaseButton"..index] and components["PurchaseButton"..index].Id then
			table.insert(useableOffButtonIds, components["PurchaseButton"..index].Id)
		end
	end
	UseableOff({ Ids = useableOffButtonIds })
	AltAspectRatioFramesHide()
	OnScreenCloseStarted( screen )
	if screen.CloseAnimationName and components.ShopBackground then
		SetAnimation({ Name = screen.CloseAnimationName, DestinationId = components.ShopBackground.Id })
	end
	CloseScreen( GetAllIds( screen.Components ), 0.15 )
	OnScreenCloseFinished( screen )
	ShowCombatUI( screen.Name )
	thread( MarkObjectiveComplete, "ShopPrompt" )
	SetPlayerVulnerable( screen.Name )

end

function mod.GenerateSellTraitShop( currentRoom, args )
	args = args or {}
	mod.GenerateSellTraitValues( currentRoom, args )

	local commonTraits = {}
	if args.PrioritizeCommonTraits then
		for traitName, traitValue in pairs( currentRoom.NightmareFearSellValues ) do
			if traitValue.Rarity == "Common" then
				table.insert( commonTraits, traitValue )
			end
		end
	end

	if currentRoom.NightmareFearSellOptions == nil then
		currentRoom.NightmareFearSellOptions = {}
		for i = 1, args.SellOptionCount or 3 do
			if IsEmpty( currentRoom.NightmareFearSellValues ) then
				break
			end
			--DebugPrint({ Text = "TableLength( currentRoom.SellValues ) = "..TableLength(currentRoom.SellValues) })
			if args.PrioritizeCommonTraits and not IsEmpty( commonTraits ) then
				local chosenTrait = RemoveRandomValue( commonTraits )
				table.insert( currentRoom.NightmareFearSellOptions, chosenTrait )
				RemoveValue( currentRoom.NightmareFearSellValues, chosenTrait )
			else
				table.insert( currentRoom.NightmareFearSellOptions, RemoveRandomValue( currentRoom.NightmareFearSellValues ) )
			end
		end
	end
end

function mod.ForceSellTraitScreenReroll( screen )
	SellTraitScreenDestroyButtons( screen )
	local exclusions = {}
	if not IsEmpty( CurrentRun.CurrentRoom.NightmareFearSellOptions ) and not IsEmpty( CurrentRun.CurrentRoom.NightmareFearSellValues ) then
		exclusions = { GetRandomValue( CurrentRun.CurrentRoom.NightmareFearSellOptions ).Name }
	end
	CurrentRun.CurrentRoom.NightmareFearSellOptions = nil
	mod.GenerateSellTraitShop( CurrentRun.CurrentRoom, { ExclusionNames = exclusions } )
	mod.CreateForceSellButtons( screen )
end

--[[modutil.mod.Path.Wrap("Kill", function(base, victim, triggerArgs)
	base(victim, triggerArgs)
	if victim == nil then
		return
	end

	if SessionMapState.HandlingDeath then
		-- No one can be killed after the hero dies, they can only be cleaned up directly
		return
	end

	triggerArgs = triggerArgs or {}

	local victimName = victim.Name
	local killer = triggerArgs.AttackerTable
	local destroyerId = triggerArgs.AttackerId
	local killingWeaponName = triggerArgs.SourceWeapon
	local currentRoom = CurrentHubRoom or CurrentRun.CurrentRoom

	if not triggerArgs.SkipOnDeathFunction then
		if victim.IsBoss and not victim.BlockPostBossMetaUpgrades and (not victim.UseGroupHealthBar or victim.GroupHealthBarOwner) then
			mod.ExpireExpiryBoons()
			local delay = 0
			if GetNumShrineUpgrades("NightmareFearPurgingMetaUpgrade") >= 1 then
				mod.OpenForcePurgeTraitMenu(delay, {})
			end
		end
	end
end)]]

modutil.mod.Path.Wrap("PostCombatAudio", function(base,eventSource)
	local encounter = CurrentRun.CurrentRoom.Encounter
	local currentRoom = CurrentRun.CurrentRoom

	if encounter and encounter.EncounterType == "Boss" and not encounter.SkipBossTraits and not currentRoom.NightmareFearPurgeRun then
		mod.ExpireExpiryBoons()
		if GetNumShrineUpgrades("NightmareFearPurgingMetaUpgrade") >= 1 then
			currentRoom.NightmareFearPurgeRun = true
			local delay = 0
			thread(mod.OpenForcePurgeTraitMenu,delay, {})
		end
	end


	return base(eventSource)
end)

-- Rudiments
table.insert(TraitRarityData.ElementalGameStateRequirements, {FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearNoElementsMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData, args )
	local valueToSave = GameState.Flags.SeenElementalIcons
	if GetNumShrineUpgrades("NightmareFearNoElementsMetaUpgrade") >= 1 then
		GameState.Flags.SeenElementalIcons = false
	end
	local valueToReturn = base(screen, lootData, itemIndex, itemData, args )
	GameState.Flags.SeenElementalIcons = valueToSave
	return valueToReturn
end)

-- Arrogance
modutil.mod.Path.Wrap("CalculateDamageMultipliers", function(base,attacker, victim, weaponData, triggerArgs)
	local multipliers = base(attacker, victim, weaponData, triggerArgs)
	if GetNumShrineUpgrades("NightmareFearFirstHitMetaUpgrade") >= 1 and victim == CurrentRun.Hero and attacker ~= CurrentRun.Hero and not SessionMapState.NightmareFearFirstHitUsed then
		 SessionMapState.NightmareFearFirstHitUsed = true
		if GetNumShrineUpgrades("NightmareFearFirstHitMetaUpgrade") == 1 then
			multipliers = multipliers + 1
		else
			multipliers = multipliers + 3
		end
	end
	return multipliers
end)

-- Expiring
modutil.mod.Path.Wrap("SetTraitsOnLoot", function(base,lootData, args)
	base(lootData, args)
	if lootData.GodLoot or lootData.TreatAsGodLootByShops and GetNumShrineUpgrades("NightmareFearExpirationMetaUpgrade") >= 1 then
		local expiringBoonChance = 0.25 * GetNumShrineUpgrades("NightmareFearExpirationMetaUpgrade")
		for i, trait in ipairs(lootData.UpgradeOptions) do
			if RandomChance(expiringBoonChance) then
				trait.NightmareFearExpiring = true
				trait.NightmareFearExpiringRemaining = 2
				if trait.CustomStatLinesWithShrineUpgrade then
					trait.CustomStatLinesWithShrineUpgrade.ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade"
					table.insert(trait.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				else
					trait.CustomStatLinesWithShrineUpgrade = {
						ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade",
						StatLines = trait.StatLines or {}
					}
					table.insert(trait.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				end
			end
		end
	end
end)

modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData, args )
	local components = screen.Components
	local purchaseButtonKey = "PurchaseButton"..itemIndex
	components[purchaseButtonKey] = base(screen, lootData, itemIndex, itemData, args )
	local button = components[purchaseButtonKey]
	local upgradeName = lootData.Name
	local upgradeChoiceData = lootData
	local itemLocationY = (ScreenCenterY - 190) + screen.ButtonSpacingY * ( itemIndex - 1 )
	local itemLocationX = ScreenCenterX - 355
	local blockedIndexes = screen.BlockedIndexes
	local upgradeData = button.Data
	local upgradeTitle = nil
	local upgradeDescription = nil
	local upgradeDescription2 = nil
	local tooltipData = nil
	local stackNum = 0
	screen.NightmareFearExpiringIds = screen.NightmareFearExpiringIds or {}


	if lootData.UpgradeOptions[itemIndex].NightmareFearExpiring or itemData.NightmareFearExpiring then
		components[purchaseButtonKey.."NightmareFearExpiringIcon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_Overlay", Animation = "NightmareFearStoreItemExpiry", Alpha = 0, X = screen.PinOffsetX + itemLocationX +50, Y = screen.PinOffsetY + itemLocationY - 10 })
		SetAlpha({ Id = components[purchaseButtonKey.."NightmareFearExpiringIcon"].Id, Fraction = 1 })
		-- Silent toolip
		local tooltipText = "NightmareFearExpiringTraitTooltip"
		CreateTextBox({
			Text = "NightmareFearExpiringTraitTooltip",
			--Text = "NightmareFearExpiringTraitTooltip",
			TextSymbolScale = 0,
			Id = components[purchaseButtonKey].Id,
			Color = Color.Transparent,
			LuaKey = "ExpiringTraitData",
			LuaValue = lootData.UpgradeOptions[itemIndex],
		})
		button.Data.NightmareFearExpiring = true
				button.Data.NightmareFearExpiringRemaining = 2
				if button.Data.CustomStatLinesWithShrineUpgrade then
					button.Data.CustomStatLinesWithShrineUpgrade.ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade"
					table.insert(button.Data.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				else
					button.Data.CustomStatLinesWithShrineUpgrade = {
						ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade",
						StatLines = button.Data.StatLines or {}
					}
					table.insert(button.Data.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				end
		table.insert(screen.NightmareFearExpiringIds, components[purchaseButtonKey.."NightmareFearExpiringIcon"].Id)
	end

	return components[purchaseButtonKey]
end)

modutil.mod.Path.Wrap("DestroyBoonLootButton", function(base,screen, index)
	local components = screen.Components
	local toDestroy = {}
	local destroyIndexes = {
		"PurchaseButton"..index.."NightmareFearExpiringIcon"
	}
		for i, indexName in pairs( destroyIndexes ) do
		if components[indexName] then
			table.insert(toDestroy, components[indexName].Id)
			components[indexName] = nil
		end
	end
	Destroy({ Ids = toDestroy })
	return base(screen, index)
end)

modutil.mod.Path.Wrap("DestroyBoonLootButtons", function(base,screen, lootData)
	if screen.NightmareFearExpiringIds then
		Destroy({Ids = screen.NightmareFearExpiringIds})
		screen.NightmareFearExpiringIds = {}
	end
	return base(screen, lootData)
end)

modutil.mod.Path.Wrap("TryUpgradeBoon", function(base,lootData, screen, button)
	
	local components = screen.Components

	local traitData = button.Data
	local sacrificeTrait = traitData.SacrificedTraitName
	local validUpgradeIndex = false
	if lootData.UpgradeOptions ~= nil then
		for i, upgradeData in pairs( lootData.UpgradeOptions ) do
			if  traitData.Name == upgradeData.ItemName and not traitData.BlockMenuRarify and traitData.Name == upgradeData.ItemName and GetUpgradedRarity(traitData.Rarity) ~= nil then
				validUpgradeIndex = i
			end
		end
	end
	if validUpgradeIndex then
		
		local toDestroy = {}
		local destroyIndexes = {
		"PurchaseButton"..validUpgradeIndex.."NightmareFearExpiringIcon",
		}
		for i, indexName in pairs( destroyIndexes ) do
			if components[indexName] then
				table.insert(toDestroy, components[indexName].Id)
				components[indexName] = nil
			end
		end
		Destroy({ Ids = toDestroy })
	end
 return base(lootData, screen, button)
end)


function mod.ExpireExpiryBoons()
	local doInCombatText = false
	local traitsToRemove = {}
	if CurrentRun.Hero.Traits == nil then
		UpdateHeroTraitDictionary()
	end
	CurrentRun.Hero.Traits = CurrentRun.Hero.Traits or {}
	for _, traitData in ipairs( CurrentRun.Hero.Traits ) do
		if traitData.NightmareFearExpiring then
			doInCombatText = true
			traitData.NightmareFearExpiringRemaining = traitData.NightmareFearExpiringRemaining - 1
			if traitData.NightmareFearExpiringRemaining < 1 then
				table.insert(traitsToRemove, traitData.Name)
			end
		end
	end
	for index, traitName in ipairs(traitsToRemove) do
		RemoveTrait(CurrentRun.Hero, traitName)
	end
	if doInCombatText then
		thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "NightmareFearExpirationMetaUpgrade_Active", Duration = 1.3, PreDelay = 0.5 } )
	end
end

modutil.mod.Path.Wrap("HandleUpgradeChoiceSelection", function(base, button, args)
	local upgradeData = button.Data
	base(button, args)
	if upgradeData and upgradeData.NightmareFearExpiring then
		for _, traitData in ipairs(CurrentRun.Hero.Traits) do
			if traitData.Name == upgradeData.Name then
				traitData.NightmareFearExpiring = true
				traitData.NightmareFearExpiringRemaining = 2
				if traitData.CustomStatLinesWithShrineUpgrade then
					traitData.CustomStatLinesWithShrineUpgrade.ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade"
					table.insert(traitData.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				else
					traitData.CustomStatLinesWithShrineUpgrade = {
						ShrineUpgradeName = "NightmareFearExpirationMetaUpgrade",
						StatLines = traitData.StatLines or {}
					}
					table.insert(traitData.CustomStatLinesWithShrineUpgrade.StatLines, "NightmareFearExpiringStatLine")
				end
				UpdateTraitNumber(traitData)
			end
		end
	end
end)

modutil.mod.Path.Wrap("SetTraitTrayDetails", function(base,args)
	args.StatLines = args.StatLines
	if args.StatLines then
		table.insert( args.StatLines, { args.StatLines[2][1], args.StatLines[2][2] } )
	end
	return base(args)
end)

function mod.SetUpNightmareFearNoHelpMetaUpgrade()
	local roomsToAdd = {"F_Story01", "G_Story01","H_Story01","I_Story01","N_Story01","O_Story01","P_Story01"}
	local encountersToAdd = {"NemesisCombatIntro", "NemesisCombatF", "NemesisCombatG", "NemesisCombatH", "NemesisCombatI", "IcarusCombatO", "IcarusCombatO2", "IcarusCombatIntro", "IcarusCombatP", "IcarusCombatP2", "ArtemisCombatF","ArtemisCombatF2","ArtemisCombatIntro","ArtemisCombatG","ArtemisCombatG2","ArtemisCombatN","ArtemisCombatN2","AthenaCombatP","AthenaCombatP02","AthenaCombatIntro","HeraclesCombatN","HeraclesCombatN2","HeraclesCombatIntro","HeraclesCombatO","HeraclesCombatO2","HeraclesCombatP","HeraclesCombatP2","NemesisRandomEvent","BridgeNemesisRandomEvent","Story_Heracles_01",}
	if ZagreusJourney then
		table.insert(roomsToAdd, "A_Story01")
		table.insert(roomsToAdd, "X_Story01")
		table.insert(roomsToAdd, "Y_Story01")
		table.insert(roomsToAdd, "A_Story01")

		table.insert(encountersToAdd, "ThanatosTartarus")
		table.insert(encountersToAdd, "ThanatosAsphodel")
		table.insert(encountersToAdd, "ThanatosElysium")
		table.insert(encountersToAdd, "ThanatosElysiumIntro")
	end
	for _, roomName in ipairs(roomsToAdd) do
		if game.RoomData[roomName] and game.RoomData[roomName].GameStateRequirements then 
		table.insert(game.RoomData[roomName].GameStateRequirements, {FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearNoHelpMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
					end
	end
	for _, encounterName in ipairs(encountersToAdd) do
		if game.EncounterData[encounterName] and game.EncounterData[encounterName].GameStateRequirements then
		table.insert(game.EncounterData[encounterName].GameStateRequirements,{FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearNoHelpMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						} )
					end
	end
end

modutil.mod.Path.Wrap("CheckShoppingEventThread", function(base, eventSource, args)
	if GetNumShrineUpgrades("NightmareFearNoHelpMetaUpgrade") <= 1 then
		return
	else
	return base(eventSource, args)
	end
end)

mod.SetUpNightmareFearNoHelpMetaUpgrade()

modutil.mod.Path.Wrap("HandleEnemySpawns", function(base, encounter)
	local encounterData = EncounterData[encounter.Name] or encounter
	if encounterData.EncounterType == "Boss" then
		mod.SetUpBetrayalWeapon(encounter, {})
	end
	return base(encounter)
end)

	
function mod.SetUpBetrayalWeapon(encounter, args)
	encounter = encounter or CurrentRun.CurrentRoom.Encounter or {}
		local encounterLookup = {BossHecate01 = 1, BossHecate02 = 1, BossScylla01 = 2, BossScylla02 = 2, BossInfestedCerberus01 = 3, BossInfestedCerberus02 = 3, BossChronos01 = 4, BossChronos02 = 4, BossPolyphemus01 = 1, BossPolyphemus02 = 1, BossEris01 = 2,BossEris02 = 2, BossPrometheus01 = 3,BossPrometheus02 = 3, BossTyphonHead01 = 4, BossTyphonHead02 = 4}
if ZagreusJourney then
		encounterLookup.BossHarpy1 = 1
		encounterLookup.BossHarpy2 = 1
		encounterLookup.BossHarpy3 = 1
		encounterLookup.BossHydra = 2
		encounterLookup.BossTheseusAndMinotaur = 3
		encounterLookup.BossHades = 4
	end
	if encounter.Name and encounterLookup[encounter.Name] and mod.BetrayalWeaponActive() then
		
	else
		return
	end
	CurrentRun = CurrentRun or {}
	CurrentRun.CurrentRoom = CurrentRun.CurrentRoom or {}
	CurrentRun.CurrentRoom.Encounter = CurrentRun.CurrentRoom.Encounter or {}
	if IsEmpty(CurrentRun.CurrentRoom.Encounter) then return end
	if SessionMapState.NightmareFearAlreadySpawnedDevotion then return end
	SessionMapState.NightmareFearAlreadySpawnedDevotion = true
	local gods = {"AphroditeUpgrade", "ApolloUpgrade","AresUpgrade", "DemeterUpgrade", "HephaestusUpgrade", "HeraUpgrade", "HestiaUpgrade", "PoseidonUpgrade",  "ZeusUpgrade"}
	local interactedGods = GetInteractedGodsThisRun()
	local chosenGod = nil
	for _, godName in ipairs(interactedGods) do
		for k, v in ipairs(gods) do
			if v == godName then
				gods[k] = nil
			end
		end
	end
	if #gods >= 1 then
		chosenGod = RemoveRandomValue(gods)
	else
		chosenGod = RemoveRandomValue({"AphroditeUpgrade", "ApolloUpgrade","AresUpgrade", "DemeterUpgrade", "HephaestusUpgrade", "HeraUpgrade", "HestiaUpgrade", "PoseidonUpgrade",  "ZeusUpgrade"})
	end
	local chosenWeapon = chosenGod.."RoomWeapon"
	SessionMapState.NightmareFearChosenPassiveRoomWeapon = chosenWeapon
	CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons = CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons or {}
	local newEnemy = DeepCopyTable( EnemyData[chosenWeapon] )
			newEnemy.ObjectId = SpawnUnit({ Name = chosenWeapon, Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId })	
			thread(SetupUnit, newEnemy, CurrentRun )
			newEnemy.Groups = newEnemy.Groups or {}
			table.insert( newEnemy.Groups, "RoomWeapon" )
			SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = _elapsedTimeMultiplier, DataValue = false, ValueChangeType = "Multiply", DestinationId = newEnemy.ObjectId })
			AddToGroup({ Id = newEnemy.ObjectId, Names = newEnemy.Groups })
			
			if not newEnemy.DontDieWithEncounter then
				table.insert(CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons, newEnemy.ObjectId)
			end
	--[[local newEnemy2 = DeepCopyTable( EnemyData[chosenWeapon] )
			newEnemy2.ObjectId = SpawnUnit({ Name = chosenWeapon, Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId })	
			thread(SetupUnit, newEnemy2, CurrentRun )
			newEnemy2.Groups = newEnemy2.Groups or {}
			table.insert( newEnemy2.Groups, "RoomWeapon" )
			SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = _elapsedTimeMultiplier, DataValue = false, ValueChangeType = "Multiply", DestinationId = newEnemy2.ObjectId })
			AddToGroup({ Id = newEnemy2.ObjectId, Names = newEnemy2.Groups })
			
			if not newEnemy2.DontDieWithEncounter then
				table.insert(encounter.PassiveRoomWeapons, newEnemy2.ObjectId)
			end]]

end

function mod.BetrayalWeaponActive()
	if (GameState.ShrineUpgrades.NightmareFearDevotionWeaponMetaUpgrade or 0) < (CurrentRun.EnteredBiomes or 0)then
			return false
	end
	return true
end

modutil.mod.Path.Wrap("OpenRunClearScreen", function(base)
	CurrentRun = CurrentRun or {}
	CurrentRun.CurrentRoom = CurrentRun.CurrentRoom or {}
	CurrentRun.CurrentRoom.Encounter = CurrentRun.CurrentRoom.Encounter or {}
	if CurrentRun.CurrentRoom.Encounter ~= nil then
		if CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons then
			for k, id in pairs(CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons) do
				if ActiveEnemies[id] ~= nil then
					CleanupEnemy(ActiveEnemies[id])
				end
			end
			Destroy({ Ids = CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons })
		end
	end
	return base()
end)


modutil.mod.Path.Wrap("SetTraitsOnLoot", function(base,lootData, args)
	args = args or {}
	args.BlockRarities = args.BlockRarities or {}
	args.ExclusionNames = args.ExclusionNames or {}
	local isGodLoot = lootData.GodLoot
	local treatAsGodLootByShops = lootData.TreatAsGodLootByShops
	if GetNumShrineUpgrades("NightmareFearLoweredRarityMetaUpgrade") >= 1 and (isGodLoot or treatAsGodLootByShops) then
		args.BlockRarities.Legendary = true
		args.BlockRarities.Heroic = true
		args.BlockRarities.Perfect = true
		if lootData.Traits then
			for _, traitName in pairs( lootData.Traits ) do
			local traitData = TraitData[traitName]
			if traitData.RarityLevels.Legendary then
				table.insert(args.ExclusionNames, traitData.Name)
			end
		end
		end
	end
	if GetNumShrineUpgrades("NightmareFearLoweredRarityMetaUpgrade") >= 2 and (isGodLoot or treatAsGodLootByShops) then
		args.BlockRarities.Legendary = true
		args.BlockRarities.Heroic = true
		args.BlockRarities.Perfect = true
		args.BlockRarities.Epic = true
	end
	if GetNumShrineUpgrades("NightmareFearLoweredRarityMetaUpgrade") >= 3 and (isGodLoot or treatAsGodLootByShops) then
		args.BlockRarities.Legendary = true
		args.BlockRarities.Heroic = true
		args.BlockRarities.Perfect = true
		args.BlockRarities.Rare = true	
	end
	return base(lootData, args)
end)

function mod.RequiredShrineLevel(source, functionArgs, args)
	if functionArgs == nil then return true end
	local requiredMetaUpgrade = functionArgs.ShrineUpgradeName
	local comparison = functionArgs.Comparison
	local level = functionArgs.Value
	if comparison == "=" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) == level
	elseif comparison == ">" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) > level
	elseif comparison == ">=" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) >= level
	elseif comparison == "<=" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) <= level
	elseif comparison == "<" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) < level
	elseif comparison == "~=" then
		return GetNumShrineUpgrades(requiredMetaUpgrade) ~= level
	else
		return true
	end
end

modutil.mod.Path.Wrap("CreateKeepsakeIcon", function(base,screen, components, args)
	base(screen, components, args)
	args = args or {}
	local localx = args.X
	local localy = args.Y
	local itemIndex = args.Index
	local upgradeData = args.UpgradeData
	local keyAppend = args.KeyAppend or ""
	local scale = args.Scale or 0.75
		
	local locked = false
	local buttonKey = "UpgradeToggle"..itemIndex..keyAppend
	if upgradeData.Unlocked and not KeepsakeOverhaul then
		if upgradeData.Gift == "SpellTalentKeepsake" and (GetNumShrineUpgrades("NightmareFearEclipseMetaUpgrade") >= 1 ) and IsGameStateEligible( upgradeData, { NamedRequirementsFalse = {"SurfaceRouteLockedByTyphonKill"}} ) then
			CreateTextBox({ 
					Id = components[buttonKey].Id,
					Text = "BlockedByNightmareFearEclipse_Tooltip",
					UseDescription = true,
					OffsetX = 0, OffsetY = 0,
					Color = Color.Transparent,
				})
			locked = true
			elseif upgradeData.Gift == "AthenaEncounterKeepsake" and (GetNumShrineUpgrades("NightmareFearNoHelpMetaUpgrade")>= 1) and IsGameStateEligible( upgradeData, { NamedRequirementsFalse = {"SurfaceRouteLockedByTyphonKill"}} ) then
				CreateTextBox({ 
					Id = components[buttonKey].Id,
					Text = "BlockedByNightmareFearIsolation_Tooltip",
					UseDescription = true,
					OffsetX = 0, OffsetY = 0,
					Color = Color.Transparent,
				})
			locked = true
		end
		local blocked = ( Contains(CurrentRun.BlockedKeepsakes, upgradeData.Gift) or ( CurrentRun.UseRecord.NPC_Athena_01 and not HeroHasTrait("AthenaEncounterKeepsake") and upgradeData.Gift == "AthenaEncounterKeepsake" ) ) 
		local blockedByEnding = false
		if not IsFateValid() and FatedEnableKeepsakes[upgradeData.Gift] then
			blocked = true
		end
		if TraitData[upgradeData.Gift].BlockedByEnding and not IsGameStateEligible( upgradeData, { NamedRequirementsFalse = {"SurfaceRouteLockedByTyphonKill"}} ) then
			blockedByEnding = true
		end
		if locked and not ((not CanFreeSwapKeepsakes() and blocked) or blockedByEnding) then 
		components[buttonKey.."Lock"] = CreateScreenComponent({ Name = "BlankObstacle", X = localx, Y = localy, Group = "Combat_Menu_Overlay", Animation = "LockedKeepsakeIcon" })
			SetColor({ Id = components[buttonKey].Id, Color = Color.DarkSlateGray })
			if components[buttonKey.."Sticker"] then
				SetColor({ Id = components[buttonKey.."Sticker"].Id, Color = Color.SlateGray })
			end
			components[buttonKey].OnPressedFunctionName = "BlockedKeepsakePresentation"
			components[buttonKey].Blocked = true
		end
	end
end)
if not KeepsakeOverhaul then
table.insert(TraitData.AthenaEncounterKeepsake.UniqueEncounterArgs.GameStateRequirements, {FunctionName = _PLUGIN.guid.. ".RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearNoHelpMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
					end

modutil.mod.Path.Wrap("EphyraZoomOut", function(base,usee)
	if GetNumShrineUpgrades("NightmareFearBlindRewardMetaUpgrade") >= 1 then
		return mod.EphyraZoomOut(usee)	
	else
	return base(usee)
	end
end)

function mod.EphyraZoomOut(usee)
	CurrentRun = CurrentRun or {}
	CurrentRun.CurrentRoom = CurrentRun.CurrentRoom or {}
	CurrentRun.CurrentRoom.ZoomFraction = CurrentRun.CurrentRoom.ZoomFraction or 0.55
	CurrentRun.CurrentRoom.ZoomFractionAlt = CurrentRun.CurrentRoom.ZoomFractionAlt or 0.63
CurrentRun.CurrentRoom.CameraZoomWeights =CurrentRun.CurrentRoom.CameraZoomWeights or 
		{
			[660496] = 1.00, -- start point of entrance hallway
			[660493] = 1.00, -- exit door
			[660489] = 1.75, -- west / bot-low
			[662609] = 1.65, -- west / bot-high
			[662592] = 1.40, -- west / mid
			[660491] = 1.55, -- west / top
			[660490] = 1.20, -- fountain
			[660494] = 1.50, -- east / top
			[660495] = 1.70, -- east / mid
			[660492] = 1.80, -- east / bot
		}
	AddInputBlock({ Name = "EphyraZoomOut" })
	AddTimerBlock( CurrentRun, "EphyraZoomOut" )
	SessionMapState.BlockPause = true
	thread( HideCombatUI, "EphyraZoomOut", { SkipHideObjectives = true } )
	SetPlayerInvulnerable( "EphyraZoomOut" )
	
	UseableOff({ Id = usee.ObjectId })

	ClearCameraClamp({ LerpTime = 0.8 })
	thread( SendCritters, { MinCount = 20, MaxCount = 20, StartX = 0, RandomStartOffsetX = 1200, StartY = 300, MinAngle = 75, MaxAngle = 115, MinSpeed = 400, MaxSpeed = 2000, MinInterval = 0.001, MaxInterval = 0.001, GroupName = "CrazyDeathBats" } )

	local cameraTargetId = SpawnObstacle({ Name = "InvisibleTarget" })
	Teleport({ Id = cameraTargetId, DestinationIsScreenRelative = true, OffsetX = ScreenCenterX, OffsetY = ScreenCenterY - 350 })
	PanCamera({ Id = cameraTargetId, Duration = 1.0, EaseIn = 0, EaseOut = 0, Retarget = true, FromCurrentLocation = true })
	FocusCamera({ Fraction = CurrentRun.CurrentRoom.ZoomFraction * 0.95, Duration = 1, ZoomType = "Ease" })

	wait( 0.50 )

	local groupName = "Combat_Menu_Backing"
	local idsCreated = {}

	ScreenAnchors.EphyraZoomBackground = CreateScreenObstacle({ Name = "rectangle01", Group = "Combat_Menu", X = ScreenCenterX, Y = ScreenCenterY })
	table.insert( idsCreated, ScreenAnchors.EphyraZoomBackground )
	SetScale({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 5 })
	SetColor({ Ids = { ScreenAnchors.EphyraZoomBackground }, Color = Color.Black })
	SetAlpha({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 0, Duration = 0 })
	SetAlpha({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 1.0, Duration = 0.2 })

	local letterboxIds = {}
	if ScreenState.NeedsLetterbox then
		local letterboxId = CreateScreenObstacle({ Name = "BlankObstacle", X = ScreenCenterX, Y = ScreenCenterY, Group = "Combat_Menu", Animation = "GUI\\Graybox\\NativeAspectRatioFrame", Alpha = 0.0 })
		table.insert( letterboxIds, letterboxId )
		SetAlpha({ Id = letterboxId, Fraction = 1.0, Duration = 0.2, EaseIn = 0.0, EaseOut = 1.0 })
	elseif ScreenState.NeedsPillarbox then
		local pillarboxLeftId = CreateScreenObstacle({ Name = "BlankObstacle", X = ScreenState.PillarboxLeftX, Y = ScreenCenterY, ScaleX = ScreenState.PillarboxScaleX, Group = "Combat_Menu", Animation = "GUI\\SideBars_01", Alpha = 0.0 })
		table.insert( letterboxIds, pillarboxLeftId )
		SetAlpha({ Id = pillarboxLeftId, Fraction = 1.0, Duration = 0.2, EaseIn = 0.0, EaseOut = 1.0 })
		FlipHorizontal({ Id = pillarboxLeftId })
		local pillarboxRightId = CreateScreenObstacle({ Name = "BlankObstacle", X = ScreenState.PillarboxRightX, Y = ScreenCenterY, ScaleX = ScreenState.PillarboxScaleX, Group = "Combat_Menu", Animation = "GUI\\SideBars_01", Alpha = 0.0 })
		table.insert( letterboxIds, pillarboxRightId )
		SetAlpha({ Id = pillarboxRightId, Fraction = 1.0, Duration = 0.2, EaseIn = 0.0, EaseOut = 1.0 })
	end

	wait( 0.21 )

	ScreenAnchors.EphyraMapId = CreateScreenObstacle({ Name = "rectangle01", Group = groupName, X = ScreenCenterX, Y = ScreenCenterY })
	table.insert( idsCreated, ScreenAnchors.EphyraMapId )
	SetAnimation({ Name = usee.MapAnimation, DestinationId = ScreenAnchors.EphyraMapId })
	SetHSV({ Id = ScreenAnchors.EphyraMapId, HSV = { 0, -0.15, 0 }, ValueChangeType = "Add" })

	local exitDoorsIPairs = CollapseTableOrdered( MapState.OfferedExitDoors )
	local sortedDoors = {}
	for index, door in ipairs( exitDoorsIPairs ) do
		if not door.SkipUnlock then
			local room = door.Room
			local rawScreenLocation = ObstacleData[usee.Name].ScreenLocations[door.ObjectId]
			if rawScreenLocation ~= nil then
				door.ScreenLocationX = rawScreenLocation.X
				door.ScreenLocationY = rawScreenLocation.Y
				table.insert( sortedDoors, door )
			end
		end
	end
	table.sort( sortedDoors, EphyraZoomOutDoorSort )

	local attachedCircles = {}
	for index, door in ipairs( sortedDoors ) do
		local room = door.Room
		local screenLocation = { X = door.ScreenLocationX + ScreenCenterNativeOffsetX, Y = door.ScreenLocationY + ScreenCenterNativeOffsetY }
		local rewardBackingId = CreateScreenObstacle({ Name = "BlankGeoObstacle", Group = groupName, X = screenLocation.X, Y = screenLocation.Y, Scale = 0.6 })
		if room.RewardStoreName == "MetaProgress" then
			SetAnimation({ Name = "RoomRewardAvailable_Back_Meta", DestinationId = rewardBackingId })
		else
			SetAnimation({ Name = "RoomRewardAvailable_Back_Run", DestinationId = rewardBackingId })
		end
		table.insert( attachedCircles, rewardBackingId )

		local rewardIconId = CreateScreenObstacle({ Name = "RoomRewardPreview", Group = groupName, X = screenLocation.X, Y = screenLocation.Y, Scale = 0.6 })
		SetColor({ Id = rewardIconId, Color = { 0,0,0,1} })
		table.insert( attachedCircles, rewardIconId )
		local rewardHidden = false
		if HasHeroTraitValue( "HiddenRoomReward" ) then
			SetAnimation({ DestinationId = rewardIconId, Name = "ChaosPreview" })
			rewardHidden = true
		elseif room.RewardPreviewOverride and room.RewardPreviewOverride == "ChaosPreview" then
			SetAnimation({ DestinationId = rewardIconId, Name = "ChaosPreview"})
		elseif room.ChosenRewardType == nil or room.ChosenRewardType == "Story" then
			SetAnimation({ DestinationId = rewardIconId, Name = "StoryPreview", SuppressSounds = true })
		elseif room.ChosenRewardType == "Shop" then
			SetAnimation({ DestinationId = rewardIconId, Name = "ShopPreview", SuppressSounds = true })
		elseif room.ChosenRewardType == "Boon" and room.ForceLootName then
			local previewIcon = LootData[room.ForceLootName].DoorIcon or LootData[room.ForceLootName].Icon
			if room.BoonRaritiesOverride ~= nil and LootData[room.ForceLootName].DoorUpgradedIcon ~= nil then
				previewIcon = LootData[room.ForceLootName].DoorUpgradedIcon
			end
			SetAnimation({ DestinationId = rewardIconId, Name = previewIcon, SuppressSounds = true })
		elseif room.ChosenRewardType == "Devotion" then

			local rewardIconAId = CreateScreenObstacle({ Name = "RoomRewardPreview", Group = groupName, X = screenLocation.X + 12, Y = screenLocation.Y - 11, Scale = 0.6 })
			SetColor({ Id = rewardIconAId, Color = { 0,0,0,1} })
			SetAnimation({ DestinationId = rewardIconAId, Name = LootData[room.Encounter.LootAName].DoorIcon, SuppressSounds = true })
			table.insert( attachedCircles, rewardIconAId )
					
			local rewardIconBId = CreateScreenObstacle({ Name = "RoomRewardPreview", Group = groupName, X = screenLocation.X - 12, Y = screenLocation.Y + 11, Scale = 0.6 })
			SetColor({ Id = rewardIconBId, Color = { 0,0,0,1} })
			SetAnimation({ DestinationId = rewardIconBId, Name = LootData[room.Encounter.LootBName].DoorIcon, SuppressSounds = true })
			table.insert( attachedCircles, rewardIconBId )
		else
			local animName = room.ChosenRewardType
			local lootData = LootData[room.ChosenRewardType]
			if lootData ~= nil then
				animName = lootData.DoorIcon or lootData.Icon or animName
			end
			local consumableData = ConsumableData[room.ChosenRewardType]
			if consumableData ~= nil then
				animName = consumableData.DoorIcon or consumableData.Icon or animName
			end
			SetAnimation({ DestinationId = rewardIconId, Name = animName, SuppressSounds = true })
		end

		local subIcons = PopulateDoorRewardPreviewSubIcons( door, { ChosenRewardType = room.ChosenRewardType, RewardHidden = rewardHidden } )

		local iconSpacing = 30
		local numSubIcons = #subIcons
		local isoOffset = iconSpacing * -0.5 * (numSubIcons - 1)
		for i, iconData in ipairs( subIcons ) do
			local iconId = CreateScreenObstacle({ Name = "BlankGeoObstacle", Group = groupName, Scale = 0.6 })
			local offsetAngle = 330
			if IsHorizontallyFlipped({ Id = door.ObjectId }) then
				offsetAngle = 30
				FlipHorizontal({ Id = iconId })
			end
			local offset = CalcOffset( math.rad( offsetAngle ), isoOffset )
			Attach({ Id = iconId, DestinationId = rewardBackingId, OffsetX = offset.X, OffsetY = offset.Y, OffsetZ = 60, })
			SetAnimation({ DestinationId = iconId, Name = iconData.Animation or iconData.Name })
			table.insert( attachedCircles, iconId )
			isoOffset = isoOffset + iconSpacing
		end

		if IsHorizontallyFlipped({ Id = door.ObjectId }) then
			local ids = ( { rewardBackingId, rewardIconId } )
			if not IsEmpty( ids ) then
				FlipHorizontal({ Ids = ids })
			end
		end

	end

	local melScreenLocation = ObstacleData[usee.Name].ScreenLocations[usee.ObjectId]
	ScreenAnchors.MelIconId = nil
	if melScreenLocation ~= nil then
		ScreenAnchors.MelIconId = CreateScreenObstacle({ Name = "rectangle01", Group = groupName, Animation = "Mel_Icon", X = melScreenLocation.X + ScreenCenterNativeOffsetX, Y = melScreenLocation.Y + ScreenCenterNativeOffsetY })
		table.insert( idsCreated, ScreenAnchors.MelIconId )
	end

	SetAlpha({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 0.0, Duration = 0.35 })
	PlaySound({ Name = "/Leftovers/World Sounds/MapZoomInShort" })
	wait( 0.5 )

	local zoomOutTime = 0.5

	ScreenAnchors.EphyraZoomBackground = CreateScreenObstacle({ Name = "rectangle01", Group = groupName, X = ScreenCenterX, Y = ScreenCenterY })
	table.insert( idsCreated, ScreenAnchors.EphyraZoomBackground )
	SetScale({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 5 })
	SetColor({ Ids = { ScreenAnchors.EphyraZoomBackground }, Color = Color.Black })
	SetAlpha({ Ids = { ScreenAnchors.EphyraZoomBackground }, Fraction = 0, Duration = 0 })

	PlayInteractAnimation( usee.ObjectId )

	--FocusCamera({ Fraction = 0.195, Duration = 1, ZoomType = "Ease" })
	--PanCamera({ Id = 664260, Duration = 1.0, EaseIn = 0.3, EaseOut = 0.3 })

	wait(0.3)
	local notifyName = "ephyraZoomBackIn"
	NotifyOnControlPressed({ Names = { "Use", "Rush", "Shout", "Attack2", "Attack1", "Attack3", "AutoLock", "Cancel", }, Notify = notifyName })
	waitUntil( notifyName )
	PlaySound({ Name = "/Leftovers/World Sounds/MapZoomInShort" })

	--FocusCamera({ Fraction = CurrentRun.CurrentRoom.ZoomFraction * 1.0, Duration = 0.5, ZoomType = "Ease" })
	--PanCamera({ Id = CurrentRun.Hero.ObjectId, Duration = 0.5 })

	Move({ Id = ScreenAnchors.LetterBoxTop, Angle = 90, Distance = 150, EaseIn = 0.99, EaseOut = 1.0, Duration = 0.5 })
	Move({ Id = ScreenAnchors.LetterBoxBottom, Angle = 270, Distance = 150, EaseIn = 0.99, EaseOut = 1.0, Duration = 0.5 })
	SetAlpha({ Ids = { ScreenAnchors.EphyraZoomBackground, ScreenAnchors.MelIconId, ScreenAnchors.EphyraMapId, }, Fraction = 0, Duration = 0.25 })
	SetAlpha({ Ids = attachedCircles, Fraction = 0, Duration = 0.15 })
	SetAlpha({ Ids = letterboxIds, Fraction = 0, Duration = 0.15 })
	Destroy({ Ids = attachedCircles })
	
	local exitDoorsIPairs = CollapseTableOrdered( MapState.OfferedExitDoors )
	for index, door in ipairs( exitDoorsIPairs ) do
		if not door.SkipUnlock then
			SetScale({ Id = door.DoorIconId, Fraction = 1, Duration = 0.15 })
			AddToGroup({ Id = door.DoorIconId, Name = "FX_Standing_Top", DrawGroup = true })
		end
	end

	Destroy({ Id = cameraTargetId })
	PanCamera({ Id = CurrentRun.Hero.ObjectId, OffsetY = 0, Duration = 0.65, EaseIn = 0, EaseOut = 0, Retarget = true })
	FocusCamera({ Fraction = CurrentRun.CurrentRoom.ZoomFraction, Duration = 0.65, ZoomType = "Ease" })
	local roomData = RoomData[CurrentRun.CurrentRoom.Name]
	if not roomData.IgnoreClamps then
		local cameraClamps = roomData.CameraClamps or GetDefaultClampIds()
		DebugAssert({ Condition = #cameraClamps ~= 1, Text = "Exactly one camera clamp on a map is nonsensical" })
		SetCameraClamp({ Ids = cameraClamps, SoftClamp = roomData.SoftClamp })
	end
	wait(0.45)

	thread( ShowCombatUI, "EphyraZoomOut" )
	--SetAlpha({ Ids = { ScreenAnchors.LetterBoxTop, ScreenAnchors.LetterBoxBottom, }, Fraction = 0, Duration = 0.25 })
	
	RemoveTimerBlock( CurrentRun, "EphyraZoomOut" )
	RemoveInputBlock({ Name = "EphyraZoomOut" })
	SessionMapState.BlockPause = false

	wait( 0.4 )
	Destroy({ Ids = { ScreenAnchors.LetterBoxTop, ScreenAnchors.LetterBoxBottom, ScreenAnchors.EphyraZoomBackground, ScreenAnchors.MelIconId, ScreenAnchors.EphyraMapId } })
	
	wait( 0.35 )
	SetPlayerVulnerable( "EphyraZoomOut" )
	UseableOn({ Id = usee.ObjectId })

	Destroy({ Ids = idsCreated })
	Destroy({ Ids = letterboxIds })
end

modutil.mod.Path.Wrap("DestroyRequiredKills", function(base,args)
	CurrentRun = CurrentRun or {}
	CurrentRun.CurrentRoom = CurrentRun.CurrentRoom or {}
	CurrentRun.CurrentRoom.Encounter = CurrentRun.CurrentRoom.Encounter or {}
	if CurrentRun.CurrentRoom.Encounter ~= nil and CurrentRun.CurrentRoom.Encounter.EncounterType ~= "Devotion" then
		if CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons then
			local ids = {}
			for k, id in pairs(CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons) do
				if ActiveEnemies[id] ~= nil then
					CancelWeaponFireRequests({ Id = id })
					CleanupEnemy(ActiveEnemies[id])
				end
				CancelWeaponFireRequests({ Id = id })
				CleanupEnemy(ActiveEnemies[id])
				table.insert(ids, id)
			end
			for k, id in ipairs(ids) do
				ActiveEnemies[id] = nil
			end
			Destroy({ Ids = ids })
			CurrentRun.CurrentRoom.Encounter.PassiveRoomWeapons = {}
		end
	end
	return base(args)
end)


modutil.mod.Path.Wrap("RunHistoryScreenShowShrineUpgrades", function(base,screen, button)
	base(screen, button)
local run = GameState.RunHistory[screen.RunIndex] or CurrentRun
	local components = screen.Components

	screen.FirstItem = nil

	if run.ShrineUpgradesCache == nil then
		return
	end

	local locationX = screen.ShrineUpgradeStartX
	local locationY = screen.TraitStartY
	
	local rowCount = 0
	local rowIndex = 0
	for i, upgradeName in ipairs( mod.CombinedShrineUpgradeOrder ) do
		local upgradeData = MetaUpgradeData[upgradeName]
		local level = run.ShrineUpgradesCache[upgradeName] or 0
		if upgradeData ~= nil and level >= 1 then

			local frameKey = "IconFrame"..upgradeData.Name
			if components[frameKey] then
				Destroy({Id = components[frameKey].Id})
			end
			local frame = CreateScreenComponent({ Name = "BlankInteractableObstacle", Group = screen.ComponentData.DefaultGroup, Scale = screen.ShrineUpgradeBackingScale, X = locationX, Y = locationY, Animation = "GUI\\Screens\\Shrine\\PactActive", Alpha = 0.0, AlphaTarget = 1.0, AlphaTargetDuration = 0.2 })
			frame.Screen = screen
			frame.OnMouseOverFunctionName = "MouseOverRunHistoryItem"
			frame.OnMouseOffFunctionName = "MouseOffRunHistoryItem"
			frame.Data = upgradeData
			frame.HighlightAnim = "GUI\\Screens\\Shrine\\PactHover"
			frame.HighlightScale = screen.ShrineUpgradeBackingScale
			if screen.FirstItem == nil then
				screen.FirstItem = frame
			end
			components[frameKey] = frame
			table.insert( screen.IconIds, frame.Id )
			AttachLua({ Id = frame.Id, Table = frame })

			local iconKey = "Icon"..upgradeData.Name
			if components[iconKey] then
				Destroy({Id = components[iconKey].Id})
			end
			local component = CreateScreenComponent({ Name = "BlankObstacle", Group = screen.ComponentData.DefaultGroup, Scale = screen.ShrineUpgradeIconScale, X = locationX, Y = locationY, Alpha = 0.0, AlphaTarget = 1.0, AlphaTargetDuration = 0.2 })
			components[iconKey] = component			
			SetAnimation({ DestinationId = component.Id , Name = upgradeData.Icon })
			table.insert( screen.IconIds, component.Id )

			rowCount = rowCount + 1
			if rowCount >= screen.ShrineUpgradesPerRow then
				locationY = locationY + screen.ShrineUpgradeSpacingY
				locationX = screen.ShrineUpgradeStartX
				rowCount = 0
				rowIndex = rowIndex + 1
			else
				locationX = locationX + screen.ShrineUpgradeSpacingX
			end
			if rowIndex >= screen.ShrineUpgradesMaxRows then
				break
			end
		end
	end
end)

--[[modutil.mod.Path.Wrap("IncreaseTraitLevel", function(base, traitData, stacks)
	local isExpiring = false
	local expiringRemaining = 0
	if HeroHasTrait(traitData.Name) then
	local trait1 = GetHeroTrait(traitData.Name)
	if trait1.NightmareFearExpiring then
		isExpiring = true
		expiringRemaining = traitData.NightmareFearExpiringRemaining or 2
	end
	end
	local newTrait = base(traitData, stacks)
	if isExpiring then
		if HeroHasTrait(traitData.Name) then
		local trait2 = GetHeroTrait(traitData.Name)
		trait2.NightmareFearExpiring = true
		trait2.NightmareFearExpiringRemaining = expiringRemaining
		end
	end
	return newTrait
end)]]

