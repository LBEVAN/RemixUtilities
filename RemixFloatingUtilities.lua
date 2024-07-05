local addonName, addonTable = ...
local RemixUtilities = addonTable.RemixUtilities

--- Generates a macro string with '/use' actions for each of the specified item ids
local function GenerateUseMacroStringWithIds(ids)
    local macroText = ""
    for itemId in pairs(ids) do
        macroText = macroText .. "/use item:" .. itemId .. "\n"
    end
    return macroText
end

--- Initialises the floating frame
local function InitFrames()
    -- create the top floating frame
    if not RemixFloatingFrame then
        RemixFloatingFrame = CreateFrame("Frame", "RemixFloatingFrame", UIParent, "BasicFrameTemplate")
        RemixFloatingFrame:SetPoint("CENTER")
        RemixFloatingFrame:SetSize(120, 70)
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
    end

    -- create the use exp threads button
    if not UseExpThreadsButton then
        UseExpThreadsButton = CreateFrame("Button", "UseExpThreadsButton", RemixFloatingFrame, "SecureActionButtonTemplate")
        UseExpThreadsButton:SetText("Use Exp Threads")
        UseExpThreadsButton:SetSize(32, 32)
        UseExpThreadsButton:SetPoint("TOPLEFT", RemixFloatingFrame, "TOPLEFT", 42, -30)
        UseExpThreadsButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        UseExpThreadsButton:SetNormalTexture(GetItemIcon(217722))
        UseExpThreadsButton:SetPushedTexture(GetItemIcon(217722))
        UseExpThreadsButton:SetHighlightTexture(GetItemIcon(217722))
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
    end
end


InitFrames()