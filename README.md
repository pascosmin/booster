# Sound Boost 🔊

A lightweight desktop GUI for Linux that lets you push your system volume beyond 100% and apply a **Clarity EQ** to make audio sound cleaner — useful when laptop speakers or Bluetooth headphones are just not loud or clear enough.

Built with Python + Tkinter on top of PipeWire / PulseAudio (`pactl`). No browser extensions needed.

![screenshot placeholder](https://i.imgur.com/placeholder.png)

---

## Features

- **Volume boost up to 300%** — per output device and per application
- **Clarity EQ toggle** — one-click LADSPA equalizer that:
  - Cuts 220–311 Hz (removes muddiness / boominess)
  - Lifts 2.5–5 kHz (adds presence, speech intelligibility)
  - Opens 10 kHz (adds air and brightness)
  - Starts at 80% gain to prevent distortion on already-boosted signal
- Auto-refreshes every 2.5 s; detects new/removed audio apps dynamically
- Dark UI (Catppuccin Mocha palette)
- Properly cleans up virtual sinks when closed or Clarity is toggled off

---

## Requirements

| Package | Purpose |
|---|---|
| `python3` | Runtime |
| `python3-tk` | GUI (Tkinter) |
| `swh-plugins` | LADSPA multiband EQ used by Clarity |
| `pactl` | PipeWire/PulseAudio control (usually pre-installed) |

---

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/booster.git
cd booster
```

### 2. Run the installer

```bash
bash install.sh
```

This will:
- Install `python3`, `python3-tk`, and `swh-plugins` via `apt`
- Make the `boost` script executable
- Add an alias `boost` to your `~/.bashrc`

### 3. Reload your shell

```bash
source ~/.bashrc
```

---

## Manual setup (without the installer)

```bash
# Install dependencies
sudo apt install python3 python3-tk swh-plugins

# Make executable
chmod +x boost

# Add alias to ~/.bashrc (replace /path/to/ with the actual path)
echo "alias boost='python3 /path/to/booster/boost &'" >> ~/.bashrc
source ~/.bashrc
```

---

## Usage

```bash
boost
```

The GUI opens. Use the sliders to:

- **Output Devices** — adjust the volume of each audio output (speakers, headphones, etc.)
- **Applications** — adjust per-app volume independently
- **✦ Clarity: OFF/ON** — toggle the Clarity EQ processor

> **Tip:** If Clarity makes audio quieter, raise the "Clarity EQ (processor)" slider in Output Devices. The 80% starting point is intentional — it gives headroom to avoid clipping.

---

## How Clarity works

When Clarity is enabled, Sound Boost loads a LADSPA virtual sink (`module-ladspa-sink` with the `mbeq_1197` multiband EQ from `swh-plugins`). All audio is routed through this virtual sink, processed, and then sent to your real speaker/headphone output.

EQ curve:

```
Freq (Hz)  |  Gain
-----------+-------
220        |  -3 dB   ← cut mud
311        |  -4 dB   ← cut boom
440        |  -1 dB   ← gentle low-mid taper
2500       |  +1 dB   ← lift presence
3500       |  +2 dB   ← peak presence (speech clarity)
5000       |  +1 dB   ← upper presence
10000      |  +1 dB   ← air
```

When you close the app or toggle Clarity OFF, the virtual sink is unloaded and audio routing is restored automatically.

---

## Troubleshooting

**"Clarity: install swh-plugins" message appears**
```bash
sudo apt install swh-plugins
```

**Clarity EQ bar shows up but audio still sounds distorted**  
Lower the "Clarity EQ (processor)" slider in Output Devices, or reduce the main output volume before enabling Clarity.

**Multiple "Clarity EQ" entries appear**  
This happened in older versions. The current version cleans up stale modules on startup automatically.

---

## License

MIT
