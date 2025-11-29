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

## Author

**Benoit Blanco (BB-Astro)**

Website: [www.bb-astro.com](https://www.bb-astro.com)

## License

CC BY-NC-SA 4.0
