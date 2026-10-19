return function(mod,generation)
 local E={generation=generation}
 local Map=require('src.world.Map')
 function E.world()local g=mod.game;return g and (g.world or g.overworld) end
 function E.tileset(map)
  local id=tostring(map and ((map.def and map.def.tileset) or (map.tileset and map.tileset.id)) or '')
  id=id:gsub('^TILESET_','')
  if id=='CAVE' or id=='DARK_CAVE' or id=='ICE_PATH' then return 'CAVERN' end
  if id=='JOHTO' or id=='JOHTO_MODERN' or id=='KANTO' or id=='PARK' then return 'OVERWORLD' end
  if id=='POKECENTER' then return 'POKECENTER' end
  return id
 end
 function E.isOutdoor(map)return map and map.def and Map.isOutdoor(map.def) or false end
 function E.isCanopy(map)return E.tileset(map)=='FOREST' end
 function E.isCave(map)
  local id=E.tileset(map)
  return id=='CAVERN' or id=='UNDERGROUND'
 end
 local grass=setmetatable({},{__mode='k'})
 function E.grassTile(map)
  if map.tileset.grassTile then return map.tileset.grassTile end
  if grass[map]~=nil then return grass[map] or nil end
  for y=0,(map.heightCells or 0)-1 do for x=0,(map.widthCells or 0)-1 do
   if map:isGrassCell(x,y) then
    local tile=map:tileAt(x*2+1,y*2+1);grass[map]=tile;return tile
   end
  end end
  grass[map]=false
 end
 function E.darkness(map)
  local game=mod.game;local w=E.world()
  if generation==2 then
   local palettes=require('src.world.gen2.Palettes')
   return {dark=palettes.isDarkness(map.def,w and w:hour() or 12,false),flash=w and w.flashUsed==true or false}
  end
  local dark=game and game.data and game.data.field and game.data.field.darkMaps
  local id=map.id or map.def.id;local yes=dark and dark[id]==true or false
  for _,name in ipairs(dark and (dark.maps or dark) or {})do if name==id then yes=true end end
  return {dark=yes,flash=game and game.save and game.save.flashLit==true or false}
 end
 -- Read the game's own imported sprites once. Gen 2 uses its native mon
 -- palette and species (Hoothoot/Noctowl/Murkrow), not Red's bird pictures.
 local birds={}
 function E.bird(name,frame)
  local species=name:upper();local key=species..frame
  if birds[key]~=nil then return birds[key] or nil end
  local game=mod.game;local def=game and game.data and game.data.pokemon[species]
  if not def then birds[key]=false;return end
  local ok,img=pcall(function()
   local src=require('src.render.Assets').imageData(def.spriteFront or ('assets/' .. 'generated/battle/front/' .. name .. '.png'))
   local w,h=src:getDimensions();local out=love.image.newImageData(w,h)
   -- Matte only edge-connected paper. Removing every white texel erases
   -- Lugia's body and other light details inside the sprite's outline.
   local paper,queue={},{}
   local function visit(x,y)
    if x<0 or y<0 or x>=w or y>=h then return end
    local key=y*w+x
    if paper[key]~=nil then return end
    local r,g,b,a=src:getPixel(x,y)
    local blank=a<.01 or (r>.95 and g>.95 and b>.95)
    paper[key]=blank
    if blank then queue[#queue+1]={x,y} end
   end
   for x=0,w-1 do visit(x,0);visit(x,h-1) end
   for y=0,h-1 do visit(0,y);visit(w-1,y) end
   local head=1
   while head<=#queue do
    local cell=queue[head];head=head+1
    visit(cell[1]-1,cell[2]);visit(cell[1]+1,cell[2]);visit(cell[1],cell[2]-1);visit(cell[1],cell[2]+1)
   end
   local colors
   if generation==2 then
    local world=E.world()
    colors=require('src.world.gen2.Palettes').monColors(world and world.palettes,species,false)
   end
   local scale=frame=='_b' and .62 or 1
   local nh=math.max(2,math.floor(h*scale));local top=math.floor((h-nh)/2)
   for y=0,nh-1 do for x=0,w-1 do
    local r,g,b,a=src:getPixel(x,math.min(h-1,math.floor(y/scale)))
    if a>0 and not paper[math.min(h-1,math.floor(y/scale))*w+x] then
     if colors then
      local index=r>.83 and 1 or (r>.5 and 2 or (r>.17 and 3 or 4))
      local c=colors[index];r,g,b=c[1]/255,c[2]/255,c[3]/255
     end
     out:setPixel(x,top+y,r,g,b,a)
    end
   end end
   local image=love.graphics.newImage(out);out:release();image:setFilter('nearest','nearest');return image
  end)
  birds[key]=ok and img or false
  return birds[key] or nil
 end
 return E
end
