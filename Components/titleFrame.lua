-- titleFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 12:47:23 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TitleFrame = Addon:NewClass('TitleFrame', 'Button')

function TitleFrame:New(title, parent)
    local b = self:Bind(CreateFrame('Button', nil, parent))

    b:SetToplevel(true)
    b:SetNormalFontObject('GameFontNormalCenter')
    b:SetHighlightFontObject('GameFontHighlightCenter')
    b:RegisterForClicks('anyUp')

    b:SetScript('OnHide', b.OnMouseUp)
    b:SetScript('OnMouseDown', b.OnMouseDown)
    b:SetScript('OnMouseUp', b.OnMouseUp)
    b:SetScript('OnClick', b.OnClick)
    b.title = title

    b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
    b:Update()

    return b
end

function TitleFrame:OnMouseUp()
    local parent = self:GetParent()
    parent:StopMovingOrSizing()
    parent:RecomputePosition()
end

function TitleFrame:OnMouseDown()
    local parent = self:GetParent()
    if not parent.profile.managed and (not Addon.sets.locked or IsAltKeyDown()) then
        parent:StartMoving()
    end
end

function TitleFrame:OnClick(button)
    if button == 'RightButton' and LoadAddOn(ADDON .. '_Config') then
        Addon.Option:Open(self:GetFrameID())
    end
end

function TitleFrame:Update()
    self:SetFormattedText(self.title, self:GetOwnerInfo().name)
    self:GetFontString():SetAllPoints(self)
end
