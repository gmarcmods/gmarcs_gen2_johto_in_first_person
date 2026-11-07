#!/usr/bin/env python3
"""Sync/check the standalone release copy of the shared first-person library."""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import shutil
import sys

MOD = Path(__file__).resolve().parents[1]
SHARED = MOD.parents[1] / "shared" / "first-person-effects" / "lib"
SNAPSHOT = MOD / ".release" / "lib"
DIGEST = MOD / ".release" / "lib.sha256"


def inventory(root: Path) -> dict[str, bytes]:
    return {p.relative_to(root).as_posix(): p.read_bytes()
            for p in root.rglob("*") if p.is_file()}


def digest(files: dict[str, bytes]) -> str:
    h = hashlib.sha256()
    for name, body in sorted(files.items()):
        h.update(name.encode("utf-8") + b"\0" + body + b"\0")
    return h.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    if args.check:
        expected = inventory(SNAPSHOT) if SNAPSHOT.is_dir() else {}
        if not expected:
            print("release snapshot is missing or empty", file=sys.stderr)
            return 1
        if SHARED.is_dir():
            actual = inventory(SHARED)
            if actual != expected:
                print("release snapshot is stale; run tools/sync_release_lib.py",
                      file=sys.stderr)
                return 1
            return 0
        if not DIGEST.is_file() or DIGEST.read_text().strip() != digest(expected):
            print("release snapshot digest is missing or invalid", file=sys.stderr)
            return 1
        return 0

    if not SHARED.is_dir():
        print(f"shared source is unavailable: {SHARED}", file=sys.stderr)
        return 1
    files = inventory(SHARED)
    if not files:
        print("shared source library is empty", file=sys.stderr)
        return 1
    if SNAPSHOT.exists():
        shutil.rmtree(SNAPSHOT)
    SNAPSHOT.mkdir(parents=True)
    for name, body in files.items():
        target = SNAPSHOT / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(body)
    DIGEST.write_text(digest(files) + "\n")
    print(f"synced {len(files)} files into {SNAPSHOT.relative_to(MOD)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
