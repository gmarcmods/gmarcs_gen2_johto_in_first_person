# Johto in First Person 1.0.1

A companion for modern gen1recomp, installed alongside **NEW_MOD_EX**.
Adds interiors with ceilings, textured cave roofs and rock, forest canopy,
native grass, birds, skies, horizon, weather and ambient sound to the voxel
renderer. This mod does not include a voxel renderer or any ROM data.

## Install

Import `JOHTO_FIRST_PERSON.zip` and `NEW_MOD_EX.zip` through the engine's
mod importer. Enable both in the Mods menu and restart the game. Use the
appropriate game generation: Gold, Silver or Crystal.
Choose **VOXEL → 1ST** or **3RD** in the game's options (or cycle with `3`).
The companion does not force your camera or modify your save.

Use the complete NEW_MOD_EX project for the authored Johto furniture and terrain. GEN2_VOXEL is the runtime/editor with minimal fallback data; it is not the complete authored world.

## Controls and settings

The voxel mod owns the camera: mouse/right stick/touch drag to look; arrows,
left stick or touch d-pad to walk relative to it. Existing engine menus,
collision and native ledges remain in charge.

The companion settings are in the Mods menu. **FIRST PERSON EFFECTS** disables
all companion drawing. **EFFECT QUALITY** defaults to BALANCED; LOW reduces
clouds, birds and rain and disables particles, insects, aircraft, ground flocks
and puddles. HIGH restores the larger effect budgets. Individual options
control ceiling/headroom, third-person cutaway, weather, sky, sound, grass,
FOV and jump feel. Keep the renderer's AA and water-reflection settings low
on slower devices; those costs belong to the renderer.

Space (pad Y by default, configurable) makes a short camera hop during idle
first/third-person roaming. It never crosses walls or replaces native ledge
movement. It passes controls through in menus, scripts and near an NPC.

## Modernization

Shared code is in `mods/shared/first-person-effects`; `lib/` and `assets/` are
relative development links. `scripts/export-mods.py` materializes these into
a self-contained companion ZIP. Do not ZIP this source folder directly.
Runtime hooks replace the old file patcher and global callback replacements.
Disabling effects restores the camera FOV and releases ambient sound.
Legacy FAST CHUNKS/removal controls and patched TALL TREES lifting are retired;
the voxel renderer keeps its native tree models.

Johto reads Gen 2 tiles, palettes and imported Pokémon sprites, including Hoothoot and Noctowl. Red-specific mountain/tree/apron overlays are omitted to preserve the complete authored Gen 2 geometry.

Original presentation code/assets: mrmushrooms11's Kanto in First Person,
upstream commit `94d0151` (original version 1.57.2). Modern runtime integration,
native Gen 2 adapter and quality controls are maintained in this workspace.
See the shared project's README and `docs/architecture.md` for development.

## Preserve the authored world (1.0.1)

Effects run only in 1ST/3RD. The angled voxel views are unchanged. Furniture
that uses a wall primitive is never extended into a room wall. The companion
keeps an overhead room enclosure but does not repaint doors, add posters or
windows, extend interior objects, or generate replacement forest/tree/rock/
grass geometry. Those surfaces belong to NEW_MOD_EX's authored models.
Unsafe legacy geometry controls are omitted from Johto's menu, including
previously saved enabled values. The renderer's Ilex canopy classification is
also left unchanged. Sky, weather, wildlife, sound and camera options remain.

The regression probe `mods/shared/first-person-effects/tests/authored_geometry.lua`
captures matched on/off views of the initial house, Elm's lab, New Bark and
Ilex Forest at angled, first-person and third-person cameras. It checks
pixel equality in angled mode. A separate geometry test verifies that an
authored cabinet using the wall primitive receives no added vertical faces.
Restart after importing the updated ZIP to replace the old runtime hooks.

## Horizon, 1.0.3

The distant backdrop uses only building-free mountain artwork on the northern
half of the compass. The south shows open sea and sky, with no painted cities
or mountains. Old HORIZON ART city settings are ignored; HORIZON still toggles
the backdrop. Native map buildings and authored voxel geometry remain intact.

## Cave enclosure, 1.0.6

Install with NEW_MOD_EX 0.1.36 for the mountain-cave repairs. JIFP keeps its
optional roof/upper walls/effects; the voxel mod owns native rock surfaces
and native ladder models. Passable landings stay clear, upward ladders have
roof openings, and upper wall extensions align with the base rock faces.
Third-person camera clearance includes the added enclosure and respects
NONE/OFF and the cutaway; disabling/detaching removes that contribution.
No authored asset or native map collision is rewritten.

The runtime's gold_cave_coherence_probe.lua covers four Mt. Mortar floors
and Mt. Moon with both cameras and companion OFF/ON. Its
 gold_cave_traversal_probe.lua walks through native upward/downward ladder
warps. See ../voxel-runtime/docs/cave-interiors.md for tests and boundaries.

## Native cave rock silhouettes, 1.0.7

Removes the companion's vertical wall extensions above native cave rocks and
its synthetic full-height boundary faces in Gen 2 caves. The authored voxel
rocks retain their original shape; the overhead rock ceiling, ladder openings,
stalactites and particle options remain. Removed extensions no longer add
invisible obstacles to the third-person camera. Building walls and Gen 1
interiors retain their existing behavior. No voxel profile is changed.

1.0.7 verification: Gold before/after captures cover UNION_CAVE_1F,
DARK_CAVE_VIOLET_ENTRANCE and ICE_PATH_1F in both cameras. Native cave geometry,
roof openings and removed camera obstacles pass unit checks. The authored
geometry driver passed the house, lab, exterior and forest comparisons,
including byte-identical angled views. The driver now freezes native World.step
as well as update so an NPC turning cannot invalidate a matched comparison.
Physical Android was not tested.

## Cave readability, 1.0.8

Install with NEW_MOD_EX **0.1.43**. The voxel runtime also had an independent
rock-cap layer; that layer is now removed, and native walkable water banks
stay low; native directional cave edges also stay short instead of becoming
full-height walls. JIFP uses a darker overhead surface and omits the legacy lumpy cave
roof pass, keeping its optional native stalactites. Strength boulders and
smashable rocks have distinct silhouettes in the voxel runtime. Cave collision
and the authored assets are unchanged. Real Surf exits, ladders and matched
first/third-person cave views were checked on desktop Gold.
