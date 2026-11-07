-- Cached native stalactites plus a single 20 Hz dust/drip vertex batch.
local V=...
local okInterior,Interior=pcall(V.require,'CaveInterior')
local A={renderer=okInterior and Interior or false};local batch,texture,lastUpdate,lastCount,lastMap;A.stats={}
local budgets={LOW={particles=0,ceiling=8},BALANCED={particles=96,ceiling=16},HIGH={particles=160,ceiling=24}}
function A.budget(quality)return budgets[quality]or budgets.BALANCED end
function A.vertices(anchors,eye,focus,time,count,headroom)
 local out={};if #anchors==0 then return out end
 local dx,dz=focus[1]-eye[1],focus[3]-eye[3];local len=math.sqrt(dx*dx+dz*dz)
 local rx,rz=len>.001 and dz/len or 1,len>.001 and -dx/len or 0
 local ordered={};for _,a in ipairs(anchors)do
  local x,z=a.cx*16+8,a.cy*16+8;ordered[#ordered+1]={anchor=a,d=(x-eye[1])^2+(z-eye[3])^2}
 end
 table.sort(ordered,function(a,b)return a.d<b.d end)
 local n=math.min(8,#ordered)
 for i=1,count do
  local p=ordered[(i-1)%n+1].anchor;local seed=p.seed+i*37
  local drop=i%6==0;local phase=(time*(drop and .65 or .035)+seed*.071)%1
  local x=p.cx*16+4+(seed%8)+math.sin(time*.32+seed)*.7
  local z=p.cy*16+4+(math.floor(seed/8)%8)+math.cos(time*.25+seed)*.7
  local y=drop and (headroom-2)*(1-phase)or 3+phase*(headroom-7)
  local w=drop and .2 or .22+(seed%3)*.07;local h=drop and .8 or w
  y=math.max(h,math.min(headroom-h,y))
  local u0,u1=drop and .5 or 0,drop and 1 or .5
  for _,q in ipairs({{-1,-1,u0,1},{1,-1,u1,1},{1,1,u1,0},{-1,1,u0,0}})do
   out[#out+1]={x+rx*w*q[1],y+h*q[2],z+rz*w*q[1],q[3],q[4],1}
  end
 end
 return out
end
local function sprite()
 if texture then return texture end
 local data=love.image.newImageData(8,4)
 for y=0,3 do for x=0,7 do
  local center=x%4==1 or x%4==2
  data:setPixel(x,y,.65,.72,.82,center and (x<4 and .55 or .75)or 0)
 end end
 texture=love.graphics.newImage(data);texture:setFilter('nearest','nearest');return texture
end
function A.supports(state)
 return V.env.generation==2 and A.renderer and A.renderer.supports and A.renderer.supports(state and state.map)
end
function A.obstacleHeight()
 -- Cave rocks retain the voxel renderer's original silhouette and clearance.
 -- There are no companion wall extensions for the boom camera to avoid.
 return nil
end
function A.drawCeiling(state,atlasFor)
 A.stats.draws,A.stats.particles,A.stats.updates,A.stats.ceilingQuads=0,0,0,0
 if not A.supports(state)then return end
 local map=state.map;local I=A.renderer
 local cfg=_G.__ds_ceiling_config and _G.__ds_ceiling_config()or{}
 local R=V.require('Voxel3D');local budget=A.budget(cfg.quality)
 local third=V.require('ThirdPerson');local boom=third.showsPlayer and third.showsPlayer()
 if cfg.ceiling~=false and cfg.caveformations~=false and(not boom or cfg.third=='FULL')then
  local detail=I.mesh(map,(cfg.headroom or 32)+16,budget.ceiling)
  if detail and detail.ceiling then (R.drawAmbient or R.draw)(detail.ceiling,atlasFor(map),nil);A.stats.draws=1;A.stats.ceilingQuads=detail.ceilingQuads end
 end
end
function A.draw(state,atlasFor)
 if not A.supports(state)then A.stats.draws,A.stats.particles,A.stats.updates,A.stats.ceilingQuads=0,0,0,0;return end
 A.stats.particles,A.stats.updates=0,0
 local map=state.map;local I=A.renderer
 local cfg=_G.__ds_ceiling_config and _G.__ds_ceiling_config()or{}
 local R=V.require('Voxel3D');local budget=A.budget(cfg.quality)
 if cfg.particles==false or budget.particles==0 or state.daytime=='DARK'then return end
 local eye=R.eye or R.camera and R.camera.eye
 local focus=R.camera and R.camera.focus
 if not eye or not focus then return end
 local t=love.timer.getTime();local count=budget.particles
 if not batch or count~=lastCount or map~=lastMap then
  if batch then batch:release();batch=nil end
  lastUpdate=nil;lastCount=count;lastMap=map
 end
 if not lastUpdate or t-lastUpdate>=.05 then
  local vertices=A.vertices(I.layout(map).hangings,eye,focus,t,count,(cfg.headroom or 32)+16)
  if #vertices==0 then return end
  if not batch then
   batch=love.graphics.newMesh(R.FORMAT,vertices,'triangles','dynamic')
   local indices={};for q=0,count-1 do for _,i in ipairs({1,2,3,1,3,4})do indices[#indices+1]=q*4+i end end
   batch:setVertexMap(indices)
  else batch:setVertices(vertices)end
  lastUpdate=t;A.stats.updates=1
 end
 if batch then
  love.graphics.setDepthMode('lequal',false)
  R.draw(batch,sprite(),nil);A.stats.draws=A.stats.draws+1;A.stats.particles=count
 end
end
function A.invalidate()
 if batch then batch:release()end
 batch,lastMap,lastUpdate,lastCount=nil,nil,nil,nil
end
return A
