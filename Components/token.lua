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
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -7)
    GameTooltip:SetBackpackToken(self.index)
    GameTooltip:Show()
end

function Token:OnClick()
    if IsModifiedClick('CHATLINK') then
        HandleModifiedItemClick(GetCurrencyLink(self.id, self.count))
    end
end

function Token:SetToken(index)
    local name, count, icon, id = GetBackpackCurrencyInfo(index)
    local color = IsCurrencyFull and IsCurrencyFull(id) and RED_FONT_COLOR or HIGHLIGHT_FONT_COLOR

    self.index = index
    self.id = id
    self.count = count
    self.text:SetText(count)
    self.icon:SetTexture(icon)
    self.text:SetTextColor(color.r, color.g, color.b)
    self:SetWidth(self.text:GetWidth() + ICON_SIZE + 2)
end
