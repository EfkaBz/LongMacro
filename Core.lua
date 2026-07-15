local ADDON_NAME = ...

LongMacro = LongMacro or {}
local LM = LongMacro

local NATIVE_MACRO_LIMIT = 255
local ICON_PATH = "Interface\\AddOns\\LongMacro\\Icon"

-- === Storage =====================================================

local function InitDB()
	LongMacroDB = LongMacroDB or {}
	LongMacroDB.macros = LongMacroDB.macros or {}
end

local function StubFor(name)
	return "/lmrun " .. name
end

-- === Execution ====================================================
-- RunMacroText() is the Blizzard-documented way to run macro text that
-- was never typed into a real macro slot. It is available on Retail,
-- Classic, Classic Era and Anniversary. It still requires the calling
-- code to be "secure" for protected actions (casting, targeting, using
-- items in combat) - a slash command triggered from inside a real macro
-- does NOT carry that secure/hardware-event status, which is a known,
-- currently unresolved Blizzard restriction affecting every "extended
-- macro" addon (see Macro Toolkit's own notes on this). Non-protected
-- lines (chat, emotes, UI toggles, etc.) always run fine.
function LM:Execute(text)
	if not text or text == "" then return end
	local ok = pcall(RunMacroText, text)
	if not ok then
		print("|cffff4444LongMacro:|r a protected line (spell, target...) was rejected by Blizzard - known limitation outside secure execution.")
	end
end

function LM:Run(name)
	local text = LongMacroDB.macros[name]
	if not text then
		print("|cffff4444LongMacro:|r extended macro not found: " .. tostring(name))
		return
	end
	self:Execute(text)
end

function LM:GetNames()
	local names = {}
	for name in pairs(LongMacroDB.macros) do
		table.insert(names, name)
	end
	table.sort(names, function(a, b) return a:lower() < b:lower() end)
	return names
end

function LM:Forget(name)
	LongMacroDB.macros[name] = nil
end

-- === Native Macro UI hook ========================================
-- Rather than a separate window, LongMacro edits macros directly inside
-- Blizzard's own macro frame (opened via /macro). Typing past 255
-- characters is allowed there; on Save, if the body is too long for a
-- real macro, the full text is stored here and a short "/lmrun <name>"
-- stub is written into the actual macro slot instead. Re-opening that
-- macro shows the full text again, so editing stays seamless.

local function HookMacroFrame()
	if LM.macroFrameHooked then return end
	if not MacroFrame or not MacroFrameText then return end
	LM.macroFrameHooked = true

	MacroFrameText:SetMaxLetters(0)

	MacroFrameText:HookScript("OnTextChanged", function(self)
		if not MacroFrameCharLimitText then return end
		local len = self:GetNumLetters()
		if len > NATIVE_MACRO_LIMIT then
			MacroFrameCharLimitText:SetText(len .. " characters (LongMacro)")
			MacroFrameCharLimitText:SetTextColor(1, 0.82, 0)
		else
			MacroFrameCharLimitText:SetTextColor(1, 1, 1)
		end
	end)

	local original_SaveMacro = MacroFrame.SaveMacro
	MacroFrame.SaveMacro = function(self, ...)
		local selectedMacroIndex = self.textChanged and self:GetSelectedIndex()
		if selectedMacroIndex then
			local actualIndex = self:GetMacroDataIndex(selectedMacroIndex)
			local fullText = MacroFrameText:GetText() or ""
			local name = GetMacroInfo(actualIndex)
			if name then
				if #fullText > NATIVE_MACRO_LIMIT then
					LongMacroDB.macros[name] = fullText
					MacroFrameText:SetText(StubFor(name))
					original_SaveMacro(self, ...)
					EditMacro(actualIndex, nil, ICON_PATH, nil)
					MacroFrameText:SetText(fullText)
					self.textChanged = nil
					print(("|cff33ccffLongMacro:|r '%s' saved (%d characters). Protected actions (spells, targets) are not guaranteed in combat through this system - current Blizzard limitation."):format(name, #fullText))
					return
				elseif LongMacroDB.macros[name] then
					LongMacroDB.macros[name] = nil
				end
			end
		end
		return original_SaveMacro(self, ...)
	end

	local original_SelectMacro = MacroFrame.SelectMacro
	MacroFrame.SelectMacro = function(self, index, ...)
		original_SelectMacro(self, index, ...)
		if index then
			local actualIndex = self:GetMacroDataIndex(index)
			local name = GetMacroInfo(actualIndex)
			if name and LongMacroDB.macros[name] then
				MacroFrameText:SetText(LongMacroDB.macros[name])
				self.textChanged = nil
			end
		end
	end
end

-- === Events / slash commands =====================================

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, addon)
	if event == "ADDON_LOADED" and addon == ADDON_NAME then
		InitDB()
	elseif event == "ADDON_LOADED" and addon == "Blizzard_MacroUI" then
		HookMacroFrame()
	elseif event == "PLAYER_LOGIN" then
		HookMacroFrame()
	end
end)

SLASH_LONGMACRO1 = "/longmacro"
SLASH_LONGMACRO2 = "/lm"
SlashCmdList["LONGMACRO"] = function(msg)
	msg = msg and msg:match("^%s*(.-)%s*$") or ""
	local cmd, rest = msg:match("^(%S*)%s*(.-)$")
	cmd = (cmd or ""):lower()
	if cmd == "forget" and rest ~= "" then
		LM:Forget(rest)
		print("|cff33ccffLongMacro:|r extended text forgotten for: " .. rest)
	else
		local names = LM:GetNames()
		if #names == 0 then
			print("|cff33ccffLongMacro:|r no extended macros. Open /macro, write more than 255 characters and save normally.")
		else
			print("|cff33ccffLongMacro:|r extended macros: " .. table.concat(names, ", "))
		end
	end
end

-- Short command written automatically into the real macro slot in place
-- of text longer than 255 characters: "/lmrun MyMacroName"
SLASH_LONGMACRORUN1 = "/lmrun"
SlashCmdList["LONGMACRORUN"] = function(msg)
	msg = msg and msg:match("^%s*(.-)%s*$") or ""
	LM:Run(msg)
end
