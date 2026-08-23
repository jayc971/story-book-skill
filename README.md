# story-book-skill

Distributes the `/story-book` Claude Code skill: a plain-language status
report on the Loop Storybook project, for non-technical stakeholders.
Content is fetched live from this repo on every invocation, so pushing an
update here reaches every installer immediately — no reinstall needed.

## One-time setup (you, the maintainer)

1. Push this folder to your own GitHub repo, e.g.
   `github.com/<you>/story-book-skill`.
2. Replace the two placeholders across this repo:
   - `<your-github-username>` in `.claude-plugin/marketplace.json` and
     `skills/story-book/SKILL.md`
   - `<your-worker-subdomain>` in `skills/story-book/SKILL.md`
3. Deploy the feedback proxy (Cloudflare Workers, free tier):
   ```
   npm install -g wrangler
   wrangler login
   wrangler deploy worker/feedback-worker.js --name story-book-feedback
   wrangler secret put GITHUB_TOKEN    # fine-grained PAT, Issues: read/write only, scoped to this repo
   wrangler secret put GITHUB_OWNER    # your GitHub username
   wrangler secret put GITHUB_REPO     # story-book-skill
   ```
   Wrangler prints the worker's URL — that's what goes in
   `<your-worker-subdomain>` above.
4. Commit and push. The GitHub token never leaves the Worker's own secret
   store — it is never present in this repo or in the skill.

## Daily update routine (you, the maintainer)

Each morning (or whenever you push changes to `loop-storybook`):

```
./scripts/generate-status.sh /path/to/loop-storybook /path/to/story-book-skill
git add status.md
git commit -m "Update status"
git push
```

That's it — every installed `/story-book` skill picks up the new content
on its next use, since it fetches this file live rather than bundling it.

Also check the `feedback` label on this repo's Issues — that's where
`/story-book` files feedback when users opt in. Fold anything useful into
the next status update, then close the issue.

## Installing the skill (your team)

**Claude Code:**

```
/plugin marketplace add <you>/story-book-skill
/plugin install story-book
```

No further setup — no token, no environment variable, nothing to
configure. Typing `/story-book` (or just asking about the project) will
trigger it.

**claude.ai (chat, not Claude Code):** see [`claude-ai/README.md`](./claude-ai/README.md)
— there's no plugin install on claude.ai, so this uses Project custom
instructions and a plain GitHub link for feedback instead of the Cloudflare
proxy.
