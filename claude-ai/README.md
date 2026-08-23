# Using story-book on claude.ai

claude.ai doesn't have a plugin-install mechanism like Claude Code, and its
"Skills" feature runs in a sandbox with **no general internet access** — a
Skill can never fetch an external URL like `raw.githubusercontent.com`; it
will always fail with "Failed to fetch" no matter how the SKILL.md is
written. That single constraint is why there are two different options
below, depending on what you care about more: the literal `/story-book`
command, or always-live data.

## Option A — `/story-book` as an actual command (snapshot, not live)

This is what most people mean when they say "install the skill." It uses
claude.ai's Skills upload feature, with the status content **bundled inside
the Skill** instead of fetched over the network (the officially supported
pattern for Skills that need data, since the sandbox blocks fetching).

**Setup:**

1. Run `./scripts/package-claude-ai-skill.sh` from this repo — it copies the
   current `status.md` into `claude-ai/skill/references/` and produces
   `claude-ai/story-book-skill.zip`.
2. On claude.ai: Settings → Capabilities/Skills → upload that zip.
3. Type `/story-book` (or ask about the project) in any chat.

**The tradeoff:** the content is a snapshot from whenever the zip was last
uploaded — not live. To refresh it, re-run the script and re-upload the zip.
This is the same kind of "re-run an update step" maintenance as Claude Code
users running `/plugin install story-book@story-book-skill` again after a
skill change — just manual instead of one command, since claude.ai has no
plugin-update mechanism.

Each teammate who wants `/story-book` needs to upload the zip to their own
account — Skills aren't shared automatically (that needs Enterprise-admin
provisioning). Share the zip file or the script + repo access.

## Option B — Live data, no slash command

If always-current data matters more than the `/story-book` command itself,
use a claude.ai Project instead — it runs as normal chat, not the Skills
sandbox, so it can actually fetch a live URL.

1. Make sure **web search** is turned on for your account (Settings →
   Capabilities) — without it Claude can't reach any external URL.
2. Create a claude.ai **Project** (e.g. "Loop Storybook status").
3. Paste the contents of [`project-instructions.md`](./project-instructions.md)
   into the Project's custom instructions.
4. Ask about the project's status in any chat inside that Project — no
   `/story-book` command, just ask naturally.

Sharing this with a team: invite teammates to the Project (Team/Enterprise
plans support this) and they get the same behavior with zero setup of their
own, still no slash command.

## Feedback, either way

Both options ask "Want me to file this as feedback?" and, if yes, hand the
user a pre-filled `github.com/jayc971/story-book-skill/issues/new?...` link
to open themselves — never a curl call to an unfamiliar domain, since a
fresh claude.ai session has no reason to trust that the way an installed
Claude Code plugin implicitly does.

## Comparison

| | Claude Code (`skills/story-book/SKILL.md`) | claude.ai Option A (Skill, bundled) | claude.ai Option B (Project) |
|---|---|---|---|
| Trigger | `/story-book` | `/story-book` | Ask naturally, no command |
| Data freshness | Live (fetched every time) | Snapshot as of last zip upload | Live (fetched every time) |
| Per-teammate setup | `/plugin install` once | Upload the zip once | None, if added to the shared Project |
| Refreshing content | Automatic (fetches live) | Re-run script, re-upload zip | Automatic (fetches live) |
