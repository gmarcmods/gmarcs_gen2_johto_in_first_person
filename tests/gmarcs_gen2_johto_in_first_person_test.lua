-- Standalone: luajit mods/gen2/johto-first-person/tests/gmarcs_gen2_johto_in_first_person_test.lua
package.path = "./?.lua;./?/init.lua;" .. package.path

local T = require("tests.modkit")
local Data = require("src.core.Data")
Data:load()

local run = T.sdk.loadMod("mods/johto_first_person", { data = Data, generation = 2 })
T.eq(#run.errors, 0, "loads clean (" .. tostring(run.errors[1]) .. ")")
T.eq(run.mod and run.mod.state, "loaded", "reached the loaded state")
T.eq(run.mod.manifest.id, "gmarcs_gen2_johto_in_first_person", "mod id is gmarcs_gen2_johto_in_first_person")

run.release()
T.finish("gmarcs_gen2_johto_in_first_person")
