-- frame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 10:57:57 AM

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Frame
Frame.ItemFrame = Addon.ItemFrame
Frame.BagFrame = Addon.BagFrame
Frame.MoneyFrame = Addon.MoneyFrame

function Frame:New(id)
    local f = self:Bind(CreateFrame('Frame', ADDON .. 'Frame' .. id, UIParent, 'ButtonFrameTemplate'))
    f.frameID = id
    f.quality = 0
    f.profile = f:GetBaseProfile()
    f.menuButtons = {}
    f.pluginButtons = {}

    f.portrait:SetMask([[Textures\MinimapMask]])
    f.portrait:SetTexture(f.Icon or [[Interface\Buttons\Button-Backpack-Up]])

    f:Hide()
    f:SetMovable(true)
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:FindRules()

    f:SetScript('OnShow', f.OnShow)
    f:SetScript('OnHide', f.OnHide)

    tinsert(UISpecialFrames, f:GetName())
    f:UpdateAppearance()
    return f
end

function Frame:RegisterSignals()
    self:RegisterSignal('UPDATE_ALL', 'Update')
    self:RegisterSignal('RULES_LOADED', 'FindRules')
    self:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'Layout')
    self:RegisterFrameSignal('ITEM_FRAME_RESIZED', 'Layout')
    self:Layout()
end

function Frame:UpdateAppearance()
    local shown = self:IsShown()
    local managed = self.profile.managed or nil
    local changed = not self:GetAttribute('UIPanelLayout-enabled') ~= not managed

    self:SetFrameStrata(self.profile.strata)
    self:SetAlpha(self.profile.alpha)
    self:SetScale(self.profile.scale)

    if changed then
        if shown then
            HideUIPanel(self)
        end

        self:SetAttribute('UIPanelLayout-enabled', managed)
        self:SetAttribute('UIPanelLayout-defined', managed)
        self:SetAttribute('UIPanelLayout-whileDead', managed)
        self:SetAttribute('UIPanelLayout-area', managed and 'left')
        self:SetAttribute('UIPanelLayout-pushable', managed and 1)

        if shown then
            ShowUIPanel(self)
        end
    end

    if not managed then
        self:ClearAllPoints()
        self:SetPoint(self:GetPosition())
    end
end

function Frame:Update()
    self:Layout()
    self:UpdateAppearance()
end

function Frame:Layout()
    self:PlaceTitleFrame()
    self:PlaceOwnerSelector()
    self:PlaceBagFrame()
    self:PlaceMenuButtons()
    self:PlaceSearchFrame()

    self:PlaceItemFrame()

    self:PlaceMoneyFrame()
    self:PlaceTokenFrame()
    self:PlaceBottomBar()

    self:UpdateSize()
end

function Frame:UpdateSize()
    self:SetWidth(self.itemFrame:GetWidth() + 24)
    self:SetHeight(self.itemFrame:GetHeight() + ((self:HasMoneyFrame() or self:HasTokenFrame()) and 100 or 77))

    if self.profile.managed then
        UpdateUIPanelPositions()
    end
end

-- title frame

function Frame:PlaceTitleFrame()
    local frame = self.titleFrame or self:CreateTitleFrame()
    frame:SetPoint('TOPLEFT', 60, -2)
    frame:SetPoint('TOPRIGHT', -24, -2)
    frame:SetHeight(18)
end

function Frame:CreateTitleFrame()
    local f = Addon.TitleFrame:New(self.Title, self)
    self.titleFrame = f
    return f
end

-- player selector

function Frame:HasOwnerSelector()
    return Addon:MultipleOwnersFound()
end

function Frame:PlaceOwnerSelector()
    if self:HasOwnerSelector() then
        local frame = self.playerSelector or self:CreateOwnerSelector()
        frame:SetPoint('TOPLEFT', -10, 12)
        frame:Show()
    elseif self.playerSelector then
        self.playerSelector:Hide()
    end
end

function Frame:CreateOwnerSelector()
    local f = Addon.OwnerSelector:New(self)
    self.playerSelector = f
    return f
end

-- bag frame

function Frame:CreateBagFrame()
    local f = self.BagFrame:New(self, 'LEFT', 29, 0)
    self.bagFrame = f
    return f
end

function Frame:IsBagFrameShown()
    return self:GetProfile().showBags
end

function Frame:PlaceBagFrame()
    if self:IsBagFrameShown() then
        local frame = self.bagFrame or self:CreateBagFrame()
        frame:SetPoint('TOPLEFT', 64, -29)
        frame:Show()
    elseif self.bagFrame then
        self.bagFrame:Hide()
    end
end

-- sort button

function Frame:HasSortButton()
    return self.profile.sort and SortBags
end

function Frame:CreateSortButton()
    local button = Addon.SortButton:New(self)
    self.sortButton = button
    return button
end

-- bag toggle

function Frame:HasBagToggle()
    return self.profile.bagToggle
end

function Frame:CreateBagToggle()
    local toggle = Addon.BagToggle:New(self)
    self.bagToggle = toggle
    return toggle
end

-- menu buttons

function Frame:CreatePluginButton(item)
    local button = CreateFrame('Button', nil, self, 'tdBagToggleButtonTemplate')
    button.texture:SetTexture(item.icon)
    item.init(button, self)
    self.pluginButtons[item.name] = button
    return button
end

function Frame:HasPluginButton(item)
    return not self.profile[item.key]
end

function Frame:PlaceMenuButtons()
    local menuButtons = self.menuButtons

    for i, button in ipairs(menuButtons) do
        button:Hide()
    end

    wipe(menuButtons)

    for _, item in Addon:IteratePluginButtons() do
        if self:HasPluginButton(item) then
            table.insert(menuButtons, self.pluginButtons[item.name] or self:CreatePluginButton(item))
        end
    end

    if self:HasSortButton() then
        tinsert(menuButtons, self.sortButton or self:CreateSortButton())
    end
    if self:HasBagToggle() then
        tinsert(menuButtons, self.bagToggle or self:CreateBagToggle())
    end

    for i, button in ipairs(menuButtons) do
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint('TOPRIGHT', -15, -31)
        else
            button:SetPoint('RIGHT', menuButtons[i - 1], 'LEFT', -3, 0)
        end
        button:Show()
    end
end

-- search frame

function Frame:PlaceSearchFrame()
    local frame = self.searchFrame or self:CreateSearchFrame()
    frame:ClearAllPoints()

    if #self.menuButtons > 0 then
        frame:SetPoint('RIGHT', self.menuButtons[#self.menuButtons], 'LEFT', -10, 0)
    else
        frame:SetPoint('TOPRIGHT', -15, -28)
    end

    if self:IsBagFrameShown() then
        frame:SetPoint('LEFT', self.bagFrame, 'RIGHT', 15, 0)
    else
        frame:SetPoint('TOPLEFT', 74, -28)
    end
end

function Frame:CreateSearchFrame()
    local f = Addon.SearchFrame:New(self)
    self.searchFrame = f
    return f
end

-- item frame

function Frame:PlaceItemFrame()
    local frame = self.itemFrame or self:CreateItemFrame()
    frame:SetPoint('TOPLEFT', self.Inset, 'TOPLEFT', 8, -8)
    frame:Show()
end

function Frame:CreateItemFrame()
    local f = self.ItemFrame:New(self, self.Bags)
    self.itemFrame = f
    return f
end

-- money frame

function Frame:HasMoneyFrame()
    return self.profile.money
end

function Frame:PlaceMoneyFrame()
    if self:HasMoneyFrame() then
        local frame = self.moneyFrame or self:CreateMoneyFrame()
        frame:ClearAllPoints()
        frame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -(frame.ICON_SIZE or 0) - (frame.ICON_OFF or 0) - 5, 2)
        frame:Show()
    elseif self.moneyFrame then
        self.moneyFrame:Hide()
    end
end

function Frame:CreateMoneyFrame()
    local f = self.MoneyFrame:New(self)
    self.moneyFrame = f
    return f
end

-- token frame

function Frame:HasTokenFrame()
    return self.profile.broker and self:IsSelf() and Addon.TokenFrame
end

function Frame:PlaceTokenFrame()
    if self:HasTokenFrame() then
        local frame = self.tokenFrame or self:CreateTokenFrame(self)
        frame:ClearAllPoints()
        frame:SetPoint('BOTTOMLEFT', 3, 2)
        if self:HasMoneyFrame() then
            frame:SetPoint('RIGHT', self.moneyFrame, 'LEFT')
        else
            frame:SetPoint('BOTTOMRIGHT', -5, 2)
        end
        frame:Show()
    elseif self.tokenFrame then
        self.tokenFrame:Hide()
    end
end

function Frame:CreateTokenFrame()
    local f = Addon.TokenFrame:New(self)
    self.tokenFrame = f
    return f
end

-- bottom bar

function Frame:PlaceBottomBar()
    if self:HasMoneyFrame() or self:HasTokenFrame() then
        ButtonFrameTemplate_ShowButtonBar(self)
    else
        ButtonFrameTemplate_HideButtonBar(self)
    end
end

--

function Frame:IsSelf()
    return self:GetOwner() == UnitName('player')
end
