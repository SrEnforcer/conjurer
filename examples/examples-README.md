# Conjurer examples

Three worked projects. Each is a real specification you can read end to end —
and each also demonstrates a way of *organising* Conjurer work, from a single
file to a multi-file collection.

| Example | Shape | What it is |
|---|---|---|
| [`dice-forge.cnj`](dice-forge.cnj) | single file | A browser workshop for forging and rolling polyhedral dice |
| [`conjurer-site/`](conjurer-site/) | multi-file (5) | The Conjurer documentation & demo website — full-stack |
| [`conjurer-mcp/`](conjurer-mcp/) | multi-file (3) | The Conjurer MCP server and its VS Code extension |

They are deliberately different domains. Read `dice-forge.cnj` first if you
want the whole language in one sitting; reach for the multi-file examples when
you want to see how a larger project is partitioned across concern-bounded
files.

---

## Single-file pattern — `dice-forge.cnj`

Everything in one file, in the canonical section order: charter, assets,
assumptions, context, domain work, frontend design, targets, foresight, and a
closing practitioner grimoire. Best for:

- Projects that fit in a single session
- Demos and teaching (this file exercises nearly every construct — `d/model`
  with mechanically checkable invariants, a `spell`, an `incantation` with
  `:expand :preview`, `t/facet`, `:forbids`, `w/tokens`/`w/flow`/`w/copy`,
  graded `f/candidate`s, and a user-authored `grimoire`)
- Early exploration before concerns solidify
- Sharing a complete project spec in one attachment

Attach the single file to any session whose agent knows Conjurer (via the
`SKILL`). Everything the project needs — its decisions, its domain model, its
targets — is in that one file.

**→ See [`dice-forge.cnj`](dice-forge.cnj)**

---

## Multi-file pattern

One file per concern, anchored by a root that holds the charter, shared assets,
and assumptions. Best for:

- Projects spanning multiple sessions and team members
- Domains large enough that a single file becomes unwieldy
- When different concerns evolve at different speeds, or different people own them

Two examples show the pattern at different scales.

### `conjurer-site/` — a full-stack website

```
conjurer-site/
├── project.cnj        ← ROOT — charter, assets, assumptions
│                         Attach this when you are unsure which file to use
├── domain.cnj         ← entities, shapes, business rules, taxonomy
├── frontend.cnj       ← React app, routes, components, UI targets
├── api.cnj            ← Hono API, endpoints, MCP proxy
└── infrastructure.cnj ← CI/CD, deployment, environment config
```

**Attach pattern per task:**

| Task | Attach |
|---|---|
| Understand the project | `project.cnj` only |
| Model a new entity | `project.cnj` + `domain.cnj` |
| Build a React component | `project.cnj` + `domain.cnj` + `frontend.cnj` |
| Build an API endpoint | `project.cnj` + `domain.cnj` + `api.cnj` |
| CI/CD or deployment | `project.cnj` + `infrastructure.cnj` |

**→ See [`conjurer-site/`](conjurer-site/)**

### `conjurer-mcp/` — a server and its editor extension

The most extensive example: the Conjurer MCP server itself, plus the VS Code
extension that drives it. Two deliverables sharing one anchor.

```
conjurer-mcp/
├── conjurer-mcp.cnj      ← ROOT — charter, shared assets, assumptions
├── mcp-server.cnj        ← the stdio MCP server (spec lookup, .cnj validation)
└── vscode-extension.cnj  ← the editor extension that talks to the server
```

This is worth reading for how one anchor coordinates two related-but-distinct
build targets, and for the recursion of it — a Conjurer specification *for the
tooling that serves Conjurer*.

**→ See [`conjurer-mcp/`](conjurer-mcp/)**

---

## References resolve transitively

A concern file names its dependencies in `:references`. An agent that knows
Conjurer resolves them for you — attaching `frontend.cnj` makes `domain.cnj`
and `project.cnj` context available without attaching each by hand. The root
anchor summarises files that are referenced but not attached, so an agent
working on one part always has a map of the whole.

With the **Conjurer MCP server running** (itself the `conjurer-mcp/` example),
this resolution — and form-level evaluation with full workspace context — is a
first-class workspace service rather than something the agent reconstructs each
session. Without it, the same context assembles by attaching the files an agent
reads directly; the MCP server is a convenience, not a prerequisite.

---

## Form evaluation

Any form in a `.cnj` file can be evaluated in isolation — a single `target`
block, one `shape`, a lone `conjure`. Select the full s-expression and ask the
agent to evaluate it; with the MCP server running you can also address a form by
location (`evaluate this: #domain.cnj:54:70`) and have the workspace context
injected automatically, so a form from `domain.cnj` sees `project.cnj`'s assets
and assumptions without manual attachment.

Forms in the multi-file examples are annotated with `@eval filename.cnj:start:end`
comments so the line ranges are easy to find.

---

## Naming conventions for multi-file projects

| File | What goes in it |
|---|---|
| `project.cnj` (or `{name}.cnj` anchor) | Root charter, all assets, all operative assumptions |
| `domain.cnj` | `d/model`, `shape`, `r/rules`, `t/define`, `lore` |
| `frontend.cnj` | `target` for web/UI, component structure, route design |
| `api.cnj` | `target` for API/backend, endpoint contracts, auth rules |
| `infrastructure.cnj` | `target` for CI/CD, deployment, env config |
| `{deliverable}.cnj` | A specific deliverable's domain work + targets |

Each concern file carries its own `charter` with a `:version` that tracks
independently. Cross-cutting decisions always go in the root anchor's
`:decisions` log — the single source of truth for choices that span concerns.
