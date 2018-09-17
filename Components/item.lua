-- item.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 3:06:08 PM

local ADDON, Addon = ...
local ItemSlot = Addon.ItemSlot
local ItemSearch = LibStub('LibItemSearch-1.2')
local Unfit = LibStub('Unfit-1.0')

local QUEST = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
local QUEST_LOWER = QUEST:lower()

local orig_Create = ItemSlot.Create
local orig_Free = ItemSlot.Free

function ItemSlot:Create()
    local item = orig_Create(self)

    item.newitemglowAnim:SetLooping('REPEAT')

    item.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
    item.QuestBorder:ClearAllPoints()
    item.QuestBorder:SetPoint('BOTTOMLEFT', 5, 4)
    item.QuestBorder:SetSize(8.88, 25.46)
    item.QuestBorder:SetTexCoord(0.14, 0.38, 0.23, 0.9)

    item.IconBorder:SetTexture([[Interface\Addons\tdBag\Images\RelicIconFrame]])
    item.IconBorder:SetDrawLayer('OVERLAY', 7)

    return item
end

function ItemSlot:Free()
    self.bag = nil
    self.slot = nil
    return orig_Free(self)
end

function ItemSlot:UpdateBorder()
    local id, quality = self.info.id, self.info.quality
    local new = Addon.sets.glowNew and self:IsNew()
    local quest, questID = self:IsQuestItem()
    local paid = self:IsPaid()
    local r, g, b

    if new and not self.flashAnim:IsPlaying() then
        self.flashAnim:Play()
        self.newitemglowAnim:Play()
    end

    if id then
        if Addon.sets.glowQuest and quest then
            r, g, b = 1, .82, .2
        elseif Addon.sets.glowUnusable and Unfit:IsItemUnusable(id) then
            r, g, b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
        elseif Addon.sets.glowSets and ItemSearch:InSet(self.info.link) then
            r, g, b = .1, 1, 1
        elseif Addon.sets.glowQuality and quality and quality > 1 then
            r, g, b = GetItemQualityColor(quality)
        end
    end

    self.IconBorder:SetVertexColor(r, g, b)
    self.IconBorder:SetShown(id and C_ArtifactUI.GetRelicInfoByItemID(id))

    self.IconGlow:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
    self.IconGlow:SetShown(r)

    self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
    self.NewItemTexture:SetShown(new and not paid)

    self.IconOverlay:SetShown(id and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(id))
    self.BattlepayItemTexture:SetShown(new and paid)
    self.QuestBorder:SetShown(questID)

    self.JunkIcon:SetShown(Addon.sets.iconJunk and self:IsJunk())
end

function ItemSlot:IsJunk()
    local id = self.info.id
    if not id then
        return
    end
    if Scrap then
        local bag, slot
        if not self:IsCached() then
            bag, slot = self:GetBag(), self:GetID()
        end
        return Scrap:IsJunk(id, bag, slot)
    else
        local _, _, quality, _, _, _, _, _, _, _, price = GetItemInfo(id)
        return quality == LE_ITEM_QUALITY_POOR and price and price > 0
    end
end

-- do
--     local tested = setmetatable({}, {
--         __index = function(t, k)
--             t[k] = {}
--             return t[k]
--         end
--     })
--     local COUNT = 3

--     local IsNewItem = C_NewItems.IsNewItem
--     local RemoveNewItem = C_NewItems.RemoveNewItem

--     C_NewItems.IsNewItem = function(bag, slot)
--         if IsNewItem(bag, slot) then
--             return true
--         end
--         local count = tested[bag][slot] or 0
--         return count < COUNT
--     end

--     C_NewItems.RemoveNewItem = function(bag, slot)
--         RemoveNewItem(bag, slot)
--         tested[bag][slot] = (tested[bag][slot] or 0) + 1
--     end

--     function _G.TestNew(count)
--         table.wipe(tested)
--         COUNT = count
--     end
-- end
