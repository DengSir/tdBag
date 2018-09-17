-- BankFix.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/22/2018, 11:45:59 PM

local ADDON, Addon = ...

local BankFix = Addon:NewModule('BankFix', 'AceEvent-3.0')

function BankFix:OnInitialize()
    self.BankHiddenParent = CreateFrame('Frame')
    self.BankHiddenParent:Hide()
end

function BankFix:OnEnable()
    self:RegisterEvent('BANKFRAME_OPENED')
    self:RegisterEvent('BANKFRAME_CLOSED')

    HideUIPanel(BankFrame)
    BankFrame:SetParent(self.BankHiddenParent)
    BankFrame:ClearAllPoints()
    BankFrame:SetPoint('TOPLEFT', 0, 0)
end

function BankFix:BANKFRAME_OPENED()
    BankFrame:Show()
end

function BankFix:BANKFRAME_CLOSED()
    BankFrame:Hide()
end
