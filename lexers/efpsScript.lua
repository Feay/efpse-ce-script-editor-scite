--[[************Easy-FPS-Editor Lexer by Fenir 'skunk' Stardust Jan2025******]]
local currentLevel = 0
local prevFoldLevel = 0
local lineNumber = 0
local lev = 0
local switchfold =0
local offnum = 0
local debugset       = props["efpsScript.debug"]

--[[function for making lists sets, I still don't know what this does]]
function Set (list)
   local set = {}
   for _, l in ipairs(list)
   do
      set[l] = true
   end
   return set
end
--[[************DEFINE LISTS for searching & styles********************]]
local foldstart = Set { "procedure","{"}
local foldend = Set { "end","end;", "}" }
local proc = Set { "procedure","end","end;" }
--local proc2 = Set { "end","end;" }
local flow = Set { "if","{", "}", "(",")","} else {" }
local comp = Set { ">=", "<=","!=","==" }
local comp2 = Set {">","<"}  -- ensure that > gets styled before >= below in match check section so that  > becomes > styled then  >= becomes >= styled else if after, >= gets restyled to > and = does not get styled
local oprands = Set { "+=", "-=","/=","*=","++","--","%="}
local types = Set { "global", "map", "local" } --these are seperate searches
local typesL = Set { "$global", "$map", "$local" } 
local map = Set { "map start","map return","map next","map goto", "map quickreturn", "keeptrigger", "pause", "halt","auto", "time out", "call", "bind", "unbind" }
local builtins = Set { "SIN","COS","TAN","ASIN","ACOS","ATAN","ATAN2","POWER","SQRT","ABS","FLOOT","CEIL","CLAMP","MIN","MAX","ROUND","RANDOM","gravity","game save slot","game save auto","game load slot","game load auto", "check resolution"}
local player = Set {"player heal","player hurt","player teleport","player move","player rotation","player retro","player turn","player steps","player speed","player sethp","player setmaxhp","player givearmour","player takearmour","player setarmour","player setmaxarmour","player cancrouch","player canjump","player height","player weapon holster","player zoom","player camspeed","player check hp","player check maxhp","player check armour","player check maxarmour","player check key","player check weapon","player check ammo","player check mag","player check heldweapon","player check position ","player check rotation","player velocity","player jumpheight"}
local entiy = Set { "entity delete","entity delete","entity move","entity spawnat","entity spawnatpos","entity spawn tile","entity spawn precise"}
local door = Set { "door open","door close","door lock","door unlock"}
local lightsshaders = Set { "light create","light move","light status","light offset","flashlight state","flashlight lock","flashlight range","flashlight colour","flashlight radius","light ambient","light sun colour","light sun direction","skybox texture","fog colour","fog distance","shader texture","shader bool","shader set"}
local hudstuff = Set {"status","hud image","hud image","hud autoscal","hud text","cursor"}
local giventake = Set {"give weapon","give ammo","give key","take weapon","take ammo","take key"}
local weaps = Set {"weapon maxammo","weapon magsize","weapon damage","weapon firerate","weapon bullets","weapon reloadspeed","weapon projectilespeed","weapon explosion","weapon recoil","weapon spread","weapon recoilrecovery"}
local cutscene = Set {"vn","vn speed","text","font","preload","image","sound","show","bg","hide","play sound","play music","play video","stop music","stop sound","stop sounds","button","label","move","front","back"}
--[[*********Scite OnStyle, main function start styler*************]]
function OnStyle(styler) 
		currentLevel = 0		-- ensure these are cleared for restyle after text entry
		prevFoldLevel = 0
		lineNumber = 0
		lev = 0
        local S_DEFAULT = 0
        local S_STRINGS = 1 --comments not on newline are ignored since efpse is touche
		local S_COMMENT = 2 --all lines that start or end with a space are BAD LINES
        local S_BADLINE = 3 -- keywords and whatever else we wanna styleize below
        local S_KEYWORD1 = 4
		local S_KEYWORD2 = 5
		local S_KEYWORD3 = 6
		local S_KEYWORD4 = 7
		local S_KEYWORD5 = 8
		local S_KEYWORD6 = 9
		local S_KEYWORD7 = 10
		local S_KEYWORD8 = 11
		local S_KEYWORD9 = 12
		local S_KEYWORD10 = 13
		local S_KEYWORD11 = 14
		local S_KEYWORD12 = 15
		local S_KEYWORD13 = 16
		local S_KEYWORD14 = 17
		local S_KEYWORD15 = 18
		local S_KEYWORD16 = 19
		local S_KEYWORD17 = 20
--[[*********Main LOOP start styling********************************]]
        styler:StartStyling(styler.startPos, styler.lengthDoc, styler.initStyle)	--bool OnStyle(unsigned int, int, int, Accessor *);	 
        while styler:More() do
			--style if not default state, move pointer forward length of match, offnum
                if styler:State() == S_STRINGS then
							if styler:Match("\"") then			-- have to escape the "  glyph
                                styler:ForwardSetState(S_DEFAULT)
                        end
			-- for whole line style till then end of it		
                elseif styler:State() == S_COMMENT or styler:State() == S_BADLINE then
                        if styler:Match("\r\n") then
                                styler:ForwardSetState(S_DEFAULT)
                        end
				elseif styler:State() > 3 then 
				--proc or greater, style state already set so move it forward lenght of match saved via offnum..the math works single glyph matches such as: > < ( ) { }
								for i =1, offnum-1 do styler:Forward() end
                                styler:SetState(S_DEFAULT)
                end

--[[ *******************DEFAULT STATE********************************]]
                if styler:State() == S_DEFAULT then
				--style single thing logic until end of thing or line hence
						if styler:Match("\"") then  -- have to escape the "  glyph
                                styler:SetState(S_STRINGS)
                        elseif styler:Match("//") then
                                styler:SetState(S_COMMENT)
						elseif styler:Match(" ") and  styler:AtLineStart() or styler:Match(" \r\n") or styler:Match("\t\r\n") then
                             styler:SetState(S_BADLINE)			
						end
				--style if match with list logic
							 for k in pairs(proc) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD1 ) end end
							  
							 for k in pairs(flow) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD2 ) end end
							 
							for k in pairs(comp2) do if styler:Match(k) then		
							--comp2 must be before comp else >= gets restyled to > and then >= never
										offnum = #k
							 styler:SetState(S_KEYWORD3 ) end end
							 
							 for k in pairs(comp) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD3 ) end end
														 
							 for k in pairs(oprands) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD4 ) end end
							 
							 for k in pairs(types) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD5 ) end end
							 
							 for k in pairs(typesL) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD6 ) end end
							 
							for k in pairs(map) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD7 ) end end
							 
							 for k in pairs(builtins) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD8 ) end end
							 
							 for k in pairs(player) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD9 ) end end
							 
							 for k in pairs(entiy) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD10 ) end end
							 
							 for k in pairs(door) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD11 ) end end
							 
							 for k in pairs(lightsshaders) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD12 ) end end
							 
							 for k in pairs(hudstuff) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD13 ) end end
							 
							 for k in pairs(giventake) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD14 ) end end

							 for k in pairs(weaps) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD15 ) end end
							 
							 for k in pairs(cutscene) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD16 ) end end
							 
                end
               styler:Forward()		-- move forwards after \r\n to next line
        end --while loop end
        styler:EndStyling()
		
--[[***********FOLDING LOGIC*****************
it is nessary to walk the entire file again since style only updates what it needs too on the fly
however we only are checking here for a few words to match
]]
	local linetotal=editor.LineCount - 1
	
	for i = 0, linetotal do
	lineNumber=i  --must use this to transfer line number to folding function
	FoldDocument(styler)
		local lengthLine = editor:PositionFromLine(i+1) - editor:PositionFromLine(i)
        local lineText = editor:GetLine(i)
	local hitstart, hitend = string.find(lineText, "procedure") 
	if(hitstart==1) then currentLevel=currentLevel+1
			FoldDocument(styler)
				 end
		
			for k in pairs(foldstart) do local hitstart, hitend = string.find(lineText, k.."\r\n")  if(hitstart ~= nil ) then --print("FOUND  START")
			currentLevel=currentLevel+1
			FoldDocument(styler)
				 end end
				 
			for k in pairs(foldend) do local hitstart, hitend = string.find(lineText, k.."\r\n")  if(hitstart ~= nil ) then --print("FOUND END")
			currentLevel=currentLevel-1
			FoldDocument(styler)
				 end end
				 
		if(i==linetotal) then
			for k in pairs(foldend) do local hitstart, hitend = string.find(lineText, k)  if(hitstart ~= nil ) then 
				if(#k == lengthLine ) then --print("found end of LAST LINE line") 
				currentLevel=currentLevel-1
				FoldDocument(styler)
				end
		end end
		
		end
		
--********DEBUG for FOLDING******************************************
	if (debugset == "1") then
	-- Get the fold level of the line
	local foldLvl = editor.FoldLevel[i]
	print("foldmask: "..foldLvl)
	-- Calculate the fold number
	local foldNumber = (foldLvl & SC_FOLDLEVELNUMBERMASK) - SC_FOLDLEVELBASE
	-- Get the header flag
	local headerFlag = (foldLvl & SC_FOLDLEVELHEADERFLAG) == SC_FOLDLEVELHEADERFLAG
print(string.format("Line %d, has a fold level of %d", i + 1, foldNumber))
	if headerFlag then
	print("\tand it is a fold point") 
	end
	end
	
end
end --end of onstyler main function

--******************FOLDING******************************************
function FoldDocument(styler)
  --~~~~~~~~-- Prevent the fold level from dropping below zero.~~~~~~~~~~
  if currentLevel < 0 then
    currentLevel = 0
  end
  --~~~~~~~~~~~~~~~~~~~~~~~~~[ FOLD ]~~~~~~~~~~~~~~~~~~~~~~~~~~
	lev = prevFoldLevel 
	local foldlevel = lev + SC_FOLDLEVELBASE
	
    if (currentLevel > prevFoldLevel) then
		foldlevel = foldlevel + SC_FOLDLEVELHEADERFLAG
    end
	
   if lev ~= styler:LevelAt(lineNumber) then
      styler:SetLevelAt(lineNumber, foldlevel)
    end
    prevFoldLevel = currentLevel

end -- end of FoldDocument function

--[[***********INFORMATION******************************]]
--[[ print(editor:LineFromPosition(styler.Position())) -- gets line at the position seen, line 0 being line 1 so off by 1 in the editor ]]
--[[
    SC_FOLDLEVELHEADERFLAG = 0x2000 | 8192 | 0b10000000000000
    SC_FOLDLEVELWHITEFLAG  = 0x1000 | 4096 | 0b1000000000000
    SC_FOLDLEVELNUMBERMASK = 0xFFF  | 4095 | 0b111111111111
    SC_FOLDLEVELBASE       = 0x400  | 1024 | 0b10000000000
]]
--[[*******DOCS
https://scintilla.sourceforge.io/SciTEExtension.html
https://scintilla.sourceforge.io/ScintillaDoc.html
Some good references that'll help when scripting SciTE with Lua:

    http://www.scintilla.org/ScintillaDoc.html
    http://www.scintilla.org/ScriptLexer.html
    http://lua-users.org/wiki/UsingLuaWithScite
]]