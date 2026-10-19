-- Reversible composition with exported voxel modules, without disk patches.
local Runtime={}
function Runtime.attach(V,effects,config,onError,atlasFor)
 local Scene,D,F=V.require('VoxelScene'),V.require('Voxel3D'),V.require('FirstPerson')
 local previous={render=Scene.render,beginScene=D.beginScene,endScene=D.endScene,frame=F.frame,fov=F.FOV}
 local okThird,Third=pcall(V.require,'ThirdPerson')
 if not okThird then Third=nil end
 previous.obstacleHeight=Third and Third.obstacleHeight
 local latestConfig=config()
 local context;local handle={draws={},errors={},active=true}
 local function invoke(name,...)
  local component=effects[name]
  if not component or not component.draw then return end
  local G=love and love.graphics
  if G and G.push then G.push('all') end
  local ok,err=pcall(component.draw,...)
  if G and G.pop then G.pop() end
  if ok then handle.draws[name]=(handle.draws[name] or 0)+1
  else
   if handle.errors[name]~=tostring(err) and onError then onError(name,tostring(err)) end
   handle.errors[name]=tostring(err)
  end
 end
 local wrappers={}
 wrappers.render=function(state,...)
  local outer=context
  local cfg=config();latestConfig=cfg
  local enabled=cfg.enabled~=false and (not cfg.perspectiveOnly or F.engaged and F.engaged())
  if enabled then context={state=state,paletteFor=select(5,...)}
  else
   context=nil;F.FOV=previous.fov
   if effects.Flora and effects.Flora.suspend then effects.Flora.suspend() end
  end
  local ok,result=pcall(previous.render,state,...)
  context=outer
  if not ok then error(result,0) end
  return result
 end
 wrappers.beginScene=function(...)
  local ready=previous.beginScene(...)
  if ready and context then
   invoke('Backdrop',context.state);invoke('SkyLayer',context.state)
   local cave=effects.CaveAtmosphere
   if cave and cave.supports and cave.supports(context.state)then
    local function atlas(map)return atlasFor and atlasFor(context.state,map,context.paletteFor)end
    invoke('Ceiling',context.state,atlas);invoke('CaveCeiling',context.state,atlas)
    context.earlyCeiling=true
   end
  end
  return ready
 end
 wrappers.endScene=function(...)
  if context then
   local function atlas(map)return atlasFor and atlasFor(context.state,map,context.paletteFor) end
   if not context.earlyCeiling then invoke('Ceiling',context.state,atlas)end
   invoke('Doorways',context.state,atlas);invoke('Flora',context.state,atlas);invoke('CaveAtmosphere',context.state,atlas)
  end
  return previous.endScene(...)
 end
 wrappers.frame=function(me,...)
  local rig,x,z=previous.frame(me,...)
  if rig and me and context and effects.Jump then
   local J=effects.Jump
   local dy=J.eyeOffset(me)+(J.buttonOffset and J.buttonOffset() or 0);local dx,dz=J.swayX(me),J.swayZ(me)
   for _,point in ipairs({rig.eye,rig.focus})do
    if point then point[1],point[2],point[3]=point[1]+dx,point[2]+dy,point[3]+dz end
   end
   x,z=x and x+dx,z and z+dz
  end
  return rig,x,z
 end
 wrappers.obstacleHeight=function(ow,map,cx,cy)
  local cave=effects.CaveAtmosphere
  if latestConfig.enabled~=false and cave and cave.obstacleHeight then
   local h=cave.obstacleHeight(ow,map,cx,cy,latestConfig)
   if h then return h end
  end
  if previous.obstacleHeight then return previous.obstacleHeight(ow,map,cx,cy)end
 end
 if Third then Third.obstacleHeight=wrappers.obstacleHeight end
 Scene.render,D.beginScene,D.endScene,F.frame=wrappers.render,wrappers.beginScene,wrappers.endScene,wrappers.frame
 function handle:detach()
  if Scene.render==wrappers.render then Scene.render=previous.render end
  if D.beginScene==wrappers.beginScene then D.beginScene=previous.beginScene end
  if D.endScene==wrappers.endScene then D.endScene=previous.endScene end
  if F.frame==wrappers.frame then F.frame=previous.frame end
  F.FOV=previous.fov
  if Third and Third.obstacleHeight==wrappers.obstacleHeight then Third.obstacleHeight=previous.obstacleHeight end
  if self.onDetach then self.onDetach() end
  self.active=false
  for _,module in pairs(effects)do if module.invalidate then module.invalidate() end end
 end
 return handle
end
return Runtime
