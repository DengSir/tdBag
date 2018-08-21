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
