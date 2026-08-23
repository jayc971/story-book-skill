export default {
  async fetch(request, env) {
    if (request.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    let payload;
    try {
      payload = await request.json();
    } catch {
      return new Response("Invalid JSON", { status: 400 });
    }

    const title = String(payload.title || "Story Book feedback").slice(0, 200);
    const body = String(payload.body || "").slice(0, 5000);

    const ghResponse = await fetch(
      `https://api.github.com/repos/${env.GITHUB_OWNER}/${env.GITHUB_REPO}/issues`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${env.GITHUB_TOKEN}`,
          Accept: "application/vnd.github+json",
          "User-Agent": "story-book-feedback-worker",
        },
        body: JSON.stringify({ title, body, labels: ["feedback"] }),
      }
    );

    if (!ghResponse.ok) {
      return new Response("Failed to file feedback", { status: 502 });
    }

    return new Response("Feedback filed, thank you!", { status: 200 });
  },
};
