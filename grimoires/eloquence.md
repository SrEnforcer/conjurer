# eloquence.md — Conjurer Eloquence Grimoire

The spellbook for language. Every other grimoire manifests artefacts —
domain models, data pipelines, web interfaces, workflows, semantic analyses.
But manifestation without articulation is incomplete. The most sophisticated
architecture becomes useless if stakeholders cannot comprehend it. The most
rigorous analysis fails if its audience cannot interpret it. The most
carefully designed system goes unappreciated if it cannot explain itself.

`eloquence` bridges manifestation and understanding. It transforms structured
knowledge into calibrated language — prose shaped to audience, purpose, and
register. Where other grimoires produce artefacts, eloquence produces
*comprehension*. Where others generate structure, eloquence generates *clarity*.

---

## Philosophy

### The rhetorical problem

Every communication is a persuasion problem. Not in the cynical sense —
not manipulation — but in the classical sense: you have knowledge the reader
does not yet have, and your task is to transfer it in a form they can receive.
What they can receive depends on who they are, what they already know, what
they care about, and what register they expect from this kind of document.

A microservices architecture document written for senior engineers is not
improved by simplification for executives. It is ruined. The executive version
is a different document — same underlying knowledge, different selection,
different framing, different register, different structure. Neither is a
degraded version of the other. Both serve their audience with integrity.

`eloquence` operationalises this insight. Every invocation specifies audience
as a first-class parameter, not an afterthought. The system adapts selection,
structure, vocabulary, and register accordingly.

### The five canons of rhetoric, manifested

Classical rhetoric identifies five canons. Eloquence operationalises each:

**Inventio (Invention)** — Discovering what to say. `e/compose` integrates
with other grimoires to access structured knowledge, then selects what is
relevant for the specific communicative purpose.

**Dispositio (Arrangement)** — Organising material. `e/narrate` structures
information using established patterns (chronological, problem/solution,
comparative, deliberative) that enhance comprehension for the specific audience
and purpose.

**Elocutio (Style)** — Choosing words. `e/compose` and `e/adapt-register`
calibrate vocabulary, sentence rhythm, hedging patterns, active/passive voice,
and technical density to audience and purpose.

**Memoria (Memory)** — Mastering content. Accumulated context and `e/refine`
enable iterative improvement while maintaining consistency across related
documents and sessions.

**Pronuntiatio (Delivery)** — Presenting effectively. Output formats (markdown,
HTML, Word, PDF) ensure appropriate presentation for each medium and context.

### The same truth, multiple tellings

A technical architecture has one truth — the actual design decisions, their
rationale, their trade-offs. But that truth requires different tellings for
different audiences. Engineers need implementation detail and failure modes.
Executives need business impact and risk posture. Compliance officers need
audit evidence and control mapping. Regulators need statutory alignment.

These are not dilutions or simplifications of each other — they are genuinely
different documents that share a common knowledge substrate. `eloquence`
enables generating all of them from that substrate while maintaining fidelity
to the underlying truth.

### Four compositional principles

**Audience-centric adaptation** — Information must transform for its receivers.
Technical depth that enlightens experts overwhelms novices. Conversational tone
that builds trust with end-users undermines authority in legal contexts.

**Rhetorical intentionality** — Every document serves purposes beyond
information transfer. Making intent explicit enables purposeful language
shaping.

**Narrative architecture** — Humans comprehend through story structures. Raw
information overwhelms; narrative scaffolding enables understanding.

**Stylistic precision** — Tone, voice, register, diction, rhythm — these are
functional, not decorative. The grimoire treats style as a parameter.

---

## Naming rationale

**`e/`** — Short namespace alias.

**Eloquence** — From Latin *eloquentia*, derived from *eloqui* "to speak out."
Eloquence combines wisdom with verbal mastery to inform, persuade, and move
audiences. Not mere fluency — purposeful, calibrated expression.

**Compose** — To bring elements together into a unified, intentional whole.
The primary act of the grimoire.

**Narrate** — To structure events or information into a story that unfolds
for the reader rather than confronting them all at once.

**Formalize** — To transform informal or ambiguous language into precise,
auditable prose suitable for legal or regulatory contexts.

---

## Part I: Core compositional functions

---

### `e/compose`

The primary function: generates calibrated prose from structured knowledge,
specified audience, purpose, and rhetorical constraints.

#### Signature

```clojure
(e/compose subject
  :from          knowledge-source
  :audience      :audience-keyword | audience-definition
  :purpose       :inform | :persuade | :instruct | :report | :propose | :warn
  :tone          :formal | :professional | :conversational | :plain | :urgent
  :length        :brief | :standard | :comprehensive | :custom-word-count
  :structure     :narrative | :argumentative | :analytical | :procedural | :comparative
  :emphasise     [:aspect ...]
  :omit          [:aspect ...]
  :format        :markdown | :html | :plain-text
  :output        :document)
```

#### Parameters

**`:audience`** — Who will read this. Built-in profiles:
`:engineer`, `:senior-engineer`, `:executive`, `:product-manager`,
`:legal-counsel`, `:compliance-officer`, `:regulator`, `:customer-support`,
`:end-user`, `:general-public`, `:board`

Custom audience definition:
```clojure
{:expertise    :domain-expert
 :technical    :low
 :cares-about  [:cost :risk :timeline]
 :register     :formal
 :language     :nl}
```

**`:purpose`** — The primary communicative goal. Determines what kinds of
rhetorical moves are appropriate: persuasive documents deploy credibility
signals and evidence; instructional documents prioritise sequence and clarity;
warning documents lead with risk and consequence.

**`:from`** — Knowledge source. Can be a domain model, a data analysis result,
a semantic analysis, a workflow specification, or free-form structured data.
The system selects from it what is relevant to the audience and purpose.

**`:emphasise`** / **`:omit`** — Fine-grained control over what aspects of the
source knowledge are foregrounded or suppressed.

#### Example 1: Architecture document for three audiences

```clojure
(def architecture (d/explore "system-architecture.pdf" :depth 3))

;; For engineers: technical detail, failure modes, implementation guidance
(e/compose "Microservices Architecture"
  :from      architecture
  :audience  :senior-engineer
  :purpose   :inform
  :tone      :professional
  :structure :analytical
  :emphasise [:implementation-patterns :failure-modes :operational-requirements]
  :format    :markdown)

;; For executives: business impact, risk, strategic rationale
(e/compose "Platform Architecture Overview"
  :from      architecture
  :audience  :executive
  :purpose   :inform
  :tone      :professional
  :structure :narrative
  :emphasise [:business-capabilities :risk-posture :scalability]
  :omit      [:implementation-detail :specific-technologies]
  :length    :brief
  :format    :markdown)

;; For compliance: audit evidence, control mapping, security posture
(e/compose "Architecture Security and Compliance Evidence"
  :from      architecture
  :audience  :compliance-officer
  :purpose   :report
  :tone      :formal
  :structure :analytical
  :emphasise [:security-controls :audit-trail :regulatory-alignment :data-handling]
  :format    :markdown)
```

#### Example 2: Data analysis communicated to stakeholders

```clojure
(def analysis-results (data/profile customer-dataset :statistics :all))

(e/compose "Customer Behaviour Analysis — Q4 2025"
  :from      analysis-results
  :audience  :product-manager
  :purpose   :inform
  :tone      :professional
  :length    :standard
  :emphasise [:segment-shifts :anomalies :actionable-findings]
  :omit      [:statistical-methodology :raw-distributions]
  :format    :markdown)

;; Generated document:
;; - Opens with executive summary of key findings
;; - Presents segment distribution in plain language ("28% of customers
;;   are now in the premium tier, up from 22% last quarter")
;; - Flags anomalies as insights ("The pending account status has doubled
;;   in the past 30 days, suggesting an onboarding friction point")
;; - Closes with explicit recommendations
;; - No mention of z-scores, statistical methodology, or raw percentages
```

---

### `e/narrate`

Structures information using an established narrative pattern — mapping content
onto a story arc that guides the reader from orientation through understanding
to conclusion.

#### Signature

```clojure
(e/narrate subject
  :from     knowledge-source
  :pattern  :problem-solution | :situation-complication-resolution
            | :comparison-contrast | :chronological | :cause-effect
            | :deliberative | :hero-transformation
  :audience :audience-keyword
  :arc      {:setup "..." :tension "..." :resolution "..."}
  :format   :markdown | :prose
  :output   :document)
```

#### Parameters

**`:pattern`** — The narrative structure:
- `:problem-solution` — establishes a problem, presents a solution, demonstrates
  resolution. Classic for proposals and design documents.
- `:situation-complication-resolution` — starts with stable situation, introduces
  a complication that disrupts it, resolves the disruption. Excellent for
  incident reports and change proposals.
- `:chronological` — follows temporal sequence. Natural for migration narratives,
  product history, and process documentation.
- `:deliberative` — presents a question, explores competing options, argues for
  a recommendation. Ideal for decision documents and ADRs.
- `:comparison-contrast` — establishes criteria, compares options against them,
  draws conclusion. Useful for technology evaluations and trade-off analyses.

**`:arc`** — Optional explicit guidance for the narrative arc when the system
needs more direction about how to tell this particular story.

#### Example: Migration narrative

```clojure
(e/narrate "Database Migration to PostgreSQL 16"
  :from    {:migration-log migration-record :profile-comparison pre-post-profiles}
  :pattern :situation-complication-resolution
  :audience :engineering-team
  :arc     {:setup      "Legacy PostgreSQL 12 had served reliably for 4 years"
            :tension    "Approaching end-of-life with security implications"
            :resolution "Successful upgrade with performance improvements"}
  :format  :markdown)

;; Generated narrative:
;; "Our PostgreSQL 12 deployment, in production since 2021, had been
;; reliable — until its extended support window began to close.
;; 
;; With security patches no longer guaranteed after November 2025, and
;; our PCI DSS certification requiring supported database versions, we
;; had a defined window to act.
;; 
;; The migration to PostgreSQL 16 completed on [date]. Query planning
;; improvements in PG16 delivered an immediate 18% reduction in p95
;; query latency. The migration itself ran without customer impact..."
```

---

### `e/adapt-register`

Transforms existing content into a different register, audience, or level of
formality while preserving the underlying information and intent.

#### Signature

```clojure
(e/adapt-register source-content
  :from    :current-register-or-audience
  :to      :target-register-or-audience
  :preserve [:intent :factual-content :structure | :all]
  :language :en | :nl | :de | :fr | ...
  :output  :adapted-document)
```

#### Design rationale

The same document must sometimes speak to multiple audiences. A technical
specification written for engineers must sometimes be adapted for a board
presentation. A legal contract must sometimes be explained in plain language
for the signatory. An internal incident report must sometimes be communicated
to customers.

`e/adapt-register` handles this without requiring a full `e/compose` from
scratch — it transforms existing content rather than generating from source
knowledge, preserving the document's structure and specific claims while
adapting vocabulary, tone, and technical density.

#### Example: Technical to plain language

```clojure
(e/adapt-register api-documentation
  :from     :technical-engineer
  :to       :end-user-non-technical
  :preserve [:intent :factual-content]
  :language :nl)

;; Before (technical):
;; "Authenticate using OAuth 2.0 Bearer tokens. Include the Authorization
;;  header with the format 'Bearer {access_token}' in all API requests."

;; After (plain language, Dutch):
;; "Om in te loggen heeft u een toegangscode (token) nodig. U ontvangt
;;  deze na het inloggen. Voeg deze code toe aan elk verzoek dat u doet —
;;  onze medewerkers kunnen u helpen dit in te stellen."
```

---

### `e/instruct`

Generates procedural instructional content — step-by-step guides, tutorials,
runbooks, and how-to documentation — structured for maximum clarity and
successful task completion.

#### Signature

```clojure
(e/instruct task
  :for           :audience-keyword
  :assumes       [:prerequisite-knowledge ...]
  :outcome       "what the reader will be able to do after reading"
  :format        :tutorial | :how-to | :runbook | :reference
  :include       [:prerequisites :steps :validation :troubleshooting :examples]
  :code-examples boolean
  :language      :nl | :en | ...
  :output        :instructional-document)
```

#### Parameters

**`:format`** — The instructional genre:
- `:tutorial` — learning-oriented; teaches concepts through doing; reader
  has not done this before
- `:how-to` — task-oriented; achieves a specific goal; reader has relevant
  background
- `:runbook` — operations-oriented; emergency procedures, operational steps;
  clarity over elegance
- `:reference` — information-oriented; lookup document; completeness over
  readability

#### Example: Onboarding runbook

```clojure
(e/instruct "New Developer Environment Setup"
  :for       :new-engineer
  :assumes   [:basic-terminal :git-installed]
  :outcome   "Running the full development stack locally within 30 minutes"
  :format    :how-to
  :include   [:prerequisites :steps :validation :troubleshooting]
  :code-examples true
  :language  :en)

;; Generated document:
;; ## Prerequisites
;; - Git ≥ 2.34 (check: `git --version`)
;; - Docker Desktop running
;; - Access to the company GitHub organisation (request from IT)
;;
;; ## Steps
;; **1. Clone the repository**
;; ```bash
;; git clone git@github.com:company/platform.git
;; cd platform
;; ```
;;
;; **2. Configure your environment**
;; Copy `.env.example` to `.env`:
;; ```bash
;; cp .env.example .env
;; ```
;; Fill in the values marked `CHANGE_ME` — your tech lead can share these.
;;
;; **Validate**: After this step, run `./scripts/validate-env.sh`.
;; You should see: `✓ Environment configuration valid`
;;
;; **Troubleshooting**: If validation fails with "Missing DATABASE_URL",
;; ensure you've replaced the placeholder with the development database URL
;; from the team's password manager.
```

---

### `e/formalize`

Transforms informal, conversational, or imprecise content into formal, precise,
auditable prose suitable for legal, regulatory, or contractual contexts.

#### Signature

```clojure
(e/formalize source-content
  :level        :standard | :legal | :regulatory | :contractual
  :preserve     :intent-strictly | :allow-clarifying-expansions
  :disambiguate [:pronouns :vague-references :implicit-agents]
  :number-claims boolean
  :definitions  :auto-generate | :existing-glossary | :none
  :citations    :auto-source | :existing-citations | :flag-unsourced
  :output       :formal-document)
```

#### Parameters

**`:disambiguate`** — What to make explicit that informal language leaves vague:
- `:pronouns` — replace "they" with the specific entity
- `:vague-references` — replace "this" and "the document" with specific references
- `:implicit-agents` — make passive constructions explicit ("it was decided" →
  "the Management Board decided")

**`:number-claims`** — Number every assertoric claim in the document, enabling
precise reference in legal correspondence ("with respect to claim 3.2...").

#### Example: Formalising a meeting decision

```clojure
(e/formalize "We decided the data team will own the GDPR compliance work
              going forward, and they need to have a DPA in place by end of Q1"
  :level        :legal
  :preserve     :intent-strictly
  :disambiguate [:pronouns :implicit-agents]
  :number-claims true)

;; Returns:
;; 1. The Data Management Team assumes ownership of the organisation's GDPR
;;    compliance programme with effect from [date of decision].
;; 2. The Data Management Team shall establish a Data Processing Agreement
;;    compliant with Article 28 of Regulation (EU) 2016/679 no later than
;;    31 March [year].
;; 3. For the purposes of this decision, "GDPR compliance programme" encompasses
;;    all obligations arising from Regulation (EU) 2016/679 and its national
;;    implementation instruments as applicable to the organisation's data
;;    processing activities.
```

---

### `e/simplify`

Transforms technically dense, formal, or complex content into plain language —
accessible without being condescending, precise without being technical.

#### Signature

```clojure
(e/simplify source-content
  :target-level  :primary | :secondary | :general-adult | :professional-non-specialist
  :preserve      [:key-obligations :legal-force :warnings]
  :language      :nl | :en | ...
  :standard      :plain-language-nl | :plain-language-uk | :clear-writing
  :output        :simplified-document)
```

#### Example: GDPR privacy notice for citizens

```clojure
(e/simplify gdpr-privacy-notice-legal-version
  :target-level :general-adult
  :preserve     [:key-obligations :legal-force :rights-information]
  :language     :nl
  :standard     :plain-language-nl)

;; Transforms complex legal notice into accessible Dutch plain language:
;; - Average sentence length reduced from 38 to 17 words
;; - Passive voice constructions replaced with active
;; - Legal jargon explained in parentheses on first use
;; - Rights section reformatted as a clear list
;; - Maintains all legally required content
;; - Readability level: suitable for readers at secondary school level
```

---

### `e/localize`

Adapts content for a specific locale — not just translation but genuine cultural
and contextual adaptation.

#### Signature

```clojure
(e/localize source-content
  :for           :locale-code
  :adapt         [:cultural-references :examples :units :date-formats
                  :formality-conventions :legal-references]
  :preserve      [:intent :factual-content :brand-voice]
  :glossary      {:term "locale-appropriate-term" ...}
  :output        :localised-document)
```

#### Design rationale

Translation is a subset of localisation. A document localised for a Dutch
audience does not merely translate English to Dutch — it adapts examples from
American contexts to Dutch contexts (replacing "zip code" with "postcode",
replacing US-centric examples with European ones), adjusts formality conventions
(Dutch professional communication is less formal than German but more formal
than American), references appropriate local regulations rather than US law,
and uses date and number formats that Dutch readers expect.

`e/localize` handles the full scope of this adaptation, not just lexical
translation.

---

## Part II: Integrated patterns

---

### Multi-audience document generation

The canonical pattern: one knowledge source, multiple audiences, each receiving
a document crafted for them.

```clojure
(def architecture-model (d/explore "architecture.pdf" :depth 4))

(parallel multi-audience-docs
  :operations [
    (e/compose "Technical Architecture" :from architecture-model :audience :senior-engineer)
    (e/compose "Platform Overview"       :from architecture-model :audience :executive)
    (e/compose "Security Evidence Pack"  :from architecture-model :audience :compliance-officer)]
  :combine-results :array)
```

### Analysis to communication pipeline

```clojure
(~> risk-assessment-data
  (s/texan      :models [:risk :ethics :stakeholder])
  (s/distill    :preserve [:argument-structure :key-claims] :for :executive)
  (e/compose "Risk Assessment Summary"
    :audience  :executive
    :purpose   :inform
    :structure :deliberative
    :emphasise [:key-risks :mitigation-options :recommendations]))
```

### Progressive formalisation

```clojure
;; Start informal, progressively formalise for different contexts
(def draft "We think we need to improve our data retention because GDPR
            requires it and we're not compliant right now")

(e/formalize draft :level :standard)    ;; Professional internal memo
(e/formalize draft :level :legal)       ;; Board resolution language
(e/formalize draft :level :regulatory)  ;; Submission to supervisory authority
```

---

## Best practices

### Specify audience before specifying content

Audience determines everything: what to include, what to omit, what vocabulary
to use, what register to adopt, how long to be. Before making any other decision
about a document, know who it is for.

### Use `:emphasise` and `:omit` deliberately

The `:from` parameter provides a knowledge source that may contain far more
than any single document should say. `:emphasise` and `:omit` are your
editorial tools. An executive summary should omit implementation detail.
A compliance evidence pack should omit business justification. Be explicit
about what each document needs and what it does not.

### Match format to purpose

- `:narrative` structure for documents that need to be understood in sequence
  (migration reports, change proposals, incident post-mortems)
- `:analytical` structure for documents where readers may jump to sections
  of interest (architecture documents, technical specifications)
- `:procedural` structure for instructional content where order matters
- `:deliberative` structure for decision documents where the reader needs
  to follow the reasoning

### Formalise before distributing legally

Any content that will form part of a contract, regulatory submission, or board
decision should pass through `e/formalize`. Informal language contains ambiguity
that is harmless in conversation and harmful in legal contexts.

### Localize thoughtfully, not mechanically

Localisation is not translation. Use `e/localize` for content that will be
read by audiences in different cultural contexts, not just different languages.
A document prepared for a Dutch municipal audience requires different examples,
different reference points, and different formality conventions than the same
document prepared for an American audience — even if both versions are in
English.

---

## Integration patterns

### Eloquence as the communication layer

`eloquence` typically operates as the final stage of a pipeline — taking
structured outputs from other grimoires and preparing them for human consumption.

```clojure
(~> requirements-document
  (d/explore    :depth 3)
  (s/texan      :models [:argumentation :stakeholder])
  (data/profile domain-data :statistics :all)
  (e/compose "Domain Analysis Report"
    :from    {:domain-model domain-model :semantic-analysis analysis :data-profile profile}
    :audience :product-manager
    :purpose  :inform
    :length   :standard))
```

### Witness reports as communication source

`core`'s `witness` construct produces interpretive records that `eloquence`
can transform into readable decision documentation.

```clojure
(def decisions (witness architecture-decisions :observe [:all] :record-to log))

(e/compose "Architecture Decision Record"
  :from      decisions
  :audience  :engineering-team
  :purpose   :report
  :structure :deliberative
  :format    :markdown)
```

---

## Grimoire metadata

```clojure
{:grimoire    "eloquence"
 :namespace   "e/"
 :version     "2.0.0"
 :description "Audience-aware document composition, register adaptation,
               narrative structure, plain language simplification, and
               formalisation for legal and regulatory contexts"

 :constructs {
   :core         [e/compose e/narrate e/adapt-register]
   :specialised  [e/instruct e/formalize e/simplify e/localize]}

 :best-for [
   "Multi-audience document generation from a single knowledge source"
   "Technical content adapted for executive, legal, and public audiences"
   "Plain language transformation of legal and technical documents"
   "GDPR and compliance communications for different audiences"
   "Instructional content: tutorials, how-tos, runbooks"
   "Formalisation of informal decisions for legal and regulatory contexts"
   "Locale-appropriate communication across Dutch, German, and English contexts"]

 :works-with [:core :domain :data :semantics :orchestrate]

 :key-concepts [
   {:term "Register"
    :definition "The variety of language appropriate to a particular social
                 situation. Formal register for legal documents; conversational
                 for user guides; technical for engineering documentation."}
   {:term "Adaptation"
    :definition "Transformation of content for a specific audience while
                 preserving the underlying information and intent"}
   {:term "Narrative pattern"
    :definition "A structural template for organising information that matches
                 the way human minds process and retain material. Problem-solution,
                 chronological, deliberative, and comparative are the most common."}
   {:term "Formalisation"
    :definition "The transformation of informal or ambiguous language into
                 precise, auditable prose suitable for legal or regulatory
                 contexts. Makes implicit agents explicit and quantifies vague claims."}
   {:term "Plain language"
    :definition "Writing that communicates clearly to its intended audience,
                 without unnecessary complexity. Not simplistic — appropriately
                 simple for the audience. Active voice, short sentences, concrete
                 examples."}
   {:term "Localisation"
    :definition "Adaptation of content for a specific locale: not just translation
                 but cultural adaptation of examples, references, conventions,
                 and formality norms."}]}
```

---

## Implementation notes for LLM processors

### Audience fidelity

The `:audience` parameter is not a suggestion. It is the governing constraint
for every language decision. When `:audience :executive` is specified, omit
implementation detail, use business-level vocabulary, avoid technical acronyms
(or explain them on first use), and structure for skimmability. When
`:audience :senior-engineer`, include failure modes, implementation choices,
and technical specificity.

Never produce prose that would be inappropriate for the specified audience.
A board presentation that includes container orchestration details is a
failure of audience fidelity.

### Register precision

The `:tone` parameter specifies register along a formality dimension. But
register is more than formality — it is the set of vocabulary choices, sentence
structures, and discourse patterns appropriate to a context:

- **Formal**: passive constructions for impersonality, nominal style, complex
  sentences, no contractions
- **Professional**: active voice preferred, moderate sentence complexity,
  third-person for institutional voice
- **Conversational**: second-person address, contractions acceptable, shorter
  sentences, direct questions
- **Plain**: short words preferred, active voice, specific examples over
  abstractions, defined-on-first-use for any technical terms

### Length calibration

- `:brief` — single page maximum; executive summaries, decision memos
- `:standard` — appropriate for the content; no padding, no artificial compression
- `:comprehensive` — full treatment; every important aspect addressed; suitable
  for reference documents and formal reports

Never pad to length. Never compress by omitting necessary information. Match
length to the content's genuine informational requirements for the specified
audience.

### Formalisation discipline

When applying `e/formalize` at `:level :legal` or `:level :regulatory`:
- Every agent must be a specific named entity or role (not "they" or "we")
- Every obligation must include "shall" (obligation) or "may" (permission)
- Every date reference must be absolute ("31 March 2026"), not relative
  ("by end of Q1")
- Every defined term must be capitalised after its definition
- Every factual claim must be sourced or marked as an assessment

### Localisation versus translation

`e/localize` is not a translation function. Translation is a prerequisite;
localisation is what happens after translation. When localising for `:nl`:
- Replace American cultural references with Dutch equivalents
- Use Dutch regulatory references (AVG, not GDPR, where both are technically
  correct but the Dutch term signals appropriate authority)
- Apply Dutch date format conventions (day-month-year)
- Observe Dutch professional communication norms (less hierarchical than
  German; more direct than British)
- Use Dutch plain language standards for citizen-facing documents (Rijksoverheid
  schrijfwijzer)