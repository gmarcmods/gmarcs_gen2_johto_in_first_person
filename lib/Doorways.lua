-- Exit cues for native directional warps. Never grow wall-based furniture.
local V=...
local D={};local cache=setmetatable({},{__mode='k'});local textures={}
local dirs={[0x70]='down',[0x76]='left',[0x78]='up',[0x7e]='right'}
function D.layout(map)
 local out={}
 if V.env.generation~=2 then return out end
 for _,w in ipairs(map.def.warps or {})do
  local dir=dirs[map:cellCollision(w.x,w.y)]
  if dir then
   local x,z=w.x*16,w.y*16
   if dir=='down'then z=z+16 elseif dir=='right'then x=x+16 end
   out[#out+1]={x=x,z=z,direction=dir,cave=V.env.isCave(map)}
  end
 end
 return out
end
local function image(cave)
 local key=cave and 'rock'or'door'
 if textures[key]then return textures[key]end
 local data=love.image.newImageData(16,24)
 for y=0,23 do for x=0,15 do
  local edge=x<2 or x>13 or y<2;local r,g,b
  if edge then r,g,b=.48,.42,.32 else r,g,b=.055,.065,.075 end
  if y==2 or x==2 or x==13 then r,g,b=.22,.20,.17 end
  local a=1
  if cave then
   local radius=math.abs(x-7.5)
   if y<math.max(0,math.floor(radius-5))then a=0 end
   local opening=x>=3 and x<=12 and y>4+math.max(0,math.floor(radius-3))
   if opening then r,g,b=.04,.045,.055 else
    local shade=((x*3+y*5)%7)/35;r,g,b=.36+shade,.34+shade,.31+shade
   end
  end
  data:setPixel(x,y,r,g,b,a)
 end end
 local tex=love.graphics.newImage(data);tex:setFilter('nearest','nearest');textures[key]=tex;return tex
end
function D.draw(state)
 local map=state and state.map;if not map or V.env.generation~=2 then return end
 local R=V.require('Voxel3D');local entry=cache[map]
 if not entry then
  local verts,indices={},{}
  for _,d in ipairs(D.layout(map))do
   local function point(u,y,depth)
    if d.direction=='down'then return {d.x+u,y,d.z+depth}
    elseif d.direction=='up'then return {d.x+16-u,y,d.z-depth}
    elseif d.direction=='right'then return {d.x+depth,y,d.z+16-u}
    else return {d.x-depth,y,d.z+u}end
   end
   local b=#verts
   for _,v in ipairs({{0,0,0,1},{16,0,1,1},{16,24,1,0},{0,24,0,0}})do
    local p=point(v[1],v[2],-.2);verts[#verts+1]={p[1],p[2],p[3],v[3],v[4],1}
   end
   for _,i in ipairs({1,2,3,1,3,4})do indices[#indices+1]=b+i end
  end
  entry={mesh=#verts>0 and R.newMesh(verts,indices)or false};cache[map]=entry
 end
 if entry.mesh then R.draw(entry.mesh,image(V.env.isCave(map)),nil)end
end
function D.invalidate()
 for _,entry in pairs(cache)do if entry.mesh then entry.mesh:release()end end
 cache=setmetatable({},{__mode='k'})
end
return D
