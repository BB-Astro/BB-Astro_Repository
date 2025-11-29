# BB-Astro PixInsight Repository

Official PixInsight update repository for BB-Astro scripts.

## Available Modules

| Module | Description | Version |
|--------|-------------|---------|
| **LAcosmic** | Cosmic ray removal using L.A.Cosmic algorithm | 1.0.1 |
| **DeepCosmicRay** | Deep learning cosmic ray removal (DeepCR) | Coming soon |
| **CosmeticCorrection** | Hot/cold pixel removal | Coming soon |

---

## Installation in PixInsight

### Step 1: Add the Repository

1. Open PixInsight
2. Go to **Resources > Updates > Manage Repositories**
3. Click **Add...**
4. Enter this URL:
   ```
   https://bb-astro.github.io/BB-Astro-Repository/
   ```
5. Click **OK**

### Step 2: Install Modules

1. Go to **Resources > Updates > Check for Updates**
2. Select the BB-Astro modules you want to install
3. Click **Apply**
4. Restart PixInsight

### Step 3: Python Dependencies (for LAcosmic/DeepCosmicRay)

After installation, install Python dependencies:

**For LAcosmic:**
```bash
pip3 install astroscrappy astropy numpy
```

**For DeepCosmicRay:**
```bash
pip3 install deepcr torch xisf numpy
```

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
```

This generates:
- `packages/*.tar.gz` - Package archives
- `updates.xri` - Repository index with SHA-1 checksums
