<h1 align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Activities/Video%20Game.png" alt="Game" width="40" height="40" />
  Brick Breaker - Assembly x86 (Irvine32)
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Activities/Video%20Game.png" alt="Game" width="40" height="40" />
</h1>

<p align="center">
  <b>A classic brick‑breaker game written entirely in x86 assembly using the Irvine32 library.</b>
  <br>
  <i>Break bricks, dodge death, collect power‑ups, and fight through three challenging levels – all from your console!</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/language-Assembly%20x86-blue" alt="Language">
  <img src="https://img.shields.io/badge/library-Irvine32-green" alt="Library">
  <img src="https://img.shields.io/badge/platform-Windows-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

---

## 🎮 About The Project

This is a fully playable brick‑breaker game developed in **x86 assembly** using **MASM** and the **Irvine32** library.  
It includes a complete menu system, high‑score recording, three distinct levels, dynamic paddle length, multi‑hit bricks, a hidden extra‑life bonus, sound effects, and a pause feature.  

The project demonstrates low‑level game development techniques – manual collision detection, screen drawing with console characters, file I/O for scores, and precise timing loops – all inside the classic 80×25 text mode.

---

## ✨ Features

- **Three Progressive Levels**  
  Each level introduces more bricks, higher block health, and faster gameplay.
- **Dynamic Paddle** – Level 1 & 3 use a long paddle; Level 2 uses a shorter one.
- **Multi‑Hit Bricks** – Level 2 bricks need 2 hits; Level 3 bricks need 3 hits. Colors change to indicate damage.
- **Hidden Extra Life** – Destroy a specific brick in Level 3 to release a falling `+` token; catch it with your paddle to gain a life.
- **Sound Effects** – Paddle bounce, wall collisions, block hits (different sounds for each hit stage), and background music.
- **High‑Score System** – Saves your name, level reached, and final score to `scores.txt`.
- **Pause & Resume** – Press `P` during gameplay.
- **Custom Name Entry** – Enter your name at the start; it appears on the win/lose screen.
- **Title & Instructions Pages** – Animated ASCII art and clear controls.
- **Full Console UI** – Built entirely with character‑based graphics.

---

## 🕹️ Controls

| Key | Action |
| :---: | :--- |
| `A` / `D` | Move paddle Left / Right |
| `P` | Pause / Resume game |
| `Enter` | Confirm menu selection or proceed |
| `W` / `S` | Navigate menu options (up/down) |
| Any Key | Start game from title screen |

---

## 📁 Project Structure

├── main.asm # Main source code (the file you uploaded)
├── sounds/ # All .wav sound files (must be provided by user)
│ ├── Boing.wav
│ ├── Saucer.wav
│ ├── Swordswi.wav
│ ├── Ao-Laser.wav
│ ├── Glass.wav
│ ├── Wowpulse.wav
│ ├── Byeball.wav
│ └── Sweepdow.wav
├── scores.txt # Auto‑generated high‑score file
└── README.txt # This file


> **Note:** The `sounds/` folder must contain the eight `.wav` files listed above. The game will not start without them.  
> You can use any short `.wav` files – rename them to match the expected names or modify the sound paths in the source.

---

## ⚙️ Requirements

To assemble and run the game, you need:

- **Microsoft Macro Assembler (MASM)** – part of Visual Studio or MASM32 SDK.
- **Irvine32 Library** – included with Kip Irvine's "Assembly Language for x86 Processors" textbook or can be downloaded separately.
  - Place `Irvine32.inc`, `Irvine32.lib`, and the kernel‑mode libraries in your project folder or the appropriate include/lib paths.
- **Windows OS** (the game uses the Win32 API for sound and console).
- **A 32‑bit linker** – the Irvine32 library is designed for 32‑bit protected mode programs.

> **💡 Tip:** The easiest setup is to install **Microsoft Visual Studio** (Community Edition is free) and include the Irvine32 files.  
> You can also use **MASM32 SDK** – just make sure to link against `Irvine32.lib` and the required Windows libraries.

---

## 🔧 How to Build & Run

### 1. Setup Irvine32
- Download the Irvine32 library files and place them in a known directory, e.g., `C:\Irvine`.
- Ensure your assembler can find `Irvine32.inc` (include path) and the linker can find `Irvine32.lib` (library path).

### 2. Assemble the Source
Open a **Developer Command Prompt for VS** (x86 native tools) and navigate to the project folder.

```bash
ml /coff /c /I"C:\Irvine" main.asm
```

<p align="center"> <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Red%20Heart.png" width="30" height="30" /> <i>Happy brick breaking!</i> <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Red%20Heart.png" width="30" height="30" /> </p>
