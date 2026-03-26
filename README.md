# ChromeSidebarToggleRaycast


https://github.com/user-attachments/assets/4c208fe2-7f23-447f-9b6f-94fc2a1eca66


A [Raycast](https://www.raycast.com/) script command that toggles Chrome's tab sidebar with a single keystroke.

Chrome's "Expand tabs" / "Collapse tabs" button has no keyboard shortcut. This script uses the macOS Accessibility API to find and press it programmatically — no coordinate hacking, works on any screen or resolution.

## Requirements

- macOS 13+
- [Raycast](https://www.raycast.com/)
- Google Chrome with the tab sidebar enabled
- Xcode Command Line Tools (`xcode-select --install`)

## Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/RotulPlastik/ChromeSidebarToggleRaycast.git
   cd ChromeSidebarToggleRaycast
   ```

2. Build the binary:
   ```bash
   ./build.sh
   ```
   This compiles `toggle-chrome-sidebar.swift` and places the binary at `~/raycast-scripts/bin/toggle-chrome-sidebar`.

3. Copy the Raycast wrapper:
   ```bash
   cp toggle-chrome-sidebar.sh ~/raycast-scripts/
   ```

4. Add `~/raycast-scripts/` as a Script Command directory in Raycast (Settings > Extensions > Script Commands > Add Directories) if not already added.

5. Grant Raycast **Accessibility** access in System Settings > Privacy & Security > Accessibility.

## Usage

Open Raycast and search for **"Toggle Chrome Sidebar"**, or assign it a hotkey in Raycast settings.

## How it works

1. Finds Chrome via its bundle identifier (`com.google.Chrome`)
2. Walks Chrome's Accessibility tree (`AXUIElement`) looking for a button titled "Expand tabs" or "Collapse tabs"
3. Presses the button via `AXUIElementPerformAction`

The script is pre-compiled to a native binary for near-instant execution (~10ms vs ~1.5s for interpreted Swift).

## Files

| File | Description |
|------|-------------|
| `toggle-chrome-sidebar.swift` | Swift source — the main logic |
| `toggle-chrome-sidebar.sh` | Bash wrapper with Raycast metadata (calls the compiled binary) |
| `build.sh` | Compiles the Swift source to `~/raycast-scripts/bin/` |
| `chrome-mouse-offset.swift` | Bonus utility — reports mouse position relative to Chrome's window (useful for coordinate-based automation) |

## Rebuilding

After editing `toggle-chrome-sidebar.swift`:

```bash
./build.sh
```

## License

MIT
