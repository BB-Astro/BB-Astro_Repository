# Code Review - BB-Astro PixInsight Repository

**Date:** 2026-02-14
**Reviewer:** Claude (automated code review)
**Scope:** Full repository review - all files and packaged contents

## Overview

This is a well-structured PixInsight update repository distributing three astronomical image processing modules (LAcosmic, DeepCosmicRay, CosmeticCorrection). The code quality is generally good, with clear separation of concerns and proper error handling. Below are the findings organized by severity.

---

## CRITICAL Issues

### 1. License Contradiction
- `LICENSE` file contains **CC0 1.0 Universal** (public domain)
- `README.md` states **CC BY-NC-SA 4.0** (non-commercial, share-alike)
- `updates.xri` states **CC BY-NC-SA 4.0**
- `BB_DeepCosmicRay.js` states **CC BY-NC-SA 4.0**
- `BB-Astro_LAcosmic.js` states **MIT License**

These are mutually incompatible licenses. CC0 abandons all rights. CC BY-NC-SA 4.0 restricts commercial use. MIT permits commercial use. This must be resolved to a single consistent license across the project.

### 2. `updates.xri` is incomplete - Missing LAcosmic and CosmeticCorrection packages
The `updates.xri` manifest only lists **DeepCosmicRay**. The **LAcosmic** and **CosmeticCorrection** packages are not listed at all, which means PixInsight will not offer them for download/update. Only DeepCosmicRay is installable via the repository update mechanism.

### 3. macOS metadata leak in LAcosmic package
The LAcosmic tar.gz contains a macOS AppleDouble/resource fork file: `._BB-Astro_LAcosmic.js`. This is a macOS metadata artifact that should not be distributed. It can cause issues on Linux systems and is a data leak (may contain extended attributes like `com.apple.macl`). The build script should use `COPYFILE_DISABLE=1` when creating tar archives on macOS, or `tar --exclude='._*'`.

---

## HIGH Severity

### 4. Hardcoded developer path in `checkDependencies()` (DeepCosmicRay)
`BB_DeepCosmicRay.js` has a hardcoded fallback path:
```javascript
var testPaths = ["/Users/benmbp", "/Users/admin", "/home"];
```
This leaks the developer's username and will never match on end-user machines. If `$HOME` detection fails, the venv Python path won't be found, and the fallback paths are useless.

### 5. Hardcoded source paths in build script
`tools/build_packages.sh` hardcodes the developer's local machine path:
```bash
SOURCES_BASE="/Users/benmbp/Documents/projetMBP/ModulePixinsightByBB"
```
The script will fail for any other contributor. This should be configurable via environment variables or a local config file.

### 6. Command injection risk via `ExternalProcess`
In both `BB-Astro_LAcosmic.js` and `BB_DeepCosmicRay.js`, commands are built by joining arrays with spaces then passed as a string:
```javascript
var cmdString = cmd.join(" ");
var process = new ExternalProcess(cmdString);
```
If any parameter (e.g., a file path) contains spaces or shell metacharacters, the command will break or potentially execute unintended commands. The temp file paths use `Math.random()` so this is low risk in practice, but the pattern is fragile.

### 7. `save_fits` has bare `except:` (lacosmic_cli.py)
```python
except:
    pass
```
A bare except silently swallows all exceptions including `KeyboardInterrupt` and `SystemExit`. Should be `except Exception:` at minimum.

---

## MEDIUM Severity

### 8. Temp file predictability (CosmeticCorrection)
`BB_CosmeticCorrection.js` uses only `Date.now()` for temp file names:
```javascript
var timestamp = Date.now();
var tempInputFile = tempDir + "/bb_cc_input_" + timestamp + ".xisf";
```
Unlike the other two modules which use `Math.random()` for added uniqueness, CosmeticCorrection uses only a timestamp. In a multi-instance scenario this could collide.

### 9. macOS-only `shasum` in build script
`tools/build_packages.sh` uses `shasum` which is macOS-specific. On Linux, `sha1sum` is the standard command. The script should check for both.

### 10. DeepCR install script downloads wrong model
`install.sh` (DeepCosmicRay) downloads model `ACS-WFC-F606W-2-32`, but the JS script defaults to `WFC3-UVIS` model. The pre-download should match the default model to avoid a second download on first use.

### 11. Timeout messages in French
```javascript
Console.criticalln("WARNING BB: le traitement a pris trop de temps...");
Console.criticalln("Essaie avec une image plus petite...");
```
All other messages are in English. These debug messages were likely left from personal development.

### 12. `deepcr_cli.py` version mismatch
`deepcr_cli.py` declares version 2.1, but the JS module declares version 2.1.1.

### 13. Threshold argument ignored when preset is set
In `deepcr_cli.py`, if a `--preset` is specified, the explicitly passed `threshold` positional argument is completely ignored. This could confuse users who pass both a custom threshold and a preset.

---

## LOW Severity

### 14. `CosmeticCorrectionData` crashes without active window
`BB_CosmeticCorrection.js`:
```javascript
this.targetView = ImageWindow.activeWindow.mainView;
```
This is called at module load time. If no window is open, `ImageWindow.activeWindow` is null and this will throw before `main()` can check for it.

### 15. No Windows support declared
The `updates.xri` only declares `macosx` and `linux` platforms, but README mentions Windows in install instructions.

### 16. `torchvision` installed but not used
DeepCosmicRay's `install.sh` installs `torchvision` (~500MB), but it is never imported or used.

### 17. `$HOME` detection fragile in PixInsight context
DeepCosmicRay runs `/bin/bash -c 'echo $HOME'` to get the home directory. In PixInsight's execution environment, `$HOME` may not be set.

### 18. `.gitignore` is minimal
Missing common entries: `*.pyc`, `__pycache__/`, `.env`, `*.log`.

---

## Style / Documentation

### 19. Inconsistent naming conventions
- LAcosmic: `BB-Astro_LAcosmic.js` (hyphen, underscore, capital C)
- DeepCosmicRay: `BB_DeepCosmicRay.js` (underscores only)
- CosmeticCorrection: `BB_CosmeticCorrection.js` (underscores only)
- Favicon files: `favicon_LACOSMIC.svg` vs `Favicon_DeepCR.svg` vs `Favicon_CosmeticCorrection.svg` (inconsistent capitalization)

### 20. Copyright year range inconsistency
- LAcosmic: "2024-2025"
- DeepCosmicRay: "2025"
- CosmeticCorrection: "2025"

---

## Security (Positive Notes)

The codebase includes several good security practices:
- **Path traversal protection** in both `lacosmic_cli.py` and `deepcr_cli.py` restricting output to allowed directories
- **Temp file cleanup** in `finally` blocks (DeepCosmicRay, CosmeticCorrection)
- **Input validation** on UI parameters with visual feedback
- **Secure temp filenames** using random components (LAcosmic, DeepCosmicRay)

---

## Summary

| Severity | Count | Key Issues |
|----------|-------|------------|
| Critical | 3 | License contradiction, incomplete xri manifest, macOS metadata leak |
| High     | 4 | Hardcoded paths, command injection risk, bare except |
| Medium   | 6 | Wrong model pre-download, French messages, version mismatch |
| Low      | 5 | Naming inconsistencies, missing .gitignore entries, unused dependency |

**Priority actions:**
1. Fix the LICENSE file to match the intended CC BY-NC-SA 4.0 (or reconcile all license declarations)
2. Add LAcosmic and CosmeticCorrection entries to `updates.xri`
3. Rebuild LAcosmic package without macOS metadata files
4. Remove hardcoded developer paths
