local addonName, addonTable = ...
local RemixUtilities = addonTable.RemixUtilities
local lootingFrame;

--- Updates the info frame, setting the text based on item counts
local function UpdateInfoFrame()
    -- find the ids refs for each combination
    local itemIds = {}
    for _, entry in ipairs(RemixInfoFrame.textComponentData) do
        table.insert(itemIds, entry[1])
    end

    -- query the counts for the item combinations
    local mailCounts = RemixUtilities:CountMailItemsById(unpack(itemIds))

    -- update the text for each entry
    for i, count in ipairs(mailCounts) do
        local textComponent = RemixInfoFrame.textComponentData[i][2]
        textComponent:SetText(textComponent.templateText:format(count))
    end

    -- ensure the frame scales with the new data
    RemixUtilities:ResizeFrame(RemixMailFrame, RemixUtilities:ExtractIndexedValues(RemixInfoFrame.textComponentData, 2))
end

--- Stops any active looting process
local function StopLooting()
    if lootingFrame then
        lootingFrame:SetScript("OnUpdate", nil)
        lootingFrame = nil
        print("RemixUtilities - Finished looting")
    end
end

--- Loots the specified items from the mailbox
local function LootItems(itemIds)
    lootingFrame = CreateFrame("Frame")
    lootingFrame:SetScript("OnUpdate", function()
        local hasLooted = false

        for i = 1, GetInboxNumItems() do
            local itemCount = select(8, GetInboxHeaderInfo(i))
            if itemCount then
                for j = 1, ATTACHMENTS_MAX_RECEIVE do
                    local currentItemId = select(2, GetInboxItem(i, j))
                    if itemIds[currentItemId] then
                        TakeInboxItem(i, j)
                        hasLooted = true
                        -- return here to process one item per frame update
                        return
                    end
                end
            end
        end

        -- if no items were looted, stop the looting process
        if not hasLooted then
            StopLooting()
        end
    end)
end

--- Initialises the mail frames
local function InitFrames()
    -- create the mail frame
    if not RemixMailFrame then
        RemixMailFrame = CreateFrame("Frame", "RemixMailFrame", MailFrame, "BasicFrameTemplate")
        RemixMailFrame:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", 10, 0)
        RemixMailFrame:EnableMouse(true)
        RemixMailFrame.title = RemixMailFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixMailFrame.title:SetPoint("CENTER", RemixMailFrame.TitleBg, "CENTER", 0, 0)
        RemixMailFrame.title:SetText("Remix Utilities")
    end

    -- create the 'loot stat threads' button
    if not LootStatThreadsButton then
        LootStatThreadsButton = CreateFrame("Button", "LootStatThreadsButton", RemixMailFrame, "UIPanelButtonTemplate")
        LootStatThreadsButton:SetPoint("TOP", RemixMailFrame, "TOP", 0, -30)
        LootStatThreadsButton:SetText("Loot Stat Threads")
        RemixUtilities:ResizeButton(LootStatThreadsButton)
        LootStatThreadsButton:SetScript("OnClick", function() LootItems(RemixUtilities.StatThreadIds) end)
    end

    -- create the 'loot exp threads' button
    if not LootExpThreadsButton then
        LootExpThreadsButton = CreateFrame("Button", "LootExpThreadsButton", RemixMailFrame, "UIPanelButtonTemplate")
        LootExpThreadsButton:SetPoint("TOP", LootStatThreadsButton, "TOP", 0, -25   )
        LootExpThreadsButton:SetText("Loot Exp Threads")
        RemixUtilities:ResizeButton(LootExpThreadsButton)
        LootExpThreadsButton:SetScript("OnClick", function() LootItems(RemixUtilities.ExpThreadIds) end)
    end

    -- create the 'loot bonus exp tokens' button
    if not LootBonusExpTokensButton then
        LootBonusExpTokensButton = CreateFrame("Button", "LootBonusExpTokensButton", RemixMailFrame, "UIPanelButtonTemplate")
        LootBonusExpTokensButton:SetPoint("TOP", LootExpThreadsButton, "TOP", 0, -25   )
        LootBonusExpTokensButton:SetText("Loot Bonus Exp Tokens")
        RemixUtilities:ResizeButton(LootBonusExpTokensButton)
        LootBonusExpTokensButton:SetScript("OnClick", function() LootItems(RemixUtilities.BonusExpTokenIds) end)
    end

    -- create the info frame
    if not RemixInfoFrame then
        RemixInfoFrame = CreateFrame("Frame", "RemixInfoFrame", RemixMailFrame)
        RemixInfoFrame:SetPoint("TOPLEFT", LootBonusExpTokensButton, "BOTTOMLEFT", 0, -5)
        RemixInfoFrame:SetSize(160, 20)

        RemixInfoFrame.statThreadsText = RemixInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixInfoFrame.statThreadsText:SetPoint("CENTER", LootBonusExpTokensButton, "CENTER", 0, -30)
        RemixInfoFrame.statThreadsText.templateText =(([[Stat Threads: %d]]))

        RemixInfoFrame.expThreadsText = RemixInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixInfoFrame.expThreadsText:SetPoint("CENTER", RemixInfoFrame.statThreadsText, "CENTER", 0, -15)
        RemixInfoFrame.expThreadsText.templateText =(([[Exp Threads: %d]]))

        RemixInfoFrame.bonusExpTokensText = RemixInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixInfoFrame.bonusExpTokensText:SetPoint("CENTER", RemixInfoFrame.expThreadsText, "CENTER", 0, -15)
        RemixInfoFrame.bonusExpTokensText.templateText = (([[Bonus Exp Tokens: %d]]))

        RemixInfoFrame.textComponentData = {}
        table.insert(RemixInfoFrame.textComponentData,{ RemixUtilities.StatThreadIds, RemixInfoFrame.statThreadsText })
        table.insert(RemixInfoFrame.textComponentData, { RemixUtilities.ExpThreadIds, RemixInfoFrame.expThreadsText })
        table.insert(RemixInfoFrame.textComponentData,{ RemixUtilities.BonusExpTokenIds, RemixInfoFrame.bonusExpTokensText })

        UpdateInfoFrame()
    end

    -- finally resize the frame
    RemixUtilities:ResizeFrame(RemixMailFrame, RemixUtilities:ExtractIndexedValues(RemixInfoFrame.textComponentData, 2))
end

-- init
local remixMailUtilities = CreateFrame("Frame")
remixMailUtilities:RegisterEvent("MAIL_SHOW")
remixMailUtilities:RegisterEvent("MAIL_INBOX_UPDATE")
remixMailUtilities:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
remixMailUtilities:SetScript("OnEvent", function(self, event, ...)
    if event == "MAIL_SHOW" then
        InitFrames()
    elseif event == "MAIL_INBOX_UPDATE" then
        UpdateInfoFrame()
    elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
        StopLooting()
    end
end)

