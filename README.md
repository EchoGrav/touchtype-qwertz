# Touch Typing Trainer QWERTZ

**A QWERTZ clone of the "Touch Typing Trainer" Omarchy plugin by Anton Milman** (MIT). It is a separate plugin with its own id (`io.github.echograv.touchtype-qwertz`), so it can be installed next to the original; progress is stored separately.

This clone targets the **German keyboard layout (DIN 2137 T1, QWERTZ)**: on-screen keyboard, finger zones, drills (incl. Ä Ö Ü ß) and German word/sentence banks. It reads the characters your system layout produces, so set your layout to `de` (Omarchy: `kb_layout = de` in `~/.config/hypr/input.conf`).
Dead keys (`^`, `´`, `` ` ``) are shown on the board but never used in drills.

Note: the on-screen keyboard and the drills implement the German/Austrian QWERTZ layout (DIN 2137 T1) with German texts. Other QWERTZ variants (e.g. Swiss, Czech, Slovak, Hungarian) differ in some keys and are not covered yet.

Touch (Blind) typing is hugely overrated in the age of AI, but if you want to go old-school and actually use a keyboard, you better be quick.
Enjoy training Touch typing using this plugin while you agent is writing your code.

## Features

A guided, level-based touch-typing trainer plugin for the
[Omarchy](https://omarchy.org/) shell (Quickshell). Fully theme-aware — it
reuses Omarchy's `Color`/`Style` design tokens, so it automatically matches
whatever Omarchy theme you have active.

- 🖐 Finger Gym beginner track: one level per finger pair (both hands
  together, easiest first — index → middle → ring → pinky), letters first,
  then a combined numbers-row level and a combined punctuation level. Each
  track unlocks independently.
- 10 progressive classic levels: home row → top row → bottom row → full alphabet →
  numbers/punctuation → mixed drills → timed sentences.
- Levels unlock as you pass the one before them (accuracy threshold per level).
- Live on-screen keyboard that highlights the next expected key (with
  shift-key hinting) and marks the F/J home-row bumps. Finger Gym levels
  additionally tint each key by finger (index = blue, middle = green,
  ring = orange, pinky = pink) and show which fingers to use.
- Live stats while typing: elapsed time, WPM, accuracy.
- Results screen: pass/fail, accuracy/WPM/time, and a "weakest keys" heatmap
  built from your per-key hit/miss stats.
- Daily streak tracking and best-score-per-level persistence.
- Compact bar-widget indicator (Finger Gym level + Classic level + streak), click to open.
- Omarchy menu integration: `Trigger → Touch Type QWERTZ → Open trainer / Reset progress`.

## Install

```bash
omarchy plugin add https://github.com/EchoGrav/touchtype-qwertz.git --enable
```

That's it — this clones the plugin into `~/.config/omarchy/plugins/io.github.echograv.touchtype-qwertz`,
registers it with the running shell, and places the bar indicator for you
(you'll be prompted to pick left/center/right, or pass
`--enable` non-interactively and move it later with
`omarchy bar move io.github.echograv.touchtype-qwertz --section right`).

If you'd rather install manually (e.g. for local development):

```bash
git clone https://github.com/EchoGrav/touchtype-qwertz.git ~/.config/omarchy/plugins/io.github.echograv.touchtype-qwertz
omarchy plugin enable io.github.echograv.touchtype-qwertz --section right
```

### Optional: menu shortcuts

The bar icon alone is enough to open the trainer, but if you'd also like it
reachable from the Omarchy launcher menu (`Trigger → Touch Type QWERTZ`), add these
lines to `~/.config/omarchy/extensions/omarchy-menu.jsonc` (this file is
user-owned config, not something a plugin installer can safely write to for
you):

```jsonc
"trigger.touchtype-qwertz": {"icon":"⌨","label":"Touch Type QWERTZ","aliases":["touchtype-qwertz","tippen","typing"]},
"trigger.touchtype-qwertz.open": {"icon":"⌨","label":"Open trainer","action":"omarchy-shell shell toggle io.github.echograv.touchtype-qwertz"},
"trigger.touchtype-qwertz.reset": {"icon":"󰭌","label":"Reset progress","action":"rm -f ~/.local/state/omarchy/touchtype-qwertz-progress.json && omarchy-notification-send 'Touch Type QWERTZ' 'Progress reset'"}
```

The file hot-reloads on save — no restart needed.

## Usage

- Click the ⌨ bar indicator, or run `omarchy-shell shell toggle io.github.echograv.touchtype-qwertz`,
  or (if you added the optional menu entries) use
  `Trigger → Touch Type QWERTZ → Open trainer`.
- Navigate levels with `↑`/`↓` + `Enter`, number keys, or mouse click.
  Switch tracks with `←`/`→` (or `Tab`), or by clicking the track tabs.
- `Esc` returns to the previous screen / closes the overlay.
- Progress is stored at `~/.local/state/omarchy/touchtype-qwertz-progress.json`.
  Reset anytime by deleting that file, or via the optional menu's
  "Reset progress" action.

## Uninstall

```bash
omarchy plugin remove io.github.echograv.touchtype-qwertz
```

This disables the plugin, removes its bar placement, and deletes
`~/.config/omarchy/plugins/io.github.echograv.touchtype-qwertz` (a timestamped backup is kept
automatically alongside it, e.g. `.touchtype-qwertz.bak.<timestamp>`, in case you
want to restore it).

To also remove saved progress and the optional menu entries:

```bash
rm -f ~/.local/state/omarchy/touchtype-qwertz-progress.json
# and remove the three trigger.touchtype-qwertz* lines you added to
# ~/.config/omarchy/extensions/omarchy-menu.jsonc, if you added them
```

## Files

| File | Purpose |
|---|---|
| `manifest.json` | Plugin manifest (id, kinds, entry points). |
| `TouchTypeQWERTZ.qml` | Main overlay: menu/lesson/results screens, state machine, persistence. |
| `Keyboard.qml` | On-screen QWERTZ keyboard visual (incl. AltGr), theme-derived colors. |
| `BarWidget.qml` | Compact bar indicator (level + streak). |
| `Corpus.js` | Word/sentence/punctuation data banks. |
| `Curriculum.js` | 10-level classic curriculum + 6-level Finger Gym definitions, finger key maps, drill-text generators. |
| `ProgressStore.js` | Progress persistence, accuracy/WPM/streak calculators. |

## License

MIT — see [LICENSE](LICENSE).

## Development notes

- Validated with `qmllint` (only the standard false-positive categories that
  also appear in Omarchy's own first-party plugins, due to the dynamic
  `qs.Commons`/`qs.Ui` import namespace not being statically resolvable).
- Live-tested against a running `quickshell -p /usr/share/omarchy/shell`
  instance: overlay open/close, full lesson completion, level unlocking,
  bar-widget live update, and menu actions all confirmed working.
