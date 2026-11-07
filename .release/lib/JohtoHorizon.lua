-- World-aligned background geometry. +Z is south; -Z is north.
-- This crop of the existing Fuji panorama contains mountains and fields,
-- excluding its lighthouse and every city/building in the other panoramas.
local H={SEA_COLOR={0.30,0.53,0.72}}
function H.geometry()
 local land,li,sea,si={},{},{},{}
 local function quad(v,indices,a,b,c,d)
  local n=#v;v[n+1]=a;v[n+2]=b;v[n+3]=c;v[n+4]=d
  for _,i in ipairs({1,2,3,1,3,4})do indices[#indices+1]=n+i end
 end
 local R,N=900,64
 for i=0,N-1 do
  local a,b=i/N*2*math.pi,(i+1)/N*2*math.pi
  local x0,z0,x1,z1=math.cos(a)*R,math.sin(a)*R,math.cos(b)*R,math.sin(b)*R
  if i>=N/2 then
   local function u(j)return (216+512*(1-math.abs((j-N/2)/(N/4)-1)))/2048 end
   -- Collapse the ridge into the horizon at east/west instead of ending
   -- in an abrupt vertical edge. Its compass bearing never drifts.
   local y0=-120+420*math.min(1,math.max(0,-math.sin(a))*4)
   local y1=-120+420*math.min(1,math.max(0,-math.sin(b))*4)
   quad(land,li,{x1,y1,z1,u(i+1),0,1},{x0,y0,z0,u(i),0,1},
    {x0,-120,z0,u(i),1,1},{x1,-120,z1,u(i+1),1,1})
  else
   -- A low ocean band fills the open southern half below sky.
   -- These are backdrop geometry, never collision or real water tiles.
   quad(sea,si,{x1,0,z1,.5,.5,1},{x0,0,z0,.5,.5,1},
    {x0,-1400,z0,.5,.5,1},{x1,-1400,z1,.5,.5,1})
  end
 end
 return land,li,sea,si
end
-- Keep the native hour/display palette, but avoid large high-contrast rings.
local palette,ramp
function H.sky(sky)
 if not(sky and sky.bands and #sky.bands>1)then return sky end
 if palette~=sky.bands then
  palette=sky.bands;ramp={}
  for i=0,31 do
   local at=i/31*(#palette-1);local a=math.floor(at)+1
   local b=math.min(#palette,a+1);local t=at-(a-1)
   ramp[i+1]={}
   for c=1,3 do ramp[i+1][c]=palette[a][c]+(palette[b][c]-palette[a][c])*t end
  end
 end
 local result={};for k,v in pairs(sky)do result[k]=v end
 result.bands=ramp;return result
end
return H
