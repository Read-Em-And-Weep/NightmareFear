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
      DisplayName = "{RR} NEXT PAGE",
    },
    {
      Id = "NightmareFearRandomTestamentIntro",
      DisplayName = "The Oath Deepens",
      Description = 
      "For fulfilling all the {#AlertHighlightFormat}{$Keywords.Bounties} of Night{#Prev}, the {#AlertHeaderFormat} Oath of the Unseen {#Prev} may now offer random {#AlertHighlightFormat}{$Keywords.Bounties}{#Prev}. If you dare, complete them in exchange for 120 {!Icons.GemPoints}{#AlertBoldFormat}Gemstones{#Prev}.\n\n· The Oath will require you to swear particular combinations of {#AlertHighlightFormat}Vows {#Prev} at specific minimum ranks.\n\n     · Then, pursue the marked {#BoldFormat}{$Keywords.Boss} {#Prev}using the specified weapon and {!Icons.ShrinePoint}{#AlertBoldFormat}Fear {#Prev} level.\n\nA unqiue combination will be offered to you each night.\n\n{!Icons.DivLong}\n\n{#AlertItalicFormat}Hint: {#Prev}Icons update depending on whether their requirement is fulfilled. If you struggle to identify what is being asked of you, attempt different combinations until something changes!",
    },
}

local screenTextFile = rom.path.combine(rom.paths.Content(), 'Game/Text/en/ScreenText.en.sjson')

sjson.hook(screenTextFile, function(data)
    for _, newScreenText in ipairs(newScreenTextData) do
        table.insert(data.Texts, sjson.to_object(newScreenText, newScreenTextOrder))
    end
end)
