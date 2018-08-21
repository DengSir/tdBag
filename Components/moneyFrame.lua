-- moneyFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 1:15:03 PM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local MoneyFrame = Addon.MoneyFrame

local orig_New = MoneyFrame.New
local orig_Update = MoneyFrame.Update

function MoneyFrame:New(parent)
    local f = orig_New(self, parent)

    local bgl = f:CreateTexture(nil, 'BACKGROUND')
    bgl:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bgl:SetTexCoord(0, 0.09375, 0, 0.625)
    bgl:SetPoint('TOPLEFT')
    bgl:SetPoint('BOTTOMLEFT')
    bgl:SetWidth(12)

    local bgr = f:CreateTexture(nil, 'BACKGROUND')
    bgr:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bgr:SetTexCoord(0.90625, 1, 0, 0.625)
    bgr:SetPoint('TOPRIGHT')
    bgr:SetPoint('BOTTOMRIGHT')
    bgr:SetWidth(12)

    local bg = f:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bg:SetTexCoord(0.125, 0.875, 0, 0.625)
    bg:SetPoint('TOPLEFT', bgl, 'TOPRIGHT')
    bg:SetPoint('BOTTOMRIGHT', bgr, 'BOTTOMLEFT')

    return f
end

function MoneyFrame:OnClick()
    MoneyInputFrame_OpenPopup(self)
    self:OnLeave()
end

function MoneyFrame:Update()
    orig_Update(self)
    self:SetWidth(self:GetWidth() + 30, 180)
end
