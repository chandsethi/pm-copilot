#!/usr/bin/env bash
# PM Co-Pilot for Codex - Installer
# Installs skills, creates workspace with memory templates and AGENTS.md
# Safe to re-run (idempotent)

set -euo pipefail

echo "Installing PM Co-Pilot for Codex..."

# Configuration
PMC_REF="${PMC_REF:-main}"
REPO_OWNER="chandsethi"
REPO_NAME="pm-copilot"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="Linux"
else
  echo "Error: Unsupported OS. This installer supports macOS and Linux only."
  exit 1
fi

# Determine user home (works without admin rights)
USER_HOME="${HOME:-$( cd ~ && pwd )}"

# Set paths
PMC_HOME="$USER_HOME/.pm-copilot"
REPO_DIR="$PMC_HOME/repo"
SKILLS_DIR="$USER_HOME/.agents/skills"
WORKSPACE_DIR="$USER_HOME/pm-copilot"

echo "  OS: $OS"
echo "  Installing from: $REPO_OWNER/$REPO_NAME@$PMC_REF"
echo "  Repository will be cached at: $REPO_DIR"
echo "  Skills will be linked to: $SKILLS_DIR"
echo "  Workspace: $WORKSPACE_DIR"
echo ""

# Step 1: Fetch or update the repository
mkdir -p "$PMC_HOME"

if [ -d "$REPO_DIR" ]; then
  echo "Updating cached repository..."
  if [ -d "$REPO_DIR/.git" ]; then
    # Update via git if it's a git clone
    cd "$REPO_DIR"
    if command -v git >/dev/null 2>&1; then
      git fetch origin >/dev/null 2>&1 || true
      git checkout "$PMC_REF" >/dev/null 2>&1 || true
      git pull origin "$PMC_REF" >/dev/null 2>&1 || true
      cd - >/dev/null
      echo "  ✓ Updated via git"
    else
      echo "  ⊘ git not available, keeping existing copy"
    fi
  else
    echo "  ⊘ Existing copy is not a git clone, keeping as-is"
  fi
else
  echo "Downloading repository..."
  
  # Try git first (handles auth, branches, etc. better)
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 --branch "$PMC_REF" \
      "https://github.com/$REPO_OWNER/$REPO_NAME.git" "$REPO_DIR" >/dev/null 2>&1 && \
      echo "  ✓ Cloned via git" || {
      echo "  ⊘ git clone failed, falling back to tarball"
      rm -rf "$REPO_DIR"
    }
  fi
  
  # Fallback to tarball (works without git, but ref must exist on GitHub)
  if [ ! -d "$REPO_DIR" ]; then
    # Convert branch name to valid ref for codeload (replace / with -)
    SAFE_REF="${PMC_REF//\//-}"
    TARBALL_URL="https://codeload.github.com/$REPO_OWNER/$REPO_NAME/tar.gz/$PMC_REF"
    TEMP_TAR="$PMC_HOME/temp.tar.gz"
    
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$TARBALL_URL" -o "$TEMP_TAR" || {
        echo "Error: Failed to download $TARBALL_URL"
        echo "Make sure the branch/ref exists on GitHub."
        exit 1
      }
    else
      echo "Error: Neither git nor curl is available. Cannot download repository."
      exit 1
    fi
    
    # Extract to a temp directory, then move to final location
    TEMP_EXTRACT="$PMC_HOME/temp_extract"
    mkdir -p "$TEMP_EXTRACT"
    tar -xzf "$TEMP_TAR" -C "$TEMP_EXTRACT" || {
      echo "Error: Failed to extract tarball"
      rm -f "$TEMP_TAR"
      rm -rf "$TEMP_EXTRACT"
      exit 1
    }
    
    # Find the extracted directory (GitHub creates pm-copilot-branch-name)
    EXTRACTED_DIR=$(find "$TEMP_EXTRACT" -maxdepth 1 -type d ! -path "$TEMP_EXTRACT" | head -1)
    if [ -z "$EXTRACTED_DIR" ]; then
      echo "Error: Could not find extracted directory"
      rm -f "$TEMP_TAR"
      rm -rf "$TEMP_EXTRACT"
      exit 1
    fi
    
    mv "$EXTRACTED_DIR" "$REPO_DIR"
    rm -f "$TEMP_TAR"
    rm -rf "$TEMP_EXTRACT"
    echo "  ✓ Downloaded tarball"
  fi
fi

PLUGIN_SKILLS="$REPO_DIR/plugins/pm-copilot/skills"
PLUGIN_TEMPLATES="$REPO_DIR/plugins/pm-copilot/templates"

# Verify the repo structure exists
if [ ! -d "$PLUGIN_SKILLS" ]; then
  echo "Error: Repository structure invalid. Expected $PLUGIN_SKILLS"
  exit 1
fi

# Step 2: Install skills via symlinks (idempotent)
echo ""
echo "Installing PM Co-Pilot skills..."
mkdir -p "$SKILLS_DIR"

SKILL_NAMES=(
  "get-started"
  "first-run"
  "morning-brief"
  "weekly-prep"
  "open-loops"
  "self-improvement"
  "memory-keeper"
  "sync"
  "consolidate"
  "improve"
)

FAILED_SKILLS=()
for skill in "${SKILL_NAMES[@]}"; do
  LINK_PATH="$SKILLS_DIR/$skill"
  TARGET_PATH="$PLUGIN_SKILLS/$skill"
  
  # Remove existing link or stale link
  if [ -L "$LINK_PATH" ]; then
    rm "$LINK_PATH"
  elif [ -e "$LINK_PATH" ]; then
    echo "  ⊘ $skill exists and is not a symlink, skipping"
    continue
  fi
  
  # Create symlink
  ln -s "$TARGET_PATH" "$LINK_PATH"
  
  # Verify the target contains SKILL.md
  if [ -f "$TARGET_PATH/SKILL.md" ]; then
    echo "  ✓ Linked $skill"
  else
    echo "  ✗ $skill -> SKILL.md not found at target!"
    FAILED_SKILLS+=("$skill")
  fi
done

if [ ${#FAILED_SKILLS[@]} -gt 0 ]; then
  echo ""
  echo "Error: Some skills failed verification:"
  for skill in "${FAILED_SKILLS[@]}"; do
    echo "  - $skill"
  done
  exit 1
fi

# Step 3: Create workspace directory if it doesn't exist
echo ""
if [ ! -d "$WORKSPACE_DIR" ]; then
  echo "Creating workspace at $WORKSPACE_DIR..."
  mkdir -p "$WORKSPACE_DIR"
else
  echo "Workspace exists at $WORKSPACE_DIR"
fi

# Step 4: Create AGENTS.md if it doesn't exist (never overwrite)
if [ ! -f "$WORKSPACE_DIR/AGENTS.md" ]; then
  echo "  Creating AGENTS.md..."
  cp "$PLUGIN_TEMPLATES/AGENTS.md" "$WORKSPACE_DIR/AGENTS.md"
  echo "  ✓ Created AGENTS.md"
else
  echo "  ✓ AGENTS.md already exists (preserving)"
fi

# Step 5: Create memory directory structure if it doesn't exist
MEMORY_DIR="$WORKSPACE_DIR/memory"
if [ ! -d "$MEMORY_DIR" ]; then
  echo "  Creating memory structure..."
  mkdir -p "$MEMORY_DIR/topics"
  mkdir -p "$MEMORY_DIR/state"
  mkdir -p "$MEMORY_DIR/_backups"
  
  # Copy memory templates (only if they don't exist)
  for template in role.md colleagues.md scope.md day-to-day.md voice.md decisions.md; do
    if [ ! -f "$MEMORY_DIR/$template" ]; then
      cp "$PLUGIN_TEMPLATES/memory/$template" "$MEMORY_DIR/$template"
    fi
  done
  
  # Create empty placeholder files
  for placeholder in context-gaps.md context-watchlist.md skill-improvements.md meeting-prep-recurring.md; do
    [ ! -f "$MEMORY_DIR/$placeholder" ] && touch "$MEMORY_DIR/$placeholder"
  done
  
  echo "  ✓ Created memory structure"
else
  echo "  ✓ Memory directory exists (preserving)"
fi

# Step 6: Update global AGENTS.md with PM Co-Pilot block (idempotent)
GLOBAL_AGENTS="$USER_HOME/.codex/AGENTS.md"
PMC_MARKER_BEGIN="# BEGIN PM Co-Pilot"
PMC_MARKER_END="# END PM Co-Pilot"

mkdir -p "$USER_HOME/.codex"

if [ -f "$GLOBAL_AGENTS" ]; then
  # Check if our block already exists
  if grep -q "$PMC_MARKER_BEGIN" "$GLOBAL_AGENTS"; then
    echo "  ✓ Global AGENTS.md already has PM Co-Pilot block (preserving)"
  else
    echo "  Appending PM Co-Pilot block to global AGENTS.md..."
    cat >> "$GLOBAL_AGENTS" <<EOF

$PMC_MARKER_BEGIN
# When working in ~/pm-copilot:
# - Read ./AGENTS.md at the start of each session
# - Load memory files from ./memory/ based on the routing table
# - Never invent facts about the user; use only what appears in memory files
$PMC_MARKER_END
EOF
    echo "  ✓ Appended PM Co-Pilot block"
  fi
else
  echo "  Creating global AGENTS.md with PM Co-Pilot block..."
  cat > "$GLOBAL_AGENTS" <<EOF
$PMC_MARKER_BEGIN
# When working in ~/pm-copilot:
# - Read ./AGENTS.md at the start of each session
# - Load memory files from ./memory/ based on the routing table
# - Never invent facts about the user; use only what appears in memory files
$PMC_MARKER_END
EOF
  echo "  ✓ Created global AGENTS.md"
fi

echo ""
echo "================================================"
echo "PM Co-Pilot for Codex installed successfully!"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open the pm-copilot workspace in Codex:"
echo "     Open the Codex app or run: codex --cd ~/pm-copilot"
echo ""
echo "  2. Say 'set me up' or invoke the get-started skill:"
echo "     \$get-started"
echo ""
echo "  3. Follow the setup questions (about 5 minutes)"
echo ""
echo "After setup, run workflows anytime:"
echo "  - \$morning-brief  (daily)"
echo "  - \$weekly-prep    (start of week)"
echo "  - \$open-loops     (twice a week)"
echo "  - \$self-improvement (weekly)"
echo ""
