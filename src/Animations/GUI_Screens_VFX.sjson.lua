local newAnimations = {
{
		Name = "NightmareFearStoreItemExpiry",
		FilePath = "GUI\\Icons\\LimitedBanner_Text",
		Material = "Unlit",
	},
	{
		Name = "NightmareFearShrineIcon_Arrogance",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowArrogance",
	},
	{
		Name = "NightmareFearShrineIcon_Betrayal",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowBetrayal",
	},
	{
		Name = "NightmareFearShrineIcon_Decay",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowDecay",
	},
	{
		Name = "NightmareFearShrineIcon_Eclipse",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowEclipse",
	},
	{
		Name = "NightmareFearShrineIcon_Expiry",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowExpiry",
	},
	{
		Name = "NightmareFearShrineIcon_Fealty",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowFealty",
	},
	{
		Name = "NightmareFearShrineIcon_Forsaking",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowForsaking",
	},
	{
		Name = "NightmareFearShrineIcon_Isolation",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowIsolation",
	},
	{
		Name = "NightmareFearShrineIcon_Naivety",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowNaivety",
	},
	{
		Name = "NightmareFearShrineIcon_Panic",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowPanic",
	},
	{
		Name = "NightmareFearShrineIcon_Purging",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowPurging",
	},
	{
		Name = "NightmareFearShrineIcon_Riposte",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowRiposte",
	},
	{
		Name = "NightmareFearShrineIcon_Secrets",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowSecrets",
	},
	{
		Name = "NightmareFearShrineIcon_Simplicity",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowSimplicity",
	},
	{
		Name = "NightmareFearShrineIcon_Taxation",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowTaxation",
	},
	{
		Name = "NightmareFearShrineIcon_Rudiments",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowRudiments",
	},
	{
		Name = "NightmareFearShrineIcon_Vanity",
		InheritFrom = "BaseShrineIcon",
		FilePath = "ReadEmAndWeep-Nightmare_FearNewIcons\\VowVanity",
	},
}

local AnimationFile = rom.path.combine(rom.paths.Content(), 'Game\\Animations\\GUI_Screens_VFX.sjson')


for k, newData in pairs(newAnimations) do
    sjson.hook(AnimationFile, function(data)
        table.insert(data.Animations, newData)
    end)
end