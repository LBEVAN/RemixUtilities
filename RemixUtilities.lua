local addonName, addonTable = ...
addonName = "Remix Utilities"
local RemixUtilities = {}

RemixUtilities.StatThreadIds = {
    -- versatility
    [210990] = true, [219263] = true, [219272] = true, [219281] = true,
    -- mastery
    [210989] = true, [219262] = true, [219271] = true, [219280] = true,
    -- leech
    [210987] = true, [219261] = true, [219270]= true, [219279] = true
    -- todo: get other ids (https://www.wowhead.com/guide/wow-remix-mists-of-pandaria-overview)
    -- speed
    -- haste
    -- crit
    -- stam
    -- int/str/agi
}

RemixUtilities.ExpThreadIds = {
    [217722] = true, [219264] = true, [219273] = true, [219282] = true,
}

--- Updates the button text and dynamically resizes the button with padding
function RemixUtilities:UpdateButtonText(button, text, padding)
    padding = padding or 20 -- default value

    button:SetText(text)
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
end

--- Resizes the button based on the text present
function RemixUtilities:ResizeButton(button, padding)
    padding = padding or 20 -- default value
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
end

--- Resizes the frame based on associated buttons and adds padding
function RemixUtilities:ResizeFrame(frame, padding)
    padding = padding or 10 -- default value

    local totalHeight = 0
    local maxWidth = 0

    -- todo: add checks for additional frames/text
    for _, child in ipairs({frame:GetChildren()}) do
        if child:IsObjectType("Button") then
            local buttonWidth = child:GetWidth()
            if buttonWidth > maxWidth then
                maxWidth = buttonWidth
            end
            totalHeight = totalHeight + child:GetHeight() + padding
        end
    end

    frame:SetSize(maxWidth + padding * 2, totalHeight + padding)
end

--- Counts the number of items in the mail that match the ids for each set, e.g. [1]=25,[2]=12
function RemixUtilities:CountMailItemsById(...)
    local sets = {...}
    local results = {}

    for i = 1, GetInboxNumItems() do
        local itemCount = select(8, GetInboxHeaderInfo(i))
        if itemCount then
            for j = 1, ATTACHMENTS_MAX_RECEIVE do
                local itemId = select(2, GetInboxItem(i, j))

                -- check each set to see if itemId exists
                for k, set in ipairs(sets) do
                    results[k] = (results[k] or 0)  -- initialise results[k] if it doesn't exist
                    if set[itemId] then
                        results[k] = results[k] + 1  -- increment count for items found in set
                    end
                end
            end
        end
    end

    return results
end

-- add this sub-addon to the table
addonTable.RemixUtilities = RemixUtilities
