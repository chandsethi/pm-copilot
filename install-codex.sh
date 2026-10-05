#!/usr/bin/env bash
# PM Co-Pilot for Codex - Installer
# Installs skills, creates workspace with memory templates and AGENTS.md
# Safe to re-run (idempotent)

set -euo pipefail

echo "Installing PM Co-Pilot for Codex..."

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
SKILLS_DIR="$USER_HOME/.agents/skills"
WORKSPACE_DIR="$USER_HOME/pm-copilot"
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_SKILLS="$PLUGIN_ROOT/plugins/pm-copilot/skills"
PLUGIN_TEMPLATES="$PLUGIN_ROOT/plugins/pm-copilot/templates"

echo "  OS: $OS"
echo "  Skills will be linked to: $SKILLS_DIR"
echo "  Workspace will be created at: $WORKSPACE_DIR"
echo ""

# Step 1: Create skills directory if it doesn't exist
if [ ! -d "$SKILLS_DIR" ]; then
  echo "Creating skills directory..."
  mkdir -p "$SKILLS_DIR"
fi

# Step 2: Install skills via symlinks (idempotent - remove and recreate)
echo "Installing PM Co-Pilot skills..."
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

for skill in "${SKILL_NAMES[@]}"; do
  LINK_PATH="$SKILLS_DIR/$skill"
  TARGET_PATH="$PLUGIN_SKILLS/$skill"
  
  if [ -L "$LINK_PATH" ]; then
    # Remove existing symlink
    rm "$LINK_PATH"
  elif [ -e "$LINK_PATH" ]; then
    echo "  Warning: $LINK_PATH exists and is not a symlink. Skipping $skill."
    continue
  fi
  
  ln -s "$TARGET_PATH" "$LINK_PATH"
  echo "  ✓ Linked $skill"
done

# Step 3: Create workspace directory if it doesn't exist
if [ ! -d "$WORKSPACE_DIR" ]; then
  echo ""
  echo "Creating workspace at $WORKSPACE_DIR..."
  mkdir -p "$WORKSPACE_DIR"
fi

# Step 4: Create AGENTS.md if it doesn't exist (never overwrite)
if [ ! -f "$WORKSPACE_DIR/AGENTS.md" ]; then
  echo "  Creating AGENTS.md..."
  cp "$PLUGIN_TEMPLATES/AGENTS.md" "$WORKSPACE_DIR/AGENTS.md"
  echo "  ✓ Created AGENTS.md"
else
  echo "  ✓ AGENTS.md already exists (not overwriting)"
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
  touch "$MEMORY_DIR/context-gaps.md"
  touch "$MEMORY_DIR/context-watchlist.md"
  touch "$MEMORY_DIR/skill-improvements.md"
  touch "$MEMORY_DIR/meeting-prep-recurring.md"
  
  echo "  ✓ Created memory structure"
else
  echo "  ✓ Memory directory already exists (not overwriting)"
fi

# Step 6: Create global AGENTS.md pointer (optional, for convenience)
GLOBAL_AGENTS="$USER_HOME/.codex/AGENTS.md"
if [ ! -f "$GLOBAL_AGENTS" ]; then
  echo ""
  echo "Creating global AGENTS.md pointer (optional)..."
  mkdir -p "$USER_HOME/.codex"
  cat > "$GLOBAL_AGENTS" <<'EOF'
# Global Codex Instructions

When working in ~/pm-copilot:
- Read ./AGENTS.md at the start of each session
- Load memory files from ./memory/ based on the routing table
- Never invent facts about the user; use only what appears in memory files

For other projects, follow their own AGENTS.md if present.
EOF
  echo "  ✓ Created $GLOBAL_AGENTS"
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
echo "To uninstall, run: curl -fsSL https://raw.githubusercontent.com/chandsethi/pm-copilot/main/uninstall-codex.sh | bash"
echo ""
