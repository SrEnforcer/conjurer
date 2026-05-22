# core.md — Conjurer Core Grimoire

The foundational spellbook. Every Conjurer program draws from this grimoire,
whether it manifests a REST API, analyses a legal document, or orchestrates a
multi-stage data pipeline. `core` provides the language itself: the constructs
for expressing intent, accumulating context, composing operations, and engaging
the system as a collaborator rather than an executor.

---

## Philosophy

The deep philosophical foundation lives in [`conjurer.md`](../conjurer.md).
This section positions what `core` specifically contributes: the vocabulary
of intent.

Every other grimoire provides domain-specific capabilities — `domain` for
knowledge extraction, `web` for front-end generation, `semantics` for textual
analysis. `core` provides something different: the *meta-capabilities* that
make all the others composable. It answers the questions no domain grimoire
can answer alone: How do I describe what I want? How do I refine it? How do
I establish shared understanding? How do I compose operations into workflows?
How do I handle failure gracefully? How do I make the system's reasoning
visible to me?

The answer to each question is a construct in this grimoire.

---

## Part I: Fundamental invocations

The five fundamental invocations — `conjure`, `refine`, `context`, `using`,
and `assume` — form the irreducible core of every Conjurer session.

---

### `conjure`

The primary act of manifestation. Describes what should exist; the system
brings it into being.

#### Signature

```clojure
(conjure name-or-description
  :requires  [:non-negotiable-capability ...]
  :prefers   [:preferred-capability ...]
  :style     {:style-preference value ...}
  :deferred  [:future-capability ...]
  :accepts   input-description
  :returns   output-description
  :examples  {input output ...}
  :output    :format-keyword
  :manifest  result-binding)
```

#### Parameters

**`name-or-description`** — What to manifest. A concise name
(`payment-processor`) or a natural-language description
(`"A CSV import tool that validates email addresses and deduplicates rows"`).
Both are valid. The system extracts intent from either form.

**`:requires`** — Load-bearing capabilities. The manifestation is incorrect
without these. When constraints conflict, `:requires` always wins.

**`:prefers`** — Preferred capabilities, applied when feasible. Yield to
`:requires` under constraint. Their absence is acceptable; the absence of a
`:requires` item is not.

**`:style`** — Aesthetic and stylistic guidance. Informs tone, verbosity, and
presentation decisions. Never overrides correctness or compliance.

**`:deferred`** — Capabilities noted for future refinement cycles. Recorded
in the manifestation's documentation but not implemented now. Prevents
premature complexity without losing intent.

**`:accepts`** — Description of expected input.

**`:returns`** — Description of expected output.

**`:examples`** — Concrete input/output pairs. Often more precise than prose
descriptions; the system uses them to calibrate intent for edge cases and
normalisation behaviour.

**`:output`** — Desired output format: `:code`, `:edn`, `:json`, `:markdown`,
`:artifact`, etc.

**`:manifest`** — Binds the result to a name for use in subsequent invocations.

#### Design rationale

Every Conjurer program revolves around `conjure`. Unlike a function call that
invokes an existing procedure, `conjure` describes *what should exist* and
trusts the system to determine *how to create it*.

The topology vocabulary — `:requires`, `:prefers`, `:style`, `:deferred` —
solves a real design problem: not all parts of a specification carry equal
weight. When the system encounters a tension between a compliance requirement
and a UX preference, it must know which to honour. Without explicit topology,
this is left to inference and is frequently inferred incorrectly. The
vocabulary makes prioritisation explicit.

The `:examples` parameter is frequently more expressive than parameter
descriptions. "What does 'normalise' mean for this data?" is answered more
cleanly by three examples than by a paragraph of prose. Whenever intent is
nuanced, lead with examples.

#### Example 1: Topology-driven specification

```clojure
(conjure payment-processor
  :requires  [:pci-dss-compliance :idempotency :audit-trail]
  :prefers   [:real-time-fraud-detection :multi-currency-support]
  :style     {:error-messages :user-friendly :logging :structured-json}
  :deferred  [:analytics-hooks :a-b-testing-framework]
  :manifest  payment-processor)

;; ✓ PCI-DSS, idempotency, audit trail: always present — non-negotiable
;; ✓ Fraud detection, multi-currency: present when feasible within constraints
;; → Analytics and A/B testing: documented, not implemented yet
```

#### Example 2: Intent expressed by example

```clojure
(conjure address-normaliser
  :accepts  raw-address-string
  :returns  {:street string :city string :postcode string :country :iso-3166-alpha-2}
  :examples {
    "Kerkstraat 12, 5011 Amsterdam"
    {:street "Kerkstraat 12" :city "Amsterdam" :postcode "5011" :country "NL"}

    "baker street 221b london"
    {:street "221B Baker Street" :city "London" :postcode nil :country "GB"}}
  :style    {:casing :title-case :missing-fields nil})

;; The examples communicate normalisation behaviour precisely:
;; title-casing, field extraction, graceful nil for missing postcode,
;; ISO country codes, handling of unconventional input ordering.
```

#### Example 3: Business process

```clojure
(conjure order-fulfillment
  :triggers  (order :status :paid)
  :requires  [:inventory-reservation :payment-capture :saga-compensation]
  :steps     [
    {:verify-inventory  :abort-if-insufficient}
    {:reserve-items     :compensate-on-failure}
    {:capture-payment   :retry-3-times}
    {:initiate-shipping :notify-customer}]
  :deferred  [:carrier-selection-optimisation :route-planning]
  :manifest  fulfillment-workflow)
```

#### Usage patterns

```clojure
;; Direct manifestation with natural-language description
(conjure "PDF invoice generator"
  :template company-letterhead
  :data     order-data
  :output   :pdf-bytes)

;; Chained conjurations — each builds on the previous result
(def domain   (conjure domain-model    :from requirements-docs))
(def api      (conjure rest-api        :from-domain domain))
(def frontend (conjure admin-panel     :from-api api))

;; Semantic equivalence — all three produce the same validator
(conjure user-form :validates [:email-format :age-minimum :password-strength])
(conjure user-form :ensures   [:valid-email :legal-age :secure-password])
(conjure user-form :requires  {:email :valid-format :age {:at-least 18}})
```

---

### `refine`

Iteratively enhances an existing manifestation. Adds capability, adjusts
parameters, removes elements, or deepens analysis — without starting over.

#### Signature

```clojure
(refine existing-manifestation
  :focus-on [:aspect ...]
  :add      [:capability ...]
  :adjust   {:parameter new-value ...}
  :without  [:capability-to-remove ...]
  :deepen   :by n-levels
  :when     predicate
  :manifest refined-result)
```

#### Parameters

**`existing-manifestation`** — The artifact to enhance.

**`:focus-on`** — Narrows refinement to specific aspects. Without it, the
entire manifestation is refined. With it, only the named aspects change —
everything else is preserved intact.

**`:add`** — Capabilities to introduce.

**`:adjust`** — Parameter modifications to apply.

**`:without`** — Capabilities to remove. The explicit counterpart to `:add`;
makes removal intentional and visible rather than accidental and implicit.

**`:deepen`** — Adds hierarchical levels of detail to the focused aspect.
Deepening by 2 means two additional layers of decomposition or analysis.

**`:when`** — A predicate or condition. When present, the refinement is
*conditional*: it applies only when the predicate holds. Enables
aspirationally complete specifications — future refinements recorded in
dormant form, activated when conditions are met.

**`:manifest`** — Binds the refined result.

#### Design rationale

Complex systems do not arrive fully formed. Neither does understanding of
them. `refine` formalises the iterative nature of real work: conjure a sketch,
see what emerges, sharpen specific aspects, repeat.

The deeper insight is that `refine` is a *discovery tool* as much as an
enhancement mechanism. The first manifestation of an underspecified intent
becomes a mirror — the practitioner sees what the system understood, which
often reveals what they actually wanted but had not yet articulated. Refinement
is how understanding develops, not just how implementations improve.

The `:without` parameter addresses an important gap. If `:add` exists, its
counterpart must too. Artefacts that can only grow but never shed accumulate
dead weight. Making removal explicit and intentional keeps manifestations
honest.

The `:when` predicate enables *aspirational completeness*: a specification
that contains future refinements in dormant form. The practitioner records
what they know will be needed — before they know they need it — and the
refinement activates automatically when conditions are met.

#### Example 1: Focused, surgical refinement

```clojure
(refine checkout-flow
  :focus-on :payment-step
  :add      [:3ds2-strong-authentication :tokenised-card-storage]
  :adjust   {:session-timeout 300 :max-retry-attempts 3}
  :without  [:legacy-iframe-payment-form]
  :manifest hardened-checkout)

;; Cart step and confirmation step: untouched
;; Payment step: surgically enhanced
;; Legacy iframe: explicitly removed — not left as silent dead code
```

#### Example 2: Conditional refinement

```clojure
(refine api-layer
  :focus-on :rate-limiting
  :add      [:sliding-window-algorithm :per-endpoint-quotas :redis-backed-counters]
  :when     (> projected-rps 500))

;; At modest scale: rate limiting is deferred — no premature complexity
;; When projections exceed 500 rps: this refinement activates automatically
;; The intent is recorded now; the implementation arrives when needed
```

#### Example 3: Analysis deepening

```clojure
(def overview
  (conjure domain-exploration :source "gdpr-guidance.pdf" :depth 2))

(refine overview
  :focus-on "data-subject-rights"
  :deepen   :by 3
  :add      [:enforcement-precedents :national-implementation-variations]
  :manifest rights-deep-dive)

;; overview: unchanged — still the full shallow exploration
;; rights-deep-dive: full depth on data-subject-rights subtree only
```

---

### `context`

Establishes semantic context — the shared understanding that shapes how all
subsequent invocations in its scope are interpreted.

#### Signature

```clojure
(context establish name
  :inherits    parent-context-name
  :domain      :domain-keyword
  :entities    {:entity-name [:attribute ...] ...}
  :conventions {:convention-name value ...}
  :regulations [:regulation ...]
  :assumptions ["natural-language assumption" ...]
  :active-in   :session | :block)
```

#### Parameters

**`name`** — Names this context for reference in `:inherits` clauses and
`using` blocks.

**`:inherits`** — A previously established context to extend. The new context
inherits all of its parent's definitions; additions and overrides apply on
top. Extends the inherited regulations list rather than replacing it.

**`:domain`** — The subject domain. Sets the semantic field for all
interpretation: vocabulary, implicit standards, reasonable defaults.

**`:entities`** — Key entities and their attributes. Defined once here; need
not be re-specified in subsequent invocations.

**`:conventions`** — Agreed standards, naming patterns, encoding choices. What
the team has decided the system should honour automatically.

**`:regulations`** — Applicable compliance requirements. Named regulations
activate implied behaviours: GDPR activates data-minimisation and
right-to-erasure handling; PSD2 activates strong-customer-authentication;
HIPAA activates PHI protection and audit logging on all PHI access.

**`:assumptions`** — Things the practitioner takes for granted that the system
should too. Making assumptions visible makes them inspectable and correctable.

**`:active-in`** — `:session` (entire conversation) or `:block` (until
explicitly closed, or when the enclosing `using` block exits).

#### Design rationale

An LLM is fundamentally a context machine. The same word means different
things in different domains: "patient" in healthcare is a clinical subject;
in a service-quality discussion, it is a virtue. Context resolves this — not
by restricting vocabulary, but by establishing the semantic field in which all
words are interpreted.

The `:inherits` parameter turns contexts from isolated declarations into a
*hierarchy*. A base service context establishes shared conventions — error
format, authentication mechanism, date standard — and a payment-specific
context inherits those, adding financial regulations without re-declaring
the shared parts. When the base changes, all inheriting contexts update.

The consequence of well-established context is *semantic gravity*: the heavier
the context, the shorter and more precise subsequent invocations become. A
practitioner who has established a rich HIPAA context does not write
compliance requirements into every `conjure` — they write only what is
*different* about this invocation. The context handles the rest.

#### Example 1: Inherited context hierarchy

```clojure
;; Base: shared across all services in the platform
(context establish platform-base
  :conventions {:error-format   :rfc-7807
                :auth           :jwt-bearer
                :date-format    :iso-8601
                :correlation-id :required-in-all-requests}
  :regulations [:gdpr]
  :active-in   :session)

;; Payment: inherits base, extends with financial domain
(context establish payments
  :inherits    platform-base
  :domain      :financial-services
  :regulations [:psd2 :aml-kyc]           ;; extends [:gdpr], does not replace it
  :entities    {:transaction [:id :amount :currency :timestamp :status]
                :account     [:id :balance :currency :risk-rating]}
  :conventions {:currency         :eur
                :amount-precision 2
                :idempotency-key  :required})

;; All subsequent payment invocations carry the full stack automatically:
;; RFC-7807 errors, JWT auth, ISO-8601 dates, GDPR + PSD2 + AML, EUR default.
(conjure payment-processor)   ;; fully specified through accumulated gravity
(conjure refund-handler)      ;; ditto — no repetition required
```

#### Example 2: Healthcare context

```clojure
(context establish clinical
  :domain      :healthcare
  :entities    {:patient   [:id :mrn :dob :phi-flag]
                :provider  [:id :specialty :license-number]
                :encounter [:id :timestamp :icd-10-codes :facility-id]}
  :regulations [:hipaa :hitech]
  :conventions {:phi-handling   :encrypted-at-rest-and-in-transit
                :audit-logging  :all-phi-access-events
                :data-retention "7 years minimum"}
  :assumptions [
    "All patient data is PHI unless explicitly marked otherwise"
    "Minimum-necessary standard applies to every data access"
    "Patient consent is required before any third-party data sharing"])
```

---

### `using`

Applies an established context or imported namespace to a scoped block of
invocations. Context within a `using` block does not leak outward.

#### Signature

```clojure
(using context-name-or-namespace
  invocation-1
  invocation-2
  ...)
```

#### Design rationale

Context often applies to a group of related invocations, not an entire
session. `using` makes scope explicit: the reader sees exactly which
invocations are governed by which context, and changes to one context cannot
accidentally affect invocations in another scope.

The same mechanism activates domain-specific languages generated by
`d/generate-dsl`. When a domain exploration yields a specialised vocabulary,
`using` makes it available for a specific block without polluting the global
namespace.

#### Example 1: Scoped financial conventions

```clojure
(context establish dcf-model
  :conventions {:compounding :continuous
                :day-count   :actual-360
                :rounding    2})

(using dcf-model
  (conjure npv-calculator
    :cash-flows    [-500000 120000 145000 170000 200000]
    :discount-rate 0.09)

  (conjure sensitivity-analysis
    :variable      :discount-rate
    :range         [0.06 0.07 0.08 0.09 0.10 0.11 0.12]
    :output-metric :npv))

;; Both invocations use continuous compounding, actual/360 day count.
;; Invocations outside this block are unaffected.
```

#### Example 2: Generated DSL activation

```clojure
(def trade-dsl
  (d/generate-dsl fixed-income-domain
    :operations [:yield :duration :convexity :dv01 :pv01]
    :notation   [:bp :bps :par]))

(using trade-dsl
  (calculate   (dv01 bond-portfolio :parallel-shift-bp 1))
  (solve-for   (yield bond :given {:price 98.75}))
  (present-value future-cashflows :at forward-curve :day-count :actual-365))
```

---

### `assume`

Declares operative constraints — the practitioner's taken-for-granted
assumptions about environment, scale, team, and feasibility. Distinct from
`context`, which defines the domain; `assume` defines the conditions under
which manifestations must actually work.

#### Signature

```clojure
(assume
  :environment    :keyword
  :scale          description
  :team           {:size n :skill-level :keyword}
  :infrastructure {:existing [...] :avoid [...]}
  :constraints    {:budget :keyword :timeline description}
  :negotiable     [:aspect ...]
  :non-negotiable [:aspect ...])
```

#### Design rationale

Every manifestation is shaped by invisible assumptions. A system unaware that
the team has three engineers might propose a twelve-service microarchitecture.
A system unaware of a bootstrapped budget might propose an enterprise
observability stack. These are not wrong manifestations — they are
manifestations for a different reality than the one the practitioner inhabits.

`assume` makes operative reality explicit. Once stated, assumptions are
inspectable via `meta-query`, overridable when circumstances change, and
available to reason about trade-offs explicitly.

The `:non-negotiable` list functions like `:requires` on a `conjure`, but at
the session level: it establishes a hard floor beneath every manifestation in
the session — things the system must never trade away regardless of other
pressures.

#### Example

```clojure
(assume
  :environment    :production-saas
  :scale          "8K daily active users, growing ~15% monthly"
  :team           {:size 3 :skill-level :senior-generalist}
  :infrastructure {:existing [:postgres :aws-ec2 :cloudflare :sendgrid]
                   :avoid    [:kubernetes :separate-message-broker]}
  :constraints    {:budget :bootstrapped :timeline "4 months to public launch"}
  :negotiable     [:ui-framework :background-job-runner :caching-strategy]
  :non-negotiable [:gdpr-compliance :zero-downtime-deploys :encryption-at-rest])

;; The system will not propose Kafka.
;; The system will not assume a DevOps engineer exists.
;; The system will not design for 10M users.
;; GDPR, zero-downtime, and encryption appear in every manifestation
;; without being re-stated.
```

---

## Part II: Semantic constructs

These constructs address the *meaning* layer of a Conjurer session: how to
structure multi-phase invocations, how to make reasoning transparent, how to
observe without intervening, and how to engage the same artifact from
different positions.

---

### `ritual`

A structured, multi-phase invocation that guides the system through deliberate
sequential steps, accumulating intermediate artifacts at each stage.

#### Signature

```clojure
(ritual name
  :phases [
    {:name    :phase-name
     :do      invocation
     :produce :artifact-name}
    ...]
  :checkpoint :after-each-phase | :on-completion
  :manifest   final-result)
```

#### Design rationale

Some manifestations are too complex for a single `conjure` — the final
artifact depends on intermediate discoveries that cannot be known upfront. A
ritual makes the multi-step nature explicit: each phase produces an artifact
the next phase consumes, and the accumulation of intermediate work is itself
part of the value.

A ritual also documents *process*, not just outcome. It communicates not only
what should be produced but what sequence of reasoning should produce it —
making the approach inspectable, reproducible, and teachable.

#### Example

```clojure
(ritual design-api
  :phases [
    {:name    :discover
     :do      (d/explore requirements-docs :depth 3 :focus [:entities :operations])
     :produce :domain-model}

    {:name    :model
     :do      (conjure resource-model
                :from   domain-model
                :apply  [:rest-constraints :hateoas-links])
     :produce :resource-map}

    {:name    :specify
     :do      (conjure endpoint-specs :for-each resource-in resource-map
                :include [:methods :parameters :error-responses :examples])
     :produce :api-spec}

    {:name    :validate
     :do      (conjure openapi-doc :from api-spec :validate :openapi-3.1)
     :produce :validated-openapi}]

  :checkpoint :after-each-phase
  :manifest   api-specification)

;; Each phase is inspectable before the next begins.
;; :checkpoint :after-each-phase means the system pauses and reports,
;; allowing course-correction before continuing.
```

---

### `explain`

Requests a transparent account of how a manifestation was produced: what the
system understood, what alternatives it considered, and what decisions it made.

#### Signature

```clojure
(explain target-manifestation
  :show  [:interpretation :alternatives :decisions :confidence :assumptions]
  :depth :summary | :full)
```

#### Design rationale

Transparency is not a debugging tool — it is a design principle. When a
practitioner understands *why* the system made the choices it did, they can
refine intent more precisely, catch misinterpretations early, and build
justified confidence in the output.

`explain` is the primary surface of Conjurer's collaborative discovery
principle. The session becomes a dialogue: the system manifests, the
practitioner asks why, understanding develops, the specification sharpens.

#### Example

```clojure
(explain fraud-detector
  :show  [:interpretation :alternatives :confidence]
  :depth :full)

;; Returns:
{:interpretation
 "Implemented as composite scoring (velocity + geography + amount deviation
  + device fingerprint) rather than threshold rules, because the domain
  context specifies financial services where composite models substantially
  reduce false positives on legitimate cross-border spend."

 :alternatives-considered [
   {:approach  "Simple threshold rules"
    :rejected  "Too many false positives for customers who travel frequently"}
   {:approach  "Isolation forest (unsupervised)"
    :rejected  "Requires offline training batch; incompatible with real-time
                scoring requirement from domain context"}]

 :confidence 0.83
 :note "High confidence on scoring logic; moderate on alert thresholds —
        these should be calibrated against real transaction data before
        going to production."}
```

---

### `meta-query`

Interrogates a manifestation or the current session at a meta level: what
assumptions underlie it, how would changes propagate, what are the failure
modes, what would the system do differently given different constraints.

#### Signature

```clojure
(meta-query target
  :questions ["natural-language question" ...])
```

#### Design rationale

The practitioner often senses that something is incomplete or misaligned but
cannot articulate it precisely. `meta-query` externalises this: rather than
requiring diagnosis, the practitioner asks the system to reason about its
own outputs. This is particularly valuable for exploring trade-offs and
surfacing non-obvious consequences of design decisions.

#### Example

```clojure
(meta-query payment-processor
  :questions [
    "Which of the current operative assumptions most constrain the architecture?"
    "What would change if we needed to support USD and GBP alongside EUR?"
    "What are the three most likely failure modes under 10× normal load?"
    "Which compliance requirements are currently underserved by this implementation?"])
```

---

### `witness`

Observes a manifestation transparently — capturing interpretive reasoning,
alternatives considered, and decisions made — without modifying the
manifestation itself. The epistemic counterpart to `intercept`.

#### Signature

```clojure
(witness target-invocation
  :observe              [:interpretation :alternatives :decisions :timing ...]
  :record-to            destination
  :include-alternatives boolean)
```

#### Design rationale

There is a meaningful difference between *changing* an operation's behaviour
and *observing* it. `intercept` changes; `witness` only observes. This
distinction matters for auditability, for understanding the system's reasoning
without affecting outcomes, and for building decision trails that survive
beyond the session.

`witness` can be inserted at any point in a `~>` pipeline without altering
the values being threaded. It produces an out-of-band observation record;
the in-band result passes through unchanged.

#### Example 1: Architecture decision record

```clojure
(witness
  (conjure system-architecture
    :for crm-platform
    :constraints [:gdpr :three-engineer-team :postgres-only])
  :observe              [:interpretation :alternatives :decisions]
  :record-to            architecture-decision-log
  :include-alternatives true)

;; The architecture is produced unchanged.
;; The log records: why each structural choice was made, what alternatives
;; were considered and set aside, which constraints were most influential.
```

#### Example 2: Inline pipeline observation

```clojure
(~> raw-transactions
  (validate :schema transaction-schema)

  (witness
    (conjure risk-scorer :model :gradient-boosted-composite)
    :observe   [:scoring-factors :feature-weights :threshold-rationale]
    :record-to risk-scoring-audit-trail
    :include-alternatives true)

  (conjure decision-engine :from risk-score))

;; The risk score threads through unchanged.
;; The audit trail captures the scoring reasoning independently,
;; without touching the pipeline's in-band value.
```

---

### `as`

Applies a perspectival role to an invocation, producing a manifestation shaped
by that role's characteristic priorities, vocabulary, and evaluative criteria.

#### Signature

```clojure
(as role-or-persona
  invocation)
```

#### Design rationale

Knowledge is perspectival. A security auditor reading an architecture diagram
sees threat surfaces and trust boundaries. A new engineer reading the same
diagram sees onboarding complexity and documentation gaps. A regulator sees
compliance obligations and audit requirements. None of these perspectives is
wrong — they are differently positioned.

`as` makes perspectival invocation first-class. The same artefact can be
reviewed, critiqued, or extended from multiple positions, producing
complementary outputs that together give a more complete picture than any
single perspective could.

#### Example 1: Multi-perspective system review

```clojure
;; Four perspectives on the same payment processor
(as :security-auditor
  (conjure review :target payment-processor
    :produce [:threat-model :vulnerability-assessment :compliance-gaps]))

(as :on-call-engineer
  (conjure review :target payment-processor
    :produce [:failure-modes :runbook :alert-thresholds]))

(as :new-team-member
  (conjure review :target payment-processor
    :produce [:onboarding-guide :local-dev-setup :common-gotchas]))

(as :product-manager
  (conjure review :target payment-processor
    :produce [:conversion-friction :missing-payment-methods :ux-gaps]))
```

#### Example 2: Parallel perspective synthesis

```clojure
(parallel comprehensive-review
  :operations [
    (as :security-auditor   (refine architecture :identify :risks))
    (as :performance-lead   (refine architecture :identify :bottlenecks))
    (as :accessibility-lead (refine architecture :identify :barriers))
    (as :compliance-officer (refine architecture :identify :regulatory-gaps))]
  :combine-results :synthesise
  :manifest        complete-assessment)
```

---

## Part III: Composition and transformation

These constructs describe how Conjurer programs are *structured*: how data
flows through a pipeline, how forms change while essence is preserved, how
independent components are integrated into coherent systems, and how domain
wisdom is encoded for reuse.

---

### `~>` — Threading

Composes a sequence of transformations into a readable left-to-right pipeline.
The result of each expression becomes the implicit first argument to the next.

#### Signature

```clojure
(~> initial-value
  (operation-1 :param value)
  (operation-2 :param value)
  ...)
```

#### Design rationale

Deep nesting is the enemy of readability. Without threading, a multi-step
pipeline reads inside-out — the last transformation appears outermost, the
first is buried deepest. The reader must mentally reverse the order to
understand the data flow.

`~>` makes data flow linear. The eye follows the transformation downward,
step by step, in the order transformations actually occur. The pipeline *is*
the program; intent is not hidden in nesting.

`~>` also enables clean insertion of `witness` calls at any stage without
restructuring surrounding code. Observability becomes frictionless.

#### Example 1: Document to deliverable

```clojure
(~> "contract-nda-2024.pdf"
  (d/explore   :depth 3 :focus [:obligations :termination :liability-caps])
  (s/texan     :models [:argumentation :risk :legal-structure])
  (conjure risk-summary
    :highlight [:uncapped-liability :auto-renewal-clauses :ip-assignment]
    :omit      [:boilerplate]
    :output    :executive-summary)
  (e/format    :tone :precise :audience :legal-counsel :length :concise))

;; PDF → domain model → semantic analysis → risk summary → formatted output
;; Each step independently inspectable; any step replaceable without
;; touching the rest of the pipeline.
```

#### Example 2: Data engineering

```clojure
(~> "transactions-q4.csv"
  (conjure loader   :validate [:schema :referential-integrity :date-ranges])
  (conjure cleanser :operations [:deduplicate :normalise-amounts :fill-missing])
  (conjure enricher :add [:merchant-category :geographic-region :risk-band])
  (witness (conjure scorer :model :gradient-boosted)
    :observe   [:feature-importance :score-distribution]
    :record-to model-audit-trail)
  (conjure reporter :format :executive-summary :output :pdf))
```

#### Example 3: Cross-grimoire product pipeline

```clojure
(~> legacy-database-schema
  (d/explore       :focus [:entities :relationships :constraints :indexes])
  (data/schema     :from-domain true :normalise true :validate true)
  (conjure migration-plan
    :strategy   :zero-downtime
    :rollback   :automated
    :validate-parity :strict)
  (w/prototype "Admin Panel"
    :from-domain true
    :features    [:crud-for-all-entities :filtering :bulk-export :audit-log-viewer]))

;; Legacy schema → understood domain → clean data contract →
;; migration plan → admin UI prototype.
;; Four grimoires; one readable pipeline.
```

---

### `transmute`

Transforms an existing manifestation into a structurally different form while
preserving its semantic essence. Where `refine` enhances the same form, and
`conjure` creates from scratch, `transmute` changes form while conserving
meaning.

#### Signature

```clojure
(transmute source-manifestation
  :into       :target-form
  :preserving [:semantic-aspect ...]
  :discarding [:structural-aspect ...]
  :style      :descriptor
  :manifest   result-binding)
```

#### Design rationale

Software knowledge exists in multiple equivalent representations. A domain
model can become a REST API, a database schema, a UI wireframe, or a test
suite. A requirements document can become user stories, a deployment checklist,
or an OpenAPI specification. These are not reimplementations — they are
*recastings* of the same knowledge into forms suited to different purposes.

Without `transmute`, each new form must be conjured from scratch, re-specifying
everything the original already encodes. With it, the existing manifestation
*is* the specification. Knowledge is stated once; forms multiply from it.

`:preserving` items are semantic content that survives the transformation.
`:discarding` items are structural artefacts of the source form that do not
transfer to the target.

#### Example 1: One domain model, three forms

```clojure
(def crm-domain (d/explore crm-documentation :depth 4))

(transmute crm-domain
  :into       :rest-api
  :preserving [:entities :relationships :business-rules]
  :discarding [:ui-presentation-hints :screen-flow-metadata]
  :manifest   crm-api)

(transmute crm-domain
  :into       :database-schema
  :preserving [:entities :constraints :relationships]
  :style      :third-normal-form
  :manifest   crm-schema)

(transmute crm-domain
  :into       :test-suite
  :preserving [:business-rules :invariants :edge-cases]
  :discarding [:implementation-details :infrastructure-choices]
  :manifest   crm-tests)

;; Three artefacts from one source of truth.
;; When the domain model changes, each can be re-transmuted.
```

#### Example 2: Requirements to development artefacts

```clojure
(~> (d/explore "product-requirements-v4.pdf" :depth 3)
  (transmute :into :user-stories
    :preserving [:user-goals :acceptance-criteria]
    :style      :gherkin-given-when-then)
  (transmute :into :engineering-tasks
    :preserving [:acceptance-criteria :technical-constraints]
    :style      :t-shirt-sized-with-dependencies)
  (transmute :into :test-plan
    :preserving [:acceptance-criteria :edge-cases :performance-requirements]
    :style      :bdd))
```

---

### `weave`

Integrates multiple independent manifestations into a coherent system. Where
`sequence` describes *order of operations*, `weave` describes *relationships
between coexisting things*. It is the difference between a recipe and an
architecture.

#### Signature

```clojure
(weave name
  :strands      [manifestation ...]
  :integrations [
    {:from     source-strand
     :to       target-strand-or-strands
     :via      integration-pattern
     :contract {:requirement value ...}}
    ...]
  :ensuring     [:system-level-property ...]
  :surface      surface-specification
  :manifest     result-binding)
```

#### Design rationale

Real systems are not sequences of operations — they are ecosystems of
coexisting components. `sequence` and `parallel` compose operations in *time*.
`weave` composes artefacts in *space*: it specifies the connections between
things, the contracts those connections must honour, and the system-level
properties that must hold across the whole.

A woven system is more than the sum of its strands. The integration contracts,
the system-level invariants, and the unified surface emerge from the weaving —
they do not exist in any individual strand.

#### Example

```clojure
(weave e-commerce-platform
  :strands [auth-service product-catalog cart-service payment-processor notifications]

  :integrations [
    {:from     auth-service
     :to       [cart-service payment-processor product-catalog]
     :via      :jwt-propagation
     :contract {:token-validation    :on-every-request
                :required-claims     [:user-id :role :session-id]}}

    {:from     cart-service
     :to       payment-processor
     :via      :order-handoff
     :contract {:idempotency-key     :required
                :amount-verification :strict
                :inventory-lock      :must-be-held}}

    {:from     payment-processor
     :to       notifications
     :via      :event-bus
     :contract {:events              [:payment-succeeded :payment-failed :refund-issued]
                :delivery-guarantee  :at-least-once
                :max-latency         "30 seconds"}}]

  :ensuring [:no-orphaned-transactions
             :unified-error-taxonomy
             :eventual-consistency-across-services
             :single-audit-trail]

  :surface  {:entry-point :api-gateway
             :auth        :single-sign-on
             :docs        :unified-openapi-spec}

  :manifest platform-architecture)
```

---

### `lore`

Encodes accumulated domain wisdom as a named, reusable pattern library. Where
`context` establishes structural facts, `lore` encodes *behavioural patterns*:
learned heuristics, design idioms, and active anti-patterns specific to a
domain.

#### Signature

```clojure
(lore name
  :observed-in   [sources ...]
  :patterns      [
    {:name      :pattern-name
     :when      "condition"
     :apply     "pattern description"
     :rationale "why it matters"}
    ...]
  :anti-patterns [
    {:name    :anti-pattern-name
     :avoid   "condition"
     :because "reason"}
    ...]
  :active-in     :scope)
```

#### Design rationale

Expertise is not just knowing a domain — it is knowing its *idioms*. An expert
in financial systems doesn't just know that idempotency matters; they know that
idempotency keys must be generated on the *client* before the request, not on
the server, because network failures occur between generation and receipt.

This knowledge rarely appears in formal documentation. It accumulates through
experience and post-mortems. `lore` gives tacit expertise a place to live in
Conjurer, making it available to every subsequent invocation within its scope
— applied as internalised knowledge, not post-hoc annotation.

#### Example

```clojure
(lore payment-system-patterns
  :observed-in ["stripe-engineering-blog" "psd2-eba-guidance" "incident-retrospectives"]

  :patterns [
    {:name      :client-side-idempotency-keys
     :when      "any state-mutating payment operation"
     :apply     "Generate the idempotency key on the client before the request;
                 validate server-side before processing."
     :rationale "Network failures occur between key generation and request receipt.
                 Server-side generation creates duplicate-charge risk on retry."}

    {:name      :amounts-in-minor-units
     :when      "any monetary amount stored or transmitted"
     :apply     "Represent as integer minor units (cents, pence);
                 never floating-point."
     :rationale "Float arithmetic introduces rounding errors that compound
                 across aggregations and currency conversions."}

    {:name      :sca-before-authorisation
     :when      "European payment flow under PSD2"
     :apply     "Complete strong customer authentication before the
                 authorisation request, not after."
     :rationale "PSD2 requires SCA to cover the specific transaction
                 amount and payee. Post-auth SCA does not satisfy this."}]

  :anti-patterns [
    {:name    :optimistic-inventory-decrement
     :avoid   "Decrementing inventory before payment confirmation"
     :because "Payment failures leave inventory counts permanently incorrect."}

    {:name    :synchronous-email-in-checkout
     :avoid   "Sending confirmation email synchronously in the checkout path"
     :because "Email provider outages should never cause payment failures.
               Async dispatch via event bus is always preferred."}]

  :active-in :session)
```

---

## Part IV: Execution primitives

The execution primitives describe how operations *relate and combine*. Unlike
domain-specific invocations that manifest complete artefacts, execution
primitives are about structure: ordering, concurrency, conditionality,
resilience, cross-cutting concerns, and graceful failure.

---

### `sequence`

Executes operations in order, passing results from each to the next.

#### Signature

```clojure
(sequence name
  :operations   [op-1 op-2 op-3 ...]
  :pass-results :forward | :accumulate | :selective
  :on-error     :stop | :continue | :compensate
  :manifest     result-binding)
```

#### Parameters

**`:pass-results`** — `:forward`: each operation receives the previous result.
`:accumulate`: each operation receives all prior results as a collection.
`:selective`: explicit bindings specify what each operation receives.

**`:on-error`** — `:stop`: halt on first failure. `:continue`: skip failed
operations, proceed with remaining. `:compensate`: on failure, execute
registered compensating operations in reverse order (saga pattern).

#### Design rationale

Sequential execution is the most fundamental composition pattern — later
operations depend on earlier results. `sequence` makes these dependencies
explicit while managing result-passing and error propagation automatically.

The three `:pass-results` modes address real diversity in how sequential
workflows actually work. Simple pipelines pass the most recent result forward.
Analysis workflows need every prior result for comprehensive synthesis. Complex
workflows need selective access to specific earlier outputs.

#### Example 1: Data pipeline

```clojure
(sequence customer-insights
  :operations [
    (conjure loader   :source "transactions.csv" :validate [:schema :completeness])
    (conjure cleanser :operations [:deduplicate :normalise :fill-missing])
    (conjure enricher :add [:merchant-category :geographic-region :risk-band])
    (conjure analyser :compute [:aggregates :trends :anomalies])
    (conjure reporter :format :executive-summary :output :pdf)]
  :pass-results :forward
  :on-error     :stop
  :manifest     insights-report)
```

#### Example 2: Saga with compensation

```clojure
(sequence order-saga
  :operations [
    (conjure reserve-inventory :items order-items
      :compensate :release-reservation)
    (conjure authorise-payment :amount total :method card
      :compensate :void-authorisation)
    (conjure send-confirmation :to customer-email
      :compensate :send-cancellation-notice)
    (conjure initiate-shipment :order order-id
      :compensate :cancel-with-carrier)]
  :pass-results :selective
  :on-error     :compensate
  :manifest     order-result)

;; If initiate-shipment fails after all prior steps succeeded,
;; compensation runs in reverse: cancel-with-carrier is skipped
;; (shipment never started), send-cancellation-notice, void-authorisation,
;; release-reservation. Clean, automatic rollback.
```

#### Example 3: Accumulating analysis

```clojure
(sequence contract-review
  :operations [
    (conjure extract-parties     :from contract :types [:signatories :indemnified])
    (conjure extract-obligations :from contract :categorise [:payment :delivery :ip])
    (conjure assess-risk         :considering [:parties :obligations])
    (conjure generate-redlines   :based-on [:parties :obligations :risks]
      :flag [:uncapped-liability :auto-renewal :unilateral-amendment-rights])]
  :pass-results :accumulate    ;; each stage sees all prior results
  :manifest     review-report)
```

---

### `parallel`

Executes operations concurrently, collecting and combining results.

#### Signature

```clojure
(parallel name
  :operations      [op-1 op-2 ...]
  :combine-results :merge | :array | :synthesise | custom-fn
  :wait-for        :all | :any | :first-n
  :timeout         duration-ms
  :on-error        :fail-fast | :collect-errors | :best-effort
  :manifest        result-binding)
```

#### Parameters

**`:wait-for`** — `:all`: wait for every operation. `:any`: return when the
first completes; cancel remaining. `:first-n`: return when N operations have
completed — useful for quorum or consensus patterns.

**`:on-error`** — `:fail-fast`: fail immediately if any operation fails.
`:collect-errors`: gather all errors before failing; surface them together.
`:best-effort`: return successful results alongside an error report for failed
ones — partial results are often better than no result.

#### Design rationale

Independent operations have no reason to execute sequentially. Network calls,
external API requests, document analyses, and validation checks that share no
dependencies are natural candidates for concurrency. `parallel` exploits this
independence while managing the complexity of concurrent execution, result
collection, and error handling.

The `:wait-for :any` mode enables racing strategies — when multiple equivalent
providers exist and latency matters, the first response wins and others are
cancelled. This is a meaningful architectural pattern, not just a performance
trick.

#### Example 1: Data enrichment from independent sources

```clojure
(parallel enrich-user-profile
  :operations [
    (conjure fetch-orders          :from order-service    :user-id uid :limit 10)
    (conjure fetch-preferences     :from settings-service :user-id uid)
    (conjure fetch-recommendations :from ml-service       :user-id uid :count 5)
    (conjure fetch-support-history :from crm-service      :user-id uid)]
  :combine-results :merge
  :wait-for        :all
  :timeout         2000
  :on-error        :best-effort   ;; partial profile beats no profile
  :manifest        dashboard-data)
```

#### Example 2: Racing providers

```clojure
(parallel geocode-address
  :operations [
    (conjure geocode :provider :google :address input-address)
    (conjure geocode :provider :mapbox :address input-address)
    (conjure geocode :provider :here   :address input-address)]
  :wait-for :any      ;; first response wins; others cancelled
  :timeout  3000
  :on-error :collect-errors
  :manifest geocoding-result)
```

#### Example 3: Comprehensive parallel validation

```clojure
(parallel validate-registration
  :operations [
    (conjure validate-schema     :data input :schema user-schema)
    (conjure validate-uniqueness :data input :check [:email :username])
    (conjure validate-security   :data input :check [:injection :xss])
    (conjure validate-business   :data input :rules [:age-of-consent :restricted-regions])]
  :wait-for        :all
  :on-error        :collect-errors    ;; surface all violations, not just the first
  :combine-results (fn [results]
                     {:valid  (every? :valid results)
                      :errors (mapcat :errors results)})
  :manifest        validation-result)
```

---

### `branch`

Executes operations conditionally based on predicates.

#### Signature

```clojure
(branch name
  :on       predicate-or-value
  :cases    {pattern-1 operation-1
             pattern-2 operation-2
             :else     default-operation}
  :evaluate :eager | :lazy
  :manifest result-binding)
```

#### Parameters

**`:evaluate`** — `:lazy`: only the matching branch executes (correct for
expensive or side-effectful operations). `:eager`: all branches execute; the
result of the matching branch is selected (useful for precomputation or when
all outcomes should be warmed).

#### Design rationale

Decision logic is fundamental: different inputs require different handling;
different states require different responses. `branch` provides declarative
control flow that integrates naturally with Conjurer's composable model.

Pattern matching supports both exact values and predicates, enabling
everything from simple dispatch to multi-factor decision trees. The `:else`
clause provides mandatory default behaviour — unhandled cases are never
silently ignored.

#### Example 1: Risk-based routing

```clojure
(branch payment-routing
  :on     (score-transaction transaction)
  :cases  {
    (< score 0.3) (conjure auto-approve    :transaction transaction)
    (< score 0.7) (conjure standard-review :transaction transaction
                   :checks [:velocity :device-fingerprint])
    (< score 0.9) (conjure enhanced-review :transaction transaction
                   :checks :all :include-biometric true)
    :else         (conjure manual-review   :transaction transaction
                   :freeze-account true :notify :fraud-team)}
  :evaluate :lazy
  :manifest routing-decision)
```

#### Example 2: Structural pattern matching

```clojure
(branch support-routing
  :on    incoming-issue
  :cases {
    {:category :technical :severity :critical}
    (conjure escalate :to :senior-engineer :sla "1h" :notify [:eng-lead :on-call])

    {:category :technical :severity :high}
    (conjure assign :to :technical-support :sla "4h")

    {:category :billing :amount (> amount 1000)}
    (conjure assign :to :account-manager :priority :high)

    {:category :billing}
    (conjure assign :to :billing-support)

    :else
    (conjure assign :to :general-queue :consider-ai-triage true)}
  :evaluate :lazy
  :manifest assignment)
```

---

### `retry`

Executes an operation with automatic retry logic for transient failures.

#### Signature

```clojure
(retry name
  :operation     operation
  :attempts      n
  :backoff       :linear | :exponential | :jittered-exponential | custom-fn
  :initial-delay ms
  :max-delay     ms
  :retry-on      [error-predicate ...]
  :give-up-on    [error-predicate ...]
  :on-retry      callback-fn
  :manifest      result-binding)
```

#### Design rationale

Distributed systems fail transiently. Network timeouts, temporary service
unavailability, rate limiting, and lock contention create failures that may
succeed on retry. `retry` implements resilience patterns that distinguish
these from permanent failures that should propagate immediately.

Backoff strategies are not cosmetic. Linear backoff suits known, bounded
recovery times. Exponential backoff reduces pressure on struggling services
progressively. Jittered exponential backoff prevents the thundering herd
problem — when many clients retry simultaneously after a shared outage, jitter
spreads the load across the recovery window.

The `:retry-on` / `:give-up-on` split is essential. Retrying an authentication
failure wastes time and may lock accounts. Retrying a network timeout is
almost always correct. Making this distinction explicit — requiring the
practitioner to be deliberate — is a feature.

#### Example

```clojure
(retry payment-gateway-call
  :operation     (conjure charge-payment
                   :amount          order-total
                   :method          payment-method
                   :idempotency-key client-generated-key)
  :attempts      5
  :backoff       :jittered-exponential
  :initial-delay 1000
  :max-delay     30000
  :retry-on      [(= status 429)       ;; rate limited — retry with backoff
                  (= status 503)       ;; gateway unavailable
                  timeout?
                  network-error?]
  :give-up-on    [(= status 400)       ;; bad request — not retriable
                  (= status 401)       ;; auth failure — fix the credentials
                  (= status 402)]      ;; payment declined — not a transient error
  :on-retry      (fn [attempt error]
                   (log/warn "Payment gateway retry" attempt :error-type (type error))
                   (metrics/increment "payment.gateway.retries"))
  :manifest      charge-result)
```

---

### `intercept`

Applies cross-cutting concerns to an operation without modifying its
implementation. Logging, authentication, timing, caching, transactions.

#### Signature

```clojure
(intercept name
  :operation target-operation
  :before    [interceptor ...]
  :around    [interceptor ...]
  :after     [interceptor ...]
  :on-error  [interceptor ...]
  :transform {:request transform-fn :response transform-fn}
  :manifest  result-binding)
```

#### Parameters

**`:before`** — Executed before the operation, in declaration order.
Validation, authentication, rate-limit checks.

**`:around`** — Wraps execution symmetrically: setup runs before the operation
in declaration order; teardown runs after in reverse order. Timing,
transactions, caching.

**`:after`** — Executed after successful completion, in reverse declaration
order. Audit logging, event publication, cache invalidation.

**`:on-error`** — Executed when the operation fails. Error logging, alerting,
error response formatting.

#### Design rationale

Cross-cutting concerns — security, observability, transaction management —
affect many operations but belong in none of their implementations. `intercept`
enables declarative application of these concerns, keeping business logic clean
and the concerns composable.

The ordering discipline is not arbitrary. Before-interceptors run in order
(outermost concern first); after-interceptors run in reverse (outermost concern
last). This models setup-teardown relationships correctly: the interceptor that
opens a transaction is the last to close it.

#### Example

```clojure
(intercept handle-payment-update
  :operation (conjure update-payment-method
               :customer-id customer-id
               :new-method  payment-data)

  :before [
    (conjure verify-jwt       :require [:not-expired :correct-audience])
    (conjure verify-ownership :customer-id customer-id :actor current-user)
    (conjure validate-schema  :data payment-data :schema payment-method-schema)
    (conjure check-rate-limit :customer-id customer-id :limit 10-per-hour)]

  :around [
    (conjure measure-latency  :record-to :metrics :labels {:op "payment-update"})
    (conjure db-transaction   :isolation :serializable :timeout 5000)]

  :after [
    (conjure audit-log        :action :payment-method-updated :actor current-user)
    (conjure publish-event    :topic "payment.method.updated" :payload {:customer-id customer-id})
    (conjure invalidate-cache :keys [[:payment-methods customer-id]])]

  :on-error [
    (conjure log-error        :severity :error :context {:customer-id customer-id})
    (conjure alert            :if (= (type error) :database-failure) :notify :on-call)
    (conjure format-error     :sanitise-pii true :include-request-id true)]

  :manifest api-response)
```

---

### `ward`

Wraps a potentially-failing operation with structured recovery strategies.
More expressive than `retry` (which handles *when to re-attempt*) and
complementary to `intercept` (which handles cross-cutting infrastructure).
`ward` handles *what to do when things fail in semantically meaningful ways*.

#### Signature

```clojure
(ward name
  :protect            operation
  :from               [failure-predicate ...]
  :recover            {failure-pattern recovery-operation ...}
  :degrade-gracefully boolean
  :escalate           :when escalation-predicate
  :manifest           result-binding)
```

#### Design rationale

Resilience is not the absence of failure — it is the quality of response to
failure. `retry` addresses one narrow class: transient failures worth
re-attempting with delay. Many failures require richer responses: serve cached
data when the source is unavailable, return a partial result rather than
nothing, degrade to simpler logic when complex logic is unavailable, notify
humans when automated recovery has been exhausted.

`ward` models this richer resilience space. The metaphor is precise: a ward
is a protective boundary. What enters the ward is guarded; what threatens it
is handled according to explicit, inspectable strategy. The `:recover` map
makes the degradation ladder visible and intentional rather than scattered
across catch blocks.

#### Example 1: Graceful recommendations degradation

```clojure
(ward recommendations
  :protect (conjure ml-recommendations
             :user-id current-user
             :timeout 200             ;; strict latency budget
             :count   10)

  :from [timeout? model-unavailable? feature-store-error?]

  :recover {
    timeout?
    (conjure cached-recommendations
      :user-id current-user
      :from    :redis
      :max-age 3600)

    model-unavailable?
    (conjure popularity-recommendations
      :category user-preferred-category
      :count    10)

    feature-store-error?
    (conjure editorial-picks
      :list :homepage-defaults)}

  :degrade-gracefully true
  :escalate           :when (> consecutive-model-failures 50)
  :manifest           recommendations)

;; The widget always renders something useful.
;; Personalised → cached → popular → editorial — the ladder is explicit.
;; Engineers are paged only after 50 consecutive model failures.
```

#### Example 2: Ward within a sequence

```clojure
(sequence checkout
  :operations [
    (validate cart :strict true)

    (ward payment-charge
      :protect (conjure charge :amount total :method card)
      :from    [gateway-timeout? network-error?]
      :recover {
        gateway-timeout?
        (conjure queue-async-charge
          :order-id order-id
          :customer-message "Payment is processing — you won't be charged twice.")
        network-error?
        (retry :attempts 2 :backoff :exponential)}
      :escalate :when (> consecutive-gateway-timeouts 3))

    (conjure send-order-confirmation)]
  :on-error :compensate)
```

---

## Part V: Semantic typing

### `shape`

Defines semantic type contracts — descriptions of what data *means* rather
than merely what it *is*. Positioned between the looseness of plain maps and
the mechanical rigidity of JSON Schema, `shape` describes data in terms the
system can reason about semantically.

#### Signature

```clojure
(shape name
  :fields      {field-name type-or-constraint ...}
  :invariants  ["natural-language invariant" ...]
  :phi-fields  [:field ...]
  :examples    [{...} ...]
  :derived-from source-schema)
```

#### Parameters

**`:fields`** — Field names mapped to semantic type descriptions, not just
primitive types. Types can carry domain constraints: `(uuid :globally-unique)`,
`(date :past-only)`, `(icd-10-code :valid :current)`.

**`:invariants`** — Natural-language statements of correctness that must hold
across the shape. The system translates these into concrete validation logic.

**`:phi-fields`** — Fields containing personally-identifiable information.
Marked fields trigger appropriate handling: access logging, encryption
requirements, right-to-erasure support.

**`:examples`** — Valid instances of the shape. Used to calibrate the system's
understanding of what the shape actually represents.

**`:derived-from`** — An existing schema from which this shape is generated,
for use when a formal schema already exists and the shape should reflect it.

#### Design rationale

Conventional type systems describe the *structure* of data: which fields
exist, what primitive types they hold. Semantic type contracts describe the
*meaning* of data: what values are valid, what relationships must hold, what
the data *represents* in the domain.

`shape` is distinct from `data/schema` (the data grimoire): `data/schema`
describes data for generation and transformation pipelines; `shape` describes
data for semantic understanding across all grimoires. A shape is a domain
concept; a schema is an implementation of it.

#### Example 1: Domain-rich record

```clojure
(shape patient-record
  :fields {
    :id                (uuid :globally-unique)
    :mrn               (string :format "MRN-XXXXXXXX" :unique-per-facility true)
    :date-of-birth     (date :past-only :not-before "1900-01-01")
    :primary-diagnosis (icd-10-code :valid :current)
    :medications       [(map :of medication-record) :or :empty-list]
    :consent-given     (boolean :required true)}

  :invariants [
    "mrn must be unique within the originating facility"
    "primary-diagnosis must correspond to a current ICD-10 code"
    "medications must not contain clinically contraindicated combinations"
    "all phi-fields must have an access-event logged whenever read or written"]

  :phi-fields [:date-of-birth :mrn :id]

  :examples [
    {:id "f47ac10b-58cc-4372-a567-0e02b2c3d479"
     :mrn "MRN-00123456"
     :date-of-birth "1978-03-22"
     :primary-diagnosis "J06.9"
     :medications []
     :consent-given true}])
```

#### Example 2: Monetary amount

```clojure
(shape monetary-amount
  :fields {
    :value    (integer :non-negative)   ;; always minor units — cents, pence, øre
    :currency (string :iso-4217)
    :scale    (integer :default 2)}     ;; decimal places for display conversion

  :invariants [
    "value is always in minor units — never floating-point"
    "arithmetic on monetary-amount values must use integer arithmetic only"
    "cross-currency arithmetic is forbidden without explicit conversion"
    "currency must be a valid ISO-4217 alphabetic code"]

  :examples [
    {:value 9999 :currency "EUR" :scale 2}   ;; €99.99
    {:value 10000 :currency "JPY" :scale 0}  ;; ¥10,000 — no minor units in JPY
    {:value 150 :currency "GBP" :scale 2}])  ;; £1.50
```

---

## Best practices

### Intention over instruction

State what you want the manifestation to accomplish, not how to accomplish it.
Success criteria, constraints, and examples communicate intent better than
algorithmic descriptions.

```clojure
;; Good: outcome-oriented, testable against clear criteria
(conjure email-validator
  :accepts   email-string
  :rejects   [:missing-at-sign :invalid-domain :leading-trailing-whitespace]
  :normalises [:lowercase-domain :trim-whitespace]
  :returns   {:valid boolean :normalised string :reason string})

;; Avoid: prescribing the implementation
(conjure email-validator
  :use-regex "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
  :split-on  "@"
  :verify-mx-record true)
```

### Establish context early; let gravity do the rest

A rich context at the start of a session is worth dozens of repeated parameters
across individual invocations. The investment compounds: the heavier the
established context, the shorter and more precise every subsequent invocation.

### Lead with examples when precision matters

The `:examples` parameter is often more precise than prose. When normalisation
behaviour, edge-case handling, or output format are nuanced, show them rather
than describing them.

### Make topology explicit

Use `:requires`, `:prefers`, `:style`, and `:deferred` deliberately. They
prevent the system from treating a stylistic preference as a correctness
requirement, or from trading away a compliance constraint to satisfy a
performance preference.

### Prefer `~>` for multi-step transformations

When a value passes through multiple sequential transformations, `~>` makes
the flow readable and each step independently observable. Nested `conjure`
calls obscure the data flow; threaded pipelines make it explicit.

### Layer execution primitives from outermost concern inward

`intercept` wraps the outermost scope (cross-cutting infrastructure).
`sequence` or `parallel` structures the operation. `retry` and `ward` handle
resilience at the most specific level. This layering keeps concerns at their
appropriate scope.

```clojure
;; Clear layering: infrastructure wraps structure wraps resilience
(intercept with-auth-and-observability
  :operation (sequence data-pipeline
    :operations [
      (retry fetch-source-data :attempts 3 :backoff :exponential)
      (parallel [enrich-a enrich-b enrich-c])
      (ward persist-results
        :protect (conjure write :to primary-store)
        :recover {unavailable? (conjure write :to fallback-queue)})]))
```

### Use `witness` to build decision trails

Inserting `witness` calls into a `~>` pipeline costs nothing in terms of the
pipeline's output. It produces an invaluable record of reasoning that can be
reviewed, audited, and used to improve the specification over time.

---

## Integration patterns

### Core as the composition layer

`core` constructs make all other grimoires composable. Domain knowledge from
`domain`, text analysed by `semantics`, workflows from `orchestrate` — all
flow through `core`'s composition machinery.

```clojure
;; Cross-grimoire pipeline
(~> requirements-document
  (d/explore    :depth 3 :focus [:entities :workflows :constraints])
  (s/texan      :models [:logical :argumentation] :surface :implicit-requirements)
  (conjure api-design :from-domain true :incorporating-implicit-requirements true)
  (weave platform
    :strands  [api-design auth-service data-layer]
    :ensuring [:consistent-auth :unified-error-taxonomy])
  (witness :observe [:architectural-decisions :trade-offs]
    :record-to adr-log))
```

### Context propagates into all grimoires

A `context establish` at the core level propagates into every grimoire
automatically. Healthcare context established once applies to `d/explore`,
`data/schema`, `w/prototype`, and `s/texan` invocations without
re-specification. Regulations, entity definitions, and conventions are
available everywhere within scope.

### Execution primitives underpin grimoire abstractions

Higher-level grimoire constructs are built on core primitives.
`o/define-workflow` is `sequence` and `parallel` with richer state management.
`d/comprehensive-analysis` is `parallel` extraction followed by `d/merge`.
The primitives are not low-level — they are the universal composition
vocabulary on which domain-specific abstractions are built.

---

## Grimoire metadata

```clojure
{:grimoire    "core"
 :version     "3.0.0"
 :description "Foundational constructs, composition machinery, and execution
               primitives for the Conjurer language"

 :constructs {
   :fundamental  [conjure refine context using assume]
   :semantic     [ritual explain meta-query witness as]
   :composition  [~> transmute weave lore]
   :execution    [sequence parallel branch retry intercept ward]
   :typing       [shape]}

 :best-for [
   "Declarative intent specification with explicit topology"
   "Progressive refinement as a discovery process"
   "Context establishment, inheritance, and semantic gravity"
   "Cross-grimoire composition and system integration"
   "Resilient workflows with graceful degradation"
   "Transparent reasoning and audit trails"
   "Perspectival analysis and multi-role review"]

 :works-with :all-grimoires

 :key-concepts [
   {:term "Invocation"
    :definition "An expression of intent that the system manifests into reality"}
   {:term "Manifestation"
    :definition "The artefact produced in response to an invocation"}
   {:term "Semantic gravity"
    :definition "The interpretive pull exerted by established context.
                 Heavier context enables terser, more precise invocations."}
   {:term "Intent topology"
    :definition "The structural importance hierarchy of a specification:
                 :requires > :prefers > :style; :deferred is dormant."}
   {:term "Productive ambiguity"
    :definition "Deliberate openness in a specification that invites creative
                 judgment rather than demanding complete prescription."}
   {:term "Transmutation"
    :definition "Form-changing transformation that preserves semantic essence.
                 Different from refinement (same form, enhanced) and
                 conjuration (new form, from scratch)."}
   {:term "Witness"
    :definition "Non-invasive observation of a manifestation's reasoning
                 without modifying the manifestation itself."}
   {:term "Ward"
    :definition "Structured error containment with explicit degradation strategy.
                 The :recover map is the degradation ladder, made visible."}]}
```

---

## Implementation notes for LLM processors

### Semantic understanding

Interpret invocation intent from context and parameters rather than relying on
exact syntax. Recognise semantic equivalence: `:validates`, `:ensures`,
`:requires`, and `:checks` all express constraint intent and should produce
equivalent validation logic. Infer reasonable defaults from established context
when parameters are absent rather than requesting specification of every detail.

### Intent topology

When processing `:requires`, `:prefers`, `:style`, and `:deferred`:

- Apply all `:requires` items unconditionally. A manifestation that omits a
  `:requires` item is incorrect.
- Apply `:prefers` items when they don't conflict with `:requires`. Under
  constraint, `:requires` always wins.
- Use `:style` to inform presentation, tone, and aesthetic decisions. Style
  never overrides correctness or compliance.
- Record `:deferred` items in the manifestation's documentation with a clear
  note that they are intentionally not yet implemented.

When a genuine conflict exists between `:requires` items, surface it
explicitly rather than silently prioritising one. Ask the practitioner to
adjudicate.

### Context and semantic gravity

Accumulate context throughout the session. When `context establish` names
`:regulations`, apply their implied behaviours automatically:

- **GDPR**: data minimisation, right-to-erasure support, processing lawfulness,
  data-subject request handling
- **HIPAA/HITECH**: PHI encryption at rest and in transit, audit logging on
  all PHI access, minimum-necessary access controls, BAA awareness
- **PSD2**: strong customer authentication before authorisation (not after),
  open banking API requirements, payment initiation security
- **AML/KYC**: transaction monitoring, suspicious activity reporting,
  customer due diligence

Context established via `:inherits` extends the parent; it does not replace
it. Additions apply on top; overrides replace specific items while preserving
the rest.

### Conditional refinement (`:when`)

When a `refine` carries a `:when` predicate: if evaluable and false, do not
apply the refinement but record it as a pending conditional refinement in the
manifestation's metadata. If the predicate is not evaluable at invocation time,
record the refinement as dormant — note the condition under which it will
activate.

### Threading (`~>`)

Execute steps in declaration order. Pass the result of each step as the
implicit first argument to the next. `witness` calls within a `~>` chain
observe the passing value but do not modify it — the threaded value continues
unchanged through the chain. If a step is `parallel`, execute its operations
concurrently and pass the combined result to the next step.

### Transmutation

Transmutation is not regeneration. Interpret the source manifestation's full
semantic content, then recast it in the target form using conventions native
to that form. `:preserving` items survive as semantic content; `:discarding`
items are structural artefacts of the source form that do not transfer. The
result must feel natural in the target form, not like a mechanical translation
from the source.

### Weaving

A woven system is more than combined strands. Generate the integration
contracts specified in `:integrations` with explicit interface types, error
behaviours, and versioning expectations. `:ensuring` clauses are system-level
invariants — verify that the proposed architecture demonstrably satisfies them.
Note any that require runtime mechanisms (eventual consistency, distributed
transactions, unified error taxonomies) to be architecturally visible and
explicitly designed, not assumed.

### Ward and graceful degradation

Attempt `:protect` first. On failure, match against `:recover` patterns in
declaration order; execute the first matching recovery operation. If
`:degrade-gracefully` is true, a partial or degraded result is a valid outcome
— prefer it to an empty result. If the `:escalate` predicate is met, signal
that human intervention is required *in addition to* executing the recovery
operation, not instead of it.

### Witness

Produce a separate observation record alongside the manifestation. The
observation is out-of-band: the manifestation is identical to what would have
been produced without the `witness`. The record should document what the system
understood the intent to be, any ambiguities resolved and how, which
alternatives were considered and set aside, and which design decisions were
made and why. This record is queryable via subsequent `explain` or `meta-query`
invocations on the witnessed target.

### Shape

Use shape definitions to inform all manifestation decisions involving that
data type: validation logic, serialisation format, display formatting, error
messages, and persistence constraints. `:invariants` written in natural
language should be translated into concrete validation rules applied wherever
the shape is handled. `:phi-fields` always trigger appropriate data-handling
requirements regardless of whether the active context has named the relevant
regulation.

### Result quality

Every manifestation must be production-ready: no placeholders, no TODO
comments, no incomplete implementations. Specified features must be present
and functional. Code must work immediately when executed. Include inline
comments for non-obvious logic. Honour `:non-negotiable` items from `assume`
without exception. When a significant interpretive decision has been made —
filling a gap with a design judgment — note it transparently in accompanying
prose so the practitioner can inspect and refine it.

---

*This grimoire is the foundation. Master its constructs and every other
grimoire opens — not as an isolated capability, but as a composable extension
of the same language.*