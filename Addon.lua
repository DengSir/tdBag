-- Addon.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/21/2018, 10:17:41 AM

local Addon = select(2, ...)

function Addon:OnEnable()
    self:StartupSettings()
    self:CreateFrame('inventory')
    self:CreateSlashCommands('tdbag')
    self:CreateOptionsLoader()
end

function Addon:ShowFrame(id, manual)
    local frame = self:CreateFrame(id)
    if frame then
        frame.manualShown = frame.manualShown or manual
        ShowUIPanel(frame)
    end
    return frame
end

function Addon:HideFrame(id, manual)
    local frame = self:GetFrame(id)
    if frame and (manual or not frame.manualShown) then
        frame.manualShown = nil
        HideUIPanel(frame)
    end
    return frame
end

function Addon:IteratePluginButtons()
    if self.pluginButtons then
        return ipairs(self.pluginButtons)
    else
        return nop
    end
end

function Addon:RegisterPluginButton(name, icon, init)
    self.pluginButtons = self.pluginButtons or {}

    table.insert(self.pluginButtons, {name = name, icon = icon, init = init, key = 'plugin_' .. name})
end
