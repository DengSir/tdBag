-- bankTab.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 5:27:58 PM

local ADDON, Addon = ...
if Addon.IsRetail then
    return
end

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BankTab = Addon:NewClass('BankTab', 'Frame')

local BankTabItem = Addon:NewClass('BankTabItem', 'Button')

function BankTabItem:New(parent, id, slot, text)
    local f = self:Bind(
                  CreateFrame('Button', parent:GetName() .. 'Tab' .. id, parent, 'CharacterFrameTabButtonTemplate'))
    f.slot = slot
    f:SetText(text)
    f:SetID(id)
    f:SetScript('OnClick', self.OnClick)
    return f
end

function BankTabItem:OnClick()
    if self:IsReagents() and not self:IsCached() and not IsReagentBankUnlocked() then
        StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
    end

    local parent = self:GetParent()
    local profile = self:GetProfile()
    local hidden = profile.hiddenBags
    local slot = profile.exclusiveReagent and not hidden[REAGENTBANK_CONTAINER] and REAGENTBANK_CONTAINER or self.slot
    hidden[slot] = not hidden[slot]

    PanelTemplates_SetTab(parent, self:GetID())
    parent:SendFrameSignal('FILTERS_CHANGED')
end

function BankTabItem:IsReagents()
    return Addon:IsReagents(self.slot)
end

function BankTab:New(parent)
    local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'TabView', parent))
    f:Hide()
    f:SetSize(1, 1)

    f.bank = BankTabItem:New(f, 1, BANK_CONTAINER, BANK)
    f.reagent = BankTabItem:New(f, 2, REAGENTBANK_CONTAINER, REAGENT_BANK)

    f.bank:SetPoint('TOPLEFT')
    f.reagent:SetPoint('LEFT', f.bank, 'RIGHT', -15, 0)

    f:SetScript('OnShow', f.OnShow)

    PanelTemplates_SetNumTabs(f, 2)
    PanelTemplates_SetTab(f, 1)
    return f
end

function BankTab:IsExclusiveReagent()
    return self:GetProfile().exclusiveReagent
end

function BankTab:IsReagentShowing()
    return self:GetFrame():IsShowingBag(REAGENTBANK_CONTAINER)
end

function BankTab:OnShow()
    local reagentShowing = self:IsReagentShowing()
    PanelTemplates_SetTab(self, reagentShowing and 2 or 1)

    if reagentShowing and self:IsExclusiveReagent() and not self:IsCached() and not IsReagentBankUnlocked() then
        StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
    end
end
