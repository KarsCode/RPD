# RPD

RPD is a lightweight, feature-rich terminal music player designed for seamless playback, playlist management, and customization. With support for various audio formats, dynamic playlists, and MPRIS integration, RPD offers an immersive listening experience.

---

## 🚀 Installation

### **Ubuntu**
To install RPD on Ubuntu, run:
```sh
sudo apt install -y pkg-config libfaad-dev libtag1-dev libfftw3-dev libopus-dev libopusfile-dev libvorbis-dev libogg-dev git gcc make libchafa-dev libglib2.0-dev
```

### **macOS**
For macOS, install dependencies using Homebrew:
```sh
brew install gettext faad2 taglib chafa fftw opus opusfile libvorbis libogg glib pkg-config make git
```

---

## 🛠️ Building RPD

Once dependencies are installed, clone the repository and build RPD:
```sh
git clone https://github.com/KarsCode/RPD.git
cd RPD
make -ij4
sudo make install
```

### **Uninstalling RPD**
If you ever (how dare you? 😢) need to uninstall RPD, simply run:
```sh
sudo make uninstall
```

---

## 🎮 Controls and Shortcuts

| **Category**         | **Shortcut**         | **Action**                                  |
|----------------------|---------------------|---------------------------------------------|
| **Track Navigation** | ← / → or h / l      | Switch tracks                              |
|                      | `number` + Enter    | Jump to track                              |
| **Volume Control**   | + (or =) / -        | Increase/Decrease Volume                   |
| **Views & Browsing** | F2                  | Playlist View                              |
|                      | ↑ / ↓ or k / j      | Scroll playlist                            |
|                      | Enter               | Play track                                 |
|                      | F3                  | Library View                               |
|                      | ↑ / ↓ or k / j      | Scroll library                             |
|                      | Enter               | Add/Remove song from playlist             |
|                      | F4                  | Track View                                 |
| **Playback Control** | Space (or p)        | Toggle pause                              |
|                      | r                   | Repeat song                               |
|                      | S                   | Shuffle playlist                          |
|                      | a / d               | Seek forward/backward                     |
| **Customization**    | i                   | Toggle color scheme                       |
|                      | u                   | Update library                            |
|                      | v                   | Show/hide spectrum visualizer             |
|                      | b                   | Toggle cover art                          |
|                      | x                   | Save playlist                             |
|                      | .                   | Add current song to `rpd.m3u`             |
| **Exit**             | Esc or q            | Quit RPD                                  |

---

## 🎧 Features
✅ **Search Music Library** → Find songs using partial titles  
✅ **Dynamic Playlists** → Auto-generate playlists based on directories  
✅ **Playback Control** → Previous, next, pause, and seek support  
✅ **Playlist Editing** → Add or remove songs on the fly  
✅ **Gapless Playback** → No delay between tracks of the same format  
✅ **Supported Formats** → MP3, FLAC, M4A (AAC, ALAC), OPUS, OGG, WAV  
✅ **MPRIS Support** → Integrates with desktop events  
✅ **Privacy-Focused** → No data collection, completely offline  

---

## 🍏 Notes for macOS Users
- **For optimal visualizer performance**, use a Sixel-capable terminal like **kitty** or **WezTerm**.
- **Visualizer & album colors** are disabled by default in macOS’s terminal due to limited rendering support.
  - To enable:
    - Press `v` to activate the visualizer
    - Press `i` to toggle album-based colors

---

