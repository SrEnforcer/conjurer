# Specification evaluation and graded extension candidates

*July 2026 — an assessment of the Conjurer specification at version 1.1.0,
followed by proposed new functionality (core symbols, a macro construct, and
grimoires), each graded with the language's own foresight scoring system.*

---

## Method: the scoring system

Conjurer already ships the instrument this evaluation needs. The `foresight`
grimoire recommends a polarity-normalised scoring set for graded candidates
(`grimoires/foresight.md`, Part I), and using it here is deliberate dogfooding:
if the language's own deliberation vocabulary cannot carry an evaluation of the
language, that would itself be a finding.

Every proposal below is scored on four dimensions, scale 1–10, **higher is
always better**, so totals are summable at equal weight (max 40):

| Dimension | Question it answers |
|---|---|
| **`:elegance`** | Does it fit the design natively, or is it bolted on? (1 = hacky, 10 = feels discovered, not invented) |
| **`:value`** | How useful is it in practice — its applicability? (1 = marginal, 10 = essential) |
| **`:feasibility`** | How achievable is it within the current spec? (1 = very hard, 10 = trivial) |
| **`:containment`** | How contained is the change? (1 = touches everything, 10 = tiny blast radius) |

Each proposal is expressed as an `f/candidate` form, so this document is not
merely *about* the spec — it is a valid `.cnj`-style artefact the project can
carry forward, reassess with `f/reassess`, and close with `f/hoist`.

---

## Part I: Assessment of the specification

### What the spec does well

**The philosophy–epistemology–construct chain is coherent.** `conjurer.md`
does something rare: it states eight design principles, then a separate layer
of *ground truths* (epistemology learned the hard way), and every grimoire
construct traces back to one or both. `f/reassess` is the durable-intent truth
applied to opinion; `materialise` is the "separate the deterministic plan from
the generative act" corollary made structural. The spec is internally
load-bearing, not decorative.

**The symmetry discipline is unusually honest.** The tenth ground truth names
where dualities are real (`conjure`/`exhume`, `given`/`ensure`) and — more
importantly — warns against manufacturing symmetry where none exists. The spec
follows its own warning: there is deliberately no `f/abandon`, and `refine`,
`witness`, and `ward` are left inverse-less. Few specifications resist that
temptation.

**Calibrated certainty names the language's limits.** `certain` / `prefer` /
`allow` plus `given` / `ensure` with per-layer verification attribution is an
honest account of what an LLM runtime can and cannot guarantee. The spec's own
words apply: a language that names its limits beats one that pretends.

**Boundaries between near-duplicates are documented.** `s/critique` vs
`e/critique`, `orchestrate` vs `handover`, `a/invoke` vs `a/delegate`,
`f/reassess` vs `r/revise` — everywhere two symbols could be confused, the
spec draws the line explicitly. At 137 symbols this is what keeps the surface
navigable.

### Findings

**F1 — The abstraction gap (vocabulary–spec mismatch).** `README.md`'s core
vocabulary table promises seven terms; three of them — **spell** ("a named,
reusable invocation pattern"), **charm** ("an anonymous invocation"), and
**incantation** ("a macro — an invocation that generates invocations") — are
defined *nowhere* in any grimoire. `core.md`'s construct map has no form for
declaring a reusable invocation pattern; `quick-reference.md` and `index.edn`
list no such symbols. The gap is not merely lexical: the language currently has
**no user-level abstraction mechanism at all**. A practitioner who writes the
same `conjure` shape twenty times has no way to name it, parameterise it, and
reuse it. Even the spec trips over the gap: `foresight.md` names "a new spell"
as a legitimate `f/hoist :into` target — a reference to a construct that does
not exist. This is the single most consequential finding, and proposals 1, 2,
4, and 5 below address it as a cluster.

**F2 — Extensibility tension.** `conjurer.md` states "No further grimoires are
currently under active consideration for addition to the standard library" —
a reasonable freeze — but the language offers no way for *practitioners* to
author their own grimoires either. `asset` registers external standards, not
Conjurer-native spell collections. Combined with F1, all growth must pass
through the standard library: a bottleneck the grimoire metaphor itself argues
against (historically, practitioners *wrote* grimoires; here they can only read
them).

**F3 — Catalog drift.** `README.md` says index.edn holds "132 symbols";
`quick-reference.md` and `index.edn` (v1.5.0) hold 137. The count was not
updated with the 1.1.0 additions. Minor, but ironic for a spec whose foresight
examples track an `x/diff-intent` drift-detection candidate. *(Fix directly;
no candidate needed.)*

**F4 — Intent topology is positive-only.** `:requires` / `:prefers` / `:style`
/ `:deferred` express what should exist and how much it matters — but there is
no load-bearing way to say what must **not** exist. Prohibitions must currently
be smuggled into `ensure` postconditions (verified after generation, not
shaping it) or `lore` anti-patterns (guidance, not binding). Proposal 3.

**F5 — Part V is thin.** `shape` stands alone as the typing story: no
composition (`:extends`), no dedicated conformance symbol (`data/validate` is
dataset-specific). Noted as a refinement opportunity for the existing
construct rather than a new-symbol candidate; not graded below.

---

## Part II: Graded candidates

All candidates share `:added "2026-07-01"` and are grouped by the requested
categories: core symbols (functions), the macro construct, and grimoires.
Scores are the evaluator's judgment offered for the maintainers to accept or
change — per foresight's implementation notes, a candidate is opinion, not
inference.

### A. Core symbols

#### 1. `spell` — named, reusable invocation patterns

```clojure
(f/candidate :spell
  :label   "spell — define a named, parameterised, reusable invocation pattern (core, Part II)"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 10 :containment 7 :value 9}
  :rationale "Closes the language's largest gap (F1): the README already promises
              the term, foresight already references spells as hoist targets, and
              the Clojure lineage makes the semantics nearly self-evident (defn
              for invocations). Every project that repeats an invocation shape
              benefits immediately. Deferred only until parameter-passing
              semantics are settled — in particular how caller arguments interact
              with certainty markers and with context inheritance."
  :conditions ["parameter/certainty interaction specified (recommended default:
                caller arguments arrive as (prefer v) unless wrapped in certain)"
               "scoping rule chosen: does a spell capture the context at
                definition site, invocation site, or both (recommended: invocation
                site, consistent with semantic gravity)"]
  :cluster :abstraction)
```

Sketch:

```clojure
(spell compliant-endpoint [entity & {:keys [audience] :or {audience :engineer}}]
  :doc "REST endpoint with our team's compliance defaults baked in"
  (conjure (str entity "-endpoint")
    :requires [:audit-trail :idempotency :pci-compliance]
    :style    {:error-messages :user-friendly}
    :within   (ensure :semantic ["errors never leak internal identifiers"])))

;; Twenty invocations later, each is one line, and the compliance
;; defaults live in exactly one place:
(compliant-endpoint transaction)
(compliant-endpoint refund :audience :compliance-officer)
```

The elegance score is maximal because this is the rare proposal the spec has
already half-written: the vocabulary exists, the lineage (`defn`) exists, and
semantic gravity explains what parameterisation *means* here — a spell is
front-loaded, portable context.

#### 2. `:forbids` — negative intent topology

```clojure
(f/candidate :forbids-topology
  :label   ":forbids — a load-bearing negative slot in the intent topology of conjure"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 9 :elegance 8 :containment 9 :value 7}
  :rationale "Completes intent topology with its negative space (F4). :requires
              wins conflicts; :forbids should carry the same binding force in the
              opposite direction — a manifestation containing a forbidden element
              is incorrect, full stop. Distinct from ensure (post-hoc
              verification) because prohibitions should shape generation up
              front, and distinct from lore anti-patterns (guidance) by binding
              force. Cheap: one parameter on an existing construct, one paragraph
              in the topology principle."
  :conditions ["decide whether :forbids also joins the topology of refine and
                weave, or starts on conjure alone"]
  :cluster :topology)
```

Sketch:

```clojure
(conjure patient-export
  :requires [:phi-minimisation :audit-trail]
  :forbids  [:third-party-analytics :silent-retries :plaintext-phi-at-rest])
;; A manifestation that includes a forbidden element is incorrect —
;; same force as a missing :requires, opposite sign.
```

#### 3. `charm` — anonymous inline invocation

```clojure
(f/candidate :charm
  :label   "charm — anonymous single-use invocation for pipeline steps"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 9 :elegance 6 :containment 9 :value 4}
  :rationale "The third undefined vocabulary term. Honest assessment: most of
              what a charm would do, an inline conjure already does — the form
              earns its keep only inside ~> pipelines, where a parameterised
              anonymous step (receiving the threaded value under a name) has no
              current expression. Kept as a candidate because the vocabulary
              promises it and because it is nearly free once spell lands; scored
              low on value because it is convenience, not capability."
  :conditions ["spell has landed (charm is its anonymous twin — fn to spell's defn)"]
  :cluster :abstraction)
```

Sketch:

```clojure
(~> quarterly-dataset
  (data/profile :detect [:drift :anomalies])
  (charm [profile]                             ;; the threaded value, named
    (conjure anomaly-note :from profile :output :markdown))
  (e/compose :audience :executive :tone :measured))
```

### B. The macro construct

#### 4. `incantation` — an invocation that generates invocations

```clojure
(f/candidate :incantation
  :label   "incantation — macro construct: deterministic expansion into invocations, inspectable before execution"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 6 :elegance 9 :containment 6 :value 8}
  :rationale "The README defines the term; nothing implements it. The design is
              dictated by an existing ground truth — separate the deterministic
              plan from the generative act: expansion (which invocations will run,
              with which arguments) is deterministic and inspectable as a
              preflight, exactly like materialise's plan phase; only then does
              the generative execution run. This kills the classic macro
              objection (opaque expansion) with machinery the spec already
              trusts. High value for any project manifesting families of similar
              artefacts (CRUD suites, per-locale variants, per-entity schemas).
              Feasibility mid-scored: hygiene questions (what may expansion
              reference? can incantations generate incantations?) need real
              design work."
  :conditions ["spell has landed — an incantation's natural output is a set of
                spell applications, and sequencing the two avoids designing
                abstraction twice"
               "expansion phase specified as mandatory-inspectable, mirroring
                materialise's preflight contract"]
  :cluster :abstraction)
```

Sketch:

```clojure
(incantation crud-suite [model]
  :doc "One endpoint family per entity in a domain model"
  :expands-to
    (for [entity (entities-of model)]
      (compliant-endpoint entity
        :handles [:create :read :update :delete])))

;; Phase 1 — deterministic, lossless, checkable:
(crud-suite insurance-domain :expand :preview)
;; => the exact list of invocations that WOULD run — inspect, then commit

;; Phase 2 — generative, lossy, irreversible:
(crud-suite insurance-domain)
```

### C. Grimoires

#### 5. `grimoire` — the user-defined grimoire construct (core, Part VII)

```clojure
(f/candidate :user-grimoire
  :label   "grimoire — package spells, lore, and shapes into a named, versioned, shareable practitioner grimoire"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 7 :elegance 9 :containment 6 :value 9}
  :rationale "Resolves the extensibility tension (F2) without touching the
              standard-library freeze: the freeze governs the STANDARD library,
              and this construct is precisely what makes that freeze sustainable,
              because domain growth gets a home outside it. It also completes the
              language's founding metaphor — historically practitioners WROTE
              grimoires; today's practitioners can only read them. A user
              grimoire is a namespace bundling spells, lore, and shapes,
              versioned, and registrable via asset so agents joining a project
              receive it like any other standard. Containment mid-scored: it
              touches asset, handover, and the catalog story."
  :conditions ["spell has landed (a grimoire with nothing to bundle is empty)"
               "namespace-collision policy with the twelve standard prefixes
                defined (recommended: user namespaces must be ≥2 characters)"]
  :cluster :abstraction)
```

Sketch:

```clojure
(grimoire acme-payments
  :namespace "acme/"
  :version   "0.1.0"
  :doc       "Acme's payment-domain spellbook: our defaults, our vocabulary"
  :provides  [acme/compliant-endpoint acme/settlement-report acme/refund-flow]
  :lore      [{:pattern :idempotency-keys-everywhere :because "PSP retries"}]
  :shapes    [acme/Transaction acme/Settlement])

;; Registered like any other standard — agents receive it in a handover:
(asset acme-payments-grimoire :from (grimoire-ref acme-payments))
```

#### 6. `scry/` — scenario simulation and counterfactual exploration

```clojure
(f/candidate :scry-grimoire
  :label   "scry/ — new grimoire: scenario simulation, perturbation, and counterfactual exploration over domain models"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 6 :elegance 8 :containment 8 :value 7}
  :rationale "A real epistemic gap, argued in the spec's own terms: reasoning
              infers from what is; foresight grades opinion about the project's
              own deferred options; NOTHING generatively explores external
              futures — 'what happens to this domain model if regulation X
              lands, if volume grows 10x, if this dependency disappears?'
              Scrying (divination by gazing) names it in the established
              register. Candidate forms: scry/scenario, scry/perturb,
              scry/outcomes, scry/stress. Outputs feed r/hypothesise and become
              the evidence behind f/reassess rationales — a clean three-way fit.
              Deferred honestly: conjurer.md currently freezes the standard
              library, so this candidate is exactly what foresight exists for —
              graded, dated, waiting for its conditions."
  :conditions ["the standard-library freeze is explicitly revisited"
               "two independent projects are observed hand-rolling scenario
                analysis with conjure + r/hypothesise (evidence of demand)"]
  :cluster :new-grimoires)
```

#### 7. `v/` — unified verification grimoire *(recommendation: abandon)*

```clojure
(f/candidate :verify-grimoire
  :label   "v/ — new grimoire unifying verification: contracts, generated tests, audits, evaluation"
  :added   "2026-07-01"
  :status  :proposed
  :scores  {:feasibility 7 :elegance 5 :containment 6 :value 7}
  :rationale "The intuition is real — verification is scattered across ensure,
              data/generate-tests, a/evaluate, and w/audit — but the scattering
              is arguably correct: each form verifies at the layer that owns the
              artefact, exactly as ensure's :verify-via attribution intends.
              A unifying grimoire would sit ON TOP of four existing homes,
              creating the boundary-confusion the spec works hard to avoid.
              Recorded so the reasoning is preserved, with a recommendation to
              abandon: the low elegance score is the finding."
  :conditions ["a concrete verification need appears that demonstrably fits none
                of the four existing homes"]
  :cluster :new-grimoires)
```

This candidate is included deliberately: a scoring system that never rejects
anything is decoration. Here the dimensions discriminate — decent value,
sub-threshold elegance — and the recommendation follows the numbers.

---

## Part III: Ranking

| # | Candidate | Category | Feasibility | Elegance | Containment | Value | **Σ /40** |
|---|---|---|---|---|---|---|---|
| 1 | `spell` | symbol | 8 | 10 | 7 | 9 | **34** |
| 2 | `:forbids` | symbol | 9 | 8 | 9 | 7 | **33** |
| 3 | `grimoire` (user-defined) | grimoire | 7 | 9 | 6 | 9 | **31** |
| 4 | `incantation` | macro | 6 | 9 | 6 | 8 | **29** |
| 5 | `scry/` | grimoire | 6 | 8 | 8 | 7 | **29** |
| 6 | `charm` | symbol | 9 | 6 | 9 | 4 | **28** |
| 7 | `v/` verify | grimoire | 7 | 5 | 6 | 7 | **25** |

**Reading the ranking.** The top of the table is the abstraction cluster plus
one cheap topology completion — which matches the assessment: F1 is the spec's
largest gap, and `:forbids` is the highest value-per-cost item on the list.
The natural adoption order respects the dependency chain recorded in the
`:conditions`: `spell` → (`charm`, `incantation`, `grimoire`) → the rest.
`scry/` waits on the library freeze; `v/` should be abandoned per its own
grades.

---

## Part IV: Deliberately not proposed

Listing what was rejected, and why, is part of the method — the spec's tenth
ground truth demands it.

- **`<~` (reverse threading).** Pure symmetry-for-its-own-sake: no semantics
  that `~>` with reordered forms lacks. The exact error the ground truths warn
  against.
- **`f/abandon`.** Already explicitly rejected by `foresight.md` itself
  (abandonment is a status, not an event). Re-proposing it would show the
  evaluation had not read the spec.
- **`x/diff-intent`.** A genuinely good idea — but it is already tracked as a
  worked `f/candidate` example in `foresight.md`, with its own scores,
  reassessments, and hoist. Re-proposing it would duplicate a live record.
- **A project-management layer over foresight.** Assignees, estimates,
  deadlines. Named as an anti-pattern by the grimoire; the temptation should
  stay resisted.
- **`shape` extensions as new symbols.** F5 is real, but it is a refinement of
  an existing construct (`:extends`, conformance), not new surface — `refine`,
  not `conjure`.

---

## Direct fixes (no candidate needed)

- **F3:** update `README.md`'s "132 symbols" to 137 (or drop the hardcoded
  count in favour of "see `index.edn`", which cannot drift).
