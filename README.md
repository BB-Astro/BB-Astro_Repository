# BB-Astro PixInsight Repository

Official PixInsight update repository for BB-Astro scripts.

## Available Scripts

| Script | Version | Description |
|--------|---------|-------------|
| **LAcosmic** | 1.0.1 | Cosmic ray removal using L.A.Cosmic algorithm |
| **DeepCosmicRay** | 2.1.1 | Deep learning cosmic ray removal (DeepCR) |
| **CosmeticCorrection** | 2.1.0 | Hot/cold pixel removal |

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

## Python Dependencies

**CosmeticCorrection** works immediately - no setup needed.

**LAcosmic** and **DeepCosmicRay** require Python. The scripts will automatically detect if dependencies are missing and show you the exact command to run.

### If prompted for LAcosmic:
```
pip3 install astroscrappy astropy numpy
```

### If prompted for DeepCosmicRay:
```
pip3 install deepcr torch xisf numpy astropy
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
