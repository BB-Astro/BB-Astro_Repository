# BB-Astro PixInsight Repository

Official PixInsight update repository for BB-Astro scripts.

## Available Modules

| Module | Version | Description |
|--------|---------|-------------|
| **LAcosmic** | 1.0.1 | Cosmic ray removal (L.A.Cosmic algorithm) |
| **DeepCosmicRay** | 2.1.1 | Deep learning cosmic ray removal (DeepCR) |
| **CosmeticCorrection** | 2.1.0 | Hot/cold pixel removal |

---

## Installation

### Step 1: Add the Repository in PixInsight

1. Open PixInsight
2. Go to **Resources > Updates > Manage Repositories**
3. Click **Add...**
4. Enter this URL:
   ```
   https://bb-astro.github.io/BB-Astro_Repository/
   ```
5. Click **OK**

### Step 2: Install Modules

1. Go to **Resources > Updates > Check for Updates**
2. Select the BB-Astro modules you want
3. Click **Apply**
4. Restart PixInsight

### Step 3: Install Python Dependencies

After PixInsight installation, open **Terminal** and run the install script:

**Find where PixInsight installed the scripts:**
- **macOS:** `/Applications/PixInsight/src/scripts/BB-Astro/`
- **Linux:** `~/.local/share/PixInsight/src/scripts/BB-Astro/`

**For LAcosmic:**
```bash
cd /Applications/PixInsight/src/scripts/BB-Astro
./install.sh
```

**For DeepCosmicRay:**
```bash
cd /Applications/PixInsight/src/scripts/BB-Astro
./install.sh
```

The DeepCosmicRay installer will:
- Create a Python virtual environment in `~/.bb-astro/deepcr_venv/`
- Install PyTorch, DeepCR, and dependencies
- Download model weights (~100 MB)

**For CosmeticCorrection:**
No installation needed - it's 100% JavaScript!

---

## After Installation

Find the scripts in: **Script > BB-Astro**

- LAcosmic
- DeepCosmicRay
- CosmeticCorrection

---

## Updating

PixInsight will automatically notify you when updates are available.

Go to **Resources > Updates > Check for Updates** to manually check.

---

## Troubleshooting

### "Python not found"
Install Python 3.8+:
- **macOS:** `brew install python3`
- **Linux:** `sudo apt install python3 python3-venv python3-pip`

### "Module not found" errors
Run the install.sh script for the module you're using.

### DeepCosmicRay is slow
First run downloads ~100MB model. Subsequent runs are faster.

---

## Author

**Benoit Blanco (BB-Astro)**

Website: [www.bb-astro.com](https://www.bb-astro.com)

---

## License

CC BY-NC-SA 4.0 (Attribution, Non-Commercial, ShareAlike)

---

## For Developers

### Rebuild packages

```bash
./tools/build_packages.sh           # Build all
./tools/build_packages.sh lacosmic  # Build only LAcosmic
./tools/build_packages.sh deepcr    # Build only DeepCosmicRay
./tools/build_packages.sh cosmetic  # Build only CosmeticCorrection
```
