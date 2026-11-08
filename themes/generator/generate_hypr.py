#!/usr/bin/env python3
"""Generate Hyprland Lua color tokens from the shared semantic palette."""

from __future__ import annotations

import re
import sys
import tomllib
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent.parent
PALETTE_PATH = REPO_ROOT / "themes" / "palettes" / "tokyo-night.toml"
TEMPLATE_DIR = REPO_ROOT / "themes" / "templates"
TEMPLATE_NAME = "hypr-colors.lua.j2"
OUTPUT_PATH = REPO_ROOT / "generated" / "hypr" / "colors.lua"
REQUIRED_COLORS = (
    "background",
    "foreground",
    "surface",
    "surface_alt",
    "accent",
    "accent_alt",
    "border",
    "muted",
    "success",
    "warning",
    "error",
    "info",
)
HEX_COLOR = re.compile(r"^#[0-9a-fA-F]{6}$")


def main() -> int:
    try:
        from jinja2 import Environment, FileSystemLoader, StrictUndefined, TemplateError
    except ImportError:
        print(
            "Cannot generate Hyprland colors: Jinja2 is not installed. "
            "Install it with 'python -m pip install Jinja2'.",
            file=sys.stderr,
        )
        return 1

    try:
        with PALETTE_PATH.open("rb") as palette_file:
            palette = tomllib.load(palette_file)
    except tomllib.TOMLDecodeError as exc:
        print(f"Invalid palette {PALETTE_PATH}: {exc}", file=sys.stderr)
        return 1
    except (OSError, UnicodeDecodeError) as exc:
        print(f"Cannot read palette {PALETTE_PATH}: {exc}", file=sys.stderr)
        return 1

    colors = palette.get("colors")
    if not isinstance(colors, dict):
        print(
            f"Invalid palette {PALETTE_PATH}: expected a [colors] table.",
            file=sys.stderr,
        )
        return 1

    missing_colors = [name for name in REQUIRED_COLORS if name not in colors]
    if missing_colors:
        print(
            f"Invalid palette {PALETTE_PATH}: missing required colors: "
            f"{', '.join(missing_colors)}.",
            file=sys.stderr,
        )
        return 1

    invalid_colors = [
        name
        for name in REQUIRED_COLORS
        if not isinstance(colors[name], str) or not HEX_COLOR.fullmatch(colors[name])
    ]
    if invalid_colors:
        print(
            f"Invalid palette {PALETTE_PATH}: expected #RRGGBB values for: "
            f"{', '.join(invalid_colors)}.",
            file=sys.stderr,
        )
        return 1

    try:
        environment = Environment(
            loader=FileSystemLoader(str(TEMPLATE_DIR)),
            undefined=StrictUndefined,
            autoescape=False,
            keep_trailing_newline=True,
        )
        template = environment.get_template(TEMPLATE_NAME)
        rendered = template.render(
            colors=colors,
            required_colors=REQUIRED_COLORS,
        )
    except (OSError, UnicodeDecodeError, TemplateError) as exc:
        print(
            f"Cannot render template {TEMPLATE_DIR / TEMPLATE_NAME}: {exc}",
            file=sys.stderr,
        )
        return 1

    try:
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding="utf-8")
    except OSError as exc:
        print(f"Cannot write generated colors module {OUTPUT_PATH}: {exc}", file=sys.stderr)
        return 1

    print(f"Generated {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
