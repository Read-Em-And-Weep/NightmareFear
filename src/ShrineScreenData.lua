import "TraitData_Shrine.lua"
import "TraitLogic_Shrine.lua"


game.ScreenData.Shrine.ComponentData.NightmareFearArrowKey = {
			Graphic = "ContextualActionButton",
			Animation = "Arrow_Right",
			X = 1530,
			Y = 327,
			Data =
			{
				OnMouseOverFunctionName = _PLUGIN.guid..".ShrineArrowMouseOverItem",
				OnMouseOffFunctionName = _PLUGIN.guid..".ShrineArrowMouseOffItem",
				OnPressedFunctionName = _PLUGIN.guid..".FlipShrineScreen",
				Sound = "/SFX/Menu Sounds/GodBoonInteract",
				ControlHotkeys = { "Confirm", },
			},
		}
game.ScreenData.Shrine.ComponentData.ActionBarRight.Children.NightmareFearArrowKeyEnter = {
					Graphic = "ContextualActionButton",
					GroupName = "Combat_Menu_Overlay",
					--[[Requirements = 
				{
					{ PathTrue = { "GameState", "WorldUpgradesAdded", "WorldUpgradeCardUpgradeSystem" },}
				},]]
					Data =
					{
						OnMouseOverFunctionName = "MouseOverContextualAction",
						OnMouseOffFunctionName = "MouseOffContextualAction",
						OnPressedFunctionName = _PLUGIN.guid..".FlipShrineScreen",
						ControlHotkeys = { "Confirm", },
					},
					Text = "NightmareFearShrineScreen_NextPage",
					TextArgs = UIData.ContextualButtonFormatRight,
}

table.insert(game.ScreenData.Shrine.ComponentData.Order,"NightmareFearArrowKey")
mod.InsertBeforeInTable(game.ScreenData.Shrine.ComponentData.ActionBarRight.ChildrenOrder,"ResetAllButton", "NightmareFearArrowKeyEnter")

function mod.FlipShrineScreen(screen, button)
    if screen.Components["ItemButton"..1].Data.Name == "EnemyDamageShrineUpgrade" then
	mod.FlipShrineScreenToNew(screen, button)
	else
		mod.FlipShrineScreenToOld(screen,button)
	end
end

mod.OldShrineUpgradeOrder = {
	"EnemyDamageShrineUpgrade",
	"EnemyHealthShrineUpgrade",
	"EnemyShieldShrineUpgrade",
	"EnemySpeedShrineUpgrade",

	"EnemyCountShrineUpgrade",
	"NextBiomeEnemyShrineUpgrade",
	"EnemyRespawnShrineUpgrade",
	"EnemyEliteShrineUpgrade",

	"HealingReductionShrineUpgrade",
	"ShopPricesShrineUpgrade",
	"MinibossCountShrineUpgrade",
	"BoonSkipShrineUpgrade",

	"BiomeSpeedShrineUpgrade",
	"LimitGraspShrineUpgrade",
	"BoonManaReserveShrineUpgrade",
	"BanUnpickedBoonsShrineUpgrade",

	"BossDifficultyShrineUpgrade",
}

mod.NewShrineUpgradeOrder = {
	"NightmareFearNoManaMetaUpgrade",
	"NightmareFearHammerlessMetaUpgrade",
	"NightmareFearLowManaStartMetaUpgrade",
	"NightmareFearEnemyDodgeMetaUpgrade",

	"NightmareFearEclipseMetaUpgrade",
	"NightmareFearFirstHitMetaUpgrade",
	"NightmareFearBlindRewardMetaUpgrade",
	"NightmareFearPurgingMetaUpgrade",

	"NightmareFearNoElementsMetaUpgrade",
	"NightmareFearTaxMetaUpgrade",
	"NightmareFearNoHelpMetaUpgrade",
	"NightmareFearPomLevelsMetaUpgrade",
	
	"NightmareFearExpirationMetaUpgrade",
	"NightmareFearKeepsakeLevelMetaUpgrade",
	"NightmareFearLoweredRarityMetaUpgrade",
	"NightmareFearLessChoicesMetaUpgrade",

"NightmareFearDevotionWeaponMetaUpgrade",
}

mod.CombinedShrineUpgradeOrder = {
	"EnemyDamageShrineUpgrade",
	"EnemyHealthShrineUpgrade",
	"EnemyShieldShrineUpgrade",
	"EnemySpeedShrineUpgrade",

	"EnemyCountShrineUpgrade",
	"NextBiomeEnemyShrineUpgrade",
	"EnemyRespawnShrineUpgrade",
	"EnemyEliteShrineUpgrade",

	"HealingReductionShrineUpgrade",
	"ShopPricesShrineUpgrade",
	"MinibossCountShrineUpgrade",
	"BoonSkipShrineUpgrade",

	"BiomeSpeedShrineUpgrade",
	"LimitGraspShrineUpgrade",
	"BoonManaReserveShrineUpgrade",
	"BanUnpickedBoonsShrineUpgrade",

	"BossDifficultyShrineUpgrade",
	"NightmareFearNoManaMetaUpgrade",
	"NightmareFearHammerlessMetaUpgrade",
	"NightmareFearLowManaStartMetaUpgrade",
	"NightmareFearEnemyDodgeMetaUpgrade",

	"NightmareFearEclipseMetaUpgrade",
	"NightmareFearFirstHitMetaUpgrade",
	"NightmareFearBlindRewardMetaUpgrade",
	"NightmareFearPurgingMetaUpgrade",

	"NightmareFearNoElementsMetaUpgrade",
	"NightmareFearTaxMetaUpgrade",
	"NightmareFearNoHelpMetaUpgrade",
	"NightmareFearPomLevelsMetaUpgrade",
	
	"NightmareFearExpirationMetaUpgrade",
	"NightmareFearKeepsakeLevelMetaUpgrade",
	"NightmareFearLoweredRarityMetaUpgrade",
	"NightmareFearLessChoicesMetaUpgrade",

"NightmareFearDevotionWeaponMetaUpgrade",

}

modutil.mod.Path.Wrap("StartPackagedBounty", function(base,screen, button)
	game.ShrineUpgradeOrder = mod.CombinedShrineUpgradeOrder
	base(screen, button)
	game.ShrineUpgradeOrder = mod.OldShrineUpgradeOrder
end)


function mod.FlipShrineScreenToNew(screen, button)
    local idsToDestory = {}
    local components = screen.Components
    for index, upgradeName in ipairs( mod.OldShrineUpgradeOrder ) do
        local upgradeData = MetaUpgradeData[upgradeName]
		local maxRank = GetShrineUpgradeMaxRank( upgradeData )
        		if maxRank > 0 then
                    table.insert(idsToDestory, components["ItemBacking"..index].Id)
                    table.insert(idsToDestory, components["ItemHighlight"..index].Id)
                    table.insert(idsToDestory, components["ItemButton"..index].Id)
                    table.insert(idsToDestory, components["NextRankBacking"..index].Id)
                    table.insert(idsToDestory, components["ItemButton"..index].Id)
                    for rank = 1, maxRank do
                        table.insert(idsToDestory, components["RankPips"..rank..index].Id)
                    end
                end
    end
    Destroy({Ids = idsToDestory})

	local itemLocationX = screen.ItemStartX
	local itemLocationY = screen.ItemStartY
screen.NumItems = 0
    for index, upgradeName in ipairs( mod.NewShrineUpgradeOrder ) do
		local upgradeData = MetaUpgradeData[upgradeName]
		local maxRank = GetShrineUpgradeMaxRank( upgradeData )
		if maxRank > 0 then
			if upgradeData.UseWideAnimations then
				itemLocationX = screen.ItemStartX + screen.WideItemOffsetX
			end

			local startOffsetY = 10

			local backing = CreateScreenComponent({
				Name = "BlankObstacle", 
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX,
				Y = itemLocationY + startOffsetY,
				Scale = screen.IconBackingScale
			})

			local fadeDuration = index * 0.018
			Move({ Id = backing.Id, Duration = fadeDuration * 1.2 + 0.24, OffsetX = itemLocationX, OffsetY = itemLocationY, EaseIn = 0.9, EaseOut = 1})
			SetAlpha({ Id = backing.Id, Fraction = 0 })
			SetAlpha({ Id = backing.Id, Fraction = 1, Duration = fadeDuration, EaseIn = 0, EaseOut = 1 })
			SetScale({ Id = backing.Id, Fraction = 0.8 })
			SetScale({ Id = backing.Id, Fraction = 1, Duration = fadeDuration, EaseIn = 0, EaseOut = 1 })
			screen.Components["ItemBacking"..index] = backing
			AttachLua({ Id = backing.Id, Table = backing })
			backing.Screen = screen
			backing.Data = upgradeData

			local highlightAnimation = screen.SelectionHighlightAnimation
			if upgradeData.UseWideAnimations then
				highlightAnimation = screen.SelectionHighlightWideAnimation
			end
			local highlight = CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX,
				Y = itemLocationY,
				Animation = highlightAnimation,
				Alpha = 0.0
			})
			screen.Components["ItemHighlight"..index] = highlight
			AttachLua({ Id = highlight.Id, Table = highlight })
			highlight.Screen = screen

			local buttonName = "ButtonShrineItem"
			local iconOffsetX = screen.IconOffsetX
			local iconOffsetY = screen.IconOffsetY
			if upgradeData.UseWideAnimations then
				buttonName = "ButtonShrineItemWide"
				iconOffsetX = iconOffsetX + screen.WideIconGroupShiftX
			end
			local button = CreateScreenComponent({
				Name = buttonName,
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX + iconOffsetX,
				Y = itemLocationY + iconOffsetY,
				Animation = upgradeData.Icon,
				Scale = screen.IconScale
			})
			screen.Components["ItemButton"..index] = button
			AttachLua({ Id = button.Id, Table = button })
			button.Screen = screen
			button.Data = upgradeData
			button.Backing = backing
			button.Highlight = highlight
			if upgradeData.UseWideAnimations then
				button.GlintAnimationName = screen.SelectionHighlightWideGlintAnimation
			else
				button.GlintAnimationName = screen.SelectionHighlightGlintAnimation
			end
			button.OnMouseOverFunctionName = "ShrineScreenMouseOverItem"
			button.OnMouseOffFunctionName = "ShrineScreenMouseOffItem"
			button.OnPressedFunctionName = "ShrineScreenRankUp"

			local nextRankBackingOffsetX = screen.NextRankBackingOffsetX
			local nextRankBackingOffsetY = screen.NextRankBackingOffsetY
			if upgradeData.UseWideAnimations then
				nextRankBackingOffsetX = screen.NextRankBackingWideOffsetX
				nextRankBackingOffsetY = screen.NextRankBackingWideOffsetY
			end
			local nextRankBacking = CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX + nextRankBackingOffsetX,
				Y = itemLocationY + nextRankBackingOffsetY,
				Alpha = 0.0
			})
			screen.Components["NextRankBacking"..index] = nextRankBacking
			AttachLua({ Id = nextRankBacking.Id, Table = nextRankBacking })
			nextRankBacking.Screen = screen
			nextRankBacking.Button = button
			button.NextRankBacking = nextRankBacking

			local nextRankFormat = ShallowCopyTable( screen.NextRankFormat )
			nextRankFormat.Id = nextRankBacking.Id
			CreateTextBox( nextRankFormat )

			button.RankPips = {}
			local pipOffsetX = screen.RankPipStartOffsetX
			local pipOffsetY = screen.RankPipStartOffsetY
			if upgradeData.UseWideAnimations then
				pipOffsetX = pipOffsetX + screen.WideIconGroupShiftX
			end
			for rank = 1, maxRank do
				local rankPip = CreateScreenComponent({
					Name = "BlankObstacle",
					Group = screen.ComponentData.DefaultGroup,
					Scale = screen.RankPipScale,
					X = itemLocationX + pipOffsetX,
					Y = itemLocationY + pipOffsetY
				})
				components["RankPips"..rank..index] = rankPip
				AttachLua({ Id = rankPip.Id, Table = rankPip })
				rankPip.Screen = screen
				button.RankPips[rank] = rankPip

				pipOffsetX = pipOffsetX + screen.RankPipSpacingX
				pipOffsetY = pipOffsetY + screen.RankPipSpacingY
			end

			ShrineScreenUpdateNextRankText( button, true )

			ShrineUpgradeExtractValues( upgradeName )

			local shortNameFormat = ShallowCopyTable( screen.ShortNameFormat )
			local currentRank = GetNumShrineUpgrades( upgradeData.Name )
			if currentRank > 0 then
				shortNameFormat = ShallowCopyTable( screen.ShortNameActiveFormat )
			end
			local name = upgradeData.Name or "nil"
			shortNameFormat.Id = button.Id
			shortNameFormat.Text = name.."_Short"
			CreateTextBox( shortNameFormat )

			-- Hidden description for tooltips
			SetInteractProperty({ DestinationId = button.Id, Property = "TooltipX", Value = screen.TooltipX + ScreenCenterNativeOffsetX })
			SetInteractProperty({ DestinationId = button.Id, Property = "TooltipY", Value = screen.TooltipY + ScreenCenterNativeOffsetY })
			CreateTextBox({ Id = button.Id,
				Text = upgradeName,
				UseDescription = true,
				Color = Color.Transparent,
				LuaKey = "TooltipData",
				LuaValue = upgradeData,
			})

			if index == 1 then
				TeleportCursor({ DestinationId = button.Id, ForceUseCheck = true })
			end

			if upgradeData.RankRevealedFunctionName ~= nil then
				local worldUpgradeName = upgradeName.."Rank"..maxRank
				if not GameState.WorldUpgradesRevealed[worldUpgradeName] then
					thread( CallFunctionName, upgradeData.RankRevealedFunctionName, screen, button, { Rank = maxRank } )
				end
				GameState.WorldUpgradesRevealed[worldUpgradeName] = true
			end

			if index % screen.ItemsPerRow == 0 then
				itemLocationX = screen.ItemStartX
				itemLocationY = itemLocationY + screen.ItemSpacingY
			else
				itemLocationX = itemLocationX + screen.ItemSpacingX
			end		

			screen.NumItems = screen.NumItems + 1
		end
	end
	ShrineScreenUpdateItems(screen, button, false)
end

function mod.FlipShrineScreenToOld(screen, button)
    local idsToDestory = {}
    local components = screen.Components
    for index, upgradeName in ipairs( mod.NewShrineUpgradeOrder ) do
        local upgradeData = MetaUpgradeData[upgradeName]
		local maxRank = GetShrineUpgradeMaxRank( upgradeData )
        		if maxRank > 0 then
                    table.insert(idsToDestory, components["ItemBacking"..index].Id)
                    table.insert(idsToDestory, components["ItemHighlight"..index].Id)
                    table.insert(idsToDestory, components["ItemButton"..index].Id)
                    table.insert(idsToDestory, components["NextRankBacking"..index].Id)
                    table.insert(idsToDestory, components["ItemButton"..index].Id)
                    for rank = 1, maxRank do
                        table.insert(idsToDestory, components["RankPips"..rank..index].Id)
                    end
                end
    end
    Destroy({Ids = idsToDestory})

	local itemLocationX = screen.ItemStartX
	local itemLocationY = screen.ItemStartY
screen.NumItems = 0
    for index, upgradeName in ipairs( mod.OldShrineUpgradeOrder ) do
		local upgradeData = MetaUpgradeData[upgradeName]
		local maxRank = GetShrineUpgradeMaxRank( upgradeData )
		if maxRank > 0 then
			if upgradeData.UseWideAnimations then
				itemLocationX = screen.ItemStartX + screen.WideItemOffsetX
			end

			local startOffsetY = 10

			local backing = CreateScreenComponent({
				Name = "BlankObstacle", 
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX,
				Y = itemLocationY + startOffsetY,
				Scale = screen.IconBackingScale
			})

			local fadeDuration = index * 0.018
			Move({ Id = backing.Id, Duration = fadeDuration * 1.2 + 0.24, OffsetX = itemLocationX, OffsetY = itemLocationY, EaseIn = 0.9, EaseOut = 1})
			SetAlpha({ Id = backing.Id, Fraction = 0 })
			SetAlpha({ Id = backing.Id, Fraction = 1, Duration = fadeDuration, EaseIn = 0, EaseOut = 1 })
			SetScale({ Id = backing.Id, Fraction = 0.8 })
			SetScale({ Id = backing.Id, Fraction = 1, Duration = fadeDuration, EaseIn = 0, EaseOut = 1 })
			screen.Components["ItemBacking"..index] = backing
			AttachLua({ Id = backing.Id, Table = backing })
			backing.Screen = screen
			backing.Data = upgradeData

			local highlightAnimation = screen.SelectionHighlightAnimation
			if upgradeData.UseWideAnimations then
				highlightAnimation = screen.SelectionHighlightWideAnimation
			end
			local highlight = CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX,
				Y = itemLocationY,
				Animation = highlightAnimation,
				Alpha = 0.0
			})
			screen.Components["ItemHighlight"..index] = highlight
			AttachLua({ Id = highlight.Id, Table = highlight })
			highlight.Screen = screen

			local buttonName = "ButtonShrineItem"
			local iconOffsetX = screen.IconOffsetX
			local iconOffsetY = screen.IconOffsetY
			if upgradeData.UseWideAnimations then
				buttonName = "ButtonShrineItemWide"
				iconOffsetX = iconOffsetX + screen.WideIconGroupShiftX
			end
			local button = CreateScreenComponent({
				Name = buttonName,
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX + iconOffsetX,
				Y = itemLocationY + iconOffsetY,
				Animation = upgradeData.Icon,
				Scale = screen.IconScale
			})
			screen.Components["ItemButton"..index] = button
			AttachLua({ Id = button.Id, Table = button })
			button.Screen = screen
			button.Data = upgradeData
			button.Backing = backing
			button.Highlight = highlight
			if upgradeData.UseWideAnimations then
				button.GlintAnimationName = screen.SelectionHighlightWideGlintAnimation
			else
				button.GlintAnimationName = screen.SelectionHighlightGlintAnimation
			end
			button.OnMouseOverFunctionName = "ShrineScreenMouseOverItem"
			button.OnMouseOffFunctionName = "ShrineScreenMouseOffItem"
			button.OnPressedFunctionName = "ShrineScreenRankUp"

			local nextRankBackingOffsetX = screen.NextRankBackingOffsetX
			local nextRankBackingOffsetY = screen.NextRankBackingOffsetY
			if upgradeData.UseWideAnimations then
				nextRankBackingOffsetX = screen.NextRankBackingWideOffsetX
				nextRankBackingOffsetY = screen.NextRankBackingWideOffsetY
			end
			local nextRankBacking = CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				X = itemLocationX + nextRankBackingOffsetX,
				Y = itemLocationY + nextRankBackingOffsetY,
				Alpha = 0.0
			})
			screen.Components["NextRankBacking"..index] = nextRankBacking
			AttachLua({ Id = nextRankBacking.Id, Table = nextRankBacking })
			nextRankBacking.Screen = screen
			nextRankBacking.Button = button
			button.NextRankBacking = nextRankBacking

			local nextRankFormat = ShallowCopyTable( screen.NextRankFormat )
			nextRankFormat.Id = nextRankBacking.Id
			CreateTextBox( nextRankFormat )

			button.RankPips = {}
			local pipOffsetX = screen.RankPipStartOffsetX
			local pipOffsetY = screen.RankPipStartOffsetY
			if upgradeData.UseWideAnimations then
				pipOffsetX = pipOffsetX + screen.WideIconGroupShiftX
			end
			for rank = 1, maxRank do
				local rankPip = CreateScreenComponent({
					Name = "BlankObstacle",
					Group = screen.ComponentData.DefaultGroup,
					Scale = screen.RankPipScale,
					X = itemLocationX + pipOffsetX,
					Y = itemLocationY + pipOffsetY
				})
				components["RankPips"..rank..index] = rankPip
				AttachLua({ Id = rankPip.Id, Table = rankPip })
				rankPip.Screen = screen
				button.RankPips[rank] = rankPip

				pipOffsetX = pipOffsetX + screen.RankPipSpacingX
				pipOffsetY = pipOffsetY + screen.RankPipSpacingY
			end

			ShrineScreenUpdateNextRankText( button, true )

			ShrineUpgradeExtractValues( upgradeName )

			local shortNameFormat = ShallowCopyTable( screen.ShortNameFormat )
			local currentRank = GetNumShrineUpgrades( upgradeData.Name )
			if currentRank > 0 then
				shortNameFormat = ShallowCopyTable( screen.ShortNameActiveFormat )
			end
			shortNameFormat.Id = button.Id
			shortNameFormat.Text = upgradeData.Name.."_Short"
			CreateTextBox( shortNameFormat )

			-- Hidden description for tooltips
			SetInteractProperty({ DestinationId = button.Id, Property = "TooltipX", Value = screen.TooltipX + ScreenCenterNativeOffsetX })
			SetInteractProperty({ DestinationId = button.Id, Property = "TooltipY", Value = screen.TooltipY + ScreenCenterNativeOffsetY })
			CreateTextBox({ Id = button.Id,
				Text = upgradeName,
				UseDescription = true,
				Color = Color.Transparent,
				LuaKey = "TooltipData",
				LuaValue = upgradeData,
			})

			if index == 1 then
				TeleportCursor({ DestinationId = button.Id, ForceUseCheck = true })
			end

			if upgradeData.RankRevealedFunctionName ~= nil then
				local worldUpgradeName = upgradeName.."Rank"..maxRank
				if not GameState.WorldUpgradesRevealed[worldUpgradeName] then
					thread( CallFunctionName, upgradeData.RankRevealedFunctionName, screen, button, { Rank = maxRank } )
				end
				GameState.WorldUpgradesRevealed[worldUpgradeName] = true
			end

			if index % screen.ItemsPerRow == 0 then
				itemLocationX = screen.ItemStartX
				itemLocationY = itemLocationY + screen.ItemSpacingY
			else
				itemLocationX = itemLocationX + screen.ItemSpacingX
			end		

			screen.NumItems = screen.NumItems + 1
		end
	end
	ShrineScreenUpdateItems(screen, button, false)
end

function mod.ShrineArrowMouseOverItem(button)
		GenericMouseOverPresentation( button )
		local screen = button.Screen
		SetAnimation({ DestinationId = button.Id, Name = "Arrow_RightHighlight" })
		SetScale({ Id = button.Id, Fraction = 1.1, Duration = 0.1, EaseIn = 0.9, EaseOut = 1.0, SkipGeometryUpdate = true })
end

function mod.ShrineArrowMouseOffItem(button)
	SetAnimation({ DestinationId = button.Id, Name = "Arrow_Right" })
	SetScale({ Id = button.Id, Fraction = 1, Duration = 0.1, EaseIn = 0.9, EaseOut = 1.0, SkipGeometryUpdate = true })
end

modutil.mod.Path.Wrap("ShrineLogicResetAll", function(base, screen, button)
	base(screen, button)

	--[[local components = screen.Components
	for itemIndex = 1, screen.NumItems do
		local button = components["ItemButton"..itemIndex]
		if (GameState.ShrineUpgrades[button.Data.Name] or 0) >= 1 then
			GameState.ShrineUpgrades[button.Data.Name] = 0
			ShrineScreenRankDownPresentation( screen, button, { Silent = true, RemoveNameHighlight = true } )
			ShrineUpgradeExtractValues( button.Data.Name )
		end
	end]]


	for index, upgradeName in ipairs(mod.OldShrineUpgradeOrder) do
		if (GameState.ShrineUpgrades[upgradeName] or 0) >= 1 then
			GameState.ShrineUpgrades[upgradeName] = 0
			--ShrineScreenRankDownPresentation( screen, button, { Silent = true, RemoveNameHighlight = true } )
			ShrineUpgradeExtractValues( upgradeName )
		end
	end
	for index, upgradeName in ipairs(mod.NewShrineUpgradeOrder) do
		if (GameState.ShrineUpgrades[upgradeName] or 0) >= 1 then
			GameState.ShrineUpgrades[upgradeName] = 0
			--ShrineScreenRankDownPresentation( screen, button, { Silent = true, RemoveNameHighlight = true } )
			ShrineUpgradeExtractValues( upgradeName )
		end
	end
		GameState.SpentShrinePointsCache = GetTotalSpentShrinePoints()
			screen.AnyChangeMade = true
	ShrineScreenUpdateSkellyText( screen )
	ShrineScreenResetPresentation( screen )
	ShrineScreenUpdateItems(screen, {}, false)
	ShrineScreenUpdateActivePoints(screen, {}, {})
	--TO DO: The pips do not update, and the thermometer does not update for upgrades on the other screen
end)

modutil.mod.Path.Wrap("ShrineScreenUpdateItems", function(base, screen, button, shrineRankUp )
local fraction = GetTotalSpentShrinePoints() / GetMaxShrinePoints()
	if fraction <= 1 then return base(screen, button, shrineRankUp)
	else
		fraction = 1
local components = screen.Components
	for index = 1, screen.NumItems do
		local backing = components["ItemBacking"..index]
		local nextRankBacking = components["NextRankBacking"..index]
		local item = components["ItemButton"..index]
		local rank = GetNumShrineUpgrades( item.Data.Name )
		local maxRank = GetShrineUpgradeMaxRank( item.Data )
		local inactiveAnimation = screen.PactInactiveAnimation
		local activeAnimation = screen.PactActiveAnimation
		if item.Data.UseWideAnimations then
			inactiveAnimation = screen.PactInactiveWideAnimation
			activeAnimation = screen.PactActiveWideAnimation
		end

		if rank <= 0 then
			SetAnimation({ DestinationId = backing.Id, Name = inactiveAnimation })
			SetAnimation({ DestinationId = nextRankBacking.Id, Name = screen.PactInactiveBadgeAnimation })
			SetAlpha({ Id = nextRankBacking.Id, Fraction = 1.0, Duration = 0.1 })
			SetColor({ Id = item.Id, Color = screen.IconInactiveColor })
		elseif rank >= maxRank then
			SetAnimation({ DestinationId = backing.Id, Name = activeAnimation })
			SetAnimation({ DestinationId = nextRankBacking.Id, Name = screen.PactActiveBadgeAnimation })
			SetAlpha({ Id = nextRankBacking.Id, Fraction = 0.0, Duration = 0.1 })
			SetColor({ Id = item.Id, Color = screen.IconActiveColor })
		else
			SetAnimation({ DestinationId = backing.Id, Name = activeAnimation })
			SetAnimation({ DestinationId = nextRankBacking.Id, Name = screen.PactActiveBadgeAnimation })
			SetAlpha({ Id = nextRankBacking.Id, Fraction = 1.0, Duration = 0.1 })
			SetColor({ Id = item.Id, Color = screen.IconActiveColor })
		end

		if item.Hidden then
			SetAlpha({ Id = item.Id, Fraction = 0.0 })
		end
	end

	local thermometerFxAlphaMinFraction = 0.09
	local thermometerFxAlphaMaxFraction = 0.20
	local thermometerFxMinX = 225
	local thermometerFxOffsetX = thermometerFxMinX + (math.floor( fraction * 100 ) * 9.8) + ScreenCenterNativeOffsetX
	local thermometerFxAlpha = math.min( (fraction - thermometerFxAlphaMinFraction) / (thermometerFxAlphaMaxFraction - thermometerFxAlphaMinFraction), 1 )
	local thermometerFxColor = Color.Lerp( { 0, 0, 0, thermometerFxAlpha}, { 1, 0.6, 0.1, thermometerFxAlpha }, fraction )
	SetScaleY({ Id = components.ThermometerFx.Id, Fraction = thermometerFxAlpha })
	Move({ Id = components.ThermometerFx.Id, OffsetX = thermometerFxOffsetX, OffsetY = 690 + ScreenCenterNativeOffsetY, Duration = 0 })
	
	local thermometerFlameAlphaMinFraction = 0.5
	local thermometerFlameAlphaMaxFraction = 0.75
	local thermometerFlameMinX = 90
	local thermometerFlameOffsetX = thermometerFlameMinX + (math.floor( fraction * 100 ) * 9.8) + ScreenCenterNativeOffsetX
	local thermometerFlameAlpha = math.min(( (fraction - thermometerFlameAlphaMinFraction) / ( thermometerFlameAlphaMaxFraction - thermometerFlameAlphaMinFraction ) ), 1 )
	SetAlpha({ Id = components.ThermometerFlame.Id, Fraction = thermometerFlameAlpha })
	Move({ Id = components.ThermometerFlame.Id, OffsetX = thermometerFlameOffsetX, OffsetY = 677 + ScreenCenterNativeOffsetY, Duration = 0 })

	if fraction == 1 then
		SetAlpha({ Id = components.ThermometerFullFx.Id, Fraction = 1 })
	else
		SetAlpha({ Id = components.ThermometerFullFx.Id, Fraction = 0 })
	end

	local thermometerAnimationName = "ShrineMeterBarFill"
	if screen.ActiveBounty ~= nil then
		thermometerAnimationName = "ShrineMeterBarFill_ActiveBounty"
		SetColor({ Id = components.ThermometerFx.Id, Color = thermometerFxColor })
	else 
		thermometerAnimationName = "ShrineMeterBarFill"
		SetColor({ Id = components.ThermometerFx.Id, Color = {0,0,0,thermometerFxAlpha} })
	end
	SetAnimation({ Name = thermometerAnimationName, DestinationId = components.ThermometerForeground.Id })
	SetAnimationFrameTarget({ Name = thermometerAnimationName, Fraction = fraction, DestinationId = components.ThermometerForeground.Id, Instant = false }) -- nopkg
	
	ModifyTextBox({ Id = components.ActiveShrinePoints.Id, ReReadTextImmediately = true, })
	thread( PulseText, { Id = components.ActiveShrinePoints.Id, Color = {255, 255, 255, 255}, OriginalColor = {176, 136, 255, 255}, ScaleTarget = 1.2, ScaleDuration = 0.1, HoldDuration = 0.25, PulseBias = 0.1 } )

	if shrineRankUp then
		local thermometerPulseFx = CreateScreenObstacle({ Name = "BlankObstacle", X = 265 + ScreenCenterNativeOffsetX, Y = 690 + ScreenCenterNativeOffsetY, Group = "Combat_Menu_Additive", })
		local thermometerPulseFxScale = 1
		if fraction <= 1 then
			thermometerPulseFxScale = (math.floor( fraction * 100 ) ) * 0.01 * 10
		else 
			thermometerPulseFxScale = (math.floor( fraction * 100 ) ) * 0.01 * 100
		end
		-- SetAlpha({ Id = thermometerPulseFx, Fraction = fraction })
		SetScaleX({ Id = thermometerPulseFx, Fraction = thermometerPulseFxScale })
		SetAnimation({ Name = "ShrineMeterPulse", DestinationId = thermometerPulseFx })
		DestroyOnDelay({ Id = thermometerPulseFx, 0.34 })
	end

	end

end)

modutil.mod.Path.Wrap("ShrineScreenOpenFinishedPresentation", function(base, screen)
	mod.CreateRandomBountyCard(screen)
	return base(screen)
end)

modutil.mod.Path.Wrap("OpenShrineScreen", function(base, args)
	GameState.NightmareFearCreatedBountyCard = false
	ShrineUpgradeOrder = mod.OldShrineUpgradeOrder
	base(args)
	ShrineUpgradeOrder = mod.CombinedShrineUpgradeOrder
end)

ShrineUpgradeOrder = mod.CombinedShrineUpgradeOrder

modutil.mod.Path.Wrap("TraitTrayShowShrineUpgrades", function(base,screen, activeCategory, args)
	local numTraits = 0
	for i, shrineUpgradeName in ipairs( mod.OldShrineUpgradeOrder ) do
		local metaUpgradeData = MetaUpgradeData[shrineUpgradeName]
		local rank = GameState.ShrineUpgrades[shrineUpgradeName] or 0
		if rank >= 1 then
			numTraits = numTraits + 1
		end
	end
	for i, shrineUpgradeName in ipairs( mod.NewShrineUpgradeOrder ) do
		local metaUpgradeData = MetaUpgradeData[shrineUpgradeName]
		local rank = GameState.ShrineUpgrades[shrineUpgradeName] or 0
		if rank >= 1 then
			numTraits = numTraits + 1
		end
	end
	if numTraits >= 24 then
	screen.ShrineStartBottomOffset = 680
	else
		screen.ShrineStartBottomOffset = 600
	end
	base(screen, activeCategory, args)
	local components = screen.Components
	local firstTrait = nil
	local highlightedTrait = nil
	local displayedTraitNum = 0
	local xOffset = screen.ShrineStartX
	local yOffset = ScreenHeight - screen.ShrineStartBottomOffset
	for i, shrineUpgradeName in ipairs( mod.OldShrineUpgradeOrder ) do
		local metaUpgradeData = MetaUpgradeData[shrineUpgradeName]
		local rank = GameState.ShrineUpgrades[shrineUpgradeName] or 0
		if rank >= 1 then
			displayedTraitNum = displayedTraitNum + 1
			--[[
			if displayedTraitNum % screen.ShrinesPerColumn == 0 then
				xOffset = xOffset + screen.ShrineSpacingX
				yOffset = ScreenHeight - screen.ShrineStartBottomOffset
			else
				yOffset = yOffset + screen.ShrineSpacingY
			end
			]]
			if displayedTraitNum % screen.ShrinesPerRow == 0 then
				xOffset = screen.ShrineStartX
				yOffset = yOffset + screen.ShrineSpacingY
			else
				xOffset = xOffset + screen.ShrineSpacingX
			end
			if not firstTrait then
				firstTrait = true
			end
		end
	end
	for i, shrineUpgradeName in ipairs( mod.NewShrineUpgradeOrder ) do
		local metaUpgradeData = MetaUpgradeData[shrineUpgradeName]
		local rank = GameState.ShrineUpgrades[shrineUpgradeName] or 0
		if rank >= 1 then

			local traitFrameId = CreateScreenObstacle({ Name = "BlankObstacle", X = xOffset, Y = yOffset,  Group = screen.ComponentData.DefaultGroup, Scale = screen.ShrineBackingScale, Alpha = 0.0 })
			local rank = GetNumShrineUpgrades( shrineUpgradeName )
			SetAnimation({ Name = "GUI\\Screens\\Shrine\\PactActiveMax", DestinationId = traitFrameId })
			SetAlpha({ Id = traitFrameId, Fraction = 1.0, Duration = 0.1 })
			table.insert( screen.Frames, traitFrameId )

			local traitIcon = CreateScreenComponent({ Name = "TraitTrayShrineIconButton", X = xOffset, Y = yOffset, Group = screen.ComponentData.DefaultGroup, Animation = metaUpgradeData.Icon, Scale = screen.ShrineIconScale, Alpha = 0 })
			AttachLua({ Id = traitIcon.Id, Table = traitIcon })
			traitIcon.Screen = screen
			traitIcon.OnMouseOverFunctionName = "TraitTrayIconButtonMouseOver"
			traitIcon.OnMouseOffFunctionName = "TraitTrayIconButtonMouseOff"
			traitIcon.OnPressedFunctionName = "PinTraitDetails"
			traitIcon.Icon = metaUpgradeData.Icon
			traitIcon.IconScale = iconScale
			traitIcon.OffsetX = xOffset
			traitIcon.OffsetY = yOffset
			traitIcon.PinIconScale = 0.28
			traitIcon.PinIconFrameScale = 0.0
			traitIcon.HighlightAnimScale = 0.27
			traitIcon.HighlightAnim = "GUI\\Screens\\Shrine\\PactHover"
			traitIcon.TrayHighlightAnimScale = 1.4
			traitIcon.PinAnimationIn = "TraitPinIn_Vow"
			traitIcon.PinAnimationOut = "TraitPinOut_Vow"
			SetAlpha({ Id = traitIcon.Id, Fraction = 1.0, Duration = 0.1 })
			if CurrentRun.ShrineUpgradesDisabled[shrineUpgradeName] then
				SetColor({ Id = traitIcon.Id, Color = screen.DisabledShrineIconColor })
				traitIcon.ShrineDisabled = true
			end
			CreateTextBox({
				Id = traitIcon.Id,
				UseDescription = true,
				VariableAutoFormat = "BoldFormatGraft",
				Scale = 0.0,
				Hide = true,
			})

			if args.DisableTooltips then
				ModifyTextBox({ Id = traitIcon.Id, BlockTooltip = true })
			end

			table.insert( components, traitIcon )
			local componentData = ShallowCopyTable( metaUpgradeData )
			componentData.Rank = rank
			traitIcon.TraitData = componentData
			screen.Icons[traitIcon.Id] = traitIcon

			--local traitFrameId = CreateScreenObstacle({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray", Scale = 0.5 })
			--Attach({ Id = traitFrameId, DestinationId = traitIcon.Id })
			if not firstTrait then
				highlightedTrait = traitIcon
				firstTrait = true
			end

			local uniqueTraitName = TraitTrayGetUniqueName( traitIcon )
			if uniqueTraitName == args.HighlightName or uniqueTraitName == activeCategory.PrevHighlightName then
				highlightedTrait = traitIcon
			end

			screen.TraitComponentDictionary[uniqueTraitName] = traitIcon
			if screen.AutoPin and not activeCategory.OpenedOnce and IsPossibleShrineUpgradeAutoPin( metaUpgradeData ) then
				table.insert( screen.PossibleAutoPins, traitIcon )
			end
			
			displayedTraitNum = displayedTraitNum + 1
			--[[
			if displayedTraitNum % screen.ShrinesPerColumn == 0 then
				xOffset = xOffset + screen.ShrineSpacingX
				yOffset = ScreenHeight - screen.ShrineStartBottomOffset
			else
				yOffset = yOffset + screen.ShrineSpacingY
			end
			]]
			if displayedTraitNum % screen.ShrinesPerRow == 0 then
				xOffset = screen.ShrineStartX
				yOffset = yOffset + screen.ShrineSpacingY
			else
				xOffset = xOffset + screen.ShrineSpacingX
			end

		end
	end
	if highlightedTrait ~= nil then
		wait( 0.02 )
		SetHighlightedTraitFrame( screen, highlightedTrait )
	end
	if GameState.NightmareFearCurrentBounty and GetTotalSpentShrinePoints() >= GameState.NightmareFearCurrentBounty.TotalFear and CurrentRun.Hero.Weapons[GameState.NightmareFearCurrentBounty.Weapon] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= 1 and GameState.NightmareFearCurrentBounty.VowRank and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= GameState.NightmareFearCurrentBounty.VowRank and not GameState.NightmareFearCurrentBountyActive then
		GameState.NightmareFearCurrentBountyActive = true
	end
	if GameState.NightmareFearCurrentBountyActive and GameState.NightmareFearCurrentBounty and ( CurrentRun.ActiveBounty == nil or CurrentHubRoom ~= nil ) then
		if GetTotalSpentShrinePoints() >= GameState.NightmareFearCurrentBounty.TotalFear and CurrentRun.Hero.Weapons[GameState.NightmareFearCurrentBounty.Weapon] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= 1 and GameState.NightmareFearCurrentBounty.VowRank and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= GameState.NightmareFearCurrentBounty.VowRank then
	

			SetAlpha({ Id = screen.Components.ActiveShrineBountyBacking.Id, Fraction = 1.0, Duration = 0.2 })
			SetAlpha({ Id = screen.Components.ActiveShrineBountyFrame.Id, Fraction = 1.0, Duration = 0.2 })
			SetAnimation({ DestinationId = screen.Components.ActiveShrineBountyFrame.Id, Name = "GUI\\Screens\\Shrine\\TestamentActive" })
			SetAlpha({ Id = screen.Components.ActiveShrineBountyTarget.Id, Fraction = 1.0, Duration = 0.2 })
			SetAnimation({ DestinationId = screen.Components.ActiveShrineBountyTarget.Id, Name = ScreenData.Shrine.BountyTargetIcons[BountyData[GameState.NightmareFearCurrentBounty.BossEncounterChosen].Encounters[1]] })
			SetAlpha({ Id = screen.Components.ActiveShrineBountyPoints.Id, Fraction = 1.0, Duration = 0.2 })
			ModifyTextBox({ Id = screen.Components.ActiveShrineBountyPoints.Id, LuaKey = "TempTextData", LuaValue = { RequiredShrinePoints = GameState.NightmareFearCurrentBounty.TotalFear } })
			SetAlpha({ Id = screen.Components.ActiveShrineBountyWeapon.Id, Fraction = 1.0, Duration = 0.2 })
			SetAnimation({ DestinationId = screen.Components.ActiveShrineBountyWeapon.Id, Name = ScreenData.Shrine.BountyWeaponIcons[GameState.NightmareFearCurrentBounty.Weapon] })
			else
		SetAlpha({ Id = screen.Components.ActiveShrineBountyBacking.Id, Fraction = 1.0, Duration = 0.2 })
		SetAlpha({ Id = screen.Components.ActiveShrineBountyFrame.Id, Fraction = 1.0, Duration = 0.2 })
		SetAnimation({ DestinationId = screen.Components.ActiveShrineBountyFrame.Id, Name = "GUI\\Screens\\Shrine\\TestamentInactive" })
		end
	end

	if highlightedTrait ~= nil then
		wait( 0.02 )
		SetHighlightedTraitFrame( screen, highlightedTrait )
	end
end)

function mod.CreateRandomBounty()
	GameState.NightmareFearCurrentBounty = {}
	GameState.NightmareFearCurrentBountyActive = false
	if not IsGameStateEligible({Name = "Unknown"}, {NamedRequirements = { "AllShrineBountiesCompleted" }},{}) then
		return
	end
	local bossEncounters = {"HecateEncounters", "ScyllaEncounters","InfestedCerberusEncounters", "ChronosEncounters", "PolyphemusEncounters", "ErisEncounters","PrometheusEncounters", "TyphonEncounters"}
	if ZagreusJourney then
		table.insert(bossEncounters, "ModsNikkelMHadesBiomesMegaeraEncounters")
		table.insert(bossEncounters, "ModsNikkelMHadesBiomesHydraEncounters")
		table.insert(bossEncounters, "ModsNikkelMHadesBiomesTheseusAndMinotaurEncounters")
		table.insert(bossEncounters, "ModsNikkelMHadesBiomesHadesEncounters")
	end
	local encounterChosen = GetRandomValue(bossEncounters)
	local vowChosen = GetRandomValue(mod.CombinedShrineUpgradeOrder)
	local vowData = game.MetaUpgradeData[vowChosen]
	local levelChosen = RandomInt(1, #(vowData.Ranks))
	if vowChosen == "NightmareFearDevotionWeaponMetaUpgrade" or vowChosen == "BossDifficultyShrineUpgrade" then
		if Contains({"HecateEncounters","PolyphemusEncounters",  "ModsNikkelMHadesBiomesMegaeraEncounters"}, encounterChosen) then
			levelChosen = math.max(1, levelChosen)
		elseif Contains({"ScyllaEncounters","ErisEncounters",  "ModsNikkelMHadesBiomesHydraEncounters"}, encounterChosen) then
			levelChosen = math.max(2, levelChosen)
		elseif Contains({"InfestedCerberusEncounters","PrometheusEncounters",  "ModsNikkelMHadesBiomesTheseusAndMinotaurEncounters"}, encounterChosen) then
			levelChosen = math.max(3, levelChosen)
		elseif Contains({"ChronosEncounters","TyphonEncounters",  "ModsNikkelMHadesBiomesHadesEncounters"}, encounterChosen) then
			levelChosen = math.max(4, levelChosen)
		end
	end
	local totalFear = RandomInt(12, 35)
	local weaponChosen = GetRandomValue({"WeaponStaffSwing", "WeaponDagger", "WeaponAxe","WeaponTorch","WeaponLob","WeaponSuit"})
	GameState.NightmareFearCurrentBounty = {
		BossEncounterChosen = encounterChosen,
		TotalFear = totalFear,
		Vow = vowChosen,
		VowRank = levelChosen,
		Weapon = weaponChosen
	}
end

function mod.CreateRandomBountyCard(screen)
	GameState.NightmareFearCreatedBountyCard = false
	if not IsGameStateEligible({Name = "Unknown"}, {NamedRequirements = { "AllShrineBountiesCompleted" }},{}) then
		GameState.NightmareFearCurrentBounty = nil
		return
	end
	if not GameState.NightmareFearCurrentBounty then
		mod.CreateRandomBounty()
	end
	local components = screen.Components
	local itemLocationX = screen.BountyRowStartX + screen.BountyRowSpacingX
	local itemLocationY = screen.BountyRowStartY
	local availableBountyNum = 1
	local key = "NightmareFearBountyAvailable" .. availableBountyNum
	local matchedWeapon = false
	if CurrentRun.Hero.Weapons[GameState.NightmareFearCurrentBounty.Weapon] then
		matchedWeapon = true
	end
	local targetItem = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = itemLocationX + screen.BountyTargetOffsetX,
		Y = itemLocationY + screen.BountyTargetOffsetY,
		Animation = screen.BountyTargetIcons[BountyData[GameState.NightmareFearCurrentBounty.BossEncounterChosen].Encounters[1]],
		Scale = screen.BountyBossIconScale
	})
	components[key.."Target"] = targetItem

	local bountyBacking = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = itemLocationX,
		Y = itemLocationY,
		Animation = "GUI\\Screens\\Shrine\\Testament",
		Scale = 1.0
	})
	components[key .. "Backing"] = bountyBacking

	local shrinePointItem = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = itemLocationX + screen.BountyShrinePointsOffsetX,
		Y = itemLocationY + screen.BountyShrinePointsOffsetY
	})

	--shrinePointItem.BountyData = bountyData
	shrinePointItem.MatchedWeapon = matchedWeapon
	shrinePointItem.WeaponName = GameState.NightmareFearCurrentBounty.Weapon
	shrinePointItem.RequiredShrinePoints = GameState.NightmareFearCurrentBounty.TotalFear
	components[key .. "ShrinePoints"] = shrinePointItem
	local bountyShrinePointsFormat = ShallowCopyTable(screen.BountyShrinePointsFormat)
	bountyShrinePointsFormat.Id = shrinePointItem.Id
	bountyShrinePointsFormat.Text = "ShrineScreen_BountyShrinePoints"
	bountyShrinePointsFormat.LuaKey = "TempTextData"
	bountyShrinePointsFormat.LuaValue = { RequiredShrinePoints = GameState.NightmareFearCurrentBounty.TotalFear }
	CreateTextBox(bountyShrinePointsFormat)

	local weaponItem = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = itemLocationX + screen.BountyWeaponOffsetX,
		Y = itemLocationY + screen.BountyWeaponOffsetY,
		Animation = screen.BountyWeaponIcons[GameState.NightmareFearCurrentBounty.Weapon],
		Scale = screen.BountyWeaponIconScale
	})
	components[key .. "Weapon"] = weaponItem
	local vowItem = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = screen.BountyRowStartX + screen.BountyRowSpacingX/2,
		Y = screen.BountyRowStartY + screen.BountyRowSpacingY,
		Animation = MetaUpgradeData[GameState.NightmareFearCurrentBounty.Vow].Icon,
		Scale = 1,
	})
	components[key .. "Vow"] = vowItem
	local vowLevelItem = CreateScreenComponent({
		Name = "BlankObstacle",
		Group = screen.ComponentData.DefaultGroup,
		X = screen.BountyRowStartX + 3 * screen.BountyRowSpacingX/2,
		Y = screen.BountyRowStartY + screen.BountyRowSpacingY
	})
	components[key .. "VowRank"] = vowLevelItem
	local bountyVowRanksFormat = ShallowCopyTable(screen.BountyShrinePointsFormat)
	
	bountyVowRanksFormat.FontSize = 24*3.5
	bountyVowRanksFormat.Font = "NumericP22UndergroundSCHeavy"
	bountyVowRanksFormat.Id = vowLevelItem.Id
	bountyVowRanksFormat.Text = "NewTraitUnlocked_Subtitle"
	local requiredRank = GameState.NightmareFearCurrentBounty.VowRank
	local romanNumerals = {"I", "II", "III", "IV"}
	if requiredRank == 1 then
		bountyVowRanksFormat.Color = Color.BoonPatchCommon
	elseif requiredRank == 2 then
		bountyVowRanksFormat.Color = Color.BoonPatchRare
	elseif requiredRank == 3 then
		bountyVowRanksFormat.Color = Color.BoonPatchEpic
	elseif requiredRank == 4 then
		bountyVowRanksFormat.Color = Color.BoonPatchHeroic
	end
	bountyVowRanksFormat.DataProperties =
		{
			ShadowBlur = 0,
			ShadowRed = 0,
			ShadowGreen = 0,
			ShadowBlue = 0,
			ShadowAlpha = 1,
			ShadowOffsetX = 2,
			ShadowOffsetY = 2,
		}
	local text = romanNumerals[requiredRank]
	bountyVowRanksFormat.LuaKey = "TempTextData"
	bountyVowRanksFormat.LuaValue = { Gift = text }
	CreateTextBox(bountyVowRanksFormat)
	GameState.NightmareFearCreatedBountyCard = true
	ShrineScreenUpdateItems( screen )
	ShrineScreenUpdateActivePoints( screen, nil, { Duration = 0.0 } )
end

modutil.mod.Path.Wrap("ShrineScreenUpdateActivePoints", function(base,screen, button, args)
args = args or {}
	local activeShrinePoints = GetTotalSpentShrinePoints()
	if GameState.NightmareFearCurrentBounty and GameState.NightmareFearCreatedBountyCard then
		local availableBountyNum = 1
		local key = "NightmareFearBountyAvailable" .. availableBountyNum
		local vowActive = false
		local weaponItem = screen.Components[key.."Weapon"]
		local backing = screen.Components[key.."Backing"]
		local vowItem = screen.Components[key .. "Vow"]
		local vowLevelItem = screen.Components[key .. "VowRank"]
		local targetItem = screen.Components[key.."Target"]
		local matchedWeapon = false
		local matchedVow = false
		local matchedRank = false
		if CurrentRun.Hero.Weapons[GameState.NightmareFearCurrentBounty.Weapon] then
			matchedWeapon = true
		end
		if GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= 1 then
			matchedVow = true
			SetColor({ Id = vowItem.Id, Color = screen.BountyActiveColor, Duration = args.Duration or 0.3 })
			if GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= GameState.NightmareFearCurrentBounty.VowRank then
				matchedRank = true
				ModifyTextBox({ Id = vowLevelItem.Id, ColorTarget = screen.BountyActiveColor })
			else
				ModifyTextBox({ Id = vowLevelItem.Id, ColorTarget = screen.BountyInactiveColor })
			end
		else
			SetColor({ Id = vowItem.Id, Color = screen.BountyInactiveColor, Duration = args.Duration or 0.3 })
			ModifyTextBox({ Id = vowLevelItem.Id, ColorTarget = screen.BountyInactiveColor })
		end	
		if matchedWeapon then
			SetColor({ Id = weaponItem.Id, Color = screen.BountyActiveColor, Duration = args.Duration or 0.3 })
		else
			SetColor({ Id = weaponItem.Id, Color = screen.BountyInactiveColor, Duration = args.Duration or 0.3 })
		end
		if activeShrinePoints >= GameState.NightmareFearCurrentBounty.TotalFear and matchedWeapon and matchedVow and matchedRank then
			SetColor({ Id = targetItem.Id, Color = screen.BountyActiveColor, Duration = args.Duration or 0.3 })
			SetAnimation({ DestinationId = backing.Id, Name = "ShrineTestamentActiveTarget" })
			if not GameState.NightmareFearCurrentBountyActive then
				PlaySound({ Name = "/SFX/Menu Sounds/MirrorFlash2", Id = backing })
				GameState.NightmareFearCurrentBountyActive = true
			end
		else
			SetColor({ Id = targetItem.Id, Color = screen.BountyInactiveColor, Duration = args.Duration or 0.3 })
			SetAnimation({ DestinationId = backing.Id, Name = "GUI\\Screens\\Shrine\\Testament" })
			GameState.NightmareFearCurrentBountyActive = false
		end
	end
	return base(screen, button,args)
end)

modutil.mod.Path.Wrap("UpdateShrineAnimation", function(base,activeBounty)
	local shrineId = 589694
	if GameState.NightmareFearCurrentBountyActive then
		return SetAnimation({ DestinationId = shrineId, Name = "Crossroads_Shrine_On01_Active" }) -- nopkg
	else
	return base(activeBounty)
	end
end)

modutil.mod.Path.Wrap("CloseShrineUpgradeScreen", function(base,screen,button)
	base(screen,button)
	if GameState.NightmareFearCurrentBountyActive then
		thread( BountyReadyConfirmPresentation, screen, button )
	end
end)

modutil.mod.Path.Wrap("CheckShrineBounties", function(base)
	if GameState.NightmareFearCurrentBountyActive and GameState.NightmareFearCurrentBounty then
		if Contains(BountyData[GameState.NightmareFearCurrentBounty.BossEncounterChosen].Encounters, CurrentRun.CurrentRoom.Encounter.Name) and GetTotalSpentShrinePoints() >= GameState.NightmareFearCurrentBounty.TotalFear and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= GameState.NightmareFearCurrentBounty.VowRank then
			wait(0.5, RoomThreadName)
			thread(ShrineBountyEarnedPresentation,
				{ TitleText = "ShrineBountyCompleteMessage", SubtitleText = "ShrineBountyCompleteSubtitle" })
			GiveRandomConsumables(
				{
					LootOptions = {
						{Name = "GemPointsBigDrop",
						Overrides =
						{
							CanDuplicate = false,
							AddResources =
							{
								GemPoints = 50,
							},
						},}
					},
					ForceToValidLocation = true,
					KeepCollision = true,
				})
			thread(CheckQuestStatus)
			wait(0.5, RoomThreadName)
			GameState.NightmareFearCurrentBountyActive = false
			GameState.NightmareFearCurrentBounty = {}
		end
	else
		return base()
	end
end)

modutil.mod.Path.Wrap("EquipPlayerWeapon", function(base,weaponData, args)
	base(weaponData, args)
	if GameState.NightmareFearCurrentBounty and GetTotalSpentShrinePoints() >= GameState.NightmareFearCurrentBounty.TotalFear and CurrentRun.Hero.Weapons[GameState.NightmareFearCurrentBounty.Weapon] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= 1 and GameState.NightmareFearCurrentBounty.VowRank and GameState.ShrineUpgrades[GameState.NightmareFearCurrentBounty.Vow] >= GameState.NightmareFearCurrentBounty.VowRank then
		GameState.NightmareFearCurrentBountyActive = true
	else
		GameState.NightmareFearCurrentBountyActive = false
	end
end)

modutil.mod.Path.Wrap("KillHero", function(base, victim, triggerArgs)
	GameState.NightmareFearCurrentBounty = nil
	GameState.NightmareFearCurrentBountyActive = false
	mod.CreateRandomBounty()
	return base(victim, triggerArgs)
end)