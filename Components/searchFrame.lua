-- searchFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 12:44:22 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SearchFrame = Addon:NewClass('SearchFrame', 'EditBox')

function SearchFrame:New(parent)
    local f = self:Bind(CreateFrame('EditBox', nil, parent, 'SearchBoxTemplate'))

    -- f:RegisterSignal('SEARCH_TOGGLED', 'OnToggle')
    f:HookScript('OnTextChanged', f.OnTextChanged)
    f:SetScript('OnEscapePressed', f.OnEscape)
    f:SetScript('OnEnterPressed', f.ClearFocus)
    f:SetScript('OnShow', f.OnShow)
    f:SetScript('OnHide', f.OnHide)
    f:SetAutoFocus(false)
    f:SetHeight(28)

    return f
end

function SearchFrame:OnTextChanged()
    local text = self:GetText():lower()
    if text ~= Addon.search then
        Addon.search = text
        Addon.canSearch = true
        Addon:SendSignal('SEARCH_CHANGED', text)
    end
end

function SearchFrame:OnEscape()
    self:ClearFocus()
    self:SetText('')
    Addon.canSearch = nil
    self:SendSignal('SEARCH_TOGGLED', nil)
end

function SearchFrame:OnShow()
    self:RegisterSignal('SEARCH_CHANGED', 'UpdateText')
    self:UpdateText()
end

function SearchFrame:OnHide()
    self:UnregisterSignal('SEARCH_CHANGED')
    self:ClearFocus()
end

function SearchFrame:UpdateText()
    if Addon.search ~= self:GetText() then
        self:SetText(Addon.search or '')
    end
end
