local addonName, addonTable = ...
addonName = "Remix Utilities"
local RemixUtilities = {}

RemixUtilities.StatThreadIds = {
    -- versatility
    [210990] = true, [219263] = true, [219272] = true, [219281] = true,
    -- mastery
    [210989] = true, [219262] = true, [219271] = true, [219280] = true,
    -- leech
    [210987] = true, [219261] = true, [219270] = true, [219279] = true,
    -- speed
    [210986] = true, [219260] = true, [219269] = true, [219278] = true,
    -- haste
    [210985] = true, [219259] = true, [219268] = true, [219277] = true,
    -- crit
    [210984] = true, [219258] = true, [219267] = true, [219276] = true,
    -- stam
    [210983] = true, [219257] = true, [219266] = true, [219275] = true,
    -- int/str/agi
    [210982] = true, [219256] = true, [219265] = true, [219274] = true
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

--- Resizes the frame based on associated buttons, text components and adds padding
function RemixUtilities:ResizeFrame(frame, textComponents, padding)
    padding = padding or 10 -- default value

    local totalHeight = 0
    local maxWidth = 0

    -- check for children of the frame, things like buttons, but does not include text
    for _, child in ipairs({frame:GetChildren()}) do
        local childWidth = child:GetWidth()
        local childHeight = child:GetHeight()

        if childWidth > maxWidth then
            maxWidth = childWidth
        end

        totalHeight = totalHeight + childHeight
    end

    -- check for any text components specified as these arent considered children of a frame
    if textComponents then
        for _, text in ipairs(textComponents) do
            local width = text:GetStringWidth()
            local height = text:GetStringHeight()

            if width > maxWidth then
                maxWidth = width
            end

            totalHeight = totalHeight + height
        end
    end

    frame:SetSize(maxWidth + padding * 2, totalHeight + padding * 2)
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
