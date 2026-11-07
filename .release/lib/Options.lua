return function(mod,generation)
  local schema={
    -- Removal is deliberate and opt-IN.  This used to be an ON/OFF
    -- "CEILING PATCH" row, which meant any stored false -- a manager
    -- rewrite, a stale value, a stray click -- silently uninstalled
    -- everything.  Patching is now the default action and cannot be
    -- switched off by accident; taking it out takes a decision.
    { key = "remove", label = "REMOVE PATCH", type = "toggle", default = false },
    { key = "ceiling", label = "CEILING", type = "toggle", default = true },
    { key = "headroom", label = "HEADROOM", type = "choice", default = "AIRY",
      choices = { { "AIRY", "AIRY" }, { "MID", "MID" }, { "SNUG", "SNUG" } } },
    { key = "cutaway", label = "SIMS CUTAWAY", type = "toggle", default = true },
    { key = "shadows", label = "CONTACT SHADOW", type = "toggle",
      default = true },
    { key = "rails", label = "RAIL AND SKIRTING", type = "toggle",
      default = true },
    { key = "spill", label = "DOORWAY LIGHT", type = "toggle",
      default = true },
    { key = "fittings", label = "CEILING LAMPS", type = "toggle",
      default = true },
    { key = "rock", label = "CAVE ROCK", type = "toggle", default = true },
    { key = "apron", label = "WORLD APRON", type = "toggle",
      default = true },
    { key = "talltrees", label = "TALL TREES", type = "toggle",
      default = true },
    { key = "peaks", label = "MOUNTAIN PEAKS", type = "toggle",
      default = true },
    { key = "fastchunks", label = "FAST CHUNKS", type = "toggle",
      default = true },
    { key = "headbob", label = "HEAD BOB", type = "toggle",
      default = false },
    { key = "jumpkey", label = "JUMP KEY", type = "choice",
      default = "space",
      choices = { { "SPACE", "space" }, { "J", "j" },
                  { "L-CTRL", "lctrl" }, { "OFF", "off" } } },
    { key = "jumppad", label = "PAD BUTTON", type = "choice",
      default = "y",
      choices = { { "Y", "y" }, { "X", "x" }, { "OFF", "off" } } },
    { key = "pools", label = "CAVE POOLS", type = "toggle", default = true },
    { key = "sconces", label = "CAVE TORCHES", type = "toggle",
      default = true },
    { key = "bats", label = "BATS", type = "toggle", default = true },
    -- What a boomed-out third-person camera sees overhead, independent
    -- of what the diorama rungs get: nothing at all, the cutaway, or the
    -- sealed room as in first person.
    { key = "third", label = "3RD CEILING", type = "choice",
      default = "CUTAWAY",
      choices = { { "NONE", "NONE" }, { "CUTAWAY", "CUTAWAY" },
                  { "FULL", "FULL" } } },
    { key = "backdrop", label = "HORIZON", type = "toggle", default = true },
    -- Extra panoramas are ordinary files in this mod's folder --
    -- backdrop2.png, backdrop3.png, backdrop4.png -- and appear here as
    -- ALT 1..3.  A missing file falls back to the shipped one rather
    -- than leaving the sky empty.
    { key = "horizonart", label = "HORIZON ART", type = "choice",
      default = "VALLEY",
      choices = { { "KANTO", "KANTO" }, { "FUJI", "FUJI" },
                  { "VALLEY", "VALLEY" }, { "CITY", "CITY" } } },
    { key = "grass", label = "GRASS HEIGHT", type = "choice",
      default = "SUBTLE",
      choices = { { "OFF", "OFF" }, { "SUBTLE", "SUBTLE" },
                  { "WILD", "WILD" } } },
    { key = "particles", label = "PARTICLES", type = "toggle", default = true },
    { key = "ambience", label = "AMBIENT SOUND", type = "choice",
      default = "MID",
      choices = { { "OFF", "OFF" }, { "LOW", "LOW" }, { "MID", "MID" },
                  { "HIGH", "HIGH" } } },
    { key = "grasssfx", label = "GRASS STEPS", type = "toggle",
      default = true },
    { key = "stepsfx", label = "FOOTSTEPS", type = "toggle",
      default = true },
    { key = "doorsfx", label = "DOOR SOUND", type = "toggle",
      default = true },
    { key = "windows", label = "WINDOWS", type = "toggle",
      default = true },
    { key = "ceildetail", label = "CEILING DETAIL", type = "toggle",
      default = true },
    { key = "fpfov", label = "FP FOV", type = "choice",
      default = "NORMAL",
      choices = { { "NARROW", "NARROW" }, { "NORMAL", "NORMAL" },
                  { "WIDE", "WIDE" }, { "ULTRA", "ULTRA" } } },
    { key = "dof", label = "DEPTH BLUR", type = "choice",
      default = "OFF",
      choices = { { "OFF", "OFF" }, { "1", "1" }, { "2", "2" },
                  { "3", "3" } } },
    { key = "rain", label = "RAIN", type = "choice", default = "SOMETIMES",
      choices = { { "OFF", "OFF" }, { "SOMETIMES", "SOMETIMES" },
                  { "ALWAYS", "ALWAYS" } } },
    { key = "umbrellas", label = "NPC UMBRELLAS", type = "toggle",
      default = true },
    { key = "puddles", label = "PUDDLES", type = "toggle", default = true },
    -- Flashing light is a photosensitivity risk. The storm's rain and
    -- thunderheads remain with this off; only the bolts and the screen
    -- brightening go.
    { key = "lightning", label = "LIGHTNING", type = "toggle",
      default = true },
    { key = "lights", label = "LAMPLIGHT", type = "toggle", default = true },
    { key = "shafts", label = "SUN SHAFTS", type = "toggle", default = true },
    { key = "canopy", label = "FOREST CANOPY", type = "toggle", default = true },
    { key = "vines", label = "HANGING VINES", type = "toggle", default = true },
    { key = "fog", label = "LAVENDER FOG", type = "toggle", default = true },
    { key = "doorstep", label = "DOORWAY STEP", type = "toggle", default = true },
    { key = "clouds", label = "CLOUDS", type = "toggle", default = true },
    { key = "stars", label = "NIGHT SKY", type = "toggle", default = true },
    { key = "birds", label = "BIRDS", type = "toggle", default = true },
    { key = "aircraft", label = "AIRCRAFT", type = "toggle", default = true },
    { key = "rainbows", label = "RAINBOWS", type = "toggle", default = true },
    { key = "insects", label = "INSECTS", type = "toggle", default = true },
    { key = "groundflock", label = "GROUND FLOCK", type = "toggle",
      default = true },
    { key = "wind", label = "WIND", type = "choice", default = "BREEZE",
      choices = { { "OFF", "OFF" }, { "BREEZE", "BREEZE" },
                  { "GUSTY", "GUSTY" } } },
    { key = "jump", label = "JUMP FEEL", type = "choice", default = "SUBTLE",
      choices = { { "OFF", "OFF" }, { "SUBTLE", "SUBTLE" }, { "BIG", "BIG" } } },
    { key = "debug", label = "DEBUG HUD", type = "toggle", default = false },
  }
 -- These legacy builders add/redecorate world geometry using Gen 1 rules.
 -- Gen 2's authored assets already own those surfaces and silhouettes.
 local authoredGeometry={talltrees=true,peaks=true,apron=true,canopy=true,vines=true,windows=true,rock=true,
  rails=true,spill=true,fittings=true,shadows=true,ceildetail=true,pools=true,sconces=true,lights=true,grass=true,doorstep=true}
 local filtered={{key='enabled',label='FIRST PERSON EFFECTS',type='toggle',default=true},
  {key='quality',label='EFFECT QUALITY',type='choice',default='BALANCED',choices={{'LOW','LOW'},{'BALANCED','BALANCED'},{'HIGH','HIGH'}}}}
 for _,row in ipairs(schema)do
  if row.key~='remove' and row.key~='fastchunks' and row.key~='talltrees' and not(generation==2 and (authoredGeometry[row.key] or row.key=='umbrellas' or row.key=='horizonart' or row.key=='puddles')) then filtered[#filtered+1]=row end
 end
 if generation==2 then filtered[#filtered+1]={key='caveformations',label='CAVE FORMATIONS',type='toggle',default=true}end
 mod.options:define(filtered)
  local HEADROOM = { AIRY = 32, MID = 24, SNUG = 16 }
  -- Configuration stays private to the companion sandbox.
  local function readConfig()
    local function opt(k, fb)
      local ok, v = pcall(function() return mod.options:get(k) end)
      if ok and v ~= nil then return v end
      return fb
    end
    return {
      ceiling = opt("ceiling", true) ~= false,
      caveformations = opt("caveformations",true) ~= false,
      headroom = HEADROOM[opt("headroom", "AIRY")] or 32,
      cutaway = opt("cutaway", true) ~= false,
      shadows = opt("shadows", true) ~= false,
      rails = opt("rails", true) ~= false,
      spill = opt("spill", true) ~= false,
      fittings = opt("fittings", true) ~= false,
      rock = opt("rock", true) ~= false,
      -- BUILDING BACKS is retired for now: the plain-wall patch on
      -- north faces misfired on several house drawings and in places
      -- covered the door itself. Forced off (and the row removed)
      -- until the face detection is rebuilt; the builder stays in
      -- Flora for that day.
      backs = false,
      apron = opt("apron", true) ~= false,
      talltrees = false, -- Legacy disk-patched lifting is retired; retain native trees.
      peaks = opt("peaks", true) ~= false,
      fastchunks = opt("fastchunks", true) ~= false,
      headbob = opt("headbob", false) == true,
      pools = opt("pools", true) ~= false,
      sconces = opt("sconces", true) ~= false,
      bats = opt("bats", true) ~= false,
      third = opt("third", "CUTAWAY"),
      backdrop = opt("backdrop", true) ~= false,
      horizonart = opt("horizonart", "KANTO"),
      jump = opt("jump", "SUBTLE"),
      grass = opt("grass", "SUBTLE"),
      particles = opt("particles", true) ~= false,
      ambience = opt("ambience", "MID"),
      grasssfx = opt("grasssfx", true) ~= false,
      stepsfx = opt("stepsfx", true) ~= false,
      doorsfx = opt("doorsfx", true) ~= false,
      windows = opt("windows", true) ~= false,
      ceildetail = opt("ceildetail", true) ~= false,
      fpfov = opt("fpfov", "NORMAL"),
      dof = opt("dof", "OFF"),
      rain = opt("rain", "SOMETIMES"),
      umbrellas = opt("umbrellas", true) ~= false,
      puddles = opt("puddles", true) ~= false,
      lightning = opt("lightning", true) ~= false,
      lights = opt("lights", true) ~= false,
      shafts = opt("shafts", true) ~= false,
      canopy = opt("canopy", true) ~= false,
      vines = opt("vines", true) ~= false,
      fog = opt("fog", true) ~= false,
      doorstep = opt("doorstep", true) ~= false,
      clouds = opt("clouds", true) ~= false,
      stars = opt("stars", true) ~= false,
      birds = opt("birds", true) ~= false,
      aircraft = opt("aircraft", true) ~= false,
      rainbows = opt("rainbows", true) ~= false,
      insects = opt("insects", true) ~= false,
      groundflock = opt("groundflock", true) ~= false,
      wind = opt("wind", "BREEZE"),
    }
  end
 local current
 local O={}
 function O.refresh()
  local cfg=readConfig()
  cfg.enabled=mod.options:get('enabled')~=false
  cfg.quality=mod.options:get('quality') or 'BALANCED'
  -- Authored Gold geometry already has trees, mountain shapes and borders.
  -- Keep those models; these legacy additions were tailored to Red tile IDs.
  cfg.preserveAuthored=generation==2
  cfg.perspectiveOnly=generation==2
  if generation==2 then
   for key in pairs(authoredGeometry)do cfg[key]=false end
   cfg.grass='OFF'
   cfg.umbrellas=false
   cfg.puddles=false
   cfg.horizonart='FUJI'
  end
  cfg.fastchunks=false
  if cfg.quality=='LOW' then
   cfg.particles,cfg.insects,cfg.aircraft,cfg.groundflock,cfg.puddles=false,false,false,false,false
  end
  local changed=current==nil
  if current then for k,v in pairs(cfg)do if current[k]~=v then changed=true;break end end end
  if changed then cfg.revision=current and current.revision+1 or 1;current=cfg end
  return current,changed
 end
 function O.current()return current end
 O.refresh()
 return O
end
