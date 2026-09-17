# FreeCAD Smart Launcher

A desktop helper (PySide6) for Linux to manage FreeCAD AppImages, test GitHub pull requests, and browse local projects — all from one window.

> ⚠️ **Unofficial project.** Not affiliated with the FreeCAD project. AppImages are downloaded directly from the official [FreeCAD GitHub releases](https://github.com/FreeCAD/FreeCAD).
> 
<img width="1278" height="846" alt="DARK" src="https://github.com/user-attachments/assets/a4ad4011-6299-48d5-a29e-7a5f3558bafb" />
<img width="1280" height="848" alt="LIGHT" src="https://github.com/user-attachments/assets/b9510acb-e0bb-4a46-b25d-d926fc78f740" />

## Features

- **AppImage management** — detect, download, launch, and delete FreeCAD **stable** and **weekly** builds automatically.
- **Pull request testing** — fetch open PRs from `FreeCAD/FreeCAD`, view the conversation/comments, compile a PR with `cmake`/`ninja`, and launch the resulting build directly.
- **Project library** — scan folders for CAD files, keep a recent-files list, and launch a project with a chosen FreeCAD version (including inside an already-running instance).
- **3D preview** — quick preview of `.FCStd`, `.step`/`.stp`, `.iges`/`.igs`, `.stl`, and `.brep` files using [F3D](https://f3d.app/) (recommended), with `vtk` as a fallback and `cadquery-ocp` used to tessellate STEP/IGES files.
- **Desktop integration** — create `.desktop` menu entries for installed versions.
- **Usage statistics** — track time spent and launch counts per FreeCAD version.
- **Single-instance lock** — prevents opening the launcher twice at once.

## Download

Download the latest AppImage from the [Releases](../../releases) page, make it executable, and run it:

```bash
chmod +x FreeCAD_Smart_Launcher-x86_64.AppImage
./FreeCAD_Smart_Launcher-x86_64.AppImage
```

No Python, PySide6, or other installation is required — everything the app needs is bundled inside the AppImage.

The only tools that are **not** bundled and must be installed separately on your system if you want to use the related features:

| Tool | Needed for |
|---|---|
| `git`, `cmake` (and ideally `ninja`) | Compiling and testing a GitHub pull request |
| [F3D](https://f3d.app/) | 3D preview of project files |

On first run, the launcher creates its install folder at `~/Applications/FreeCAD` (configurable from the app), where it stores downloaded AppImages, `launcher_config.json`, and `time_tracker.json`.

## Running from source

If you'd rather run the Python script directly (e.g. to contribute):

- **Linux** (uses `.desktop` files and AppImages; not intended for Windows/macOS)
- **Python 3.9+**

```bash
pip install PySide6
python freecad_smart_launcher.py
```

Optional, for the 3D preview panel (used as fallbacks/tessellation if F3D isn't picking up the file):

```bash
pip install vtk cadquery-ocp
```

To test and build FreeCAD pull requests, you'll also need a full FreeCAD build toolchain (`git`, `cmake`, `ninja` recommended) and a cloned `FreeCAD/FreeCAD` source folder. See [Compile on Linux](https://wiki.freecad.org/Compile_on_Linux) on the FreeCAD wiki.

### Testing a pull request

1. Point **"TEST A GITHUB PULL REQUEST"** at your local `FreeCAD/FreeCAD` git clone.
2. Enter a PR number (or search/browse open PRs from within the app).
3. Click **Build** — the launcher runs `git fetch origin pull/<PR>/head`, configures with `cmake` (using `ninja` if available), and builds with your machine's CPU core count.
4. Click **Launch** to run the compiled build, optionally opening a project from your library with it.

## Notes

- All GitHub API calls are unauthenticated by default and therefore subject to GitHub's standard [rate limits](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api) for anonymous requests.
- Config and stats files from older versions (`~/.freecad_launcher_config.json`, `~/.freecad_time_tracker.json`) are migrated automatically into the install folder on first run.

## License

*(Add your preferred license here — e.g. MIT.)*
