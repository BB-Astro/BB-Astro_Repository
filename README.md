# BB-Astro PixInsight Repository

Official PixInsight update repository for BB-Astro scripts.

## Available Scripts

`updates.xri` is the authority on what is published. This table is a convenience copy.

| Script | Description | Python |
|--------|-------------|--------|
| **LAcosmic** | Cosmic ray removal using the L.A.Cosmic algorithm | 3.10+ |
| **DeepCosmicRay** | Deep learning cosmic ray removal (DeepCR) | 3.10 or 3.11 |
| **CosmeticCorrection** | Hot/cold pixel removal | none |

LAcosmic and DeepCosmicRay drive Python through a shell wrapper, so they are macOS and Linux only. CosmeticCorrection is pure PJSR.

---

## Installation

### Step 1: Add the Repository

1. Open PixInsight
2. Go to **Resources > Updates > Manage Repositories**
3. Click **Add...**
4. Enter this URL:
   ```
   https://bb-astro.github.io/BB-Astro_Repository/
   ```
5. Click **OK**

### Step 2: Install Scripts

1. Go to **Resources > Updates > Check for Updates**
2. Select the BB-Astro scripts you want
3. Click **Apply**
4. Restart PixInsight

Scripts are located in: **Script > BB-Astro**

---

## Step 3: Python Setup

**CosmeticCorrection** works immediately, no setup needed.

**LAcosmic** and **DeepCosmicRay** each ship a setup script that builds a dedicated virtual environment under `~/.bb-astro`. Run the one you need once, from a Terminal:

```bash
bash /Applications/PixInsight/src/scripts/BB-Astro/install_lacosmic.sh
bash /Applications/PixInsight/src/scripts/BB-Astro/install_deepcr.sh
```

On Linux the path is `/opt/PixInsight/src/scripts/BB-Astro/` by default. Each script launched from PixInsight checks its environment before opening its dialog, and names the exact command if it is missing.

Do **not** try `pip3 install ...` into your system Python: Homebrew and most Linux distributions mark their interpreter as externally managed (PEP 668) and refuse it.

DeepCosmicRay additionally needs **Python 3.10 or 3.11**. `torch` requires 3.10 or later, while `deepcr` is published as a source distribution whose `setup.py` breaks on 3.12 and above. `install_deepcr.sh` finds a suitable interpreter, or tells you what to install:

```bash
brew install python@3.11                          # macOS
sudo apt install python3.11 python3.11-venv       # Debian / Ubuntu
```

To check what would actually run:

```bash
bash /Applications/PixInsight/src/scripts/BB-Astro/run_deepcr.sh --probe
bash /Applications/PixInsight/src/scripts/BB-Astro/run_lacosmic.sh --probe
```

---

## Updating

PixInsight automatically notifies you when updates are available.

Manual check: **Resources > Updates > Check for Updates**

---

## For Contributors — Building Packages

Packages are built from the source repositories using `tools/build_packages.sh`.

### Configure source paths

The script reads paths from environment variables or a personal config file. Create `~/.bb-astro/build.conf`:

```bash
mkdir -p ~/.bb-astro
cat > ~/.bb-astro/build.conf << 'EOF'
LACOSMIC_DIR="/path/to/BB-Astro_LAcosmic"
DEEPCR_DIR="/path/to/BB-Astro_DeepCosmicRay"
COSMETIC_DIR="/path/to/BB_CosmeticCorrection"
EOF
```

Or pass paths inline as environment variables:

```bash
LACOSMIC_DIR=~/dev/BB-Astro_LAcosmic \
DEEPCR_DIR=~/dev/BB-Astro_DeepCosmicRay \
COSMETIC_DIR=~/dev/BB_CosmeticCorrection \
  ./tools/build_packages.sh
```

### Build all packages

```bash
./tools/build_packages.sh          # Build all
./tools/build_packages.sh lacosmic # LAcosmic only
./tools/build_packages.sh deepcr   # DeepCosmicRay only
./tools/build_packages.sh cosmetic # CosmeticCorrection only
```

The script generates `packages/*.tar.gz` and regenerates `updates.xri` automatically.

---

## Author

**Benoit Blanco (BB-Astro)**

Website: [www.bb-astro.com](https://www.bb-astro.com)

## License

CC0 1.0 Universal
