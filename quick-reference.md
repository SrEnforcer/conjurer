# Conjurer — Quick Reference

All 107 symbols across 10 grimoires. For full signatures and examples,
see the individual grimoire files.

---

## core — Foundational constructs

| Symbol | Synopsis |
|---|---|
| `conjure` | Primary manifestation: describe what should exist |
| `refine` | Iteratively enhance an existing manifestation |
| `context` | Establish semantic context for subsequent invocations |
| `using` | Scope a context or namespace to a block |
| `assume` | Declare operative constraints: team, infrastructure, non-negotiables |
| `ritual` | Multi-phase invocation with named stages and intermediate artefacts |
| `explain` | Transparent account of how a manifestation was produced |
| `meta-query` | Interrogate a manifestation — assumptions, trade-offs, failure modes |
| `witness` | Observe without modifying; produces out-of-band reasoning record |
| `as` | Apply a perspectival role — security auditor, new engineer, regulator |
| `~>` | Threading: compose transformations left-to-right |
| `transmute` | Change form while preserving semantic essence |
| `weave` | Integrate independent artefacts into a system with explicit contracts |
| `lore` | Register domain patterns and anti-patterns for session-wide application |
| `sequence` | Execute operations in order; saga compensation on failure |
| `parallel` | Execute operations concurrently; combine by merge, quorum, or first-wins |
| `branch` | Conditional execution on predicate or structural pattern |
| `retry` | Automatic retry with backoff for transient failures |
| `intercept` | Apply cross-cutting concerns without touching the operation |
| `ward` | Structured error containment with explicit degradation ladder |
| `shape` | Semantic type contract — what data means, not just its structure |
| `charter` | Session anchor for `.cnj` files: goals, decisions, open questions |
| `target` | Declare implementation form: language, standard, artefact types |
| `asset` | Register external standard or capability (coding standard, design system) |
| `handover` | Package session context; transfer to specialist agent |

### Key parameters

| Parameter | Meaning |
|---|---|
| `:requires` | Load-bearing capabilities — always present |
| `:prefers` | Preferred capabilities — applied when feasible |
| `:style` | Aesthetic guidance — never overrides correctness |
| `:deferred` | Noted but not implemented now |
| `:manifest` | Bind the result to a name |
| `:when` | Conditional refinement — activates when predicate holds |
| `:inherits` | Context hierarchy — extends parent, does not replace |

---

## domain `d/` — Knowledge extraction

| Symbol | Synopsis |
|---|---|
| `d/explore` | Analyse sources; extract entities, relationships, constraints, rules |
| `d/extract` | Targeted retrieval of a specific domain facet |
| `d/refine` | Deepen or extend an existing model on specific concepts |
| `d/merge` | Combine models; align concepts; make conflicts explicit |
| `d/compare` | Structured comparison: alignments, divergences, gaps |
| `d/scope` | Derive a focused sub-domain view from a larger model |
| `d/model` | Manually define a domain model from practitioner knowledge |
| `d/annotate` | Add tacit knowledge without altering extracted facts |
| `d/validate` | Check model for completeness, consistency, pattern conformance |
| `d/generate-dsl` | Create a domain-specific language from a domain model |
| `d/export` | Export a model to documentation or interchange formats |
| `d/query` | Search a model for concepts, patterns, or relationships |

### `:focus` values for `d/explore`
`:taxonomy` `:entities` `:operations` `:constraints` `:nomenclature`
`:legal-definitions` `:relationships` `:actors` `:lifecycle` `:invariants`

### `:infer` values
`:missing-concepts` `:implicit-rules` `:unstated-assumptions`

---

## data `data/` — Data lifecycle

| Symbol | Synopsis |
|---|---|
| `data/schema` | Formal schema: fields, types, constraints, compliance |
| `data/generate` | Realistic datasets with locale-aware distributions |
| `data/transform` | Declarative reshape, filter, enrich, aggregate |
| `data/convert-format` | Format conversion preserving semantics (CSV ↔ Parquet ↔ JSON …) |
| `data/pipeline` | Multi-stage pipeline with resilience and checkpointing |
| `data/validate` | Validate data against schema; collect all violations |
| `data/profile` | Statistical profile: distributions, cardinalities, drift detection |
| `data/generate-tests` | Auto-generate test suites from schema constraints |
| `data/lineage` | Non-invasive provenance tracking through transformations |
| `data/mask` | Privacy: anonymise, pseudonymise, redact, or substitute |
| `data/reconcile` | Compare two datasets that should match; surface discrepancies |

### `:quality` values for `data/generate`
`:basic` `:realistic` `:production`

### `:strategy` values for `data/mask`
`:anonymise` `:pseudonymise` `:redact` `:synthetic-substitute`

---

## web `w/` — Web development

| Symbol | Synopsis |
|---|---|
| `w/analyze` | Analyse a site: visual design, structure, accessibility, performance |
| `w/extract-style` | Extract design tokens; normalise to NL Design System or Tailwind |
| `w/extract-structure` | Extract page structure, navigation, inferred user journey |
| `w/prototype` | Complete deployable web project; production-ready from first invocation |
| `w/component` | UI component with all variants, states, and interaction patterns |
| `w/tokens` | Design token system: primitives → semantic → component tiers |
| `w/audit` | Accessibility, performance, SEO, code quality audit |
| `w/migrate` | Framework/toolchain migration preserving appearance and behaviour |

### `:accessibility` values
`:wcag-aa` (default, legal minimum) `:wcag-aaa` (highest standard)

### Common `:features` values
`:responsive` `:dark-mode` `:animations` `:accessibility` `:i18n` `:pwa`

---

## semantics `s/` — Textual analysis

| Symbol | Synopsis |
|---|---|
| `s/texan` | Comprehensive semantic extraction through structured analytical models |
| `s/viewpoint` | Explicit perspectival interpretation from a stakeholder role |
| `s/critique` | Systematic weakness identification; constructive mode produces repair suggestions |
| `s/synthesise` | Multi-perspective integration; preserves genuine tensions |
| `s/distill` | Compress to argumentative skeleton — different from summarisation |
| `s/compare` | Compare texts: convergences, divergences, unique claims |
| `s/chronicle` | Extract temporal structure: timeline, causality, projections |
| `s/counter-manifest` | Principled alternative interpretation from a different position |
| `s/semantic-profile` | Semantic fingerprint: argumentative complexity, rhetorical features |

### `:models` for `s/texan`
`:argumentation` `:framing` `:rhetoric` `:ethics` `:sentiment` `:style`
`:logical` `:contextual` `:power` `:facts-assumptions` `:temporal` `:stakeholder`

---

## orchestrate `o/` — Runtime workflow coordination

| Symbol | Synopsis |
|---|---|
| `o/define-workflow` | Named versioned workflow: stages, compensation, monitoring |
| `o/execute-workflow` | Initiate a workflow instance; supports dry-run and resume |
| `o/workflow-status` | Query current state of a running or completed instance |
| `o/scatter-gather` | Distribute in parallel; aggregate by merge, quorum, or first-wins |
| `o/human-approval` | Human-in-the-loop checkpoint with deadline, escalation, audit trail |
| `o/circuit-breaker` | Detect systematic failures; fail fast; allow recovery time |
| `o/schedule` | Recurring trigger with cron, interval, or fixed time; overlap management |
| `o/replay` | Re-execute a workflow from a specific stage; preserves prior work |
| `o/audit-trail` | Complete execution history: decisions, human actions, errors, timing |

### Saga pattern
Register `:compensate` on each stage; set `:on-error :compensate`. Compensation
runs in reverse order automatically on failure.

---

## eloquence `e/` — Audience-aware communication

| Symbol | Synopsis |
|---|---|
| `e/compose` | Calibrated prose from structured knowledge for audience and purpose |
| `e/narrate` | Structure via narrative pattern: problem-solution, deliberative, etc. |
| `e/adapt-register` | Transform content between registers or audiences |
| `e/instruct` | Procedural content: tutorials, how-tos, runbooks, reference docs |
| `e/formalize` | Informal → precise auditable prose for legal or regulatory contexts |
| `e/simplify` | Technical → plain language for non-specialist audiences |
| `e/localize` | Cultural adaptation, not just translation |

### `:narrative` patterns for `e/narrate`
`:problem-solution` `:situation-complication-resolution` `:chronological`
`:deliberative` `:comparison-contrast` `:hero-transformation`

### `:audience` keywords
`:engineer` `:senior-engineer` `:executive` `:product-manager` `:legal-counsel`
`:compliance-officer` `:regulator` `:end-user` `:general-public` `:board`

---

## reasoning `r/` — Logical inference

| Symbol | Synopsis |
|---|---|
| `r/model` | Explicit logical model: facts, definitions, axioms, constraints |
| `r/rules` | Named if-then rules with strength and conflict resolution |
| `r/derive` | Primary inference: deductive, inductive, or abductive; full derivation chain |
| `r/decide` | Decision table / tree / rule-set evaluation with path and sensitivity |
| `r/hypothesise` | Abductive: ranked candidate explanations for observations |
| `r/check` | Verify: does this follow from these premises? Are these consistent? |
| `r/contradict` | Find internal contradictions in a belief set |
| `r/trace` | Complete readable derivation chain in step-by-step, tree, or prose form |
| `r/argue` | Construct formal argument in Toulmin, classical, or legal-brief format |

### Inference modes
- **Deductive** — conclusion necessarily follows; as certain as premises
- **Inductive** — probable generalisation; new evidence can overturn
- **Abductive** — best explanation for observations; a candidate, not a certainty

### `:surface` values for `r/derive`
`:conclusions` `:derivation-chain` `:open-questions` `:underdetermined`

---

## taxonomy `t/` — Classification

| Symbol | Synopsis |
|---|---|
| `t/define` | Declare taxonomy: root, criteria, categories, membership rules |
| `t/build` | Construct taxonomy inductively from existing items |
| `t/facet` | Multi-dimensional orthogonal classification |
| `t/classify` | Place items in taxonomy; surfaces confidence and boundary cases |
| `t/align` | Map one taxonomy to another; surfaces gaps and conflicts |
| `t/validate` | Check for exhaustiveness, exclusivity, criterion consistency |
| `t/browse` | Query and navigate: find, filter by facet, traverse paths |
| `t/evolve` | Manage taxonomy change with crosswalk preservation |

### `:membership` types
- **`:monothetic`** — strict necessary and sufficient criteria; sharp boundaries
- **`:polythetic`** — family resemblance; items share most characteristic properties

---

## agent `a/` — Autonomous action

| Symbol | Synopsis |
|---|---|
| `a/define` | Declare agent identity: specializations, standards, constraints, memory |
| `a/memory` | Named memory store for operational state across invocations |
| `a/invoke` | Directed specific task — agent equivalent of a function call |
| `a/delegate` | Goal assignment with agent autonomy over approach |
| `a/compose` | Agent pipeline: sequential, parallel, or parallel-then-merge |
| `a/supervise` | Supervisor coordinates team; assigns tasks; synthesises results |
| `a/negotiate` | Structured agent dialogue toward shared position |
| `a/evaluate` | Assess output against criteria; optionally produce improved version |
| `a/reflect` | Agent examines its own output: assumptions, alternatives, failure modes |

### Invoke vs delegate
| Situation | Use |
|---|---|
| Specific task, known approach | `a/invoke` |
| Goal known, path not specified | `a/delegate` |
| Multiple sequential specialists | `a/compose :sequential` |
| Multiple parallel perspectives | `a/compose :parallel-then-merge` |
| Complex goal needing dynamic assignment | `a/supervise` |
| Contested design decision | `a/negotiate` |

### `:approve` values for `a/delegate`
`:each-step` `:major-decisions` `:on-completion` `:never`

---

## The `.cnj` file — canonical section order

```
1. (charter ...)           ← always first; goals, decisions, open questions
2. (asset ...)             ← external standards and capabilities
3. (assume ...)            ← operative constraints
4. (context establish ...) ← domain semantic frame
5. domain work             ← d/explore, r/rules, t/define, etc.
6. (target ...)            ← implementation declarations
7. (handover ...)          ← when ready to materialise (issued, not always present)
```

---

## Cross-grimoire pipelines — common patterns

```clojure
;; Knowledge → code
(~> requirements-doc
  (d/explore :depth 4)
  (r/derive "What obligations apply?" :using compliance-rules)
  (t/classify entities :using gdpr-taxonomy)
  (target :api :language :typescript :standard :team-standard)
  (handover :to :typescript-agent :scope [:api]))

;; Text → decision
(~> policy-document
  (s/texan :models [:argumentation :facts-assumptions])
  (r/check "Does this satisfy our obligations?" :against compliance-model)
  (e/compose "Compliance Assessment" :audience :legal-counsel))

;; Agent quality loop
(~> domain-model
  (a/invoke :typescript-agent :task "Generate API" :produce :source)
  (a/evaluate :against quality-criteria :improve true)
  (a/reflect :questions ["What assumptions might not hold?"] :depth :thorough))

;; Multi-perspective review
(a/compose review
  :strategy :parallel-then-merge
  :agents [
    {:agent :security-reviewer  :task "Identify risks"}
    {:agent :performance-analyst :task "Identify bottlenecks"}
    {:agent :accessibility-lead  :task "Identify barriers"}])
```