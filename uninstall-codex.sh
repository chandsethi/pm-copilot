#!/usr/bin/env bash
# PM Co-Pilot for Codex - Uninstaller
# Removes skill symlinks and global AGENTS.md block, preserves workspace and memory
# Safe to re-run

set -euo pipefail

echo "Uninstalling PM Co-Pilot for Codex..."

# Determine user home
USER_HOME="${HOME:-$( cd ~ && pwd )}"

# Set paths
PMC_HOME="$USER_HOME/.pm-copilot"
SKILLS_DIR="$USER_HOME/.agents/skills"
WORKSPACE_DIR="$USER_HOME/pm-copilot"
GLOBAL_AGENTS="$USER_HOME/.codex/AGENTS.md"

# List of skill names to remove
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

# Step 1: Remove skill symlinks
echo "Removing PM Co-Pilot skills..."
REMOVED=0
for skill in "${SKILL_NAMES[@]}"; do
  LINK_PATH="$SKILLS_DIR/$skill"
  if [ -L "$LINK_PATH" ]; then
    # Check if it's a PM Co-Pilot symlink (points to .pm-copilot directory)
    TARGET=$(readlink "$LINK_PATH" || true)
    if [[ "$TARGET" == *".pm-copilot"* ]]; then
      rm "$LINK_PATH"
      echo "  ✓ Removed $skill"
      REMOVED=$((REMOVED + 1))
    else
      echo "  ⊘ Skipped $skill (not a PM Co-Pilot symlink)"
    fi
  fi
done

if [ $REMOVED -eq 0 ]; then
  echo "  No PM Co-Pilot skills found to remove."
fi

# Step 2: Remove PM Co-Pilot block from global AGENTS.md
echo ""
if [ -f "$GLOBAL_AGENTS" ]; then
  PMC_MARKER_BEGIN="# BEGIN PM Co-Pilot"
  PMC_MARKER_END="# END PM Co-Pilot"
  
  if grep -q "$PMC_MARKER_BEGIN" "$GLOBAL_AGENTS"; then
    echo "Removing PM Co-Pilot block from global AGENTS.md..."
    # Create temp file without the PM Co-Pilot block
    sed "/^$PMC_MARKER_BEGIN$/,/^$PMC_MARKER_END$/d" "$GLOBAL_AGENTS" > "$GLOBAL_AGENTS.tmp"
    mv "$GLOBAL_AGENTS.tmp" "$GLOBAL_AGENTS"
    echo "  ✓ Removed PM Co-Pilot block from $GLOBAL_AGENTS"
  else
    echo "  ✓ Global AGENTS.md has no PM Co-Pilot block"
  fi
fi

# Step 3: Inform about workspace and cached repo preservation
echo ""
echo "Preserved (not removed):"
if [ -d "$WORKSPACE_DIR" ]; then
  echo "  • Workspace: $WORKSPACE_DIR"
  echo "    Contains your personal setup and memory files."
fi
if [ -d "$PMC_HOME" ]; then
  echo "  • Cached repository: $PMC_HOME/repo"
  echo "    Used for updates. Safe to delete to save space."
fi

echo ""
echo "To remove everything including memory:"
echo "  rm -rf $WORKSPACE_DIR $PMC_HOME"

echo ""
echo "================================================"
echo "PM Co-Pilot for Codex uninstalled successfully!"
echo "================================================"
echo ""
