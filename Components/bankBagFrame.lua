-- bankBagFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 10:19:57 PM

local ADDON, Addon = ...
if Addon.IsRetail then
    return
end

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BankBagFrame = Addon:NewClass('BankBagFrame', 'Frame')
local Bag = Addon.Bag

function BankBagFrame:New(parent, from, x, y)
    local f = self:Bind(CreateFrame('Frame', nil, parent))
    local button, k

    if parent.Bags[#parent.Bags] ~= REAGENTBANK_CONTAINER then
        tremove(parent.Bags, tIndexOf(parent.Bags, REAGENTBANK_CONTAINER))
        tinsert(parent.Bags, REAGENTBANK_CONTAINER)
    end

    for i, bag in ipairs(parent.Bags) do
        k = i - 1
        button = Bag:New(f, bag)
        button:SetPoint(from, x * k, y * k)
    end

    f.reagentButton = button
    f.x = x
    f.y = y
    f:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'Update')
    f:RegisterSignal('UPDATE_ALL', 'Update')
    f:Update()

    return f
end

function BankBagFrame:Update()
    self:UpdateShown()
    self:UpdateSize()
end

function BankBagFrame:UpdateShown()
    self:SetShown(self:GetFrame():IsBagFrameShown())
    self.reagentButton:SetShown(not self:GetProfile().exclusiveReagent)
end

function BankBagFrame:UpdateSize()
    local button = self.reagentButton
    local x = self.x
    local y = self.y
    local k = #self:GetParent().Bags - 1
    if self:GetProfile().exclusiveReagent then
        k = k - 1
    end
    self:SetSize(k * abs(x) + button:GetWidth(), k * abs(y) + button:GetHeight())
end
