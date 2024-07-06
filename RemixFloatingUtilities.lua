local addonName, addonTable = ...
local RemixUtilities = addonTable.RemixUtilities
local bagItemCounts = {
    statThreads = 0,
    expThreads = 0,
    spools = 0,
    bronzeCaches = 0,
    infiniteTreasures = 0
}

--- Generates a macro string with '/use' actions for each of the specified item ids
local function GenerateUseMacroStringWithIds(ids)
    local macroText = ""
    for itemId in pairs(ids) do
        macroText = macroText .. "/use item:" .. itemId .. "\n"
    end
    return macroText
end

--- Resets the bag item counts back to zero
local function ResetBagItemCount()
    for key in pairs(bagItemCounts) do
        bagItemCounts[key] = 0
    end
end

--- Updates the item count of the tracked items that are present in character bags
local function UpdateBagItemCount()
    ResetBagItemCount()

    for bag = 4,0,-1 do
        for slot = C_Container.GetContainerNumSlots(bag),1,-1 do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info then
                local itemId = info.itemID

                if RemixUtilities.StatThreadIds[itemId] then
                    bagItemCounts.statThreads = bagItemCounts.statThreads + 1
                end

                if RemixUtilities.ExpThreadIds[itemId] then
                    bagItemCounts.expThreads = bagItemCounts.expThreads + 1
                end

                if RemixUtilities.SpoolIds[itemId] then
                    bagItemCounts.spools = bagItemCounts.spools + 1
                end

                if RemixUtilities.BronzeCacheIds[itemId] then
                    bagItemCounts.bronzeCaches = bagItemCounts.bronzeCaches + 1
                end

                if RemixUtilities.InfiniteTreasureIds[itemId] then
                    bagItemCounts.infiniteTreasures = bagItemCounts.infiniteTreasures + 1
                end
            end
        end
    end

    UseStatThreadsButton.countText:SetText(bagItemCounts.statThreads)
    UseExpThreadsButton.countText:SetText(bagItemCounts.expThreads)
    UseSpoolsButton.countText:SetText(bagItemCounts.spools)
    OpenBronzeCachesButton.countText:SetText(bagItemCounts.bronzeCaches)
    OpenInfiniteTreasuresButton.countText:SetText(bagItemCounts.infiniteTreasures)
end

--- Creates the item count frame and attaches it to the button
local function CreateItemCountText(button, itemCount)
    button.countText = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    button.countText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    button.countText:SetText(itemCount)
end

--- Initialises the floating frame
local function InitFrames()
    -- create the top floating frame
    if not RemixFloatingFrame then
        RemixFloatingFrame = CreateFrame("Frame", "RemixFloatingFrame", UIParent, "BasicFrameTemplate")
        RemixFloatingFrame:SetPoint("CENTER")
        RemixFloatingFrame:SetSize(192, 67)
        RemixFloatingFrame:EnableMouse(true)
        RemixFloatingFrame.title = RemixFloatingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        RemixFloatingFrame.title:SetPoint("CENTER", RemixFloatingFrame.TitleBg, "CENTER", 0, 0)
        RemixFloatingFrame.title:SetText("Remix Utilities")

        -- make the frame movable
        RemixFloatingFrame:SetMovable(true)
        RemixFloatingFrame:SetScript("OnMouseDown", function(self, button)
            self:StartMoving()
        end)
        RemixFloatingFrame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()
        end)
    end

    -- create the use stat threads button
    if not UseStatThreadsButton then
        UseStatThreadsButton = CreateFrame("Button", "UseStatThreadsButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        UseStatThreadsButton:SetText("Use Stat Threads")
        UseStatThreadsButton:SetSize(32, 32)
        UseStatThreadsButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 5, -30)
        UseStatThreadsButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        UseStatThreadsButton:SetNormalTexture(GetItemIcon(219274))
        UseStatThreadsButton:SetPushedTexture(GetItemIcon(219274))
        UseStatThreadsButton:SetHighlightTexture(GetItemIcon(219274))
        UseStatThreadsButton:SetAttribute("type", "macro")
        UseStatThreadsButton:SetAttribute("macrotext", GenerateUseMacroStringWithIds(RemixUtilities.StatThreadIds))

        UseStatThreadsButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BUTTON");
            GameTooltip:ClearLines();
            GameTooltip:SetText("Use Stat Threads")
        end)
        UseStatThreadsButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        CreateItemCountText(UseStatThreadsButton, bagItemCounts.statThreads)
    end

    -- create the use exp threads button
    if not UseExpThreadsButton then
        UseExpThreadsButton = CreateFrame("Button", "UseExpThreadsButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        UseExpThreadsButton:SetText("Use Exp Threads")
        UseExpThreadsButton:SetSize(32, 32)
        UseExpThreadsButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 42, -30)
        UseExpThreadsButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        UseExpThreadsButton:SetNormalTexture(GetItemIcon(220763))
        UseExpThreadsButton:SetPushedTexture(GetItemIcon(220763))
        UseExpThreadsButton:SetHighlightTexture(GetItemIcon(220763))
        UseExpThreadsButton:SetAttribute("type", "macro")
        UseExpThreadsButton:SetAttribute("macrotext", GenerateUseMacroStringWithIds(RemixUtilities.ExpThreadIds))

        UseExpThreadsButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BUTTON");
            GameTooltip:ClearLines();
            GameTooltip:SetText("Use Exp Threads")
        end)
        UseExpThreadsButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        CreateItemCountText(UseExpThreadsButton, bagItemCounts.expThreads)
    end

    -- create the use spools button
    if not UseSpoolsButton then
        UseSpoolsButton = CreateFrame("Button", "UseSpoolsButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        UseSpoolsButton:SetSize(32, 32)
        UseSpoolsButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 79, -30)
        UseSpoolsButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        UseSpoolsButton:SetNormalTexture(GetItemIcon(226143))
        UseSpoolsButton:SetPushedTexture(GetItemIcon(226143))
        UseSpoolsButton:SetHighlightTexture(GetItemIcon(226143))
        UseSpoolsButton:SetAttribute("type", "macro")
        UseSpoolsButton:SetAttribute("macrotext", GenerateUseMacroStringWithIds(RemixUtilities.SpoolIds))

        UseSpoolsButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BUTTON");
            GameTooltip:ClearLines();
            GameTooltip:SetText("Use Spools")
        end)
        UseSpoolsButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        CreateItemCountText(UseSpoolsButton, bagItemCounts.spools)
    end

    -- create the open bronze cache button
    if not OpenBronzeCachesButton then
        OpenBronzeCachesButton = CreateFrame("Button", "OpenBronzeCachesButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        OpenBronzeCachesButton:SetSize(32, 32)
        OpenBronzeCachesButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 116, -30)
        OpenBronzeCachesButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        OpenBronzeCachesButton:SetNormalTexture(GetItemIcon(223911))
        OpenBronzeCachesButton:SetPushedTexture(GetItemIcon(223911))
        OpenBronzeCachesButton:SetHighlightTexture(GetItemIcon(223911))
        OpenBronzeCachesButton:SetAttribute("type", "macro")
        OpenBronzeCachesButton:SetAttribute("macrotext", GenerateUseMacroStringWithIds(RemixUtilities.BronzeCacheIds))

        OpenBronzeCachesButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BUTTON");
            GameTooltip:ClearLines();
            GameTooltip:SetText("Open Bronze Caches")
        end)
        OpenBronzeCachesButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        CreateItemCountText(OpenBronzeCachesButton, bagItemCounts.bronzeCaches)
    end

    -- create the open bronze cache button
    if not OpenInfiniteTreasuresButton then
        OpenInfiniteTreasuresButton = CreateFrame("Button", "OpenInfiniteTreasuresButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        OpenInfiniteTreasuresButton:SetSize(32, 32)
        OpenInfiniteTreasuresButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 153, -30)
        OpenInfiniteTreasuresButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        OpenInfiniteTreasuresButton:SetNormalTexture(GetItemIcon(211279))
        OpenInfiniteTreasuresButton:SetPushedTexture(GetItemIcon(211279))
        OpenInfiniteTreasuresButton:SetHighlightTexture(GetItemIcon(211279))
        OpenInfiniteTreasuresButton:SetAttribute("type", "macro")
        OpenInfiniteTreasuresButton:SetAttribute("macrotext", GenerateUseMacroStringWithIds(RemixUtilities.InfiniteTreasureIds))

        OpenInfiniteTreasuresButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BUTTON");
            GameTooltip:ClearLines();
            GameTooltip:SetText("Open Infinite Caches")
        end)
        OpenInfiniteTreasuresButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        CreateItemCountText(OpenInfiniteTreasuresButton, bagItemCounts.infiniteTreasures)
    end
end


-- init
InitFrames()

-- register bag events
local remixFloatingUtilities = CreateFrame("Frame")
remixFloatingUtilities:RegisterEvent("BAG_UPDATE")
remixFloatingUtilities:RegisterEvent("BAG_UPDATE_DELAYED")
remixFloatingUtilities:SetScript("OnEvent", function(self, event, ...)
    if event == "BAG_UPDATE" or event == "BAG_UPDATE_DELAYED" then
        UpdateBagItemCount()
    end
end)