-- itemFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 9:16:21 PM

local ADDON, Addon = ...
local ItemFrame = Addon.ItemFrame

function ItemFrame:LayoutTraits()
    local frame = self:GetFrame()
    local profile = self:GetProfile()

    -- if frame:IsBank() and profile.exclusiveReagent and not profile.hiddenBags[REAGENTBANK_CONTAINER] then
    --     local total = 0
    --     for _, bag in ipairs(self.bags) do
    --         if bag ~= REAGENTBANK_CONTAINER and not profile.hiddenBags[bag] then
    --             total = total + self:NumSlots(bag)
    --         end
    --     end
    --     return min(32, ceil(self:NumSlots(REAGENTBANK_CONTAINER) / ceil(total / profile.columns))), profile.itemScale
    -- end

    -- if profile.specialBagAlwaysBottom then
    --     sort(self.bags, comp)
    -- end
    return profile.columns, profile.itemScale
end
