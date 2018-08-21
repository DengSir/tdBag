-- bankTab.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 5:27:58 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BankTab = Addon:NewClass('BankTab', 'Frame')

local function OnClick(self)
    local parent = self:GetParent()
    local profile = parent:GetProfile()
    local hidden = profile.hiddenBags
    local slot = profile.exclusiveReagent and not hidden[REAGENTBANK_CONTAINER] and REAGENTBANK_CONTAINER or self.slot
    hidden[slot] = not hidden[slot]

    PanelTemplates_SetTab(parent, self:GetID())
    parent:SendFrameSignal('FILTERS_CHANGED')
end

local function CreateTab(parent, id, slot, text)
    local f = CreateFrame('Button', parent:GetName() .. 'Tab' .. id, parent, 'CharacterFrameTabButtonTemplate')
    f.slot = slot
    f:SetText(text)
    f:SetID(id)
    f:SetScript('OnClick', OnClick)
    return f
end

function BankTab:New(parent)
    local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'TabView', parent))
    f:Hide()
    f:SetSize(1, 1)

    f.bank = CreateTab(f, 1, BANK_CONTAINER, BANK)
    f.reagent = CreateTab(f, 2, REAGENTBANK_CONTAINER, REAGENT_BANK)

    f.bank:SetPoint('TOPLEFT')
    f.reagent:SetPoint('LEFT', f.bank, 'RIGHT', -15, 0)

    f:SetScript('OnShow', f.OnShow)

    PanelTemplates_SetNumTabs(f, 2)
    PanelTemplates_SetTab(f, 1)
    return f
end

function BankTab:OnShow()
    PanelTemplates_SetTab(self, self:GetFrame():IsShowingBag(REAGENTBANK_CONTAINER) and 2 or 1)
end
