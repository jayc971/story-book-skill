# Using story-book on claude.ai

This is a claude.ai-native version of the `/story-book` skill. It doesn't
rely on a plugin install (that's a Claude Code concept) or on the Cloudflare
feedback proxy (that requires curl access this chat surface may not have,
and unfamiliar-domain webhooks are the kind of thing a fresh Claude instance
correctly hesitates to call). Instead it works entirely through fetching a
public GitHub URL and, for feedback, handing the user a plain GitHub link to
click.

## Setup (one time, ~1 minute)

1. On claude.ai, create a **Project** (any name — e.g. "Loop Storybook
   status").
2. Open the Project's **custom instructions** and paste in the full contents
   of [`project-instructions.md`](./project-instructions.md).
3. Save.

That's it. Every chat inside that Project now behaves like the skill: ask
about the project's status and it fetches the live doc and explains it in
plain language.

## If your account has the newer "Skills" upload feature

Some claude.ai plans support uploading a Skill folder directly (Settings →
Capabilities/Skills). If you have that, you can instead create a
`SKILL.md` with this frontmatter prepended to the same instructions:

```
---
name: story-book
description: Explains the current state of the Loop Storybook project in plain language for non-technical stakeholders.
---
```

Behavior should be identical either way — the Skills feature just automates
"paste into custom instructions."

## Why this differs from the Claude Code version

| | Claude Code (`skills/story-book/SKILL.md`) | claude.ai (this folder) |
|---|---|---|
| Install | `/plugin install story-book` | Paste into Project instructions |
| Fetch status.md | WebFetch tool, always available | Depends on the chat having fetch access — flag this if it can't retrieve the file |
| Feedback | curl to a Cloudflare Worker proxy | Pre-filled `github.com/.../issues/new` link the user opens themselves |
| Trust model | Installing implies trust; tool calls run silently | No install step, so unfamiliar domains/webhooks get (correctly) questioned — this version avoids that by never asking Claude to call anything but github.com |
