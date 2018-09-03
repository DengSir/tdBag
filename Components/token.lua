--[[
token.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]
local ADDON, Addon = ...
local Token = Addon:NewClass('Token', 'Button')

local ICON_SIZE = 14

function Token:New(parent)
    local token = self:Bind(CreateFrame('Button', nil, parent))

    local icon = token:CreateTexture(nil, 'OVERLAY')
    icon:SetSize(ICON_SIZE, ICON_SIZE)
    icon:SetPoint('RIGHT')

    local text = token:CreateFontString(nil, 'OVERLAY', 'NumberFontNormalRight')
    text:SetPoint('RIGHT', icon, 'LEFT', 0, 0)

    token.icon = icon
    token.text = text

    token:SetHeight(ICON_SIZE)

    token:SetScript('OnClick', self.OnClick)
    token:SetScript('OnEnter', self.OnEnter)
    token:SetScript('OnLeave', GameTooltip_Hide)

    return token
end

function Token:OnEnter()
    GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_TOP')
    GameTooltip:SetBackpackToken(self.index)
    -- GameTooltip:SetText(CURRENCY)
    -- for i = 1, GetNumWatchedTokens() do
    --     local name, count, icon, id = GetBackpackCurrencyInfo(i)
    --     local rarity = select(8, GetCurrencyInfo(id))
    --     local l = ITEM_QUALITY_COLORS[rarity] or HIGHLIGHT_FONT_COLOR
    --     local r = IsCurrencyFull and IsCurrencyFull(id) and RED_FONT_COLOR or HIGHLIGHT_FONT_COLOR
    --     GameTooltip:AddDoubleLine(format('|T%s:16|t %s', icon, name), count, l.r, l.g, l.b, 1, r.r, r.g, r.b)
    -- end
    GameTooltip:Show()
end

function Token:OnClick()
    if IsModifiedClick('CHATLINK') then
        HandleModifiedItemClick(GetCurrencyLink(self.id, self.count))
    else
        ToggleCharacter('TokenFrame')
    end
end

function Token:IsFull(id)
    local name, quantity, icon, earnedThisWeek, weeklyMax, maxQuantity, discovered, rarity = GetCurrencyInfo(id)
    if maxQuantity == 0 and weeklyMax == 0 then
        return false
    end
    return (weeklyMax > 0 and earnedThisWeek == weeklyMax) or (maxQuantity > 0 and quantity == maxQuantity)
end

function Token:SetToken(index)
    local name, count, icon, id = GetBackpackCurrencyInfo(index)
    local color = self:IsFull(id) and RED_FONT_COLOR or HIGHLIGHT_FONT_COLOR

    self.index = index
    self.id = id
    self.count = count
    self.text:SetText(count)
    self.icon:SetTexture(icon)
    self.text:SetTextColor(color.r, color.g, color.b)
    self:SetWidth(self.text:GetWidth() + ICON_SIZE + 2)
end
