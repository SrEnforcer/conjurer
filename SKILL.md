---
name: conjurer
description: Interpret and execute Conjurer, a declarative language for LLM interaction. Use when practitioners write Conjurer code using any grimoire namespace — core constructs (conjure, refine, charter, target, handover), domain extraction (d/explore, d/model), data operations (data/schema, data/generate), web generation (w/prototype, w/component), semantic analysis (s/texan, s/viewpoint), workflow orchestration (o/define-workflow), communication (e/compose), logical inference (r/derive, r/decide), classification (t/classify, t/define), or agent coordination (a/delegate, a/compose). Also use when a .cnj file is attached — read the charter first and continue from where the session left off.
---

# Conjurer Language Interpreter

Conjurer is a declarative language for LLM interaction. Practitioners specify
*what* should exist; the system manifests it. Clojure-inspired syntax, composable
grimoires, and semantic context accumulation let intent compress over time.
The LLM is not an executor — it is a co-author that ascends to meet the practitioner.

---

## Grimoire namespaces

| Grimoire | Prefix | File |
|---|---|---|
| core | _(none)_ | `grimoires/core.md` |
| domain | `d/` | `grimoires/domain.md` |
| data | `data/` | `grimoires/data.md` |
| web | `w/` | `grimoires/web.md` |
| semantics | `s/` | `grimoires/semantics.md` |
| orchestrate | `o/` | `grimoires/orchestrate.md` |
| eloquence | `e/` | `grimoires/eloquence.md` |
| reasoning | `r/` | `grimoires/reasoning.md` |
| taxonomy | `t/` | `grimoires/taxonomy.md` |
| agent | `a/` | `grimoires/agent.md` |

**Symbol lookup:** `index.edn` — every symbol with grimoire, synopsis, and key params.
**Compact cheat sheet:** `quick-reference.md` — all 119 symbols at a glance.
**Full philosophy:** `conjurer.md`
**File structure spec:** `template.md`

---

## Core principles

1. **Declarative supremacy** — specify outcomes, not implementations
2. **Semantic richness over syntactic rigidity** — `:validates`, `:ensures`, `:checks` are all equivalent; the system understands intent
3. **Semantic gravity** — context accumulates mass; later invocations can be terser
4. **Productive ambiguity** — deliberate openness invites creative judgment; do not force resolution
5. **Progressive refinement** — first manifestations are sketches; `refine` is a discovery tool
6. **Intent topology** — `:requires` > `:prefers` > `:style`; `:deferred` is noted but not implemented
7. **Calibrated certainty** — use `certain` · `prefer` · `allow` and `given` / `ensure` to declare commitment and contracts explicitly
8. **Collaborative discovery** — surface tensions, propose improvements, make reasoning visible

---

## Processing any Conjurer invocation

1. **Identify the grimoire** from the namespace prefix (or lack thereof for core)
2. **Extract semantic intent** — recognise equivalent expressions; infer from context
3. **Apply accumulated context** — domain, regulations, conventions established earlier
4. **Honor intent topology** — apply `:requires` unconditionally; `:prefers` when feasible; style informs but never overrides
5. **Produce a production-ready manifestation** — no placeholders, no TODOs, no stubs
6. **Explain significant interpretive choices** transparently in accompanying prose

---

## When a `.cnj` file is attached

1. Read the `charter` first — this is the project's intellectual memory
2. Note the `:decisions` log — do not re-open closed decisions
3. Note the `:open` list — surface relevant open questions when appropriate
4. Note the `:outputs` map — which are `:conjurer-only`, which have `target` declarations
5. Continue from where the previous session ended without asking for re-explanation
6. Append significant decisions to `:decisions` before the session ends

When natural-language text is provided with no `.cnj` file, the correct first
response is to produce a `charter` — not domain analysis, not code. The charter
is what gets saved; everything else flows from it.

---

## Key constructs — fast reference

### The fundamental four

```clojure
;; Manifest something
(conjure payment-processor
  :requires  [:idempotency :audit-trail]
  :prefers   [:real-time-fraud-detection]
  :deferred  [:analytics-hooks])

;; Enhance an existing manifestation
(refine payment-processor
  :add      [:multi-currency]
  :focus-on :error-handling
  :when     (> projected-volume 10000))  ;; conditional refinement

;; Establish semantic context (accumulates across session)
(context establish payments
  :inherits  platform-base
  :domain    :financial-services
  :regulations [:psd2 :gdpr])

;; Thread a data pipeline left-to-right
(~> "requirements.pdf"
  (d/explore :depth 4)
  (transmute :into :rest-api :preserving [:business-rules])
  (e/compose "API Overview" :audience :engineering-team))
```

### Execution primitives

```clojure
;; Sequential with saga compensation
(sequence order-saga
  :operations [
    (conjure reserve-inventory :compensate :release-reservation)
    (conjure charge-payment    :compensate :void-authorisation)]
  :on-error :compensate)

;; Concurrent with result combining
(parallel enrich-user
  :operations [(fetch :orders) (fetch :preferences) (fetch :recommendations)]
  :combine-results :merge :wait-for :all :on-error :best-effort)

;; Graceful degradation
(ward recommendations
  :protect  (conjure ml-recommendations :timeout 200)
  :recover  {timeout?           (conjure cached-recommendations)
             model-unavailable? (conjure popularity-recommendations)}
  :degrade-gracefully true)
```

### Ecosystem layer (`.cnj` project files)

```clojure
;; Session anchor — always first in a .cnj file
(charter "Subscription Platform"
  :goals     ["Automate renewal reminders" "Give finance ARR visibility"]
  :decisions [{:date "2025-11-05" :decision "TypeScript throughout; functional style"}]
  :open      ["Which payment provider?"]
  :outputs   {:domain-model :conjurer-only
              :api          (target :typescript :standard :team-standard)})

;; Register external standard
(asset :team-standard :type :code-standard :location "standards/ts.md"
  :enforces ["No imperative loops" "No any types"]
  :prohibits ["throw in business logic"])

;; Transfer to specialist agent
(handover :to :typescript-agent
  :scope   [:api]
  :include [:charter :domain-model :target-specs :assets]
  :briefing "Implement the subscription API per the target spec.")
```

### Reasoning

```clojure
;; Derive what rules imply
(r/derive "What GDPR obligations apply to our newsletter processing?"
  :from  gdpr-compliance-model
  :using gdpr-obligation-rules
  :mode  :deductive :explain true
  :surface [:conclusions :open-questions])

;; Generate hypotheses for an observation
(r/hypothesise "API error rate spiked from 0.1% to 12% at 14:23 UTC"
  :from    {:observations ["Spike on POST /payments only" "Deployment at 14:20"]}
  :rank-by :plausibility :candidates 3)
```

### Taxonomy

```clojure
;; Classify data fields for GDPR compliance
(t/classify [{:field :email} {:field :dna-profile} {:field :ip-address}]
  :using gdpr-taxonomy :mode :strict :explain true
  :surface [:classification :boundary-cases])

;; Align internal taxonomy to regulatory standard
(t/align internal-taxonomy gdpr-taxonomy
  :purpose "GDPR compliance gap analysis"
  :produce :gap-report)
```

### Agent coordination

```clojure
;; Invoke for a specific task
(a/invoke security-reviewer
  :task "Review the payment module for OWASP Top 10 vulnerabilities"
  :with (read-file "src/payments/processor.ts")
  :produce :security-report :explain true)

;; Delegate a goal with autonomy
(a/delegate typescript-agent
  :goal  "Implement the subscription API — production-ready with tests"
  :context {:domain-model subscription-domain :target api-target}
  :within {:max-turns 20 :must-report [:decision :uncertainty]}
  :approve :major-decisions)

;; Multi-perspective architecture review
(a/compose architecture-review
  :agents [
    {:agent :security-reviewer    :task "Identify risks"       :produces :security}
    {:agent :performance-analyst  :task "Identify bottlenecks" :produces :performance}]
  :strategy :parallel-then-merge
  :synthesise {:agent :architect-agent :goal "Unified assessment"})
```

---

## Semantic equivalence — recognise all of these

The following groups are semantically equivalent and should produce identical results:

- **Constraint intent:** `:validates` `:ensures` `:requires` `:checks` `:enforces`
- **Preference intent:** `:prefers` `:would-like` `:ideally` `:nice-to-have`
- **Output binding:** `:manifest` `:as` `:bind-to` `:save-as`
- **Depth:** `:depth 3` `"thorough"` `:comprehensive` `:deep`
- **Format:** `:output :edn` `:format :edn` `"return as EDN"`

---

## Result quality standards

Every manifestation must be:
- **Complete** — no placeholders, TODOs, or stubs
- **Functional** — works immediately when executed or deployed
- **Honest** — significant interpretive choices noted transparently
- **Consistent with topology** — `:requires` always present; `:deferred` never implemented

When an invocation is ambiguous: make a reasonable inference from context,
proceed with the manifestation, note the interpretation. Never block on
minor uncertainties. Request clarification only for genuine fundamental
ambiguities that would change the entire direction of the output.

---

## File references

```
SKILL.md                ← this file (entrypoint)
index.edn               ← machine-readable symbol catalog (routing layer)
quick-reference.md      ← all 119 symbols at a glance
conjurer.md             ← language philosophy and principles
template.md             ← grimoire and .cnj file structure specification
grimoires/
  core.md               ← all core constructs with full signatures
  domain.md             ← d/ knowledge extraction
  data.md               ← data/ data lifecycle
  web.md                ← w/ web development
  semantics.md          ← s/ textual analysis
  orchestrate.md        ← o/ runtime workflow coordination
  eloquence.md          ← e/ audience-aware communication
  reasoning.md          ← r/ logical inference
  taxonomy.md           ← t/ classification
  agent.md              ← a/ autonomous action
```

When depth is needed on any construct, read the relevant grimoire file.
The symbol index (`index.edn`) routes from symbol name to grimoire file.