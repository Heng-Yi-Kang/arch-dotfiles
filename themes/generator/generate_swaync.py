#!/usr/bin/env python3
"""Render the SwayNC stylesheet from the shared Tokyo Night palette."""

from __future__ import annotations

import sys
import tomllib
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent.parent
PALETTE_PATH = REPO_ROOT / "themes" / "palettes" / "tokyo-night.toml"
TEMPLATE_DIR = REPO_ROOT / "themes" / "templates"
TEMPLATE_NAME = "swaync.css.j2"
OUTPUT_PATH = REPO_ROOT / "generated" / "swaync.css"


def rgba(hex_color: str, opacity: float) -> str:
    """Convert a #RRGGBB palette value to GTK CSS-compatible rgba() syntax."""
    if len(hex_color) != 7 or not hex_color.startswith("#"):
        raise ValueError(f"Expected a #RRGGBB color, got {hex_color!r}")
    try:
        red, green, blue = (
            int(hex_color[index : index + 2], 16) for index in (1, 3, 5)
        )
    except ValueError as exc:
        raise ValueError(f"Invalid hex color {hex_color!r}") from exc
    if not 0 <= opacity <= 1:
        raise ValueError(f"Opacity must be between 0 and 1, got {opacity!r}")
    return f"rgba({red}, {green}, {blue}, {opacity:g})"


def main() -> int:
    try:
        from jinja2 import Environment, FileSystemLoader, StrictUndefined, TemplateError
    except ImportError:
        print(
            "Cannot generate SwayNC CSS: Jinja2 is not installed. "
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
    if not isinstance(colors, dict) or not all(
        isinstance(name, str) and isinstance(value, str)
        for name, value in colors.items()
    ):
        print(
            f"Invalid palette {PALETTE_PATH}: expected a [colors] table "
            "containing string values.",
            file=sys.stderr,
        )
        return 1

    try:
        environment = Environment(
            loader=FileSystemLoader(str(TEMPLATE_DIR)),
            undefined=StrictUndefined,
            autoescape=False,
        )
        environment.filters["rgba"] = rgba
        template = environment.get_template(TEMPLATE_NAME)
        rendered = template.render(colors=colors, **colors)
    except (OSError, UnicodeDecodeError, TemplateError, ValueError) as exc:
        print(
            f"Cannot render template {TEMPLATE_DIR / TEMPLATE_NAME}: {exc}",
            file=sys.stderr,
        )
        return 1

    try:
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding="utf-8")
    except OSError as exc:
        print(f"Cannot write generated stylesheet {OUTPUT_PATH}: {exc}", file=sys.stderr)
        return 1

    print(f"Generated {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
