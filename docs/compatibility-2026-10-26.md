# Compatibility check — 2026-10-26

Checked Johto in First Person 1.0.11 against the maintained gen1recomp checkout bc1190663 (latest fetched upstream dev 535a5ec08 plus local integrations) and authored voxel 1.0.16. No companion runtime changes were necessary.

Nine focused shared-effect scripts passed: runtime attach/detach and failure isolation, authored furniture/ceiling preservation, options and quality, directional doorways, native cave ceiling, cave atmosphere budgets, native birds, Johto horizon and jump input.

Desktop Gold real-game checks covered the player house, Elm's lab, Dark Cave, Ilex Forest, New Bark Town and Route 29. Native room/lab/cave/forest/outdoor effects drew without reported companion errors; OFF stopped effects and LOW/re-enable applied live. A second run captured matched on/off views in first and third person for house/lab/town/forest; angled views were byte-identical on/off.

The test wrapper removes Renderer.drawWorldOverride and Renderer.withWorldOverrideMirror in its process, verifying that those local engine orientation extensions are not required by the companion when used with voxel 1.0.16. This does not simulate an actual iOS graphics backend. Physical iOS/Android and Silver/Crystal were not run in this check; complete platform compatibility is not claimed.

The current exports/gen2/gmarcs_gen2_johto_in_first_person.zip matched all 15 manifest/entry/runtime source files. No replacement release was required. The companion's final output is composited by the active voxel mod, so use voxel 1.0.16 for the mod-owned iOS orientation correction.

Driver: workspace/tests/jifp_current_compat_live.lua. Captures/logs: workspace/dist/jifp-current-review and workspace/dist/jifp-current-authored (workspace root). No user save was written; testing used an isolated imported Gold identity.
