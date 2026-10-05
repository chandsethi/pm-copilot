---
name: get-started
description: Start here - sets up PM Co-Pilot for a new user by walking through a few questions and writing their routing brain and memory. Triggers on "set me up", "get started", "get me started", "set up pm co-pilot", "pm copilot setup", "onboard me", "how do I start", "help me start", or any first-time request to begin using PM Co-Pilot. This is the plain-language front door; it runs the same setup flow.
---

The user wants to start using PM Co-Pilot. Run the full setup now.

Follow the setup flow below end to end: locate the workspace, check which tools are connected, ask the setup questions in short batches (proposing answers from connected tools where you can), write the routing brain (AGENTS.md or CLAUDE.md) and the `memory/` scaffold on their confirmation, then show them their memory as a short recap and point them to the first-run workflow.

## Ground rules
- Ask in small batches, not one giant form.
- Every question has a sensible default. Make clear they can accept the default and refine later. Nobody should stall.
- **Recommend, don't interrogate.** Wherever a tool is connected, PROPOSE the answer from real signals and ask the user to confirm or adjust, instead of asking them to type from a blank page. Only ask cold when you have nothing to propose.
- This system is tool-agnostic. Ask what they use; never assume a specific tool.
- Write only to their chosen workspace folder. Never write outside it. Show what you'll write before writing.

## Step 1 - Locate the workspace
Confirm the folder where their routing brain (AGENTS.md or CLAUDE.md) and `memory/` should live (their main agent working folder). A fresh, empty folder is perfectly fine and avoids tangling with anything else they run. If unclear, ask. Everything below is written there.

**Before writing anything, check for an existing setup.** If the chosen folder already has a routing brain file or a `memory/` folder, stop and tell the user plainly. Do not overwrite it. Give them two options and let them pick before you go on:
- Point setup at a fresh, empty folder instead, so PM Co-Pilot stays separate from what they already run.
- Or walk through their existing routing brain together and fold PM Co-Pilot's routing table and memory files into it, so nothing they rely on is lost.

Only proceed once they have chosen. Never replace an existing routing brain on your own.

## Step 2 - Check what's connected
Quickly note which relevant tools are actually available (chat, task tracker, email, calendar, notes/transcripts, docs) via MCP or other connections. You'll use the connected ones both to propose answers below and to tell the user, at the end, which workflows will be live vs skipped. If a tool they rely on isn't connected, note it and tell them how to connect it (MCP server configuration) or that the related workflow step will simply be skipped until they do.

## Step 3 - Ask the setup questions (batched, propose-first)
Group into a few short rounds. Offer defaults in brackets. For any item marked "propose", do the discovery read first and present your suggestion for confirmation.

**You** (propose name, role, company, email domain, timezone from the account/profile/calendar where possible)
- Name?
- Role / title? [Product Manager]
- Company, in one line of what it does?
- Work email domain?
- Location / timezone? [detect]
- **Manager** (propose from recurring 1:1s on the calendar): "Looks like your manager may be [X], from your recurring 1:1. Right?"
- Primary focus or domain right now?
- What you're working toward (a launch, a metric, a promotion)? [optional]

**Your tools** (for each: name the tool, or "none")
- Chat / messaging? [e.g. Slack, Teams, Discord]
- Task tracker, your "board"? [e.g. Notion, Jira, Linear, Asana, a to-do app] and its lists/statuses [default: Inbox / This Week / Backlog / Archive].
  - **If they don't have a tracker yet:** offer to create one. "I can set up a simple board for you (for example a Notion database, or a markdown board in your folder). Want me to?" If yes, create it and record where it lives and its ID. Don't force them into a tool they don't use.
- Email? [e.g. Gmail, Outlook]
- Calendar? [e.g. Google Calendar, Outlook]
- Meeting notes / transcripts? [e.g. Otter, Fireflies, tl;dv, none]
- Docs store? [e.g. Google Drive, Confluence, Notion]
- Optional: a personal capture channel (a private chat channel where you toss things for the co-pilot to file). If they want one, note its name/ID; the morning brief will read it.
- What is your company OK with you connecting? (so you never suggest a tool they can't use)

**Your key channels and people** (propose, don't ask cold)
- **Priority channels:** if chat is connected, scan the last ~30 days for the channels they post in, are mentioned in, or have starred (their sidebar groups are the best signal), rank the top 10 to 15, and present them to confirm/trim/add. If chat isn't connected, ask for a short list.
- **VIPs (people whose messages always surface):** if chat/calendar is connected, propose frequent DM contacts and recurring 1:1 partners with a one-line reason each ("appears in 8 threads this month"), present to confirm/trim/add. Otherwise ask for a few names.

**Your rhythm**
- When does your week start? [Monday]
- When do you wrap up / review the week? [Friday afternoon]
- When do you want your morning brief, and in what timezone? [09:00 local]
- Any non-working days or holidays to respect?

**Your voice** [all optional]
- General tone? [direct and concise]
- Anything you never do in writing? [e.g. no em-dashes, no emoji]
- Paste 1 to 3 real things you've written, if you want it to sound like you.

## Step 4 - Write the files and create the folders
Fill the templates from the answers. Create the full folder structure up front so nothing ever fails later with "nowhere to save":

**Determine which routing brain to create:**
- If you're running in Claude Code or Claude Cowork: create `CLAUDE.md`
- If you're running in Codex: create `AGENTS.md`
- Copy from the appropriate template in this plugin's `templates/` folder

**Create these files:**
- The routing brain (`AGENTS.md` or `CLAUDE.md`) from the appropriate template (adjust the tool references to match their stack; keep the routing table).
- `memory/role.md`, `memory/colleagues.md`, `memory/scope.md`, `memory/day-to-day.md`, `memory/voice.md`, `memory/decisions.md` from `templates/memory/`, filled with their answers. Record their priority channels and capture channel in `day-to-day.md`. Leave blanks where they skipped; do not invent anything.
- Create these empty so every workflow has a home: `memory/topics/`, `memory/state/`, `memory/context-gaps.md`, `memory/context-watchlist.md`, `memory/skill-improvements.md`, `memory/meeting-prep-recurring.md`, and a `memory/_backups/` folder for the sync/consolidate backups.

Show the user exactly what you're about to write (a short summary per file), then write on their confirmation. Never fabricate a fact they didn't give.

## Step 5 - Point them to the next steps
First, **show them their memory** so it feels real, not hidden. Present a short, friendly recap of what the co-pilot now knows, one line per file, drawn from what they just gave you, for example:
```
Here's what I've got so far. This is your memory, it lives in your folder, and it grows as we work.
- You: [name], [role] at [company], [timezone]
- People I'll watch for: [VIPs]
- What you own: [focus/scope]
- Your tools: [connected tools] · [any skipped]
- Your week: starts [day], review [day], brief at [time]
- Your voice: [tone] · [never-dos]
You can change any of this anytime by just telling me.
```
Fill only from their answers; show blanks as "not set yet", never invent. Then confirm which workflows will be live vs skipped based on their connected tools, and tell them:
- Their system is live; from now on the agent reads the routing brain and loads the right memory automatically.
- Run the first-run workflow to run all the workflows once right now, see the output, and calibrate. In Claude: say "first run" or use the first-run skill. In Codex: invoke `$first-run`.
- After that, run any workflow whenever they want by opening a new chat and invoking it: `$morning-brief` each morning (or say "morning brief" in Claude), `$weekly-prep` at the start of the week, `$open-loops` and `$self-improvement` for a periodic sweep, `$sync` then `$consolidate` to refresh memory.
- They can add topic files under `memory/topics/` any time; `sync` and `consolidate` keep memory current.
