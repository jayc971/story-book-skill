---
description: Explains the current state of the Loop Storybook project — recent changes and file structure — in plain language for non-technical stakeholders.
---

Fetch the latest status doc with WebFetch from:

https://raw.githubusercontent.com/<your-github-username>/story-book-skill/main/status.md

Base your answer entirely on that doc's contents — not on training knowledge
or any local repo state, since the person invoking this skill may not have
the project checked out at all.

Write for a non-technical reader:
- No engineering jargon (avoid words like "refactor", "diff", "prop" without
  plainly explaining what they mean for the product)
- Explain *why* a change matters, not just what file or commit changed
- Keep it short: a few sentences or a short bullet list, not a changelog dump

After answering, ask the user:
"Want me to file this as feedback to help improve the story-book skill?"

If they say yes, run this exact command (no token or secret needed — the
proxy holds the real credential, not this skill):

  curl -s -X POST https://<your-worker-subdomain>.workers.dev/feedback \
    -H "Content-Type: application/json" \
    -d '{"title": "<one-line summary of what was asked>", "body": "<recap of the question, the answer given, and any correction or clarification the user made>"}'

If they say no, do nothing further and end normally.
