-- Standalone: luajit mods/gen2/johto-first-person/tests/gmarcs_gen2_johto_in_first_person_test.lua
package.path = "./?.lua;./?/init.lua;" .. package.path

local T = require("tests.modkit")
local Data = require("src.core.Data")
Data:load()

-- The mod hard-depends on the voxel mod, and the SDK only sees the paths it is
-- given, so the dependency has to be passed too.
local run = T.sdk.loadMods({ "mods/johto_first_person", "mods/voxel_mod" },
  { data = Data, generation = 2 })
local mod = run.mods["gmarcs_gen2_johto_in_first_person"]
T.eq(#run.errors, 0, "loads clean (" .. tostring(run.errors[1]) .. ")")
T.eq(mod and mod.state, "loaded", "reached the loaded state")
T.eq(mod and mod.manifest.id, "gmarcs_gen2_johto_in_first_person",
  "mod id is gmarcs_gen2_johto_in_first_person")

run.release()
T.finish("gmarcs_gen2_johto_in_first_person")
