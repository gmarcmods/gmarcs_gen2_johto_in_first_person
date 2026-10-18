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
