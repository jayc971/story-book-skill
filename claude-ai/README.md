# Using story-book on claude.ai

This is a claude.ai-native version of the `/story-book` skill. It doesn't
rely on a plugin install (that's a Claude Code concept) or on the Cloudflare
feedback proxy (that requires curl access this chat surface may not have,
and unfamiliar-domain webhooks are the kind of thing a fresh Claude instance
correctly hesitates to call). Instead it works entirely through fetching a
public GitHub URL and, for feedback, handing the user a plain GitHub link to
click.

## Setup (one time, ~1 minute)

1. Make sure **web search** is turned on for your account (Settings →
   Capabilities). Without it, Claude has no way to reach an external URL at
   all.
2. On claude.ai, create a **Project** (any name — e.g. "Loop Storybook
   status").
3. Open the Project's **custom instructions** and paste in the full contents
   of [`project-instructions.md`](./project-instructions.md).
4. Save.

That's it. Every chat inside that Project now behaves like the skill: ask
about the project's status and it fetches the live doc and explains it in
plain language.

## Do NOT use the "Skills" upload feature for this

claude.ai's Skills upload feature (Settings → Capabilities/Skills) runs each
Skill inside a sandboxed code-execution environment with **no general
internet access**. A Skill can never fetch an arbitrary URL like
`raw.githubusercontent.com` — it will always fail with "Failed to fetch",
regardless of how the SKILL.md is written. This is a hard platform
limitation, not a bug in this repo.

The Project custom instructions route above works because it runs as normal
chat (not the Skills sandbox) and can use claude.ai's regular web-browsing
capability instead.

## Why this differs from the Claude Code version

| | Claude Code (`skills/story-book/SKILL.md`) | claude.ai (this folder) |
|---|---|---|
| Install | `/plugin install story-book` | Paste into Project instructions |
| Fetch status.md | WebFetch tool, always available | Needs "web search" enabled in claude.ai Settings; the Skills-upload feature specifically cannot fetch at all (sandboxed, no internet) |
| Feedback | curl to a Cloudflare Worker proxy | Pre-filled `github.com/.../issues/new` link the user opens themselves |
| Trust model | Installing implies trust; tool calls run silently | No install step, so unfamiliar domains/webhooks get (correctly) questioned — this version avoids that by never asking Claude to call anything but github.com |
