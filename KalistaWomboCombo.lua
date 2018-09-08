if myHero.charName ~= "Kalista" then return end

function OnLoad()
	PrintChat("WOMBOCOMBO by Pussykate")
end	

 
--Locals
local CastSpell     = Control.CastSpell
local CanUseSpell   = Game.CanUseSpell
local Hero          = Game.Hero
local HeroCount     = Game.HeroCount
 
-- Spell Data
local rRange    = 1100
local swornAlly = nil



 -- Menu
local Menu = MenuElement({type = MENU, id = "WomboCombo by RMAN and Pussykate", name = "PussyWomboCombo"})
Menu:MenuElement({id = "Blitz", name = "Use R on Blitzcrank Grab", value = true})
Menu:MenuElement({id = "Skarner", name = "Use R on Skarner Ult", value = true})
Menu:MenuElement({id = "MyHP", name = "Kalista min.Hp to UseR",  value = 40, min = 0, max = 100, step = 1})
Menu:MenuElement({id = "TargetHP", name = "Target min.Hp to UseR",  value = 30, min = 0, max = 100, step = 1})

-- Common
local function Ready(slot)
    return CanUseSpell(slot) == 0
end
 
local function GetDistanceSqr(p1, p2) 
    local dx, dz = p1.x - p2.x, p1.z - p2.z 
    return dx * dx + dz * dz
end

local function getPercentHP(unit)
	return unit.health * 100 / unit.maxHealth
end

	
local function GetSwornAlly()   
    for i = 1, HeroCount() do
        local hero = Hero(i)
        if hero and hero.isAlly and GotBuff(hero, "kalistacoopstrikeally") == 1 then            
            return hero.charName == "Blitzcrank" and hero or "Wrong Oath" or
			hero.charName == "Skarner" and hero or "Wrong Oath" 
			
		end
    end 
end
 
local function ExecuteBalista()
    for i = 1, HeroCount() do
        local enemy = Hero(i)
        if enemy and enemy.isEnemy and GotBuff(enemy, "rocketgrab2") == 1  then          
            CastSpell(HK_R)
            return
        end
    end 
end	


local function ExecuteSkarlista()
    for i = 1, HeroCount() do
        local enemy = Hero(i)
        if enemy and enemy.isEnemy and GotBuff(enemy, "SkarnerImpale") == 1  then          
            CastSpell(HK_R)
            return
        end
    end 
end




local function OnTick()
    if not swornAlly then
        swornAlly = GetSwornAlly()
    end
	for i = 1, HeroCount() do
    local enemy = Hero(i)
    --
    if swornAlly and Menu.Blitz:Value() and Ready(_R) and GetDistanceSqr(swornAlly.pos, myHero.pos) <= rRange * rRange and getPercentHP(myHero) >= Menu.MyHP:Value() and getPercentHP(enemy) >= Menu.TargetHP:Value() then
        ExecuteBalista() 
    end
	if swornAlly and Menu.Skarner:Value() and Ready(_R) and GetDistanceSqr(swornAlly.pos, myHero.pos) <= rRange * rRange and getPercentHP(myHero) >= Menu.MyHP:Value() and getPercentHP(enemy) >= Menu.TargetHP:Value() then
        ExecuteSkarlista()
    end
end
end	







 
Callback.Add("Tick", OnTick)