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
							FunctionName = "RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearHammerlessMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
table.insert(NamedRequirementsData.LateHammerLootRequirements, {
							FunctionName = "RequiredShrineLevel",
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
							FunctionName = "RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = "<",
								Value = 1,
							},
						})
table.insert(NamedRequirementsData.TalentLegal, {
							FunctionName = "RequiredShrineLevel",
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
							FunctionName = "RequiredShrineLevel",
							FunctionArgs =
							{
								ShrineUpgradeName = "NightmareFearEclipseMetaUpgrade",
								Comparison = ">=",
								Value = 1,
							},
						})
		elseif options.Name == "TalentDrop" then
			table.insert(options.ReplaceRequirements, {
							FunctionName = "RequiredShrineLevel",
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
	local currentRoom = CurrentRun.CurrentRoom
	CurrentRun.NightmareFearPomSkips = CurrentRun.NightmareFearPomSkips or 0
	if GetNumShrineUpgrades( "NightmareFearPomLevelsMetaUpgrade" ) > CurrentRun.NightmareFearPomSkips then
		CurrentRun.NightmareFearPomSkips = CurrentRun.NightmareFearPomSkips + 1
		local consumableId = SpawnObstacle({ Name = "RoomRewardConsolationPrize", DestinationId = args.SpawnPoint, Group = "Standing", OffsetX = args.OffsetX, OffsetY = args.OffsetY })
		local reward = CreateConsumableItem( consumableId, "RoomRewardConsolationPrize", 0, { IgnoreSounds = currentRoom.SuppressRewardSpawnSounds } )
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
		mod.EmptyMana()
	else
		return base()
	end
	end)
end)

function mod.EmptyMana()
	ManaDelta(-GetHeroMaxAvailableMana())
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
			local room = exitDoor.Room

	args = args or {}

	if exitDoor.HideRewardPreview or room.HideRewardPreview then
		return
	end

	if not args.SkipCageRewards and room.CageRewards ~= nil and chosenRewardType == nil then
		for index, cageReward in ipairs( room.CageRewards ) do
			CreateDoorRewardPreview( exitDoor, cageReward.RewardType, cageReward.ForceLootName, index, { SkipCageRewards = true, SkipRoomSubIcons = (index < #room.CageRewards) } )
		end
		return
	end

	chosenRewardType = chosenRewardType or room.ChosenRewardType
	chosenLootName = chosenLootName or room.ForceLootName

	local doorIconOffsetX = exitDoor.RewardPreviewOffsetX or 0
	local doorIconOffsetY = exitDoor.RewardPreviewOffsetY or 0
	local doorIconOffsetZ = exitDoor.RewardPreviewOffsetZ or 130

	local doorIconIsometricShiftX = -6
	local doorIconIsometricShiftZ = -3

	index = index or 1

	doorIconOffsetZ = doorIconOffsetZ + ((index - 1) * 180)
	
	if IsHorizontallyFlipped({ Id = exitDoor.ObjectId }) then
		doorIconOffsetX = doorIconOffsetX * -1
		doorIconIsometricShiftX = doorIconIsometricShiftX * -1
	end
	exitDoor.AdditionalIcons = exitDoor.AdditionalIcons or {}

	exitDoor.RewardPreviewBackingIds = exitDoor.RewardPreviewBackingIds or {}
	local backingId = nil
	if args.ReUseIds then
		backingId = exitDoor.RewardPreviewBackingIds[index]
	else
		backingId = SpawnObstacle({ Name = "BlankGeoObstacle", Group = "Combat_UI_World", SortById = true, })
		table.insert( exitDoor.RewardPreviewBackingIds, backingId )
		SetAlpha({ Id = backingId, Fraction = 0.0, Duration = 0.0 })
		SetAlpha({ Id = backingId, Fraction = 1.0, Duration = 0.1 })
		Attach({ Id = backingId, DestinationId = exitDoor.ObjectId, OffsetZ = doorIconOffsetZ, OffsetY = doorIconOffsetY, OffsetX = doorIconOffsetX })
	end
	if (exitDoor.RewardStoreName or exitDoor.Room.RewardStoreName) == "MetaProgress" then
		SetAnimation({ Name = "RoomRewardAvailable_Back_Meta", DestinationId = backingId })
	else
		SetAnimation({ Name = "RoomRewardAvailable_Back_Run", DestinationId = backingId })
	end

	exitDoor.RewardPreviewIconIds = exitDoor.RewardPreviewIconIds or {}
	local doorIconId = nil
	if args.ReUseIds then
		doorIconId = exitDoor.RewardPreviewIconIds[index]
	else
		doorIconId = SpawnObstacle({ Name = "RoomRewardPreview", Group = "Combat_UI", DestinationId = exitDoor.ObjectId, SortById = true,
			OffsetY = doorIconOffsetY, OffsetX = doorIconOffsetX + doorIconIsometricShiftX, OffsetZ = doorIconOffsetZ + doorIconIsometricShiftZ })
		SetAlpha({ Id = doorIconId, Fraction = 0.0, Duration = 0.0 })
		SetAlpha({ Id = doorIconId, Fraction = 1.0, Duration = 0.1 })
		table.insert( exitDoor.RewardPreviewIconIds, doorIconId )
	end

	local rewardHidden = false
	if room.RewardPreviewOverride ~= nil then
		exitDoor.RewardPreviewAnimName = room.RewardPreviewOverride
		SetAnimation({ DestinationId = doorIconId, Name = exitDoor.RewardPreviewAnimName })
	elseif room.NextRoomSet then
		exitDoor.RewardPreviewAnimName = room.ExitPreviewAnim or "ExitPreview"
		SetAnimation({ DestinationId = doorIconId, Name = exitDoor.RewardPreviewAnimName })
	else
		exitDoor.RewardPreviewAnimName = "ChaosPreview"
		SetAnimation({ DestinationId = doorIconId, Name = exitDoor.RewardPreviewAnimName })
		rewardHidden = true
	end
		if RoomData[CurrentRun.CurrentRoom.Name].UseDefaultRewardPreview and exitDoor.DefaultRewardPreviewOverride ~= nil then
		exitDoor.RewardPreviewAnimName = exitDoor.DefaultRewardPreviewOverride
		exitDoor.Room.RewardPreviewIcon = nil
		SetAnimation({ DestinationId = doorIconId, Name = exitDoor.RewardPreviewAnimName })
	end

	if exitDoor.RewardPreviewAnimName ~= nil then
		MapState.OfferedRewardPreviewTypes[exitDoor.RewardPreviewAnimName] = true
	end

	local subIcons = PopulateDoorRewardPreviewSubIcons( exitDoor, { ChosenRewardType = chosenRewardType, RewardHidden = rewardHidden, SkipRoomSubIcons = args.SkipRoomSubIcons, CageRewards = room.CageRewards } )
	local doorIconIndexForSubIcons = 1
	if room.CageRewards ~= nil then
		doorIconIndexForSubIcons = #room.CageRewards
	end
	local iconSpacing = 60
	local numSubIcons = #subIcons
	local isoOffset = iconSpacing * -0.5 * (numSubIcons - 1)
	for i, iconData in ipairs( subIcons ) do
		AddDoorInfoIcon({ Door = exitDoor, DoorIconId = exitDoor.RewardPreviewIconIds[doorIconIndexForSubIcons], Group = "Combat_UI_World", IsoOffset = isoOffset, Name = iconData.Name, Animation = iconData.Animation or iconData.Name, ReUseIds = args.ReUseIds })
		isoOffset = isoOffset + iconSpacing
	end

	if not args.ReUseIds and IsHorizontallyFlipped({ Id = exitDoor.ObjectId }) then
		local ids = { doorIconId, backingId }
		FlipHorizontal({ Ids = ids })
	end

	PlaySound({ Id = exitDoor.ObjectId, Name = "/Leftovers/SFX/DoorStateChangeRewardAppearance" })

		else
			return base(exitDoor, chosenRewardType, chosenLootName, index, args)
		end
	else
	return base(exitDoor, chosenRewardType, chosenLootName, index, args)
	end
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
	args = args or {}
	GenerateSellTraitShop( CurrentRun.CurrentRoom )

	AltAspectRatioFramesShow()

	local screen = DeepCopyTable( ScreenData.NightmareFearSellTraits )

	SetPlayerInvulnerable( screen.Name )
	OnScreenOpened( screen )
	HideCombatUI( screen.Name, screen.TraitTrayArgs )
	CreateScreenFromData( screen, screen.ComponentData )	

	screen.ShopItemStartX = screen.ShopItemStartX + ScreenCenterNativeOffsetX
	screen.ShopItemStartY = screen.ShopItemStartY + ScreenCenterNativeOffsetY

	local outdatedData = false
	if CurrentRun.CurrentRoom.SellOptions == nil then
		outdatedData = true
	else
		for itemIndex, sellData in pairs( CurrentRun.CurrentRoom.SellOptions ) do
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
		CurrentRun.CurrentRoom.SellOptions = nil
		GenerateSellTraitShop( CurrentRun.CurrentRoom )
	end

	if TableLength(CurrentRun.CurrentRoom.SellOptions) < 1 then
		return mod.CloseForceSellScreen(screen)
	end

	for i, data in pairs(CurrentRun.CurrentRoom.SellOptions) do
		if not data.Value then
			data.Value = GetTraitValue( GetHeroTrait( data.Name ))
		end	
	end

	wait( 0.2 )
	mod.CreateForceSellButtons( screen )

	if TableLength( CurrentRun.CurrentRoom.SellOptions ) > 0 then
		thread( PlayVoiceLines, HeroVoiceLines.SellTraitShopUsedVoiceLines, true )
	else
		thread( PlayVoiceLines, HeroVoiceLines.SellTraitShopSoldOutVoiceLines, true )
	end

	screen.KeepOpen = true
	HandleScreenInput( screen )

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
	for itemIndex, sellData in pairs( CurrentRun.CurrentRoom.SellOptions ) do
		for index, traitData in ipairs( CurrentRun.Hero.Traits ) do
			if sellData.Name == traitData.Name and traitData.Rarity and ( upgradeOptionsTable[traitData.Name] == nil or GetRarityValue( upgradeOptionsTable[traitData.Name].Rarity ) > GetRarityValue( traitData.Rarity ) ) then
				upgradeOptionsTable[traitData.Name] = { Data = traitData, Value = sellData.Value }
			end
		end
	end

	for i, value in pairs( upgradeOptionsTable ) do
		table.insert( sellList, value )
	end

	local screenData = ScreenData.UpgradeChoice

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
		end

		itemLocationX = itemLocationX + itemLocationXSpacer
		if itemLocationX >= itemLocationMaxX then
			itemLocationX = itemLocationStartX
			itemLocationY = itemLocationY + itemLocationYSpacer
		end
	end

	UpdateStoreReroll( screen, CurrentRun.CurrentRoom.SellOptions, _PLUGIN.guid .. ".ForceSellTraitScreenReroll" )

end

function mod.HandleForceSellChoiceSelection( screen, button )
	RemoveWeaponTrait( button.UpgradeName, { Silent = true } )
	AddResource( "Money", button.Value, "TraitSell" )

	for index, sellData in pairs( CurrentRun.CurrentRoom.SellOptions ) do
		if sellData.Name == button.UpgradeName then
			CurrentRun.CurrentRoom.SellOptions[index] = nil
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

function mod.ForceSellTraitScreenReroll( screen )
	SellTraitScreenDestroyButtons( screen )
	local exclusions = {}
	if not IsEmpty( CurrentRun.CurrentRoom.SellOptions ) and not IsEmpty( CurrentRun.CurrentRoom.SellValues ) then
		exclusions = { GetRandomValue( CurrentRun.CurrentRoom.SellOptions ).Name }
	end
	CurrentRun.CurrentRoom.SellOptions = nil
	GenerateSellTraitShop( CurrentRun.CurrentRoom, { ExclusionNames = exclusions } )
	mod.CreateForceSellButtons( screen )
end
modutil.mod.Path.Wrap("Kill", function(base, victim, triggerArgs)
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
			if GetNumShrineUpgrades("NightmareFearExpirationMetaUpgrade") >= 1 then
				mod.ExpireExpiryBoons()
			end
			local delay = 0
			if GetNumShrineUpgrades("NightmareFearPurgingMetaUpgrade") >= 1 then
				mod.OpenForcePurgeTraitMenu(delay, {})
			end
		end
	end
end)

-- Rudiments
table.insert(TraitRarityData.ElementalGameStateRequirements, {FunctionName = "RequiredShrineLevel",
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
	waitUnmodified( 0.5, "NightmareFearExpirationMetaUpgrade" )
	local doInCombatText = false
	local traitsToRemove = {}
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
		thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "NightmareFearExpirationMetaUpgrade_Active", Duration = 1.3, PreDelay = 0.2 } )
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
		table.insert(game.RoomData[roomName].GameStateRequirements, {FunctionName = "RequiredShrineLevel",
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
		table.insert(game.EncounterData[encounterName].GameStateRequirements,{FunctionName = "RequiredShrineLevel",
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
	if encounter.Name and encounterLookup[encounter.Name] and GetNumShrineUpgrades("NightmareFearDevotionWeaponMetaUpgrade") >= encounterLookup[encounter.Name] then
		
	else
		return
	end
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
	encounter.PassiveRoomWeapons = encounter.PassiveRoomWeapons or {}
	encounter.SpawnPassiveRoomWeapons = encounter.SpawnPassiveRoomWeapons or {}
	local newEnemy = DeepCopyTable( EnemyData[chosenWeapon] )
			newEnemy.ObjectId = SpawnUnit({ Name = chosenWeapon, Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId })	
			thread(SetupUnit, newEnemy, CurrentRun )
			newEnemy.Groups = newEnemy.Groups or {}
			table.insert( newEnemy.Groups, "RoomWeapon" )
			SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = _elapsedTimeMultiplier, DataValue = false, ValueChangeType = "Multiply", DestinationId = newEnemy.ObjectId })
			AddToGroup({ Id = newEnemy.ObjectId, Names = newEnemy.Groups })
			
			if not newEnemy.DontDieWithEncounter then
				table.insert(encounter.PassiveRoomWeapons, newEnemy.ObjectId)
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