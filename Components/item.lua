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

function ItemSlot:Create()
    local item = orig_Create(self)

    item.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
    item.QuestBorder:ClearAllPoints()
    item.QuestBorder:SetPoint('BOTTOMLEFT', 5, 4)
    item.QuestBorder:SetSize(8.88, 25.46)
    item.QuestBorder:SetTexCoord(0.14, 0.38, 0.23, 0.9)

    item.IconBorder:SetTexture([[Interface\Addons\tdBag\Images\RelicIconFrame]])
    item.IconBorder:SetDrawLayer('OVERLAY', 7)

    return item
end

function ItemSlot:HideBorder()
    self.QuestBorder:Hide()
    self.Border:Hide()
    self.NewItemTexture:Hide()
    self.BattlepayItemTexture:Hide()
    self.IconBorder:Hide()
    self.JunkIcon:Hide()
    self.IconOverlay:Hide()
end

function ItemSlot:UpdateBorder()
    self:HideBorder()

    local item = self.info.link
    if item then
        local quality = tonumber(self.info.quality)
        if Addon.sets.iconJunk and self:IsJunk() then
            self.JunkIcon:Show()
        end

        if self:IsAzeriteEmpowered() then
            self.IconOverlay:SetAtlas([[AzeriteIconFrame]])
            self.IconOverlay:Show()
        end

        if self:IsArtifactRelic() then
            local r, g, b = GetItemQualityColor(quality)
            self.IconBorder:Show()
            self.IconBorder:SetVertexColor(r, g, b)
        end

        local isQuestItem, isQuestStarter = self:IsQuestItem()
        if isQuestStarter then
            self.QuestBorder:Show()
        end

        if Addon.sets.glowNew and self:IsNew() then
            if not self.flashAnim:IsPlaying() then
                self.flashAnim:Play()
                self.newitemglowAnim:SetLooping('NONE')
                self.newitemglowAnim:Play()
            end

            if self:IsPaid() then
                return self.BattlepayItemTexture:Show()
            else
                self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
                self.NewItemTexture:Show()
                return
            end
        end

        if Addon.sets.glowQuest and (isQuestItem or isQuestStarter) then
            return self:SetBorderColor(1, .82, .2)
        end

        if Addon.sets.glowSets and ItemSearch:InSet(item) then
            return self:SetBorderColor(.1, 1, 1)
        end

        if Addon.sets.glowUnusable and Unfit:IsItemUnusable(item) then
            return self:SetBorderColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        end

        if Addon.sets.glowQuality and quality and quality > 1 then
            return self:SetBorderColor(GetItemQualityColor(quality))
        end
    end
end

function ItemSlot:IsQuestItem()
    if self.info.id then
        if self:IsCached() then
            return select(12, GetItemInfo(self.info.id)) == LE_ITEM_CLASS_QUESTITEM or
                ItemSearch:Tooltip(self.info.link, QUEST_LOWER), false
        else
            local isQuestItem, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
            return isQuestItem or questID, (questID and not isActive)
        end
    end
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

function ItemSlot:IsArtifactRelic()
    return self.info.id and IsArtifactRelicItem(self.info.id)
end

function ItemSlot:IsAzeriteEmpowered()
    return self.info.id and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(self.info.id)
end
