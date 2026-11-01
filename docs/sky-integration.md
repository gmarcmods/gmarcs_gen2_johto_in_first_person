# Johto sky integration — 1.0.13

The companion refines the native time-of-day sky into a cached 32-color ramp, retaining its original zenith and horizon colors. This removes the broad contrasting bands without adding a screen pass or replacing the native sun/moon. Water reflections share that same ramp during the scene, avoiding alternating texture uploads. Disabling the companion, using the angled view, or detaching restores the native sky.

The Johto horizon now uses a small skylit material: mountain peaks retain more detail while low fields and the distant southern sea blend toward the native sky haze. It uses the renderer's existing clock tint; foreground lighting/shadows and all authored terrain remain untouched. An overlapping southern backdrop floor was removed to avoid fan-shaped seams. Northern mountains and the building-free crop are preserved; no cities or mountains are added to the south. Indoor and canopy maps retain their existing presentation. Gen 1 artwork keeps its prior path.

Johto's materialized library was identical to the shared source at the start of this change. Its lib link now points to the shared effects source again so future edits and packaged files cannot silently diverge. Export tooling materializes that link; the installed ZIP is self-contained. No engine API or source modifications.

Desktop Gold captures were checked at day, dusk and night on official gen1recomp origin/dev 7e736db2f. Compass views and raised horizon views cover the mountain/sea split. Unit tests check native palette endpoints, cached ramp identity, reflection palette sharing, disabled/angled paths and exact detach restoration. Matched first/third-person and angled on/off captures check authored-geometry isolation. No physical Android/iOS validation or GPU performance claim is made.

Before/after media: exports/media/jifp-sky-1.0.13 at workspace root. Drivers: workspace/tests/jifp_sky_review_live.lua and shared tests/johto_horizon.lua.
