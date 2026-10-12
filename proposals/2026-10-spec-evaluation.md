# Specification evaluation: the design questions behind the October review

*October 2026. A second evaluation of the Conjurer specification, written after
two editorial and semantic passes (#11 and #12) closed the inconsistencies a
review of 12 October found. What remains are design questions: places where the
specification is not wrong so much as undecided. Each is graded with the
foresight scoring set, as in the July evaluation.*

---

## Method

The scoring set is unchanged from `proposals/2026-07-spec-evaluation.md`: four
dimensions on a scale of 1 to 10, higher always better, summable at equal
weight (maximum 40).

| Dimension | Question it answers |
|---|---|
| **`:feasibility`** | How achievable is it within the current specification? |
| **`:elegance`** | Does it fit the design natively, or is it bolted on? |
| **`:containment`** | How small is the blast radius across grimoires, examples and tooling? |
| **`:value`** | How much does it matter in practice? |

An equal-weight sum favours cheap, contained changes. The questions in this
evaluation are the opposite kind: they touch many files because they sit
underneath many files. Where value and total point in different directions,
the reading of the ranking says so.

Each candidate is an `f/candidate` form. Where a question has a credible
alternative to the recommended answer, the alternative is graded as well, so
that the choice is visible and the losing option is on record.

---

## Part I: Where the specification stands

### What the October passes settled

The review of 12 October found 23 issues. Two pull requests resolved the
editorial and semantic ones without adding a symbol:

- **#11, consistency.** `SKILL.md` agrees with core again (eight principles;
  `:requires` and `:as` in their right equivalence classes; the abstraction,
  certainty and materialisation constructs in the fast reference). The phantom
  `(context establish ...)` is gone everywhere. `|` is signature notation only;
  an invocation writes `(one-of ...)`. Phantom symbols in examples are replaced,
  drafting-history phrases removed, British spelling completed.
- **#12, semantics.** `branch :cases` and `ward :recover` are ordered vectors.
  Parameters come in pairs (`:escalate-when`, `:deepen 3`) and `template.md`
  states the form-shape rule with its principled exceptions. `ensure` no longer
  claims an MCP layer that does not exist for the artefact at hand. `conjure`
  declares `:within`; `refine` gains `:because` and may refine a spell; `given`
  and `context` lifetimes have an end.

### What remains open

**F1. There is no expression language.** Conjurer has a predicate convention
(free variables, prefix form), unit forms (`(eur 10000)`) and type forms
(`(string :iso-4217)`), but nowhere lists them as a set or says which heads a
processor may evaluate. `incantation :expands-to` uses `for` and
`entities-of`; `spell` uses `str`; `ensure :structural` predicates appear as
`(<= daily-limit (eur 10000))`, `(every-step-has :rollback)` and
`(every-field-has-label?)`. The language declares incantation expansion and
structural postconditions *deterministic*, and the MCP server is where
determinism lives — yet nothing tells a deterministic expander which forms it
may evaluate and which belong to the model.

**F2. Execution primitives live in two times.** `(sequence contract-review ...)`
is analysis the processor performs now. `(sequence order-saga ...)` and
`(retry payment-gateway-call ... :retry-on [(= status 429)])` describe the
behaviour of a system to be generated. Both are written the same way, and no
rule tells the processor which reading applies.

**F3. Names and references are not uniform.** Targets and assets are named by
keyword (`(target :api ...)`), spells, shapes and contexts by symbol, and a
target is referenced by symbol (`(materialise subscription-api)`). The
conjurer-mcp preflight compares names literally and reports a target built
`:from` a domain-model binding as unresolved. Charter decisions have no
identifier, yet `f/hoist :into :charter-decision/...` points at one and
`template.md` asks that a reversal reference the decision it reverses.

**F4. Confidence has five vocabularies.** `:high`/`:medium`/`:low` (about 38
uses), a numeric `0.83` in `explain`, exhume's
`:attested`/`:strongly-inferred`/`:speculative`, and `:calibrated`/`:assertive`
in `agent.md`. Worse, `:confidence` is both a *reported value* (in results)
and an *instruction* (`x/recover-model :confidence :grade-each`, `a/define
:confidence :calibrated`). The paradigm statement "how well you know something
is part of the language" has no single scale to stand on.

**F5. The `.cnj` structure has three owners.** `template.md` Part II,
core's "The `.cnj` file — canonical structure" and `quick-reference.md` each
state it. They have drifted once already (the `context establish` form), and
none covers spells, shapes, lore or the foresight backlog. `template.md` also
copies the signatures of `charter`, `asset`, `target` and `handover`, which
have since diverged from core.

**F6. Practitioner grimoires are under-specified.** Core's example provides
`acme/compliant-endpoint`, but the spell was defined as `compliant-endpoint`;
nothing says how a spell enters a namespace. The example registers
`grimoires/acme-payments.cnj`, while the standard grimoires are literate
`.md`. `asset :type :grimoire` appears in no list of asset types, and the
template's naming rule ("namespace aliases are one or two letters") contradicts
both `data/` and the two-character minimum for practitioner namespaces.

**F7. `shape` is thin and partly domain-specific.** `:phi-fields` is a
healthcare term in a core construct and is defined as personally identifiable
information, which PHI is not. The July finding F5 — no composition
(`:extends`) — is still open.

**F8. Which version is the version?** `package.json` and the release-please
manifest say 0.1.0, `CHANGELOG.md` ends at 1.2.0 with an Unreleased section,
`index.edn` is at 1.7.0, and each grimoire carries its own version.

---

## Part II: Graded candidates

All candidates share `:added "2026-10-12"`.

### A. The expression layer

#### 1. A closed expression prelude

```clojure
(f/candidate :expression-prelude
  :label   "A closed, listed expression prelude in core: what a deterministic processor may evaluate"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 6 :elegance 9 :containment 6 :value 9}
  :rationale "Closes F1. A short section in core (Part V, beside shape) lists
              the forms every processor understands and a deterministic one may
              evaluate: literals; unit forms (unit-name magnitude); type forms
              (string, integer, decimal, boolean, date, uuid, list, one-of) with
              constraint keywords; prefix predicates under the free-variable
              convention (= not= < <= > >= in? and or not); and a few
              expansion forms over bindings (for, str, entities-of, fields-of).
              Every other head is a semantic function: the model resolves it,
              no deterministic layer may claim to. Two rules follow at once: an
              incantation's :expands-to may use only prelude forms and
              registered spells, and an ensure :structural predicate is
              :mcp-checkable only when it is written in the prelude. The
              determinism boundary, until now a project rule, becomes a
              property of the language."
  :conditions ["the accessor set over domain-model bindings is fixed
                (recommended: entities-of, fields-of, relations-of)"
               "conjurer-mcp implements the prelude evaluator before any
                construct claims mcp-level expansion"]
  :cluster :expressions)
```

Sketch:

```clojure
;; Prelude: deterministic, checkable by the MCP layer
(conjure rate-limiter-config
  :tier   :standard
  :within (ensure
            :structural [(<= requests-per-minute 300)
                         (in? algorithm #{:token-bucket :sliding-window})]
            :verify-via [:mcp]))

;; Not prelude: a semantic function, so the honest layer is :llm
(conjure customer-signup-form
  :fields [:name :email :company]
  :within (ensure
            :structural [(every-field-has-label?)]
            :verify-via [:llm]))

;; Expansion uses only prelude forms over a registered binding
(incantation crud-suite [model]
  :expands-to (for [entity (entities-of model)]
                (compliant-endpoint entity :handles [:create :read :update :delete])))
```

The elegance score reflects that nothing here is new in spirit: the
free-variable convention, unit forms and `(one-of ...)` already exist. The
prelude names them, closes the list, and turns the semantic/deterministic
split into something a reader can check form by form.

#### 2. A host-language subset *(recommendation: abandon)*

```clojure
(f/candidate :host-subset
  :label   "Adopt a subset of clojure.core as the expression language"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 7 :elegance 3 :containment 5 :value 6}
  :rationale "The obvious alternative to a prelude: let expressions be Clojure.
              It is complete and familiar, but it reintroduces exactly what the
              1.2.0 editorial pass removed (fn, #(), host functions in examples),
              ties every processor to a host's semantics, and makes no
              distinction between what is deterministic and what is semantic —
              the distinction F1 is about. Recorded so the reasoning stays
              visible; the low elegance score is the finding."
  :conditions ["a concrete need appears that a closed prelude cannot express"]
  :cluster :expressions)
```

### B. Time and execution

#### 3. Position decides the time

```clojure
(f/candidate :primitive-time-by-position
  :label   "Execution primitives perform when they stand alone and describe when they stand inside a manifestation"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 7 :elegance 9 :containment 6 :value 9}
  :rationale "Closes F2 with one rule and no new parameter. A sequence,
              parallel, branch, retry, intercept or ward that stands on its own
              — at top level, in a ~> pipeline, in a ritual — is performed by
              the processor now. One that stands inside a manifestation (as the
              value of a conjure, weave or target parameter) describes the
              behaviour of the artefact being manifested, and the processor
              generates that behaviour. The language already says conjure
              describes what should exist; this extends that to the primitives
              written inside it. The saga and retry examples move inside the
              conjure they describe; the analysis examples stay where they are."
  :conditions ["core Part III gains an implementation note per primitive, all
                stating the rule once"
               "the orchestrate boundary note is reworded: o/ forms are always
                descriptive, core primitives depend on position"]
  :cluster :execution)
```

Sketch:

```clojure
;; Performed now: the processor runs the analyses in order
(sequence contract-review
  :operations   [(d/extract contract :focus [:parties :obligations])
                 (s/critique :against [:uncapped-liability :auto-renewal])]
  :pass-results :accumulate)

;; Described: the saga is behaviour of the checkout service being generated
(conjure checkout-service
  :behaviour (sequence order-saga
               :operations [(conjure reserve-inventory :compensate :release-reservation)
                            (conjure authorise-payment :compensate :void-authorisation)]
               :on-error   :compensate))
```

#### 4. An explicit `:at` parameter *(recommendation: keep as fallback, do not adopt)*

```clojure
(f/candidate :primitive-time-by-parameter
  :label   ":at :session | :runtime on every execution primitive"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 5 :containment 5 :value 7}
  :rationale "Equally decisive and easier to parse: every primitive declares its
              time. But it adds the same parameter to six constructs, asks the
              practitioner to state what position already says, and invites a
              third value the first time a case is ambiguous. Kept as the
              fallback if the position rule proves hard to apply in practice."
  :conditions ["the position rule produces an ambiguity in a real .cnj that
                cannot be resolved by moving the form"]
  :cluster :execution)
```

### C. Names and references

#### 5. One name, two spellings

```clojure
(f/candidate :name-equivalence
  :label   "A construct's name may be written as a symbol or a keyword; both denote the same name"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 9 :elegance 7 :containment 9 :value 8}
  :rationale "Closes the referencing half of F3 at almost no cost. (target :api)
              and (materialise api) refer to the same target; a reference
              resolves by name, not by spelling. Every existing example stays
              valid, and the conjurer-mcp preflight gains a one-line
              normalisation instead of a special case per construct (Q-14 is
              one symptom). Elegance is held back by what it does not do: it
              legitimises two spellings instead of choosing one."
  :conditions ["core states the rule once, under the form-shape rule in template.md"]
  :cluster :references)
```

#### 6. Symbols only *(recommendation: defer)*

```clojure
(f/candidate :names-are-symbols
  :label   "Names are always symbols; keywords are always values"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 5 :elegance 9 :containment 3 :value 7}
  :rationale "The clean end state, and the Clojure reading (def names are
              symbols). It would touch every target, asset, agent and candidate
              in the grimoires and all worked examples, and every authored .cnj.
              Deferred rather than abandoned: name-equivalence makes it a
              matter of style that can be adopted file by file."
  :conditions ["name-equivalence has landed"
               "a formatter in conjurer-mcp can rewrite keyword names mechanically"]
  :cluster :references)
```

#### 7. Decision identifiers and reference keywords

```clojure
(f/candidate :decision-ids
  :label   "Charter decisions carry an :id; references use namespaced keywords by kind"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 8 :containment 7 :value 9}
  :rationale "Closes the identity half of F3. A decision entry gains an optional
              :id, required as soon as anything refers to it, and an optional
              :supersedes naming the decision it reverses — the append-only log
              then records reversals as links rather than prose. References
              everywhere take one shape, already used by foresight: a keyword
              namespaced by kind, :decision/amendment-approval, :target/api,
              :spell/compliant-endpoint, :core/spell for a construct. f/hoist
              :into, :supersedes and r/decide :from-candidates become checkable
              by the deterministic layer."
  :conditions ["the kinds are listed in core (decision, target, asset, spell,
                shape, candidate, construct)"]
  :cluster :references)
```

Sketch:

```clojure
(charter "Subscription & Contract Management Platform"
  :decisions [
    {:id       :amendment-approval
     :date     "2025-11-04"
     :decision "Contract amendments require finance approval before taking effect."}
    {:id         :self-service-amendments
     :date       "2026-03-02"
     :supersedes :amendment-approval
     :decision   "Amendments under €500 take effect without approval; finance
                  reviews them weekly. The approval queue had become the
                  bottleneck for small renewals."}])

(f/hoist :of :diff-intent
  :date "2026-11-20"
  :into :decision/x-diff-intent-accepted)
```

### D. Confidence

#### 8. Two axes, one vocabulary

```clojure
(f/candidate :confidence-vocabulary
  :label   "Confidence is two axes — provenance and degree — with one vocabulary each, defined in core Part IV"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 8 :containment 6 :value 8}
  :rationale "Closes F4. The five vocabularies are really two questions.
              Provenance — how was this obtained: :attested, :strongly-inferred,
              :speculative (exhume's grades, which generalise to every
              grimoire). Degree — how sure is the claim: :high, :medium, :low.
              A number is allowed only with its basis stated (:basis
              :historical-false-positives), because an unexplained 0.83 is
              exactly the false precision the ground truths warn against. The
              key collision is resolved by name: results report :confidence
              {:provenance ... :degree ...}; instructions use :grade (exhume's
              :confidence :grade-each becomes :grade :each) and agents declare
              a :disposition (:calibrated or :assertive), which is what that
              parameter always meant."
  :conditions ["exhume, agent and core examples are migrated in one pass so no
                grimoire is left on the old reading"]
  :cluster :epistemics)
```

Sketch:

```clojure
(explain fraud-detector :show [:interpretation :confidence])
;; => {:interpretation "Composite scoring rather than threshold rules ..."
;;     :confidence {:provenance :strongly-inferred
;;                  :degree     :high
;;                  :note       "Moderate on alert thresholds until calibrated
;;                               against real transaction data."}}
```

### E. Structure and packaging

#### 9. One owner for the `.cnj` structure

```clojure
(f/candidate :cnj-structure-owner
  :label   "template.md owns the .cnj structure; core and quick-reference point to it"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 9 :containment 6 :value 8}
  :rationale "Closes F5. The structure is stated once, in template.md, and
              extended with the sections practice has produced since: an
              abstractions section (lore, shape, spell, grimoire) between context
              and domain work, and a foresight section (f/candidate backlog)
              after the targets. handover and materialise stay events, not
              sections. Core's canonical-structure section shrinks to its diagram
              and a pointer; quick-reference keeps a one-line-per-section summary
              marked as derived. template.md stops copying signatures and names
              the core section for each construct instead."
  :conditions []
  :cluster :packaging)
```

Sketch of the extended order:

```text
1. charter        session anchor; always first
2. asset          external standards and capabilities
3. assume         operative constraints
4. context        domain semantic frame
5. abstractions   lore, shape, spell, grimoire
6. domain work    the intellectual body of the project
7. target         implementation declarations
8. foresight      f/candidate backlog, with reassessments in :history
9. handover       issued when ready (an event, not always present)
```

#### 10. Practitioner grimoires, specified

```clojure
(f/candidate :practitioner-grimoire-spec
  :label   "Specify how spells enter a namespace, the file format of a practitioner grimoire, and the namespace rules"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 8 :containment 7 :value 7}
  :rationale "Closes F6 with three decisions. A spell enters a namespace by
              being named in it: (spell acme/compliant-endpoint ...); the
              grimoire's :provides lists those names and the processor rejects a
              provided name outside the declared namespace. A practitioner
              grimoire is a .cnj file holding the grimoire form and its spells,
              lore and shapes — the standard library stays literate .md, a team's
              spellbook is executable source. asset :type gains :grimoire, and
              the template's naming rule is restated: standard namespaces are
              one or two letters or data/; practitioner namespaces are at least
              two characters and never a standard prefix."
  :conditions []
  :cluster :abstraction)
```

#### 11. `shape` generalised

```clojure
(f/candidate :shape-generalised
  :label   "shape gains :sensitive-fields by class and :extends for composition"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 8 :elegance 7 :containment 8 :value 6}
  :rationale "Closes F7 and the July F5. :sensitive-fields {:phi [...] :pii [...]
              :pci [...]} replaces the healthcare-specific :phi-fields, which
              stays accepted as shorthand for the :phi class; each class
              triggers its own handling (access logging and encryption for PHI,
              erasure support for PII, tokenisation for PCI). :extends lets a
              shape build on another (monetary-amount inside invoice-line)
              without restating fields or invariants."
  :conditions []
  :cluster :typing)
```

#### 12. One version model

```clojure
(f/candidate :version-model
  :label   "Three independent version lines, each with one owner"
  :added   "2026-10-12"
  :status  :proposed
  :scores  {:feasibility 9 :elegance 8 :containment 9 :value 7}
  :rationale "Closes F8 by separating what is mixed today. The specification
              release is the package version: release-please owns it,
              CHANGELOG.md headings follow it, and package.json and the manifest
              move from 0.1.0 to the line CHANGELOG already uses (the next
              release is 1.3.0). The catalogue version in index.edn tracks the
              symbol surface and key parameters only. Each grimoire's version
              tracks that grimoire. CHANGELOG.md records all three, and
              README.md's 'nothing is versioned yet' is retired."
  :conditions ["the maintainer confirms 1.3.0 as the first release-please release"]
  :cluster :packaging)
```

---

## Part III: Ranking

| # | Candidate | Feasibility | Elegance | Containment | Value | **Σ /40** |
|---|---|---|---|---|---|---|
| 5 | `:name-equivalence` | 9 | 7 | 9 | 8 | **33** |
| 12 | `:version-model` | 9 | 8 | 9 | 7 | **33** |
| 7 | `:decision-ids` | 8 | 8 | 7 | 9 | **32** |
| 3 | `:primitive-time-by-position` | 7 | 9 | 6 | 9 | **31** |
| 9 | `:cnj-structure-owner` | 8 | 9 | 6 | 8 | **31** |
| 1 | `:expression-prelude` | 6 | 9 | 6 | 9 | **30** |
| 8 | `:confidence-vocabulary` | 8 | 8 | 6 | 8 | **30** |
| 10 | `:practitioner-grimoire-spec` | 8 | 8 | 7 | 7 | **30** |
| 11 | `:shape-generalised` | 8 | 7 | 8 | 6 | **29** |
| 4 | `:primitive-time-by-parameter` | 8 | 5 | 5 | 7 | **25** |
| 6 | `:names-are-symbols` | 5 | 9 | 3 | 7 | **24** |
| 2 | `:host-subset` | 7 | 3 | 5 | 6 | **21** |

**Reading the ranking.** The two cheapest candidates lead on the sum, and both
are worth taking at once. But ordered by value alone, the expression prelude,
the position rule and decision identifiers lead, and they are what makes the
deterministic half of Conjurer real: without a prelude, conjurer-mcp cannot
know what it may evaluate; without decision identifiers, foresight's `:into`
points at nothing. The alternatives at the bottom score as they should — each
loses on elegance or containment to the candidate it competes with — and that
discrimination is the scoring set doing its job.

A sensible order: `:name-equivalence` and `:version-model` first (small,
independent); then `:decision-ids` and `:cnj-structure-owner` together, since
the new structure gives decision identifiers a home; then
`:expression-prelude`, which conjurer-mcp must follow; then
`:primitive-time-by-position` and `:confidence-vocabulary`, the two that move
the most examples; `:practitioner-grimoire-spec` and `:shape-generalised`
whenever convenient.

---

## Part IV: Deliberately not proposed

- **A verification grimoire.** Abandoned in July for good reason; F1's
  prelude makes the existing layering checkable instead of adding a layer on
  top of it.
- **Numeric confidence everywhere.** Uniform, but it would spread exactly the
  unexplained precision the ground truths warn against. Numbers stay allowed
  with a stated basis.
- **A separate `retract` construct for `given`.** #12 already gave session-scoped
  preconditions an end: a later contrary `given` supersedes them. A dedicated
  construct would record nothing that supersession does not.
- **Renaming the `-ize` symbols** (`e/formalize`, `e/localize`, `w/analyze`) to
  match the British prose. A symbol rename breaks every caller for a spelling
  preference; the prose and the symbols may differ.

---

## Direct fixes (no candidate needed)

- `template.md` asks for at least two examples per construct; 92 of 141 have
  one, and `s/synthesise` has none. Relax the rule to "at least one, and a
  second where it shows a different aspect", and give `s/synthesise` its
  example.
- Example quality in core and foresight: the `quarterly-close` spell pipeline,
  the `f/reassess` example that edits the candidate's `:status` in place, a
  one-step `~>`, `r/decide :among X :from-candidates X`, and
  `:pass-results :selective` without its bindings. One editorial pass.
- Core Part VII: the order of sections in the body differs from the construct
  map (`grimoire` before `handover`; `materialise` after the `.cnj` structure).

---

## Part V: Disposition (2026-10-12)

The maintainer accepted the evaluation and asked for the recommended
candidates to be carried out in full. Per foresight discipline, each candidate
closes through a dated event; the candidate forms above stay untouched.

```clojure
(f/hoist :of :name-equivalence
  :date     "2026-10-12"
  :into     :core/names-and-references
  :outcomes [:core-section :template-rule]
  :note     "Stated once in core under the construct map and referenced from the
             form-shape rule in template.md.")

(f/hoist :of :version-model
  :date     "2026-10-12"
  :into     :decision/three-version-lines
  :outcomes [:template-rule :package-version-aligned]
  :note     "package.json and the release-please manifest set to 1.2.0, the line
             CHANGELOG.md already uses; the next release-please release follows it.")

(f/hoist :of :decision-ids
  :date     "2026-10-12"
  :into     :core/charter
  :outcomes [:new-parameters :reference-keywords :foresight-update]
  :note     "Decisions carry :id and :supersedes; f/hoist :into examples use
             :decision/<id>.")

(f/hoist :of :cnj-structure-owner
  :date     "2026-10-12"
  :into     :decision/template-owns-cnj-structure
  :outcomes [:template-part-ii-rewritten :core-section-reduced]
  :note     "Nine sections, abstractions and foresight added. Core's Part VII now
             follows its construct map: materialise and grimoire moved after
             handover.")

(f/hoist :of :expression-prelude
  :date     "2026-10-12"
  :into     :core/prelude
  :outcomes [:core-section :catalogue-prelude :example-predicates-normalised]
  :note     "index.edn carries :prelude for tools. Condition met in the
             specification; conjurer-mcp's evaluator is still to follow.")

(f/hoist :of :primitive-time-by-position
  :date     "2026-10-12"
  :into     :core/conjure-behaviour
  :outcomes [:new-parameter :implementation-note :examples-moved]
  :note     "conjure gains :behaviour; runtime examples in core, SKILL.md and
             README.md now sit inside the conjure they describe.")

(f/hoist :of :confidence-vocabulary
  :date     "2026-10-12"
  :into     :core/confidence
  :outcomes [:core-section :parameter-renames]
  :note     "Shorthand keeps every existing :confidence :high or :attested valid.
             exhume :confidence :grade-each became :grade :each; agent style
             :confidence became :disposition.")

(f/hoist :of :practitioner-grimoire-spec
  :date     "2026-10-12"
  :into     :core/grimoire
  :outcomes [:namespace-rule :file-format :asset-type]
  :note     "Spells enter a namespace by name; a practitioner grimoire is a .cnj;
             asset :type :grimoire listed.")

(f/hoist :of :shape-generalised
  :date     "2026-10-12"
  :into     :core/shape
  :outcomes [:new-parameters :example]
  :note     ":phi-fields remains as shorthand for :sensitive-fields {:phi ...}.
             data/schema keeps its own :phi-fields and :pci-fields for now.")

(f/reassess :of :host-subset
  :date      "2026-10-12"
  :rationale "The prelude closes the question without a host; recommendation
              accepted."
  :status    :abandoned)

(f/reassess :of :primitive-time-by-parameter
  :date      "2026-10-12"
  :rationale "Not adopted; the position rule landed. Kept as the fallback its
              conditions describe."
  :status    :proposed)

(f/reassess :of :names-are-symbols
  :date      "2026-10-12"
  :rationale "Deferred as recommended: name equivalence makes it a matter of
              style that can be adopted file by file."
  :status    :proposed)
```

The direct fixes listed above were carried out in the same change: the
example rule in `template.md` now asks for at least one example, `s/synthesise`
has one, and the example corrections in core and foresight are made.
