local mod,generation=...
local function own(name)
 local source=assert(mod:read('lib/'..name..'.lua'),'Missing first-person module '..name)
 return assert(load(source,'@'..mod.path..'/lib/'..name..'.lua'))
end
local Options=own('Options')()(mod,generation)
local Env=own('Environment')()(mod,generation)
local Runtime=own('Runtime')()
local effects,handle,base={}
mod.exports.errors={}
mod.exports.generation=generation
local function report(name,err)
 mod.exports.errors[name]=err
 mod.log:warn(name..': '..err)
end
_G.__ds_ceiling_config=Options.current -- private to THIS mod's sandbox
_G.__ds_posters_dir=mod.assets:path('assets')..'/'
local function configuration()
 local old=Options.current()
 local cfg,changed=Options.refresh()
 local panoramas={KANTO='backdrop.png',FUJI='backdrop2.png',VALLEY='backdrop3.png',CITY='backdrop4.png'}
 _G.__ds_backdrop_path=mod.assets:path('assets/'..(generation==2 and 'backdrop2.png' or panoramas[cfg.horizonart] or 'backdrop.png'))
 if not cfg.enabled and effects.Flora then effects.Flora.suspend() end
 if old and old.quality~=cfg.quality and effects.SkyLayer then effects.SkyLayer.invalidate() end
 if changed then
  for _,name in ipairs({'Ceiling','Flora'})do
   if effects[name] and effects[name].invalidate then effects[name].invalidate() end
  end
 end
 return cfg
end
local ids=generation==1 and {'DRAMATIC_SHAPE','BATTLE_ART_VOXEL_FORK','DRAMALESS_SHAPE','TERRARIUM'} or {'gmarcs_gen2_voxel_mod','GEN2_VOXEL'}
local function attach()
 if handle then return true end
 for _,id in ipairs(ids)do
  local candidate=mod.find(id)
  if candidate and candidate.exports and candidate.exports.lib then base=candidate.exports.lib;mod.exports.renderer=id;break end
 end
 if not base then mod.exports.status='Enable a compatible voxel mod first';return false end
 local V={mod=mod,env=Env,assets=mod.assets,require=function(name)
  return base.require(name)
 end}
 for _,name in ipairs({'Ceiling','Flora','SkyLayer','Backdrop','Jump','Doorways','CaveAtmosphere'})do
  local ok,result=pcall(function()return own(name)(V)end)
  if not ok then report(name,result);return false end
  effects[name]=result
 end

 effects.CaveCeiling={draw=effects.CaveAtmosphere.drawCeiling}
 Env.caveRenderer=effects.CaveAtmosphere.renderer
 configuration()
 handle=Runtime.attach(base,effects,configuration,report,function(state,map,paletteFor)
  if generation==2 then return base.require('Gen2').goldAtlas(state,map) end
  return base.require('TerrainAtlas').forMap(map,paletteFor and paletteFor(map) or nil)
 end)
 own('JumpButton')()(mod,base,effects)
 mod.exports.status='Active';mod.exports.runtime=handle;mod.exports.effects=effects
 mod.exports.environment=Env
 return true
end
mod.exports.attach=attach
mod.exports.config=Options.current
mod.exports.active=function()return handle~=nil and handle.active and Options.current().enabled end
mod.exports.telemetry=function()
 return {ceiling=_G.__ds_ceiling_status,flora=_G.__ds_flora_status,sky=_G.__ds_sky_status,backdrop=_G.__ds_backdrop_status}
end
-- Input steps run even in menus and in 2D, so ambient loops cannot be left
-- playing when the voxel draw stops. No global love.update replacement.
mod.hooks:wrap('input.step',function(next,game,dt)
 local sound=rawget(_G,'__ds_amb_state')
 if sound and love.timer.getTime()-sound.beat>.5 then
  for key,source in pairs(sound.srcs)do
   if source and sound.LOOPS[key] then
    local volume=source:getVolume()*math.exp(-6*(dt or 1/60))
    source:setVolume(volume);if volume<.01 then source:stop() end
   end
  end
 end
 return next(game,dt)
end)
mod.events:on('game.ready',function()
 local ok,result=pcall(attach)
 if not ok then report('integration',result) end
end)
attach()
