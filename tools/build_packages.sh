#!/usr/bin/env bash
#
# build_packages.sh - Build PixInsight packages for BB-Astro Repository
#
# Usage:
#   ./tools/build_packages.sh              # Build all packages
#   ./tools/build_packages.sh lacosmic     # Build only LAcosmic
#   ./tools/build_packages.sh deepcr       # Build only DeepCosmicRay
#   ./tools/build_packages.sh cosmetic     # Build only CosmeticCorrection
#

set -e

# =============================================================================
# CONFIGURATION
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGES_DIR="$REPO_DIR/packages"
BUILD_DIR="$REPO_DIR/.build"

# Source directories (adjust paths as needed)
SOURCES_BASE="/Users/benmbp/Documents/projetMBP/ModulePixinsightByBB"
LACOSMIC_DIR="$SOURCES_BASE/BB-Astro_LAcosmic-GitHub"
DEEPCR_DIR="$SOURCES_BASE/BB-Astro_DeepCosmicRay_GitHub"
COSMETIC_DIR="$SOURCES_BASE/BB_CosmeticCorrection"

# GitHub Pages base URL (update after creating repo)
GITHUB_USER="BB-Astro"
GITHUB_REPO="BB-Astro_Repository"
BASE_URL="https://${GITHUB_USER}.github.io/${GITHUB_REPO}"

# Release date (today)
RELEASE_DATE=$(date +%Y%m%d)

# =============================================================================
# FUNCTIONS
# =============================================================================

log() {
    echo "===> $1"
}

error() {
    echo "ERROR: $1" >&2
    exit 1
}

# Get version from JS file
get_version() {
    local js_file="$1"
    grep '#define VERSION' "$js_file" | sed 's/.*"\(.*\)".*/\1/' | head -1
}

# Calculate SHA-1 of a file
get_sha1() {
    shasum -a 1 "$1" | awk '{print $1}'
}

# Build a package
# Args: package_name source_dir version files...
build_package() {
    local name="$1"
    local src_dir="$2"
    local version="$3"
    shift 3
    local files=("$@")

    local package_name="${name}_v${version}.tar.gz"
    local build_path="$BUILD_DIR/$name"

    log "Building $name v$version..."

    # Clean and create build directory
    rm -rf "$build_path"
    mkdir -p "$build_path/src/scripts/BB-Astro"

    # Copy script files
    for file in "${files[@]}"; do
        if [[ -f "$src_dir/$file" ]]; then
            cp "$src_dir/$file" "$build_path/src/scripts/BB-Astro/"
            # Make shell scripts executable
            if [[ "$file" == *.sh ]]; then
                chmod +x "$build_path/src/scripts/BB-Astro/$file"
            fi
        else
            error "File not found: $src_dir/$file"
        fi
    done

    # Create the package (from inside build dir so paths are relative)
    cd "$build_path"
    tar -czf "$PACKAGES_DIR/$package_name" .
    cd "$REPO_DIR"

    # Calculate SHA-1
    local sha1=$(get_sha1 "$PACKAGES_DIR/$package_name")
    local size=$(stat -f%z "$PACKAGES_DIR/$package_name" 2>/dev/null || stat -c%s "$PACKAGES_DIR/$package_name")

    log "  Package: $package_name"
    log "  SHA-1:   $sha1"
    log "  Size:    $size bytes"

    # Store info for updates.xri generation
    echo "$name|$version|$package_name|$sha1|$size" >> "$BUILD_DIR/packages.txt"
}

# =============================================================================
# BUILD LACOSMIC
# =============================================================================
build_lacosmic() {
    if [[ ! -d "$LACOSMIC_DIR" ]]; then
        error "LAcosmic source not found: $LACOSMIC_DIR"
    fi

    local version=$(get_version "$LACOSMIC_DIR/BB-Astro_LAcosmic.js")
    if [[ -z "$version" ]]; then
        version="1.0.1"
    fi

    build_package "BB_LAcosmic" "$LACOSMIC_DIR" "$version" \
        "BB-Astro_LAcosmic.js" \
        "lacosmic_cli.py" \
        "run_lacosmic.sh" \
        "favicon_LACOSMIC.svg"
}

# =============================================================================
# BUILD DEEPCOSMICRAY
# =============================================================================
build_deepcr() {
    if [[ ! -d "$DEEPCR_DIR" ]]; then
        log "DeepCosmicRay source not found, skipping: $DEEPCR_DIR"
        return 0
    fi

    local js_file="$DEEPCR_DIR/BB_DeepCosmicRay.js"
    if [[ ! -f "$js_file" ]]; then
        log "DeepCosmicRay JS not found, skipping"
        return 0
    fi

    local version=$(get_version "$js_file")
    if [[ -z "$version" ]]; then
        version="2.1.0"
    fi

    build_package "BB_DeepCosmicRay" "$DEEPCR_DIR" "$version" \
        "BB_DeepCosmicRay.js" \
        "deepcr_cli.py" \
        "run_deepcr.sh" \
        "Favicon_DeepCR.svg"
}

# =============================================================================
# BUILD COSMETICCORRECTION
# =============================================================================
build_cosmetic() {
    if [[ ! -d "$COSMETIC_DIR" ]]; then
        log "CosmeticCorrection source not found, skipping: $COSMETIC_DIR"
        return 0
    fi

    local js_file="$COSMETIC_DIR/BB_CosmeticCorrection.js"
    if [[ ! -f "$js_file" ]]; then
        log "CosmeticCorrection JS not found, skipping"
        return 0
    fi

    local version=$(get_version "$js_file")
    if [[ -z "$version" ]]; then
        version="2.1.0"
    fi

    build_package "BB_CosmeticCorrection" "$COSMETIC_DIR" "$version" \
        "BB_CosmeticCorrection.js" \
        "Favicon_CosmeticCorrection.svg"
}

# =============================================================================
# GENERATE updates.xri
# =============================================================================
generate_updates_xri() {
    log "Generating updates.xri..."

    cat > "$REPO_DIR/updates.xri" << 'XMLHEADER'
<?xml version="1.0" encoding="UTF-8"?>
<xri version="1.0">

  <!-- ================================================================== -->
  <!-- BB-Astro Official PixInsight Repository                           -->
  <!-- ================================================================== -->

  <description>
    <p><b>BB-Astro Official Repository</b></p>
    <p>Professional astronomical image processing tools for PixInsight</p>
    <p></p>
    <p><b>Available Modules:</b></p>
    <p>- LAcosmic: Cosmic ray removal using L.A.Cosmic algorithm</p>
    <p>- DeepCosmicRay: Deep learning cosmic ray removal (DeepCR)</p>
    <p>- CosmeticCorrection: Hot/cold pixel removal</p>
    <p></p>
    <p><b>Author:</b> Benoit Blanco (BB-Astro)</p>
    <p><b>Website:</b> <a href="https://www.bb-astro.com">www.bb-astro.com</a></p>
    <p><b>License:</b> CC BY-NC-SA 4.0</p>
  </description>

XMLHEADER

    # Generate package entries for each platform
    # For scripts, we use "noarch" since they work on all platforms

    while IFS='|' read -r name version package_name sha1 size; do
        [[ -z "$name" ]] && continue

        # Get description based on package name
        local title desc
        case "$name" in
            BB_LAcosmic)
                title="BB-Astro LAcosmic v${version}"
                desc="Cosmic ray removal using the L.A.Cosmic algorithm (van Dokkum 2001). Optimized parameters detect +24% more cosmic rays than defaults. Requires Python 3 with astroscrappy."
                ;;
            BB_DeepCosmicRay)
                title="BB-Astro DeepCosmicRay v${version}"
                desc="Deep learning cosmic ray removal using DeepCR (Zhang &amp; Bloom 2020). Superior accuracy trained on 15,000+ HST images. Requires Python 3 with DeepCR, PyTorch."
                ;;
            BB_CosmeticCorrection)
                title="BB-Astro CosmeticCorrection v${version}"
                desc="Professional hot and cold pixel removal with visual validation. Easy-to-use interface for cosmetic correction."
                ;;
        esac

        cat >> "$REPO_DIR/updates.xri" << XMLPACKAGE
  <!-- ================================================================== -->
  <!-- ${title} -->
  <!-- ================================================================== -->

  <platform os="macosx" arch="x64" version="1.8.0:2.0.0">
    <package fileName="packages/${package_name}" sha1="${sha1}" type="script" releaseDate="${RELEASE_DATE}">
      <title>${title}</title>
      <description>
        <p><b>${title}</b></p>
        <p>${desc}</p>
      </description>
    </package>
  </platform>

  <platform os="linux" arch="x64" version="1.8.0:2.0.0">
    <package fileName="packages/${package_name}" sha1="${sha1}" type="script" releaseDate="${RELEASE_DATE}">
      <title>${title}</title>
      <description>
        <p><b>${title}</b></p>
        <p>${desc}</p>
      </description>
    </package>
  </platform>

XMLPACKAGE

    done < "$BUILD_DIR/packages.txt"

    # Close XML
    echo "</xri>" >> "$REPO_DIR/updates.xri"

    log "updates.xri generated successfully"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    log "BB-Astro Repository Builder"
    log "============================"

    # Create directories
    mkdir -p "$PACKAGES_DIR" "$BUILD_DIR"
    rm -f "$BUILD_DIR/packages.txt"

    # Determine what to build
    local target="${1:-all}"

    case "$target" in
        lacosmic)
            build_lacosmic
            ;;
        deepcr)
            build_deepcr
            ;;
        cosmetic)
            build_cosmetic
            ;;
        all)
            build_lacosmic
            build_deepcr
            build_cosmetic
            ;;
        *)
            error "Unknown target: $target (use: lacosmic, deepcr, cosmetic, or all)"
            ;;
    esac

    # Generate updates.xri
    generate_updates_xri

    # Cleanup
    rm -rf "$BUILD_DIR"

    log ""
    log "Build complete!"
    log ""
    log "Repository URL for PixInsight:"
    log "  ${BASE_URL}/"
    log ""
    log "Next steps:"
    log "  1. git init && git add . && git commit -m 'Initial repository'"
    log "  2. Create repo on GitHub: ${GITHUB_USER}/${GITHUB_REPO}"
    log "  3. git remote add origin git@github.com:${GITHUB_USER}/${GITHUB_REPO}.git"
    log "  4. git push -u origin main"
    log "  5. Enable GitHub Pages (Settings > Pages > Source: main branch)"
    log ""
}

main "$@"
