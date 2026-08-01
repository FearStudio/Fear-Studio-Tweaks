<div align="center">

<img src="images/logo/logo.png" alt="Fear Studio Tweaks" width="220">

# FEAR STUDIO TWEAKS

**Free, no-nonsense Windows optimisation tools — built for gamers and enthusiasts who want their hardware to actually perform.**

[![Website](https://img.shields.io/badge/website-live-red?style=flat-square)](#)
[![Batch Scripts](https://img.shields.io/badge/scripts-.bat-black?style=flat-square)](#-available-tweaks)
[![Stars](https://img.shields.io/github/stars/FearStudio/Fear-Studio-Tweaks?style=flat-square&color=red)](https://github.com/FearStudio/Fear-Studio-Tweaks/stargazers)

</div>

---

## Overview

**Fear Studio Tweaks** is a collection of carefully tested `.bat` scripts and a companion website designed to reduce latency, cut background overhead, and optimise Windows for gaming and general responsiveness. Every tweak is documented, reversible, and built around a single principle: **know exactly what a script changes before you run it.**

No bundled installers. No telemetry of our own. No bloat — just scripts and a static site.

---

## Table of Contents

- [Features](#-features)
- [Available Tweaks](#-available-tweaks)
- [Site Structure](#-site-structure)
- [Getting Started](#-getting-started)
- [Repository Structure](#-repository-structure)
- [Suggesting a Tweak](#-suggesting-a-tweak)
- [Safety Notes](#-safety-notes)
- [Branding](#-branding)

---

## Features

- ⚡ **Performance tweaks** — reduce latency and background overhead across networking, power, and system services
- 🖥️ **Dark terminal aesthetic** — consistent Fear Studio branding across the site and every script
- 🔁 **Revert logic** — every tweak documents (and where possible, restores) Windows default behaviour
- 🔐 **Admin-safe scripts** — built-in privilege checks before any system change is made
- 🍪 **PECR / UK GDPR compliant** — lightweight cookie consent banner, scoped to first load only
- 💬 **Community suggestions** — submit tweak ideas directly through the site

---

## Available Tweaks

| Script | What it does |
|---|---|
| **Delivery Optimization** | Disables Windows peer-to-peer update sharing to save bandwidth |
| **Network Tweak** | Disables Nagle's Algorithm to reduce network latency |
| **Ultimate Performance Plan** | Unlocks and applies Windows' hidden high-performance power plan |
| **Background Apps Disable** | Stops UWP apps running in the background |
| **End Task (Right-Click)** | Adds a native "End Task" option to the taskbar right-click menu |
| **Telemetry Disable** | Reduces Windows diagnostic data collection to the minimum allowed |

Every script follows the same house style: ASCII Fear Studio banner, `[step/total]` progress counters, an admin privilege check, and suppressed console noise for a clean run.

> Full script source lives in [`Tweak_Files/`](Tweak_Files).

---

## Site Structure

The companion site is a static, multi-page HTML/CSS build with per-page scoped styling:

| Page | Purpose |
|---|---|
| `index.html` | Landing page |
| `Tweaks.html` | Browse and download available tweaks |
| `How_It_Works.html` | Explains what each tweak does under the hood |
| `About.html` | Project background |
| `Suggest_a_tweak.html` | Community tweak submission form |

---

## Getting Started

1. Visit the [Tweaks page](Tweaks.html) or browse [`Tweak_Files/`](Tweak_Files) directly
2. Download the `.bat` script for the tweak you want
3. Right-click → **Run as administrator**
4. Follow the on-screen steps — each script tells you exactly what it's doing as it runs

> 💡 It's recommended to create a System Restore Point before applying tweaks that touch the registry or system services.

---

## Repository Structure

```
Fear-Studio-Tweaks/
├── Tweak_Files/       # All .bat optimisation scripts
├── CSS Files/         # Per-page stylesheets
├── Cookies/           # Cookie consent banner logic
├── images/logo/       # Fear Studio branding assets
├── index.html
├── Tweaks.html
├── About.html
├── How_It_Works.html
├── Suggest_a_tweak.html
└── README.md
```

---

## Suggesting a Tweak

Got an idea for an optimisation that should be here? Head to [`Suggest_a_tweak.html`](Suggest_a_tweak.html) and submit it through the built-in Microsoft Forms integration. A client-side cooldown keeps submissions spam-free.

---

## Safety Notes

- Scripts modify registry values, services, and power settings — review before running if you're unsure
- All tweaks are designed to be **reversible**; documented Windows defaults are included in each script
- Run scripts with administrator privileges only when prompted to do so
- Use at your own discretion on production or work machines

---

## Branding

Fear Studio Tweaks uses a consistent visual identity across the site and scripts: a dark terminal theme, red/white/black palette, and an ASCII banner in every script. Logo assets are available in [`images/logo/`](images/logo).

---

<div align="center">

Made by **Fear Studio**

</div>
