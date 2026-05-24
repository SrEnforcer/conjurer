# domain.md — Conjurer Domain Grimoire

The spellbook for knowledge. Every field of human endeavour — healthcare,
law, finance, logistics, software architecture — possesses structure that
practitioners understand intuitively but rarely articulate systematically.
The `domain` grimoire surfaces this implicit structure, transforming
documentation, regulation, and practitioner knowledge into explicit,
composable, and operationalisable domain models.

---

## Philosophy

### The tacit knowledge problem

There is a gap between what domain experts *know* and what they have *written
down*. An experienced clinician knows that a particular drug interaction
matters only when the patient is over 65 and renally impaired — but this may
not appear explicitly in any single document. A tax lawyer knows that a
certain clause triggers a provision that most practitioners miss. A senior
engineer knows that a particular field in the legacy system is always null in
practice, despite being mandatory in the schema.

This tacit knowledge — accumulated through years of practice, pattern
recognition, and hard-won experience — is precisely what domain models must
capture. It is also what makes domain modelling hard. Sources document the
explicit; the valuable often lives in the gap.

`domain` grimoire functions therefore do two things: they extract what sources
*say*, and they infer what the domain *implies*. Both are made visible. Both
are attributed. The gap between stated fact and inferred structure is preserved
as an epistemic distinction, not collapsed.

### Discovery, not invention

Domains have inherent structure whether we model them or not. Insurance has
premiums, risk pools, and actuarial tables whether any software models them.
Contract law has offer, acceptance, consideration, and capacity whether any
system represents them. The domain grimoire's first principle is that we
*discover* this structure — we do not invent it.

This is a meaningful design constraint. It means domain models should be
justified by evidence from sources, not by the practitioner's preferences.
It means conflicts between sources should be preserved, not silently resolved
by preference. It means the model's provenance — where each concept came from,
how confident we are, what we could not find — is first-class information,
not metadata to be discarded.

The opposite of discovery is *imposition*: forcing a domain into a framework
that suits the technology rather than the domain. Imposing an anemic ORM
schema onto a rich legal domain produces a model that is internally consistent
but semantically false. The domain grimoire resists this.

### The model as epistemological instrument

A domain model is not just a technical artefact — it is an epistemological
instrument. The act of building it forces clarity about what is known, what
is assumed, and what is unknown. Entities that cannot be defined precisely are
often entities that are not understood. Relationships that cannot be stated
often reflect genuine ambiguity in the domain. Constraints that turn out to
be contested often reveal genuine disagreements between stakeholders.

This means that the process of building a domain model has value independent
of the model produced. The questions that arise — "Is this a separate entity
or an attribute of that one?" "Does this rule apply in that jurisdiction?"
"Who is responsible for this operation?" — are exactly the questions that
should be asked before writing a line of code.

### Progressive depth

No domain is fully understood in a single pass. Exploration begins with
breadth — a map of the territory, enough to navigate. Refinement adds depth
where it matters. This is how human understanding develops, and the grimoire
honours it: initial models are sketches; refined models are working documents;
annotated models are institutional knowledge.

---

## Naming rationale

**Domain** — In domain-driven design, the domain is the subject area to which
the application applies: the sphere of knowledge, activity, and rules that
the software models. The term carries this precise technical heritage into
Conjurer.

**`d/`** — The short namespace alias. Deliberate terseness: domain exploration
invocations appear frequently in complex programs, and brevity compounds.

---

## Part I: Discovery

The foundation of domain work is discovery — analysing sources to extract
entities, relationships, operations, constraints, and the implicit structure
that connects them.

---

### `d/explore`

Analyses sources — documents, URLs, text, or previously built models — to
extract a comprehensive domain model. The primary entry point for domain
discovery.

#### Signature

```clojure
(d/explore source
  :from          :text | :url | :file | :model | :multiple
  :depth         n
  :breadth       :narrow | :moderate | :broad | :exhaustive
  :focus         [:taxonomy :entities :operations :constraints
                  :nomenclature :legal-definitions :relationships
                  :actors :lifecycle :invariants]
  :sources       [:authoritative :legal :academic :practitioner]
  :language      :en | :nl | :de | :fr | ...
  :infer         [:missing-concepts :implicit-rules :unstated-assumptions]
  :confidence-threshold 0.0-1.0
  :compare-to    existing-model
  :output        :edn | :markdown | :graph)
```

#### Parameters

**`source`** — What to analyse. A URL, a file path, a text string, a
previously produced domain model, or a vector of any of these for
multi-source exploration.

**`:from`** — Source type hint: `:text` (inline string), `:url` (web page),
`:file` (local document), `:model` (existing domain model to re-analyse),
`:multiple` (heterogeneous vector of sources).

**`:depth`** — Maximum nesting levels in taxonomies and hierarchies (1–5;
default 3). Deeper is richer; shallower is faster. Mark truncated branches
with `:more-available true` at the depth boundary.

**`:breadth`** — Concepts extracted per level: `:narrow` (top 3–5),
`:moderate` (10–15, default), `:broad` (20–30), `:exhaustive` (all
discoverable). Breadth determines coverage; depth determines detail.

**`:focus`** — Which domain aspects to prioritise. Multiple values produce
comprehensive analysis; single values produce targeted extraction:
- `:taxonomy` — hierarchical classification of concepts
- `:entities` — objects with identity and lifecycle
- `:operations` — actions, processes, state transitions
- `:constraints` — rules, obligations, prohibitions, preconditions
- `:nomenclature` — terminology, definitions, synonyms
- `:legal-definitions` — statutory definitions with citations
- `:relationships` — entity-to-entity connections with cardinality
- `:actors` — agents who perform operations or bear obligations
- `:lifecycle` — state machines for entities with meaningful state
- `:invariants` — conditions that must always hold across the domain

**`:sources`** — Source preference weighting:
- `:authoritative` — official bodies, government, standards organisations
- `:legal` — statutes, regulations, case law
- `:academic` — peer-reviewed research, established textbooks
- `:practitioner` — professional guides, handbooks, practitioner commentary

**`:language`** — Primary language for analysis and output. Technical terms
with no conventional translation (API, schema, GDPR) are preserved in their
original form.

**`:infer`** — What to infer beyond what sources explicitly state:
- `:missing-concepts` — concepts implied but not defined
- `:implicit-rules` — constraints that the domain assumes but does not state
- `:unstated-assumptions` — background knowledge the domain takes for granted

Inferred elements are marked `:inferred true` and attributed with the
reasoning that produced them. They are never silently promoted to stated fact.

**`:confidence-threshold`** — Minimum confidence score (0.0–1.0) for a
concept to appear in the output. Lower thresholds yield more complete but
less reliable models; higher thresholds yield sparser but more confident
ones. Default 0.6.

**`:compare-to`** — An existing model to diff against immediately after
exploration. Produces an annotated model with `:new`, `:changed`, and
`:absent` markers relative to the reference. Useful for tracking how a
domain evolves across document versions.

**`:output`** — Output format: `:edn` (default, structured data), `:markdown`
(human-readable documentation), `:graph` (entity-relationship representation).

#### Design rationale

Domain exploration requires balancing breadth and depth. Too shallow misses
important nuances; too deep overwhelms with detail that obscures structure.
The `:depth` and `:breadth` parameters give the practitioner explicit control
over this trade-off.

The `:focus` parameter reflects a real insight: different explorations serve
different purposes. Legal compliance work prioritises `:legal-definitions` and
`:constraints`. API design prioritises `:entities` and `:operations`.
Terminology alignment prioritises `:nomenclature`. Architecture planning
prioritises `:relationships` and `:lifecycle`. Forcing every exploration to
produce every aspect wastes effort and obscures relevant findings.

The `:infer` parameter addresses the tacit knowledge problem directly. Sources
document the explicit; inference surfaces the implicit. Marking inferred
elements distinctly — never collapsing them into stated facts — preserves the
epistemological distinction that matters for high-stakes domains where the
difference between "the regulation says" and "this implies" is legally
significant.

#### Example 1: Dutch healthcare insurance domain

```clojure
(d/explore "https://www.rijksoverheid.nl/onderwerpen/zorgverzekering"
  :from    :url
  :depth   3
  :focus   [:taxonomy :legal-definitions :entities :constraints]
  :sources [:authoritative :legal]
  :language :nl
  :infer   [:implicit-rules]
  :output  :edn)

;; Returns:
{:domain       "Nederlandse Zorgverzekering"
 :description  "Verplicht zorgstelsel geregeld door de Zorgverzekeringswet"
 :source       "rijksoverheid.nl/onderwerpen/zorgverzekering"

 :taxonomy {
   :root "Zorgverzekering"
   :levels {
     1 [{:concept     "Basisverzekering"
         :definition  "Verplichte verzekering voor alle ingezetenen van Nederland"
         :legal-ref   "Zorgverzekeringswet art. 2"
         :confidence  :high}
        {:concept     "Aanvullende verzekering"
         :definition  "Vrijwillige verzekering voor zorg buiten het basispakket"
         :confidence  :high}]
     2 [{:concept     "Eigen risico"
         :parent      "Basisverzekering"
         :definition  "Verplicht jaarlijks bedrag dat verzekerde zelf betaalt"
         :legal-ref   "Zvw art. 19"
         :amount-2024 385
         :confidence  :high}
        {:concept     "Zorgpremie"
         :parent      "Basisverzekering"
         :definition  "Maandelijks bedrag aan de verzekeraar"
         :legal-ref   "Zvw art. 16"
         :confidence  :high}]
     3 [{:concept          "Zorgtoeslag"
         :parent           "Zorgpremie"
         :definition       "Inkomensafhankelijke tegemoetkoming in premiekosten"
         :legal-ref        "Wet op de zorgtoeslag"
         :administered-by  "Belastingdienst"
         :confidence       :high}]}}

 :entities {
   "verzekerde"      {:type :actor
                      :attributes [:bsn :woonadres :inkomenscategorie]
                      :roles [:premiebetaler :zorggebruiker]
                      :lifecycle [:onverzekerd :verzekerd :geschorst]}
   "zorgverzekeraar" {:type :actor
                      :attributes [:vergunning-dnb :solvabiliteitsbuffer]
                      :roles [:premie-innen :zorg-vergoeden :contracteren]
                      :legal-obligations ["Acceptatieplicht art. 3 Zvw"]}
   "zorgverlener"    {:type :actor
                      :roles [:zorg-verlenen :declareren]
                      :subtypes ["huisarts" "specialist" "apotheek" "ziekenhuis"]}}

 :relationships [
   {:from "verzekerde"    :to "zorgverzekeraar" :type :contracteert-met
    :cardinality :many-to-one :constraint "Maximaal één basisverzekeraar"}
   {:from "verzekerde"    :to "zorgverlener"    :type :ontvangt-zorg-van}
   {:from "zorgverlener"  :to "zorgverzekeraar" :type :declareert-bij
    :note "Alleen bij gecontracteerde zorgverleners directe declaratie"}]

 :constraints [
   {:type :legal :strength :obligation
    :description "Verzekeraar moet elke aanvrager van basisverzekering accepteren"
    :source "Zorgverzekeringswet art. 3"
    :applies-to ["zorgverzekeraar"]}
   {:type :legal :strength :obligation
    :description "Iedere ingezetene is verplicht een basisverzekering af te sluiten"
    :source "Zvw art. 2"
    :applies-to ["verzekerde"]}
   {:type     :inferred
    :inferred true
    :description "Wisselen van verzekeraar is alleen mogelijk per 1 januari,
                  aanmelden vóór 1 februari"
    :reasoning  "Volgt uit combinatie art. 4 (contractduur) en art. 8 (opzegrecht)"
    :confidence :medium}]

 :nomenclature {
   "premie"       {:definition  "Maandelijks bedrag voor zorgverzekering"
                   :legal-ref   "Zvw art. 16"
                   :synonyms    ["zorgpremie" "verzekeringspremie"]}
   "eigen risico" {:definition  "Verplicht jaarlijks eigen aandeel in zorgkosten"
                   :legal-ref   "Zvw art. 19"
                   :related     ["eigen bijdrage" "no-claim"]
                   :note        "Eigen bijdrage is iets anders — per prestatie"}}}

 :metadata {
   :analysed-at          "2025-11-02T18:30:00Z"
   :source-language      :nl
   :concepts-extracted   34
   :confidence           :high
   :completeness         0.85
   :inferred-elements    3
   :sources-consulted    ["rijksoverheid.nl" "Zvw" "zorginstituut.nl"]}}
```

#### Example 2: Multi-source regulatory exploration

```clojure
(d/explore ["https://gdpr-info.eu/art-1-gdpr/"
            "https://autoriteitpersoonsgegevens.nl/"
            "national-implementation-notes.pdf"]
  :from    :multiple
  :depth   4
  :focus   [:legal-definitions :constraints :actors :operations]
  :sources [:legal :authoritative]
  :language :nl
  :infer   [:implicit-rules :unstated-assumptions]
  :output  :edn)

;; Returns unified model spanning all three sources:
;; - Data subject rights extracted from EU text and Dutch implementation
;; - Conflicts between EU art. 8 age of consent and Dutch implementation (age 16)
;;   preserved and attributed to both sources
;; - Implicit rule inferred: DPIA required for systematic processing of
;;   special categories, even when not explicitly triggered by any single
;;   criterion — marked :inferred true with reasoning
```

#### Example 3: Technical domain with inference

```clojure
(d/explore "OAuth 2.0 RFC 6749 and RFC 6750"
  :from    :text
  :depth   2
  :breadth :narrow
  :focus   [:entities :operations :relationships :constraints]
  :infer   [:implicit-rules]
  :output  :edn)

;; Returns:
{:domain "OAuth 2.0"
 :entities {
   "Resource Owner" {:type :actor  :role "End user who authorises access"}
   "Client"         {:type :actor  :role "Application requesting access on behalf of owner"}
   "Authorisation Server" {:type :service :role "Issues access tokens after authentication"}
   "Resource Server"      {:type :service :role "Hosts protected resources; validates tokens"}}

 :operations {
   "Authorisation Code Flow" {
     :actors  ["Resource Owner" "Client" "Authorisation Server"]
     :steps   [:redirect-to-as :user-authenticates :code-issued :code-exchanged :token-issued]
     :use-when "Client can securely store client secret (server-side apps)"}
   "Token Refresh" {
     :actors [:Client :Authorisation-Server]
     :inputs [:refresh-token]
     :outputs [:new-access-token :new-refresh-token]}}

 :constraints [
   {:type :security :strength :obligation
    :description "Access tokens must be short-lived"
    :source "RFC 6749 §1.5"}
   {:type     :inferred :inferred true
    :description "Implicit flow is deprecated — clients must not use it for new implementations"
    :reasoning  "RFC 9700 (OAuth 2.0 Security BCP) prohibits implicit flow;
                 not stated in original RFC 6749 but now industry consensus"
    :confidence :high}]}
```

#### Usage patterns

```clojure
;; Single authoritative source
(d/explore "https://official-standard.org/specification"
  :from    :url
  :depth   3
  :sources [:authoritative])

;; Focused extraction — only what's needed
(d/explore requirements-doc
  :focus  [:entities :constraints]   ;; skip taxonomy, nomenclature
  :depth  2)

;; Compare a domain against a reference model to surface what has changed
(d/explore "updated-regulations-2025.pdf"
  :compare-to existing-domain-model
  :output :edn)
;; → Returns model with :new, :changed, :absent markers

;; High-confidence only — sparse but reliable
(d/explore noisy-source
  :confidence-threshold 0.8
  :breadth :narrow)
```

---

### `d/extract`

Targeted extraction of specific facts, relationships, or structural elements
from a source or an existing model. Where `d/explore` produces a comprehensive
domain map, `d/extract` retrieves a precise answer to a specific question.

#### Signature

```clojure
(d/extract source-or-model
  :what     :entities | :relationships | :constraints | :operations
            | :terminology | :actors | :lifecycle | :invariants
  :matching criteria
  :depth    n
  :as       :list | :map | :graph
  :output   :edn)
```

#### Parameters

**`:what`** — What category of domain fact to extract. Unlike `d/explore`,
which extracts everything, `d/extract` retrieves one specific facet.

**`:matching`** — A filter: a pattern, predicate, or natural-language
description of which items within the category to retrieve.

**`:depth`** — How deep to follow references when extracting. Depth 1 returns
the item; depth 2 includes its immediate relationships; depth 3 includes the
relationships of those relationships.

**`:as`** — Output shape: `:list` (ordered collection), `:map` (keyed by
concept name), `:graph` (nodes and edges).

#### Design rationale

`d/explore` is an expedition — comprehensive, time-consuming, producing a map
of the territory. `d/extract` is a query — targeted, fast, producing a
specific answer. The two are complementary: explore to understand, extract to
retrieve.

The distinction matters in practice. A practitioner building an API endpoint
for a specific entity doesn't need the entire domain model — they need that
entity's attributes, relationships, and applicable constraints. `d/extract`
retrieves precisely that, without the overhead of a full exploration.

#### Example 1: Entity extraction with depth

```clojure
(d/extract healthcare-domain
  :what     :entities
  :matching {:type :actor}
  :depth    2
  :as       :map)

;; Returns: all actor-type entities with their immediate relationships
;; {
;;   "verzekerde" {
;;     :attributes [:bsn :woonadres]
;;     :related-entities ["zorgverzekeraar" "zorgverlener"]
;;     :operations-as-actor ["aanmelden" "opzeggen" "declareren"]}
;;   "zorgverzekeraar" { ... }
;;   "zorgverlener"    { ... }}
```

#### Example 2: Constraint extraction by type

```clojure
(d/extract gdpr-domain
  :what     :constraints
  :matching {:strength :obligation :applies-to "controller"}
  :as       :list)

;; Returns: ordered list of all obligations on data controllers
;; [{:description "Maintain records of processing activities"
;;   :source "GDPR Art. 30"  :applies-to "controller"}
;;  {:description "Designate DPO where required"
;;   :source "GDPR Art. 37"  :applies-to "controller"} ...]
```

#### Example 3: Lifecycle extraction

```clojure
(d/extract order-domain
  :what     :lifecycle
  :matching {:entity "order"}
  :as       :graph)

;; Returns state machine as graph:
;; {:states [:draft :submitted :confirmed :shipped :delivered :cancelled :refunded]
;;  :transitions [
;;    {:from :draft     :to :submitted  :trigger "customer confirms"}
;;    {:from :submitted :to :confirmed  :trigger "payment clears"}
;;    {:from :submitted :to :cancelled  :trigger "payment fails" :compensate :release-inventory}
;;    {:from :confirmed :to :shipped    :trigger "warehouse dispatches"}
;;    {:from :shipped   :to :delivered  :trigger "delivery confirmed"}
;;    {:from :delivered :to :refunded   :trigger "return accepted" :within "14 days"}]
;;  :terminal-states [:delivered :cancelled :refunded]}
```

---

### `d/refine`

Deepens or extends an existing domain model by focusing on specific concepts,
incorporating additional sources, or expanding specific aspects with more
detail.

#### Signature

```clojure
(d/refine existing-model
  :focus-on  "concept-name" | [:concept-1 :concept-2]
  :expand    [:deeper-taxonomy :more-examples :related-concepts
              :legal-framework :edge-cases :historical-context]
  :depth     +n
  :enrich-from [additional-source ...]
  :infer     [:missing-concepts :implicit-rules]
  :output    :enhanced-edn)
```

#### Parameters

**`:focus-on`** — Specific concept or concepts to deepen. All other parts of
the model are preserved unchanged.

**`:expand`** — What aspects to add to the focused concept:
- `:deeper-taxonomy` — additional hierarchy levels beneath the concept
- `:more-examples` — concrete usage examples and edge cases
- `:related-concepts` — concepts adjacent to but not directly under this one
- `:legal-framework` — statutory basis, enforcement history, interpretation
- `:edge-cases` — boundary conditions and exception handling
- `:historical-context` — how the concept evolved, prior definitions

**`:depth`** — Additional levels to add beyond the model's current depth for
the focused concept. Use `+n` notation: `:depth +2` adds two levels.

**`:enrich-from`** — Additional sources to incorporate for the focused area.

#### Design rationale

Initial explorations favour breadth; refinement provides targeted depth. Rather
than requiring complete specifications upfront, `d/refine` supports iterative
discovery: explore broadly to understand the terrain, identify areas requiring
more detail, refine precisely there.

This mirrors how domain experts actually work. A lawyer reading a contract
does not attempt to understand every clause at maximum depth simultaneously.
They scan for structure, identify clauses requiring close attention, then read
those closely. `d/refine` formalises this expert reading strategy.

#### Example

```clojure
(def zorgverzekering (d/explore "rijksoverheid.nl/zorgverzekering"
  :depth 2 :breadth :moderate))

(d/refine zorgverzekering
  :focus-on "eigen-risico"
  :expand   [:legal-framework :edge-cases :historical-context]
  :depth    +3
  :enrich-from ["https://www.rijksoverheid.nl/onderwerpen/eigen-risico"
                "zvw-toelichting-artikel-19.pdf"])

;; Original model: unchanged
;; eigen-risico branch: expanded to depth 5, with:
;; - Legal basis: Zvw art. 19 with full legislative history
;; - Current amounts per year (indexed series)
;; - Exceptions: huisartsenzorg, kraamzorg, jeugdzorg t/m 18
;; - Edge cases: chronisch-zorgforfait, compensatie chronisch zieken
;; - Historical: introduction 2008, various reforms, 2012 no-claim abolition
```

---

## Part II: Synthesis

When understanding must emerge from multiple sources, or when a model must be
understood from a particular vantage point, synthesis constructs combine,
compare, and scope domain knowledge.

---

### `d/merge`

Combines multiple domain models into a unified view, aligning equivalent
concepts and making conflicts between sources explicit.

#### Signature

```clojure
(d/merge [model-1 model-2 ...]
  :strategy         :union | :intersection | :prefer-first | :synthesise
  :align-concepts   true | false
  :perspective-map  {:model-1 :regulatory :model-2 :practitioner ...}
  :conflict-resolution :prefer-authoritative | :prefer-recent | :preserve-all
  :output           :unified-edn)
```

#### Parameters

**`:strategy`** — How to combine content:
- `:union` — include all information from all sources; mark conflicts
- `:intersection` — include only content agreed upon by all sources
- `:prefer-first` — first-listed model wins all conflicts
- `:synthesise` — attempt intelligent reconciliation; explain reasoning

**`:align-concepts`** — When true, detect semantically equivalent concepts
with different names across sources and merge them under a canonical term.
The alignment is always made visible: the canonical term is explicit, and
all source terms are preserved as alternatives.

**`:perspective-map`** — Labels what each source *represents*, not just what
it *is*. A model from a regulatory body represents `:regulatory` interpretation;
a model from a trade association represents `:industry` interpretation; one
from a practitioner handbook represents `:operational` interpretation.
Labelled perspectives enable the merged model to carry perspective context
alongside content.

**`:conflict-resolution`** — When `:synthesise` cannot determine consensus:
`:prefer-authoritative` (government > academic > industry),
`:prefer-recent` (later publication wins),
`:preserve-all` (include all positions with attribution).

#### Design rationale

Domains rarely have single authoritative sources. Legal domains span multiple
jurisdictions. Healthcare has clinical guidelines, research findings, and
regulatory requirements. Technical domains evolve through standards bodies,
vendor implementations, and community practices. A model built from one source
is incomplete; a model that hides the provenance of its claims is unreliable.

The `:perspective-map` is an important addition to the original design. When
merging a regulatory interpretation with a practitioner handbook with an
academic analysis, the merged model should carry that provenance. Not just
*what* each source said, but *from where it was speaking*. This is the
difference between a model that can be used for compliance work (requires
regulatory provenance) and one that can only inform general understanding.

#### Example: Merging GDPR perspectives

```clojure
(def eu-gdpr   (d/explore "https://gdpr-info.eu" :sources [:legal]))
(def nl-ap     (d/explore "https://autoriteitpersoonsgegevens.nl" :sources [:authoritative]))
(def dpa-guide (d/explore "dpa-practitioner-guide-2024.pdf" :sources [:practitioner]))

(d/merge [eu-gdpr nl-ap dpa-guide]
  :strategy        :synthesise
  :align-concepts  true
  :perspective-map {:eu-gdpr   :eu-regulatory
                    :nl-ap     :nl-supervisory-authority
                    :dpa-guide :practitioner-operational}
  :conflict-resolution :prefer-authoritative)

;; Returns:
{:domain "GDPR / AVG"
 :perspectives {:eu-regulatory          "EU-tekst, bindend voor alle lidstaten"
                :nl-supervisory-authority "Nederlandse uitleg door AP, gezaghebbend"
                :practitioner-operational "Operationele richtlijnen voor praktijkgebruik"}

 :aligned-concepts [
   {:sources-terms  ["data subject" "betrokkene" "data-subject"]
    :canonical      "data-subject"
    :aligned-from   [:eu-regulatory :nl-supervisory-authority :practitioner-operational]}
   {:sources-terms  ["controller" "verwerkingsverantwoordelijke"]
    :canonical      "controller"}]

 :conflicts [
   {:concept  "consent-age-minimum"
    :positions [
      {:perspective :eu-regulatory          :value "13–16, member state discretion"
       :source "GDPR Art. 8"}
      {:perspective :nl-supervisory-authority :value 16
       :source "AVG implementatiewet"}]
    :resolution  "Netherlands has set 16; compliant with EU upper bound"
    :actionable  "Use 16 for all NL-based implementations"}]

 :confidence   :high
 :completeness 0.91}
```

---

### `d/compare`

Produces a structured comparison of two domain models — identifying
conceptual alignments, divergences, gaps, and structural differences.
Different from `d/merge`, which produces a unified model; `d/compare` produces
an analysis of the *relationship* between two models.

#### Signature

```clojure
(d/compare model-a model-b
  :dimensions   [:entities :operations :constraints :terminology :structure]
  :highlight    :alignments | :divergences | :gaps | :all
  :perspective  "natural-language framing of why this comparison matters"
  :output       :comparison-report | :diff-edn)
```

#### Design rationale

Comparison without merge is a common need that the original spec did not
address. A compliance team needs to know: does our internal data model align
with GDPR requirements? A migration team needs to know: what concepts exist
in the legacy model that are absent from the target? A standards body needs
to know: how does this implementation of the standard diverge from the
reference?

`d/compare` answers these questions by producing an explicit relational
analysis — which concepts are equivalent, which are present in one model but
absent in the other, which share names but mean different things, and which
structural patterns differ between the models.

#### Example: Checking internal model against regulation

```clojure
(d/compare internal-data-model gdpr-domain
  :dimensions  [:entities :constraints :operations]
  :highlight   :gaps
  :perspective "Does our internal model satisfy GDPR's structural requirements?")

;; Returns:
{:comparison "internal-data-model vs gdpr-domain"
 :perspective "GDPR compliance gap analysis"

 :alignments [
   {:concept       "data-subject"
    :in-model-a    "User" :in-model-b "data-subject"
    :verdict       :semantically-equivalent
    :note          "Same concept, different name — align terminology"}]

 :gaps-in-model-a [
   {:missing-concept  "processing-record"
    :required-by      "GDPR Art. 30"
    :severity         :critical
    :description      "No record of processing activities found in internal model"}
   {:missing-concept  "data-retention-policy"
    :required-by      "GDPR Art. 5(1)(e) storage limitation"
    :severity         :high
    :description      "Retention durations not modelled for any entity type"}]

 :divergences [
   {:concept      "consent"
    :in-model-a   "Boolean flag on User record"
    :in-model-b   "Structured record with purpose, timestamp, and withdrawal path"
    :severity     :high
    :description  "Internal consent representation is insufficient for Art. 7 compliance"}]

 :verdict     :non-compliant
 :critical-gaps 1
 :high-gaps     2
 :recommendations [
   "Add processing-record entity with mandatory fields per Art. 30"
   "Model consent as first-class entity, not attribute"
   "Add retention-policy to each entity with stored personal data"]}
```

---

### `d/scope`

Derives a focused sub-domain view from a larger domain model. Useful when a
comprehensive model exists but only a specific facet is needed for a given
task — the scope narrows the lens without losing the parent context.

#### Signature

```clojure
(d/scope domain-model
  :to        "sub-domain name or concept cluster"
  :include   [:related-entities :applicable-constraints :relevant-operations]
  :depth     n
  :retain-provenance true
  :output    :scoped-edn)
```

#### Design rationale

A comprehensive domain model of healthcare may contain hundreds of entities.
A practitioner building a prescription management system needs a scope: the
prescription sub-domain, its entities, its constraints, and its actors —
but not the billing sub-domain or the ward management sub-domain.

`d/scope` derives this focused view without losing the parent context. The
scoped model retains provenance (it knows where it came from and what it is a
view of), enabling the practitioner to expand scope when needed without
starting over.

#### Example

```clojure
(d/scope comprehensive-healthcare-domain
  :to      "prescription-management"
  :include [:related-entities :applicable-constraints :relevant-operations]
  :depth   3
  :retain-provenance true)

;; Returns a scoped model containing:
;; Entities: Patient (scoped attributes), Prescriber, Medication, Prescription
;; Operations: prescribe, dispense, refill, cancel, check-interactions
;; Constraints: prescription-validity-period, max-refills, controlled-substance-rules
;; Actors: physician, pharmacist, patient
;; 
;; Provenance: {:parent-model comprehensive-healthcare-domain
;;              :scope "prescription-management"
;;              :excluded-sub-domains ["billing" "ward-management" "diagnostics"]}
```

---

## Part III: Explicit modeling

When no suitable source exists, when sources are insufficient, or when
practitioner knowledge must be codified directly, explicit modeling constructs
allow the practitioner to author domain knowledge rather than extract it.

---

### `d/model`

Manually defines a domain model — entities, relationships, operations,
constraints, and lifecycle states — from the practitioner's own understanding.

#### Signature

```clojure
(d/model domain-name
  :entities      {:entity-name {:attributes  [:attr ...]
                                :lifecycle   [:state ...]
                                :type        :aggregate-root | :entity | :value-object | :actor}} 
  :relationships [{:from :entity-a :to :entity-b
                   :type :relationship-type
                   :cardinality :one-to-one | :one-to-many | :many-to-many
                   :cascade :delete | :preserve | :nullify}
                  ...]
  :operations    {:op-name {:actors       [:actor ...]
                            :inputs       [:input ...]
                            :outputs      [:output ...]
                            :preconditions ["condition"]
                            :postconditions ["condition"]
                            :invariants   ["must hold throughout"]}}
  :constraints   [{:type    :business | :technical | :legal | :security
                   :strength :obligation | :permission | :prohibition | :recommendation
                   :rule    "natural-language rule"
                   :source  "origin of rule"
                   :applies-to [:entity ...]}
                  ...]
  :invariants    ["always-true condition" ...]
  :output        :edn)
```

#### Parameters

**`:entities`** — Map of entity names to their structure. The `:type`
classification encodes the entity's role in the domain:
- `:aggregate-root` — entry point for transactional consistency (DDD aggregate)
- `:entity` — has identity and lifecycle but subordinate to an aggregate root
- `:value-object` — defined by attributes alone; no independent identity
- `:actor` — an agent that performs operations or bears obligations

**`:lifecycle`** — Explicit state machine for entities with meaningful state.
States are listed in natural order; transitions are inferred from operations
unless explicitly provided.

**`:operations`** — Domain operations (verbs) with their actors, inputs,
outputs, and the conditions that must hold before (preconditions) and after
(postconditions) them.

**`:invariants`** — Conditions that must hold across the domain at all times
(not just before or after specific operations). These are the domain's
architectural laws: "a product's inventory count is never negative", "a
cancelled order cannot transition to shipped".

#### Example: E-commerce domain

```clojure
(d/model "E-Commerce Platform"
  :entities {
    :customer {:type       :aggregate-root
               :attributes [:id :email :name :address :payment-methods]
               :lifecycle  [:prospective :registered :verified :suspended :churned]}

    :order    {:type       :aggregate-root
               :attributes [:id :customer-id :items :total :status :placed-at]
               :lifecycle  [:draft :submitted :confirmed :processing
                            :shipped :delivered :cancelled :refunded]}

    :product  {:type       :entity
               :attributes [:id :sku :name :price :inventory-count :category]
               :note       "inventory-count is managed by warehouse system — read-only here"}

    :payment  {:type       :entity
               :attributes [:id :order-id :amount :currency :method :status :authorised-at]}

    :address  {:type       :value-object
               :attributes [:street :city :postcode :country-iso]
               :note       "Equality by attribute value, not identity"}}

  :relationships [
    {:from :customer :to :order   :type :places
     :cardinality :one-to-many    :cascade :preserve}
    {:from :order    :to :product :type :contains
     :cardinality :many-to-many   :via :order-line}
    {:from :order    :to :payment :type :settled-by
     :cardinality :one-to-one     :cascade :preserve}]

  :operations {
    :place-order {
      :actors         [:customer]
      :inputs         [:cart-contents :shipping-address :payment-method]
      :outputs        [:order-confirmation :order-id]
      :preconditions  ["All items have inventory-count ≥ quantity requested"
                       "Payment method is valid and not expired"
                       "Customer account is :verified"]
      :postconditions ["inventory-count decremented for each item"
                       "Order status is :submitted"
                       "Payment status is :authorised"]}

    :process-return {
      :actors         [:customer :support-agent]
      :inputs         [:order-id :return-reason :items-to-return]
      :outputs        [:return-label :refund-confirmation]
      :preconditions  ["Order status is :delivered"
                       "Return requested within 14 days of delivery"
                       "Items not excluded from return policy"]
      :postconditions ["Refund initiated within 5 business days"
                       "Order status is :refunded"]}}

  :constraints [
    {:type :business :strength :obligation
     :rule "Orders over €50 qualify for free shipping to NL addresses"
     :applies-to [:order]}
    {:type :technical :strength :obligation
     :rule "Inventory decrement must be atomic to prevent overselling"
     :applies-to [:order :product]}
    {:type :legal :strength :obligation
     :rule "EU customers have 14-day right of withdrawal from distance purchases"
     :source "EU Consumer Rights Directive 2011/83/EU"
     :applies-to [:order]}]

  :invariants [
    "A product's inventory-count is never negative"
    "A payment's amount always equals the associated order's total"
    "An order in :cancelled status cannot transition to any non-terminal state"
    "A :churned customer's personal data must not be retained beyond legal minimum"])
```

---

### `d/annotate`

Adds practitioner knowledge — corrections, context, caveats, and tacit
expertise — to an existing domain model without altering the model's
extracted facts.

#### Signature

```clojure
(d/annotate model
  :annotations [
    {:target  "concept-or-path"
     :kind    :correction | :context | :caveat | :tacit-knowledge | :open-question
     :note    "annotation text"
     :author  "practitioner identifier"
     :confidence :high | :medium | :low}
    ...]
  :output :annotated-edn)
```

#### Design rationale

An extracted model is a document's interpretation. A practitioner's model
is an expert's interpretation. Both are valuable; neither is complete alone.
`d/annotate` provides a layer for the practitioner to add what the documents
do not say — the edge case that always trips people up in practice, the
regulatory interpretation that differs from the literal text, the business
rule that was agreed verbally but never written down.

Annotations are separate from extracted facts. They do not mutate the
underlying model; they add an authoritative practitioner layer above it.
This preserves the distinction between what the source says and what the
expert knows.

#### Example

```clojure
(d/annotate zorgverzekering-model
  :annotations [
    {:target     "eigen-risico.exceptions"
     :kind       :tacit-knowledge
     :note       "In practice, ambulance transport (112) is also eigen-risico-vrij
                  but this is often missed in documentation. Confirmed by Zvw art. 13."
     :author     "domain-expert-mjansen"
     :confidence :high}

    {:target     "zorgverzekeraar.acceptatieplicht"
     :kind       :caveat
     :note       "Acceptatieplicht applies to basisverzekering only.
                  Aanvullende verzekering may be refused — common gotcha."
     :author     "domain-expert-mjansen"
     :confidence :high}

    {:target     "zorgverlener.declareren"
     :kind       :open-question
     :note       "Unclear whether e-health platforms without BIG-registration
                  can declareren directly. Needs legal confirmation."
     :author     "domain-expert-mjansen"
     :confidence :low}])
```

---

### `d/validate`

Checks a domain model for internal consistency, structural completeness, and
adherence to known patterns.

#### Signature

```clojure
(d/validate model
  :checks  [:completeness :consistency :naming :relationship-integrity
            :constraint-coverage :lifecycle-reachability]
  :against :ddd | :rest-conventions | :openapi | :custom-standard
  :strict  false
  :output  :validation-report)
```

#### Parameters

**`:checks`** — What to validate:
- `:completeness` — all referenced concepts are defined
- `:consistency` — no contradictions within the model
- `:naming` — terminology is consistent throughout (no mixed synonyms)
- `:relationship-integrity` — all relationship endpoints reference defined entities
- `:constraint-coverage` — all entities have at least one applicable constraint
- `:lifecycle-reachability` — all lifecycle states are reachable from the initial state

**`:against`** — Validate against a known pattern or standard:
- `:ddd` — Domain-Driven Design (aggregate roots, value objects, bounded contexts)
- `:rest-conventions` — REST API design principles (resource naming, operation mapping)
- `:openapi` — OpenAPI 3.1 specification compatibility

#### Example

```clojure
(d/validate ecommerce-model
  :checks  [:completeness :consistency :naming :lifecycle-reachability]
  :against :ddd
  :strict  false)

;; Returns:
{:valid    true
 :score    0.84
 :errors   []
 :warnings [
   {:check       :completeness
    :description ":order-line is referenced in the order→product relationship
                  but is not defined as an entity"}
   {:check       :lifecycle-reachability
    :description "State :processing in order lifecycle has no incoming transition
                  from :confirmed — unreachable"}]
 :suggestions [
   "Define :order-line as an entity with :quantity and :unit-price attributes"
   "Add :confirm-payment operation transitioning order from :confirmed to :processing"
   "Consider designating :customer as an explicit aggregate root with bounded context"]
 :ddd-assessment {
   :aggregate-roots-identified [:customer :order]
   :missing-bounded-context-definitions true
   :value-objects-correctly-typed true}}
```

---

## Part IV: Operationalisation

Domain knowledge has value when it can be acted upon. These constructs transform
domain models into operational artefacts: domain-specific languages, exportable
documentation, and queryable knowledge bases.

---

### `d/generate-dsl`

Creates a domain-specific language from an explored domain, enabling
practitioners to express solutions in domain vocabulary rather than generic
programming vocabulary.

#### Signature

```clojure
(d/generate-dsl domain-model
  :style     :declarative | :imperative | :mixed
  :includes  [:entities :operations :queries :constraints]
  :namespace "domain.namespace"
  :target    :clojure | :conjurer-extension | :natural-language
  :output    :dsl-definition)
```

#### Parameters

**`:target`** — What kind of DSL to generate:
- `:clojure` — Clojure functions namespaced under `:namespace`
- `:conjurer-extension` — New Conjurer grimoire constructs that extend the
  language itself with domain-specific invocations
- `:natural-language` — A structured vocabulary guide for consistent
  communication across the team

#### Design rationale

The end goal of domain modelling is not the model — it is the language. When a
team can express their work in the domain's own vocabulary (`prescribe-medication`,
`place-order`, `declare-bankruptcy`), the conceptual gap between business
understanding and technical implementation narrows. Bugs that arise from
mistranslation between business and technical vocabulary become rarer. Reviews
between domain experts and engineers become possible.

The `:conjurer-extension` target is particularly powerful: it generates a new
Conjurer grimoire from the domain model, extending Conjurer itself with
domain-specific invocations. The modelled domain becomes executable Conjurer.

#### Example 1: Healthcare DSL

```clojure
(def healthcare-dsl
  (d/generate-dsl clinical-domain
    :style     :declarative
    :includes  [:entities :operations :constraints]
    :namespace "healthcare.nl"
    :target    :clojure))

;; Generated DSL enables domain-fluent code:
(require '[healthcare.nl :as h])

(h/prescribe-medication
  :prescriber  physician-007
  :patient     patient-12345
  :medication  "Metformine 500mg"
  :dosage      {:frequency :twice-daily :duration :90-days}
  :indication  "DM type 2 — HbA1c onvoldoende gereguleerd")

(h/check-interactions
  :patient    patient-12345
  :new-medication "Metformine 500mg"
  :current-medications current-prescription-list)
```

#### Example 2: Conjurer extension from domain

```clojure
(d/generate-dsl insurance-domain
  :style     :declarative
  :includes  [:operations :constraints]
  :namespace "insurance"
  :target    :conjurer-extension)

;; Generates a new grimoire that extends Conjurer:
;; (i/accept-claim claim-data :assess [:coverage :liability :fraud-signals])
;; (i/calculate-premium profile :factors [:age :risk-class :history])
;; (i/validate-policy policy :against [:zvw-requirements :internal-rules])
```

---

### `d/export`

Exports a domain model to an external format for documentation, collaboration,
or tooling integration.

#### Signature

```clojure
(d/export domain-model
  :to       :markdown | :html | :mermaid | :plantuml | :owl-rdf | :json-ld
  :include  [:diagrams :definitions :constraints :metadata :annotations]
  :audience :technical | :business | :regulatory
  :output   "filename.ext")
```

#### Parameters

**`:audience`** — Shapes the language and level of technical detail in the
exported document. `:technical` uses precise technical vocabulary; `:business`
uses domain vocabulary without implementation concerns; `:regulatory` uses
legal and compliance framing.

#### Example

```clojure
(d/export gdpr-compliance-model
  :to       :markdown
  :include  [:definitions :constraints :annotations]
  :audience :regulatory
  :output   "gdpr-compliance-model.md")

;; Generates structured documentation:
;; - Executive summary of data processing activities
;; - Data subject rights catalogue with legal citations
;; - Obligations per actor with source references
;; - Annotated known issues and open questions
;; - Suitable for submission to Data Protection Authority
```

---

### `d/query`

Searches a domain model for specific concepts, patterns, or relationships,
returning targeted results.

#### Signature

```clojure
(d/query domain-model
  :find   "natural-language question or pattern"
  :return :concepts | :relationships | :constraints | :operations | :all
  :limit  n
  :output :edn | :list)
```

#### Example

```clojure
(d/query healthcare-domain
  :find   "all obligations that apply when handling patient data"
  :return :constraints
  :output :list)

;; Returns: ordered list of all constraints matching the query,
;; with source attribution and confidence scores.

(d/query ecommerce-domain
  :find   "entities that can be in more than one state simultaneously"
  :return :concepts
  :output :list)
```

---

## Best practices

### Authoritative sources first; practitioner sources to supplement

Build domain models on official, citable foundations. Legal texts, standards
bodies, and authoritative reference works give models their epistemic backbone.
Practitioner guides and community documentation add operational nuance. The
provenance hierarchy matters: when sources conflict, authoritative sources win —
but conflicts should be named, not silently resolved.

### Mark the boundary between extracted and inferred

The `:inferred true` marker is not decoration. In high-stakes domains —
regulation, medicine, finance — the difference between "the law says" and "this
implies" is legally and operationally significant. Never promote an inferred
element to a stated fact. Keep the distinction explicit and permanent.

### Preserve conflicts; never silently resolve them

When two sources contradict each other, the correct response is to preserve
both positions with attribution and note the contradiction. Silent resolution
— choosing one source's position without visibility — creates models that look
authoritative but conceal genuine disagreements that domain experts need to
adjudicate.

### Use `:lifecycle` for entities with meaningful state

An entity that can be in different states (`order: draft → submitted →
confirmed → shipped → delivered`) has a state machine. Make it explicit.
Explicit lifecycle models enable reachability checks, prevent invalid
transitions, and make the domain's dynamics visible.

### Annotate before you forget

Tacit knowledge has a half-life. The expert who knows why a particular
exception exists will eventually leave. The meeting where a business rule was
verbally agreed will be forgotten. `d/annotate` is the mechanism for
capturing this before it disappears — not as code, not as documentation
nobody reads, but as first-class domain knowledge attached to the model it
explains.

### Scope before generating

When using a domain model to generate artefacts — APIs, UI components, test
suites — scope the model first to the relevant sub-domain. Passing a
comprehensive 200-entity domain model to `w/prototype` produces output
calibrated to the wrong level of abstraction. Scoping to the 8 entities
actually needed produces something immediately useful.

---

## Integration patterns

### Domain as the common semantic substrate

A domain model produced by `d/explore` serves as the shared semantic
foundation from which multiple artefacts are generated. This is the key
integration pattern: one exploration, many transmutations.

```clojure
;; Explore once — generate many
(def crm-domain
  (d/explore "crm-requirements.pdf"
    :depth 4 :focus [:entities :operations :constraints]))

(~> crm-domain
  (d/scope :to "customer-management" :include :all)
  (w/prototype "Customer Portal"
    :from-domain true :features [:crud :search :export])
  (weave customer-platform
    :strands [customer-portal auth-service notification-service]
    :ensuring [:gdpr-compliance :audit-trail]))

(transmute crm-domain
  :into :rest-api :preserving [:entities :operations :constraints])

(transmute crm-domain
  :into :test-suite :preserving [:business-rules :invariants])
```

### Domain context enriching core context

Domain models feed directly into `context establish`. An explored domain is
not just a data structure — it is semantic knowledge that should propagate
into the session's interpretive frame.

```clojure
(def healthcare (d/explore "healthcare-requirements.pdf" :depth 3))

(context establish clinical
  :domain      :healthcare
  :entities    (d/extract healthcare :what :entities :as :map)
  :constraints (d/extract healthcare :what :constraints :as :list))

;; All subsequent invocations now understand the healthcare domain's
;; entities and constraints without being told explicitly.
(conjure appointment-scheduler)  ;; knows Patient, Provider, Encounter entities
(conjure billing-module)         ;; knows the constraint structure automatically
```

### Domain-driven code generation via threading

```clojure
(~> requirements-document
  (d/explore    :depth 4 :focus [:entities :operations :constraints])
  (d/validate   :checks [:completeness :consistency] :against :ddd)
  (d/annotate   :annotations practitioner-knowledge-base)
  (d/scope      :to "core-domain" :include :all)
  (transmute    :into :rest-api :preserving [:entities :operations])
  (w/prototype  "Management Interface" :from-domain true))
```

---

## Grimoire metadata

```clojure
{:grimoire    "domain"
 :namespace   "d/"
 :version     "2.0.0"
 :description "Domain knowledge discovery, modelling, synthesis,
               and operationalisation"

 :constructs {
   :discovery    [d/explore d/extract d/refine]
   :synthesis    [d/merge d/compare d/scope]
   :modeling     [d/model d/annotate d/validate]
   :operations   [d/generate-dsl d/export d/query]}

 :best-for [
   "Domain-driven design and knowledge extraction"
   "Regulatory compliance modelling and gap analysis"
   "Multi-source knowledge synthesis with conflict preservation"
   "DSL generation from domain models"
   "Living documentation that evolves with understanding"
   "Comparative analysis between model versions or perspectives"
   "Scoping large domain models for targeted artifact generation"]

 :works-with [:core :data :web :semantics :orchestrate]

 :key-concepts [
   {:term "Domain"
    :definition "A sphere of knowledge with inherent structure, rules, and vocabulary
                 that exists independently of any software model of it"}
   {:term "Entity"
    :definition "A domain object with identity and lifecycle — it persists over time
                 and can be individually distinguished (customer, order, patient)"}
   {:term "Value object"
    :definition "Defined by its attributes alone; has no independent identity.
                 Two addresses with the same fields are the same address."}
   {:term "Aggregate root"
    :definition "The entity through which a cluster of related entities is accessed;
                 the transactional consistency boundary in DDD"}
   {:term "Actor"
    :definition "An agent — human, system, or organisation — that performs
                 operations or bears obligations within the domain"}
   {:term "Operation"
    :definition "An action or process that changes domain state. Has actors,
                 inputs, outputs, preconditions, and postconditions."}
   {:term "Constraint"
    :definition "A rule governing the domain: obligation, prohibition, permission,
                 or recommendation. Carries strength and provenance."}
   {:term "Invariant"
    :definition "A condition that must hold at all times across the domain —
                 not just before or after operations, but always"}
   {:term "Lifecycle"
    :definition "The state machine of an entity: the states it can be in
                 and the transitions between them"}
   {:term "Inferred element"
    :definition "A concept, rule, or relationship that the domain implies
                 but no source explicitly states. Always marked :inferred true."}
   {:term "Provenance"
    :definition "The origin of a domain element: which source stated it,
                 under what authority, with what confidence"}]}
```

---

## Implementation notes for LLM processors

### Semantic extraction from natural language

Domain structure is encoded in language patterns. Recognise:

- **Hierarchies**: "types of X include…", "X is a kind of…", "X consists of…"
- **Definitions**: "X is defined as…", "X means…", "for the purposes of this…"
- **Relationships**: "X belongs to Y", "each X has one Y", "X produces Y"
- **Actors**: "X is responsible for…", "Y must…", "the [role] shall…"
- **Constraints**: `must`, `shall`, `required`, `prohibited`, `only if`, `unless`
- **Lifecycle signals**: "X can be active, suspended, or terminated"
- **Implicit rules**: consequence clauses, "therefore", "which means that"

```clojure
;; From: "A prescribing physician must verify the patient has no known allergies
;;        before issuing a controlled substance prescription."
;; Extract:
{:operation "issue-controlled-substance-prescription"
 :actors    ["prescribing-physician"]
 :preconditions ["patient.known-allergies verified by prescriber"]
 :constraint {:type :legal :strength :obligation
              :source "text" :applies-to ["prescribing-physician"]}}
```

### Depth management

Respect `:depth` strictly. At the depth boundary, mark the item with
`:more-available true` rather than truncating silently. Never recurse into
a concept at depth n+1 when the limit is n.

```clojure
;; At depth limit, mark rather than truncate:
{:concept "Carnivores" :parent "Mammals" :more-available true}
;; Not: {:concept "Carnivores" :children [{...}]}  ;; violates depth limit
```

### Source prioritisation

When `:sources [:authoritative :legal]` is specified, apply this priority
order: government/official bodies → legal statutes and case law → standards
organisations (ISO, W3C, RFC) → peer-reviewed academic → industry bodies →
practitioner guides → community documentation.

Mark each extracted element with its source type so the consumer can assess
epistemic weight.

### The inferred/stated distinction

This is the most important processing discipline in the domain grimoire.
*Never* promote an inferred element to stated fact. The markers `:inferred true`
and `:source` are not optional metadata — they are the epistemological
structure of the model. An extracted element without `:source` is incomplete.
An inferred element without `:inferred true` is a misrepresentation.

When `:infer [:implicit-rules]` is specified:
- Identify consequence chains: if A and B are stated, and A+B → C is a
  logical necessity, infer C and mark it inferred
- Identify gaps: concepts that are referenced but not defined; mark them as
  `:missing-concept true` rather than inventing definitions

### Conflict handling in `d/merge`

When sources disagree:
- Never silently resolve. Always produce a `:conflicts` key.
- Apply `:conflict-resolution` strategy to determine which position takes
  precedence, but always preserve all positions with attribution.
- With `:strategy :synthesise`, attempt reconciliation only when sources are
  addressing different aspects of the same concept. When they genuinely
  contradict each other, mark the conflict explicitly.

### Lifecycle reachability

When `:lifecycle` is defined or extracted, verify:
1. There is exactly one initial state (or mark if ambiguous)
2. Every non-initial state is reachable from the initial state through some
   chain of transitions
3. Terminal states are identified (states with no outgoing transitions)
4. Report unreachable states as warnings in `d/validate`

### Concept alignment in `d/merge`

When `:align-concepts true`, detect synonymy by:
- Exact string equivalence across languages (known translation pairs)
- Semantic similarity (same definition, different term)
- Structural equivalence (same attributes, same relationships, different name)

Never merge concepts on name similarity alone. "Customer" and "Customer
account" may be distinct entities. Alignment requires semantic justification.
The canonical term is the most authoritative or most precise — annotate the
reasoning for the choice.

### Confidence scoring

Every extracted element should carry a confidence estimate:
- `:high` — explicit statement in a primary authoritative source
- `:medium` — stated in a secondary source, or inferred from clear implication
- `:low` — inferred from indirect evidence, or stated in a low-authority source

The model's overall `:confidence` is the weighted mean of its elements.
`:completeness` is an estimate of how much of the domain has been captured,
expressed as a fraction 0.0–1.0.

### Metadata richness

Every domain model must include:

```clojure
{:metadata {
   :analysed-at          "ISO-8601 timestamp"
   :sources-consulted    ["source-1" "source-2"]
   :concepts-extracted   n
   :inferred-elements    n
   :confidence           :high | :medium | :low
   :completeness         0.0-1.0
   :depth-achieved       n
   :language             :nl
   :conflicts-found      n
   :conflicts-resolved   n}}
```

Omitting metadata is not acceptable. An unattributed domain model is not a
domain model — it is an assertion without evidence.