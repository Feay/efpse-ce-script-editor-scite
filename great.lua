-- lua BullSHit with set a set of elements as a set list...this was nessary for serach for match and get a bool result, but that is not used any more, we want match literal with length of element later 
--may this is unessary but lua is weird
function Set (list)
   local set = {}
   for _, l in ipairs(list)
   do
      set[l] = true
   end
   return set
end

local proc = Set { "procedure","end","end;" }
local flow = Set { "if", "{", "}", "(",")","else" }
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

local offnum = 0

function OnStyle(styler)
		--anything not an identifer or found word is default, 
        local S_DEFAULT = 0
		--anything keywords canstart with, style, but are't key words, should be the same color as default
        local S_STRINGS = 1
		--comments anyline that has a comment, comments not on newline are ignored since efpse is touche
		local S_COMMENT = 2
		--all lines that start with a space are BAD LINES since efpse does not like indents
        local S_BADLINE = 3
		-- keywords and whatever else we wanna styleize
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
-- start styling!
        styler:StartStyling(styler.startPos, styler.lengthDoc, styler.initStyle)
        while styler:More() do
-- loop till end of doc, and swtich style state below as we move forwards
                -- Exit current set style state back to default upon moving forwards nth degree
                if styler:State() == S_STRINGS then
							if styler:Match("\"") then			-- have to escape the "  glyph
                                styler:ForwardSetState(S_DEFAULT)
                        end
				-- for whole line style till then end of it		
                elseif styler:State() == S_COMMENT or styler:State() == S_BADLINE then
                        if styler:Match("\r\n") then
                                styler:ForwardSetState(S_DEFAULT)
                        end
				elseif styler:State() > 3 then --proc or greater, style state already set so move it forward lenght of match saved via offnum..the math works okay even for single glyph matches such as: > < ( ) { }
								for i =1, offnum-1 do styler:Forward() end
                                styler:SetState(S_DEFAULT)
                end

                -- Enter state if needed
                if styler:State() == S_DEFAULT then
						if styler:Match("\"") then		-- have to escape the "  glyph
                                styler:SetState(S_STRINGS)
                        elseif styler:Match("//") then
                                styler:SetState(S_COMMENT)
						elseif styler:Match(" ") and  styler:AtLineStart() or styler:Match(" \r\n") or styler:Match("\t\r\n") then
                             styler:SetState(S_BADLINE)			
						end

							 for k in pairs(proc) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD1 ) end end
							 
							 for k in pairs(flow) do if styler:Match(k) then
										offnum = #k
							 styler:SetState(S_KEYWORD2 ) end end
							 
							for k in pairs(comp2) do if styler:Match(k) then		--must be before comp other wise >= gets restyled to >, so style  > then check and restyle for  >=
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

               styler:Forward()
        end
        styler:EndStyling()
end