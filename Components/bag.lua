-- bag.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 10:21:07 AM

local Addon = select(2, ...)
local Bag = Addon.Bag

Bag.SIZE = 26
Bag.TEXTURE_SIZE = 64 * (Bag.SIZE / 36)

function Bag:UpdateToggle()
    local color = self:IsPurchasable() and .1 or 1

    SetItemButtonTextureVertexColor(self, 1, color, color)
    SetItemButtonDesaturated(self, self:IsHidden())
    self:SetChecked(false)

    if not Addon.IsRetail then
        self:RegisterForClicks('LeftButtonUp')
    end
end

function Bag:SetIcon(icon)
    SetItemButtonTexture(self, icon)
    self:UpdateToggle()
end

function Bag:Update()
    local info = self:GetInfo()

    self.FilterIcon:Hide()
    self.Count:SetText(info.free and info.free > 0 and info.free)

    if self:IsBackpack() or self:IsBank() then
        self:SetIcon('Interface/Buttons/Button-Backpack-Up')
    elseif self:IsReagents() then
        self:SetIcon('Interface/Icons/Achievement_GuildPerk_BountifulBags')
    else
        self:SetIcon(info.icon or 'Interface/PaperDoll/UI-PaperDoll-Slot-Bag')
        self.link = info.link

        if not info.icon then
            self.Count:SetText()
        end
    end

    if not info.cached then
        for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
            local id = self:GetSlot()
            local active = id > NUM_BAG_SLOTS and GetBankBagSlotFlag(id - NUM_BAG_SLOTS, i) or GetBagSlotFlag(id, i)

            if active then
                self.FilterIcon.Icon:SetAtlas(BAG_FILTER_ICONS[i])
                self.FilterIcon:Show()
            end
        end
    end

    self:UpdateLock()
    self:UpdateCursor()
    self:UpdateToggle()
end
