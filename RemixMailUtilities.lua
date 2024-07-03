local addonName, addonTable = ...
local RemixUtilities = addonTable.RemixUtilities

--- Updates the info frame, setting the text based on item counts
local function UpdateInfoFrame()
    local mailCounts = RemixUtilities:CountMailItemsById(RemixUtilities.StatThreadIds, RemixUtilities.ExpThreadIds)
    RemixInfoFrame.statThreadsText:SetText(([[Stat Threads: %d]]):format(mailCounts[1]))
    RemixInfoFrame.expThreadsText:SetText(([[Exp Threads: %d]]):format(mailCounts[2]))
end

--- Loots stat threads from the mailbox
local function LootStatThreads()
    print("looting stat threads")
    local exit = false
    for i = 1, GetInboxNumItems() do
        local itemCount = select(8, GetInboxHeaderInfo(i))
        if itemCount then
            for j = 1, ATTACHMENTS_MAX_RECEIVE do
                local currentItemID = select(2, GetInboxItem(i, j))
                if RemixUtilities.StatThreadIds[currentItemID] then
                    -- todo: implement coroutine to continually loot
                    TakeInboxItem(i, j)
                    exit = true
                end
                if exit then
                    break;
                end
            end
        end
        if exit then
            -- todo: remove, just temp to do 1 thread
            break
        end
    end
end

--- Loots experience threads from the mailbox
local function LootExpThreads()
    -- todo: implement
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
        LootStatThreadsButton:SetScript("OnClick", function() LootStatThreads() end)
    end

    -- create the 'loot xp threads' button
    if not LootExpThreadsButton then
        LootExpThreadsButton = CreateFrame("Button", "LootExpThreadsButton", RemixMailFrame, "UIPanelButtonTemplate")
        LootExpThreadsButton:SetPoint("TOP", LootStatThreadsButton, "TOP", 0, -25   )
        LootExpThreadsButton:SetText("Loot Exp Threads")
        RemixUtilities:ResizeButton(LootExpThreadsButton)
        LootExpThreadsButton:SetScript("OnClick", function() LootExpThreads() end)
    end

    -- create the info frame
    if not RemixInfoFrame then
        RemixInfoFrame = CreateFrame("Frame", "RemixInfoFrame", RemixMailFrame)
        RemixInfoFrame:SetPoint("TOPLEFT", LootExpThreadsButton, "BOTTOMLEFT", 0, -5)
        RemixInfoFrame:SetSize(160, 20)

        RemixInfoFrame.statThreadsText = RemixInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixInfoFrame.statThreadsText:SetPoint("CENTER", LootExpThreadsButton, "CENTER", 0, -30)

        RemixInfoFrame.expThreadsText = RemixInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixInfoFrame.expThreadsText:SetPoint("CENTER", RemixInfoFrame.statThreadsText, "CENTER", 0, -15)

        UpdateInfoFrame()
    end

    -- finally resize the frame
    RemixUtilities:ResizeFrame(RemixMailFrame, { RemixInfoFrame.statThreadsText, RemixInfoFrame.expThreadsText })
end

-- init
local remixMailUtilities = CreateFrame("Frame")
remixMailUtilities:RegisterEvent("MAIL_SHOW")
remixMailUtilities:RegisterEvent("MAIL_INBOX_UPDATE")
remixMailUtilities:SetScript("OnEvent", function(self, event, ...)
    if event == "MAIL_SHOW" then
        InitFrames()
    elseif event == "MAIL_INBOX_UPDATE" then
        UpdateInfoFrame()
    end
end)

