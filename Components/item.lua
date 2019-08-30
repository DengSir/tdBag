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
    self.newitemglowAnim:Stop()
    self.flashAnim:Stop()
    return orig_Free(self)
end

function ItemSlot:UpdateBorder()
    local id, quality = self.info.id, tonumber(self.info.quality)
    local new = Addon.sets.glowNew and self:IsNew()
    local quest, questID = self:IsQuestItem()
    local paid = self:IsPaid()
    local r, g, b

    if new then
        -- if not self.flashAnim:IsPlaying() or not self.newitemglowAnim:IsPlaying() then
        self.flashAnim:Play()
        self.newitemglowAnim:Play()
        -- end
    else
        -- if self.flashAnim:IsPlaying() or self.newitemglowAnim:IsPlaying() then
        self.flashAnim:Stop()
        self.newitemglowAnim:Stop()
        -- end
    end

    if id then
        if Addon.sets.glowQuest and (quest or questID) then
            r, g, b = 1, .82, .2
        elseif Addon.sets.glowUnusable and Unfit:IsItemUnusable(id) then
            r, g, b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
        elseif Addon.sets.glowSets and ItemSearch:InSet(self.info.link) then
            r, g, b = .1, 1, 1
        elseif Addon.sets.glowQuality and quality and quality > 1 then
            r, g, b = GetItemQualityColor(quality)
        end
    end

    if Addon.IsRetail then
        self.IconBorder:SetVertexColor(r, g, b)
        self.IconBorder:SetShown(id and C_ArtifactUI.GetRelicInfoByItemID(id))
        self.IconOverlay:SetShown(id and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(id))
    end

    self.IconGlow:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
    self.IconGlow:SetShown(r)

    self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
    self.NewItemTexture:SetShown(new and not paid)

    self.BattlepayItemTexture:SetShown(new and paid)
    self.QuestBorder:SetShown(questID)

    self.JunkIcon:SetShown(Addon.sets.iconJunk and self:IsJunk())
end

function ItemSlot:UpdateSearch()
    local search = Addon.canSearch and Addon.search or ''
    local matches = search == '' or ItemSearch:Matches(self.info.link, search)

    local isNew = self.newitemglowAnim:IsPlaying()
    if isNew then
        self.newitemglowAnim:Stop()
        self.flashAnim:Stop()
    end

    if matches then
        self:UpdateLocked()
        self:SetAlpha(1)
    else
        self:SetLocked(true)
        self:SetAlpha(0.3)
    end

    if isNew then
        self.newitemglowAnim:Play()
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
