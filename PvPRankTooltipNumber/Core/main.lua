-- Big thanks to Lars Norberg who made the addon TooltipCleaner from which i have used most of the code and inspiration from
-- This addon is light weight and alot less code just for the intended purpose.

--[[

	The MIT License (MIT)

	Copyright (c) 2025 Swarleey-Spineshatter

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

--]]
local Addon, ns = ...

local L = LibStub("AceLocale-3.0"):GetLocale(Addon, true)

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")

ns = LibStub("AceAddon-3.0"):NewAddon(ns, Addon, "LibMoreEvents-1.0", "AceConsole-3.0", "AceHook-3.0")

-- Lua API
local next = next
local rawget = rawget
local rawset = rawset
local select = select
local setmetatable = setmetatable
local string_gsub = string.gsub
local string_match = string.match

-- Convert a WoW global string to a search pattern
local makePattern = function(msg)
	msg = string_gsub(msg, "%%([%d%$]-)d", "(%%d+)")
	msg = string_gsub(msg, "%%([%d%$]-)s", "(.+)")
	return msg
end

-- Search Pattern Cache.
-- This will generate the pattern on the first lookup.
local P = setmetatable({}, { __index = function(t,k)
	rawset(t,k,makePattern(k))
	return rawget(t,k)
end })

-- Affected tooltips.
local tooltips = {
	[GameTooltip] = true,
	[EmbeddedItemTooltip] = true,
	[ItemRefTooltip] = true,
	[ItemRefShoppingTooltip1] = true,
	[ItemRefShoppingTooltip2] = true,
	[ShoppingTooltip1] = true,
	[ShoppingTooltip2] = true
}

ns.UpdateSettings = function(self)
	for tooltip in next,tooltips do
		if (not self:IsHooked(tooltip, "OnTooltipSetItem")) then
			self:SecureHookScript(tooltip, "OnTooltipSetItem", "OnTooltipSetItem")
		end
	end
end


ns.OnTooltipSetItem = function(self, tooltip)
	if (not tooltip) or (tooltip:IsForbidden()) then return end

	local tipName = tooltip:GetName()

	for i = tooltip:NumLines(),1,-1 do
		local line = _G[tipName.."TextLeft"..i]
		local msg = line and line:GetText()

		if (not msg) then break end

		-- Alliance
		if (string_match(msg, P["Requires Private"])) then
			line:SetText("Requires Private (Rank 1)")
		elseif (string_match(msg, P["Requires Corporal"])) then
			line:SetText("Requires Corporal (Rank 2)")
		elseif (string_match(msg, P["Requires Sergeant"])) then
			line:SetText("Requires Sergeant (Rank 3)")
		elseif (string_match(msg, P["Requires Master Sergeant"])) then
			line:SetText("Requires Master Sergeant (Rank 4)")
		elseif (string_match(msg, P["Requires Sergeant Major"])) then
			line:SetText("Requires Sergeant Major (Rank 5)")
		elseif (string_match(msg, P["Requires Knight$"])) then
			line:SetText("Requires Knight (Rank 6)")
		elseif (string_match(msg, P["Requires Knight.*Lieutenant"])) then
			line:SetText("Requires Knight-Lieutenant (Rank 7)")
		elseif (string_match(msg, P["Requires Knight.*Captain"])) then
			line:SetText("Requires Knight-Captain (Rank 8)")
		elseif (string_match(msg, P["Requires Knight.*Champion"])) then
			line:SetText("Requires Knight-Champion (Rank 9)")
		elseif (string_match(msg, P["Requires Lieutenant Commander"])) then
			line:SetText("Requires Lieutenant Commander (Rank 10)")
		elseif (string_match(msg, P["Requires Commander"])) then
			line:SetText("Requires Commander (Rank 11)")
		elseif (string_match(msg, P["Requires Marshal"])) then
			line:SetText("Requires Marshal (Rank 12)")
		elseif (string_match(msg, P["Requires Field Marshal"])) then
			line:SetText("Requires Field Marshal (Rank 13)")
		elseif (string_match(msg, P["Requires Grand Marshal"])) then
			line:SetText("Requires Grand Marshal (Rank 14)")
		end

		-- Horde
		if (string_match(msg, P["Requires Scout"])) then
			line:SetText("Requires Scout (Rank 1)")
		elseif (string_match(msg, P["Requires Grunt"])) then
			line:SetText("Requires Grunt (Rank 2)")
		elseif (string_match(msg, P["Requires Sergeant"])) then
			line:SetText("Requires Sergeant (Rank 3)")
		elseif (string_match(msg, P["Requires Senior Sergeant"])) then
			line:SetText("Requires Senior Sergeant (Rank 4)")
		elseif (string_match(msg, P["Requires First Sergeant"])) then
			line:SetText("Requires First Sergeant (Rank 5)")
		elseif (string_match(msg, P["Requires Stone Guard"])) then
			line:SetText("Requires Stone Guard (Rank 6)")
		elseif (string_match(msg, P["Requires Blood Guard"])) then
			line:SetText("Requires Blood Guard (Rank 7)")
		elseif (string_match(msg, P["Requires Legionnaire"])) then
			line:SetText("Requires Legionnaire (Rank 8)")
		elseif (string_match(msg, P["Requires Centurion"])) then
			line:SetText("Requires Centurion (Rank 9)")
		elseif (string_match(msg, P["Requires Champion"])) then
			line:SetText("Requires Champion (Rank 10)")
		elseif (string_match(msg, P["Requires Lieutenant General"])) then
			line:SetText("Requires Lieutenant General (Rank 11)")
		elseif (string_match(msg, P["Requires General"])) then
			line:SetText("Requires General (Rank 12)")
		elseif (string_match(msg, P["Requires Warlord"])) then
			line:SetText("Requires Warlord (Rank 13)")
		elseif (string_match(msg, P["Requires High Warlord"])) then
			line:SetText("Requires High Warlord (Rank 14)")
		end
	end
end

ns.OnEnable = function(self)
	self:UpdateSettings()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateSettings")
end