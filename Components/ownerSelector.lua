-- ownerSelector.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 1:50:54 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local OwnerSelector = Addon:NewClass('OwnerSelector', 'Button')

function OwnerSelector:New(parent)
    local b = self:Bind(CreateFrame('Button', nil, parent))
    b:SetWidth(68)
    b:SetHeight(68)
    b:RegisterForClicks('anyUp')

    local ht = b:CreateTexture(nil, 'HIGHLIGHT')
    ht:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
    ht:SetBlendMode('ADD')
    ht:SetSize(78, 78)
    ht:SetPoint('TOPLEFT', -4, 0)
    b:SetHighlightTexture(ht)

    b:SetScript('OnClick', b.OnClick)
    b:SetScript('OnEnter', b.OnEnter)
    b:SetScript('OnLeave', b.OnLeave)

    return b
end

function OwnerSelector:OnClick(button)
    if button == 'RightButton' then
        self:GetFrame():SetOwner(nil)
    else
        Addon:ToggleOwnerDropdown(self, self:GetFrame(), 10, 2)
    end
end

function OwnerSelector:OnEnter()
    if self:GetRight() > (GetScreenWidth() / 2) then
        GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
    else
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    end

    local current = self:GetFrame():GetOwner()
    GameTooltip:SetText(CHARACTER)
    GameTooltip:AddLine(L.TipChangePlayer, 1, 1, 1)
    GameTooltip:AddLine(L.TipResetPlayer, 1, 1, 1)
    GameTooltip:Show()
end

function OwnerSelector:OnLeave()
    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide()
    end
end
