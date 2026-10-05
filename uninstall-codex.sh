#!/usr/bin/env bash
# PM Co-Pilot for Codex - Uninstaller
# Removes skill symlinks, preserves workspace and memory
# Safe to re-run

set -euo pipefail

echo "Uninstalling PM Co-Pilot for Codex..."

# Determine user home
USER_HOME="${HOME:-$( cd ~ && pwd )}"

# Set paths
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
    # Check if it's a PM Co-Pilot symlink (points to pm-copilot directory)
    if readlink "$LINK_PATH" | grep -q "pm-copilot"; then
      rm "$LINK_PATH"
      echo "  ✓ Removed $skill"
      ((REMOVED++))
    else
      echo "  ⊘ Skipped $skill (not a PM Co-Pilot symlink)"
    fi
  fi
done

if [ $REMOVED -eq 0 ]; then
  echo "  No PM Co-Pilot skills found to remove."
fi

# Step 2: Inform about workspace preservation
echo ""
if [ -d "$WORKSPACE_DIR" ]; then
  echo "Your workspace and memory are preserved at:"
  echo "  $WORKSPACE_DIR"
  echo ""
  echo "This contains your personal setup and memory files."
  echo "If you want to remove it too, run:"
  echo "  rm -rf $WORKSPACE_DIR"
else
  echo "No workspace directory found at $WORKSPACE_DIR"
fi

# Step 3: Check global AGENTS.md
echo ""
if [ -f "$GLOBAL_AGENTS" ] && grep -q "pm-copilot" "$GLOBAL_AGENTS" 2>/dev/null; then
  echo "Note: Your global Codex instructions reference pm-copilot:"
  echo "  $GLOBAL_AGENTS"
  echo ""
  echo "You may want to edit or remove this file."
fi

echo ""
echo "================================================"
echo "PM Co-Pilot for Codex uninstalled successfully!"
echo "================================================"
echo ""
