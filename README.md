# PM Co-Pilot

> 🎙️ **Featured on How I AI with Claire Vo.** [Watch](https://www.youtube.com/watch?v=p2qmX6TM0kw) · [Listen](https://open.spotify.com/episode/75Adi3KXzDDXIZEJmnv6N6) · [Read](https://www.lennysnewsletter.com/p/how-i-turned-claude-into-a-self-improving)

Being a PM means holding fifty things in your head at once. Tasks pile up across email, chat, and meetings and keep reshuffling while you're stuck in back-to-back calls. The real work, talking to users and digging into the data, gets squeezed out.

PM Co-Pilot carries that overhead so you can get back to it. It catches what comes at you, keeps it organized, and surfaces what actually needs you.

It runs inside Claude Cowork, and works in Claude Code too.

## How it works

You give it context up front: your role, your people, your priorities, how you like to work. After that it keeps that memory up to date as you go, and fills its own gaps instead of waiting for you to spell everything out.

The more you give it, the more it can do. Dump in a lot of context early (dictating with a transcription tool is the fastest way), connect more of your tools, and run more of your work through it.

Four workflows handle the day-to-day, and they build on each other:

- **Weekly prep** starts your week. It pulls from your tools and walks you through setting your priorities and your focus.
- **Morning brief** refreshes that each morning: what came in, what's done, what today needs.
- **Open loops** catches the threads you'd otherwise lose, what you're waiting on and who's waiting on you.
- **Self-improvement** closes the week by learning from how you worked and improving your setup for the next one.

And when you come across a tip for running Claude better, paste it in and **improve** tells you whether it's worth adopting for your setup, then folds the ones you keep into that same loop.

It checks with you before doing anything, and its memory of you stays on your machine.

## What's included

Setup writes two things into your workspace: a **`CLAUDE.md`** routing brain that loads the right memory by topic, and a **`memory/`** folder for your role, people, priorities, decisions, and voice. It keeps that memory current as you work.

**Skills (9)**

- The four workflows above: morning-brief, weekly-prep, open-loops, self-improvement.
- memory-keeper, sync, and consolidate, which keep your memory captured, refreshed, and tidy.
- improve, which weighs an outside setup idea against yours and recommends what to adopt.
- get-started, the plain-language front door: say "set me up" and it runs your setup.

**Commands (3)**

- `/pm-copilot:setup` and `/pm-copilot:first-run` to get going, and `/pm-copilot:improve` to weigh a new setup idea against yours anytime.

> **Already use a `CLAUDE.md`?** This creates its own. Point setup at a fresh folder, or have Claude help you merge it into what you've got, so it works alongside your setup instead of replacing it.

## What you need

- **Claude Cowork, Claude Code, or OpenAI Codex.**
- **Your tools connected.** Hook up whatever you already use through MCP servers, and it works with them. Connect a couple now, add more whenever.

## Get it

Install it once, then open a new chat and type **`set me up`**. That's the whole start; it takes it from there.

> ⚠️ **Install by URL, not by downloading the ZIP.** This repo is a Claude plugin *marketplace* (the plugin itself lives in `plugins/pm-copilot/`), so a downloaded ZIP won't install as a plugin. Add it as a marketplace using the steps below and it's one click.

**In Claude Cowork**

1. Go to **Customize > Plugins > Add marketplace** and paste this repo's link.
2. Find **PM Co-Pilot** and click **Install**.
3. Open a new chat and type **`set me up`** (or run **`/pm-copilot:setup`**). A few questions, skip any you want, and it's yours.
4. Run **`/pm-copilot:first-run`** to see it work once, so you can fix anything that's off.

**In Claude Code**

Run:

```
/plugin marketplace add IamBlum/pm-copilot
/plugin install pm-copilot@pm-copilot
```

Then type **`set me up`** (or run **`/pm-copilot:setup`**), followed by **`/pm-copilot:first-run`**.

**In Codex (OpenAI)**

Run this one-line installer in your terminal (no admin rights needed):

```bash
curl -fsSL https://raw.githubusercontent.com/chandsethi/pm-copilot/main/install-codex.sh | bash
```

Then:
1. Open the pm-copilot folder in Codex (the installer creates `~/pm-copilot` for you)
2. Type **`set me up`** or invoke **`$get-started`**
3. Follow the setup questions (about 5 minutes)

The installer downloads the plugin to `~/.pm-copilot/repo` and symlinks skills to `~/.agents/skills`. Re-run anytime to update.

After setup, run workflows by invoking them as skills: `$morning-brief`, `$weekly-prep`, `$open-loops`, `$self-improvement`.

To uninstall:
```bash
curl -fsSL https://raw.githubusercontent.com/chandsethi/pm-copilot/main/uninstall-codex.sh | bash
```

Your workspace and memory at `~/pm-copilot` are preserved when you uninstall. To remove everything including memory:
```bash
rm -rf ~/pm-copilot ~/.pm-copilot
```

## Running it

**In Claude:** Open a new chat and run a workflow whenever you want it. Just type the workflow name: `morning-brief` each morning, `weekly-prep` at the start of your week, `open-loops` and `self-improvement` for a periodic sweep, and `sync` then `consolidate` to refresh your memory every couple of weeks.

**In Codex:** Invoke workflows as skills using `$` to see available skills, or call them directly: `$morning-brief`, `$weekly-prep`, `$open-loops`, `$self-improvement`, `$sync`, `$consolidate`.

**Why you run them yourself.** Run workflows in a normal chat on your machine where they can access your local memory folder. Scheduled or cloud-based runs may not have access to local files.

## Staying updated

**For Claude installations:**

Turn on auto-update once and new versions arrive on their own:

- **Claude Code:** run `/plugin`, open the **Marketplaces** tab, select PM Co-Pilot, and choose **Enable auto-update**.
- **Cowork:** open **Customize > Plugins** and enable updates for the PM Co-Pilot marketplace.

After that, updates download in the background and load next time you start (Claude may nudge you to run `/reload-plugins`). Updating never touches your `CLAUDE.md` or memory, so your setup stays exactly as you left it. New skills show up automatically; tweaks to the setup templates only apply to fresh setups.

PM Co-Pilot also tells you in-chat when it updates, so you don't have to go looking.

**For Codex installations:**

Re-run the installer to update to the latest version:

```bash
curl -fsSL https://raw.githubusercontent.com/chandsethi/pm-copilot/main/install-codex.sh | bash
```

The installer is idempotent and safe to re-run. It updates skill symlinks without touching your workspace or memory.

**Version history:** See [CHANGELOG.md](plugins/pm-copilot/CHANGELOG.md) or the repo's **Releases** page.

## Feedback

Tried it and have thoughts, or hit a snag? Email me at [itsdanielsagent@gmail.com](mailto:itsdanielsagent@gmail.com).

## License

MIT.

## Working on it (development)

Want to hack on it or contribute?

1. Clone it: `git clone https://github.com/IamBlum/pm-copilot.git`
2. The plugin lives in `plugins/pm-copilot/`: its commands, skills, hooks, and memory templates. Edit there.
3. To test your changes, point a marketplace at your local clone in Claude Code: `/plugin marketplace add <path-to-your-clone>`, then `/plugin install pm-copilot@pm-copilot` and reload.

PRs welcome.
