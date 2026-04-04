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

modutil.mod.Path.Wrap("OpenShrineScreen", function(base, args)
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
end)