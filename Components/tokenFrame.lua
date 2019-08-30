-- titleFrame.lua
-- @Author  : DengSir (tdaddon@163.com)
-- @Link    : https://dengsir.github.io

local ADDON, Addon = ...
if not Addon.IsRetail then
    return
end

local TokenFrame = Addon:NewClass('TokenFrame', 'Frame')
LibStub('AceHook-3.0'):Embed(TokenFrame)

function TokenFrame:New(parent, id)
    local f = self:Bind(CreateFrame('Frame', nil, parent))

    f:Hide()
    f:SetHeight(24)
    f.tokens = {}

    local bgl = f:CreateTexture(nil, 'BACKGROUND')
    bgl:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bgl:SetTexCoord(0, 0.09375, 0, 0.625)
    bgl:SetVertexColor(0, 1, 0)
    bgl:SetPoint('TOPLEFT')
    bgl:SetPoint('BOTTOMLEFT')
    bgl:SetWidth(12)

    local bgr = f:CreateTexture(nil, 'BACKGROUND')
    bgr:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bgr:SetTexCoord(0.90625, 1, 0, 0.625)
    bgr:SetVertexColor(0, 1, 0)
    bgr:SetPoint('TOPRIGHT')
    bgr:SetPoint('BOTTOMRIGHT')
    bgr:SetWidth(12)

    local bg = f:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture([[Interface\MoneyFrame\UI-MoneyFrame-Border]])
    bg:SetTexCoord(0.125, 0.875, 0, 0.625)
    bg:SetVertexColor(0, 1, 0)
    bg:SetPoint('TOPLEFT', bgl, 'TOPRIGHT')
    bg:SetPoint('BOTTOMRIGHT', bgr, 'BOTTOMLEFT')

    f:SetScript('OnShow', f.OnShow)
    f:SetScript('OnHide', f.OnHide)

    return f
end

function TokenFrame:OnShow()
    if _G.BackpackTokenFrame_Update then
        self:SecureHook('BackpackTokenFrame_Update', 'Update')
    end
    self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
    self:Update()
end

function TokenFrame:OnHide()
    self:UnhookAll()
    self:UnregisterFrameSignal('OWNER_CHANGED')
end

function TokenFrame:OnPlayerChanged()
    self:GetParent():PlaceTokenFrame()
end

function TokenFrame:Update()
    for i = 1, MAX_WATCHED_TOKENS do
        local token = self:GetButton(i)
        if GetBackpackCurrencyInfo(i) then
            token:SetToken(i)
            token:Show()
        else
            token:Hide()
        end
    end
end

function TokenFrame:GetButton(i)
    if not self.tokens[i] then
        local token = Addon.Token:New(self)
        if i == 1 then
            token:SetPoint('LEFT', 10, 0)
        else
            token:SetPoint('LEFT', self.tokens[#self.tokens], 'RIGHT')
        end
        tinsert(self.tokens, token)
    end
    return self.tokens[i]
end
