ScreenData.NightmareFearSellTraits =
{
    Name = "NightmareFearSellTraits",
	Components = {},
	TraitTrayArgs =
	{
		IgnoreHideMoney = true,
	},
	FreezePlayerArgs =
	{
		DisableTray = false,
	},			
	BlockPause = true,
	AllowAdvancedTooltip = false, -- Block the normal hotkey, works through TraitTrayButton
	CloseAnimationName = "SellShopOut",

	GamepadNavigation =
	{
		FreeFormSelectWrapY = true,
		FreeFormSelecSearchFromId = 0,
		FreeFormSelectStepDistance = 10,
	},

	ShopItemStartX = ScreenCenterX,
	ShopItemSpacerX = 820,
	ShopItemStartY = 300,
	ShopItemSpacerY = 240,

	SellAmountFormat =
	{
		OffsetX = 496,
		OffsetY = 66,
		FontSize = 28,
		Font = "P22UndergroundSCMedium",
		Justification = "Right",
		Color = Color.Gold,
	},

	ComponentData =
	{
		DefaultGroup = "Combat_Menu",
		UseNativeScreenCenter = true,

		Order =
		{
			"BackgroundTint",
			"ShopBackground",
			"ActionBarBackground",
		},
		
		BackgroundTint = 
		{
			Graphic = "rectangle01",
			Scale = 4.0,
			UseScreenScaleX = true,
			UseScreenScaleY = true,
			X = ScreenCenterX,
			Y = ScreenCenterY,
			Color = {0.15, 0.15, 0.15, 0.85}
		},

		ShopBackground = 
		{
			AnimationName = "SellShopIn",
			OffsetX = 0, 
			OffsetY = 190,
			Children = 
			{
				ShopSubtitle = 
				{
					Text = "SellTrait_Hint",
					TextArgs =  
					{
						FontSize = 18, 
						OffsetX = 0, 
						OffsetY = 380, 
						Width = 840, 
						Color = Color.Gray, 
						Font = "LatoMedium", 
						ShadowBlur = 0, 
						ShadowColor = {0,0,0,1}, 
						ShadowOffset={0, 2}, 
						Justification = "Center",
					}
				},
			},
		},

		ActionBarBackground =
		{
			AnimationName = "GUI\\ActionBar",
			X = ScreenCenterX,
			Y = UIData.ActionBarY,
			UseScreenScaleX = true,
		},

		ActionBar =
		{
			X = UIData.ContextualButtonXRight,
			Y = UIData.ContextualButtonY,
			AutoAlignContextualButtons = true,
			AutoAlignJustification = "Right",

			ChildrenOrder =
			{
				"TraitTrayButton",
				"SelectButton",
				"RerollButton",
			},

			Children =
			{
				SelectButton =
				{
					Graphic = "ContextualActionButton",
					Alpha = 0.0,
					Data =
					{
						-- Dummy button
					},
					Text = "Menu_Purge",
					TextArgs = UIData.ContextualButtonFormatRight,
				},
				
				RerollButton =
				{
					Graphic = "ContextualActionButton",
					Alpha = 0.0,
					Data =
					{
						OnMouseOverFunctionName = "MouseOverContextualAction",
						OnMouseOffFunctionName = "MouseOffContextualAction",
						OnPressedFunctionName = "AttemptPanelReroll",
						ControlHotkeys = { "Reroll", },
					},
					Text = " ",
					TextArgs = UIData.ContextualButtonFormatRight,
				},

				TraitTrayButton = 
				{
					Graphic = "ContextualActionButton",
					Data =
					{
						OnMouseOverFunctionName = "MouseOverContextualAction",
						OnMouseOffFunctionName = "MouseOffContextualAction",
						OnPressedFunctionName = "UpgradeChoiceScreenOpenTraitTray",
						ControlHotkeys = { "AdvancedTooltip", },
					},
					Text = "Menu_OpenTraitTray",
					TextArgs = UIData.ContextualButtonFormatRight,
				},
			},
		},
	}
}