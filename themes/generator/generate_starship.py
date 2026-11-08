#!/usr/bin/env python3
"""Render Starship's config from the shared semantic palette."""

from __future__ import annotations

import sys
import tomllib
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent.parent
PALETTE_PATH = REPO_ROOT / "themes" / "palettes" / "tokyo-night.toml"
CONFIG_DIR = REPO_ROOT / "apps" / "starship"
CONFIG_NAME = "config.toml"
OUTPUT_PATH = REPO_ROOT / "generated" / "starship.toml"

REQUIRED_COLORS = (
    "accent",
    "accent_alt",
    "muted",
    "success",
    "warning",
    "error",
)


def main() -> int:
    try:
        from jinja2 import Environment, FileSystemLoader, StrictUndefined, TemplateError
    except ImportError:
        print(
            "Cannot generate Starship config: Jinja2 is not installed. "
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

    missing_colors = [name for name in REQUIRED_COLORS if name not in colors]
    if missing_colors:
        print(
            f"Invalid palette {PALETTE_PATH}: missing required colors: "
            f"{', '.join(missing_colors)}.",
            file=sys.stderr,
        )
        return 1

    try:
        environment = Environment(
            loader=FileSystemLoader(str(CONFIG_DIR)),
            undefined=StrictUndefined,
            autoescape=False,
        )
        template = environment.get_template(CONFIG_NAME)
        rendered = template.render(colors=colors)
    except (OSError, UnicodeDecodeError, TemplateError) as exc:
        print(
            f"Cannot render Starship config source {CONFIG_DIR / CONFIG_NAME}: {exc}",
            file=sys.stderr,
        )
        return 1

    try:
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding="utf-8")
    except OSError as exc:
        print(f"Cannot write generated config {OUTPUT_PATH}: {exc}", file=sys.stderr)
        return 1

    print(f"Generated {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
