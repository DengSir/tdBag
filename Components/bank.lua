-- bank.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 3:46:30 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bank = Addon.BankFrame

Bank.BagFrame = Addon.BankBagFrame
Bank.Icon = [[Interface\ICONS\INV_Misc_Bag_13]]

if not Addon.IsRetail then
    return
end

local Frame = Addon.Frame
local BankTab = Addon.BankTab

function Bank:Layout()
    Frame.Layout(self)
    self:PlaceTabView()
end

function Bank:PlaceTabView()
    if self:HasTabView() then
        local tabView = self.tabView or self:CreateTabView()
        tabView:Show()
    elseif self.tabView then
        self.tabView:Hide()
    end
end

function Bank:HasTabView()
    return self:GetProfile().exclusiveReagent
end

function Bank:CreateTabView()
    local f = Addon.BankTab:New(self)
    f:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 11, 2)
    self.tabView = f
    return f
end

function Bank:IsBagFrameShown(args)
    return self:GetProfile().showBags and
               (not self.profile.exclusiveReagent or not self:IsShowingBag(REAGENTBANK_CONTAINER))
end
