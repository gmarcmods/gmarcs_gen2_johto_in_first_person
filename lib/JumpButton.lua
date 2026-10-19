-- Extra jump key is camera-only. Native ledges, collision and scripts keep
-- their normal rules; no writes to either generation's player controller.
return function(mod,renderer,effects)
 local scriptRunning=false
 mod.events:on('script.started',function()scriptRunning=true end)
 mod.events:on('script.ended',function()scriptRunning=false end)
 local function jump(game)
  if scriptRunning or mod.options:get('enabled')==false then return false end
  local world=game and (game.world or game.overworld)
  if not world or not renderer.require('FirstPerson').driving(world) then return false end
  local p=world.player
  if not p or p.moving or p.jumping or p.surfing then return false end
  local dx=({left=-1,right=1,up=0,down=0})[p.facing] or 0
  local dy=({left=0,right=0,up=-1,down=1})[p.facing] or 0
  for _,npc in ipairs(world.entities or {})do
   if npc.cellX==p.cellX+dx and npc.cellY==p.cellY+dy then return false end
  end
  return effects.Jump.press()
 end
 mod.hooks:wrap('input.key',function(next,game,ev)
  if ev.phase=='pressed' and ev.key==mod.options:get('jumpkey') and jump(game) then return true end
  return next(game,ev)
 end)
 mod.hooks:wrap('input.gamepad',function(next,game,ev)
  if ev.phase=='pressed' and ev.button==mod.options:get('jumppad')
   and not(ev.joystick and ev.joystick:isGamepadDown('back')) and jump(game) then return true end
  return next(game,ev)
 end)
end
