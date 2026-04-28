---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

if not Contains(PersistentTraitKeys, "NightmareFearExpiring") then

table.insert(PersistentTraitKeys, "NightmareFearExpiring")
table.insert(PersistentTraitKeys, "NightmareFearExpiringRemaining")
end