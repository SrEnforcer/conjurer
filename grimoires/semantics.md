# semantics.md — Conjurer Semantics Grimoire

The spellbook for meaning. Human communication embeds intent in layers that
resist naive extraction. A policy document is simultaneously a legal
instrument, a political position, an administrative procedure, and a power
relation. A contract is simultaneously a commercial agreement, a risk
allocation, a relationship definition, and a future constraint. The `semantics`
grimoire treats interpretation as what it actually is: a structured, perspectival,
dialectical activity — not a passive reading-off of what texts "contain."

---

## Philosophy

### The interpretive predicament

Every act of reading is an act of interpretation. There is no view from nowhere —
every analysis proceeds from a position, applies assumptions, and produces an
understanding that another position, with different assumptions, might challenge.
This is not a deficiency to be overcome; it is the nature of meaning.

The question for a semantic analysis framework is not "how do we produce
objective interpretations?" — that is impossible. The question is "how do we
produce *honest* interpretations?" — ones that make their assumptions visible,
trace their reasoning transparently, and acknowledge what alternative positions
could coherently claim.

The `semantics` grimoire is built on this epistemological honesty. Every
analytical claim maintains visible connections to evidence. Every interpretive
choice is made explicit rather than left as invisible background assumption.
Counter-perspectives are generated systematically — not as rhetorical gestures
toward balance, but as genuine alternative readings that illuminate what the
primary interpretation depends on.

### Meaning is perspectival without being arbitrary

Multiple valid interpretations can coexist. A labour economist and a management
consultant reading the same organisational policy will extract different primary
meanings — not because one is wrong, but because they bring different frameworks
that make different aspects salient. Both can be coherent. Both can be defended.
Both can be wrong about specific factual claims while being right about
structural patterns.

This is not relativism. Interpretations are not all equally good. Some are more
coherent, better evidenced, more attentive to the text, more aware of their
own assumptions, more honest about what they cannot determine. The semantics
grimoire provides the tools to distinguish better from worse interpretations
while acknowledging that "better" is itself a standard that different analytical
traditions define differently.

### Dialectical refinement as method

Understanding does not deepen through accumulation of confirmatory readings.
It deepens through encounter with alternatives that reveal what a primary reading
depends on, what it occludes, and where it is more fragile than it appears.
The `s/critique` and `s/viewpoint` constructs operationalise this dialectical
method. Generating a counter-perspective is not a politeness gesture — it is
the primary mechanism by which analytical understanding improves.

### Four design principles

**Perspectival pluralism with rigour** — Multiple interpretations can coexist;
each is assessed on its own coherence and evidentiary grounding.

**Semantic transparency through provenance** — Every claim traces to evidence,
applied model, and interpretive choice. Reasoning is visible, not concealed.

**Structured interpretation as method** — Codified analytical models (argumentation,
framing, rhetoric, ethics) provide systematic lenses that direct attention and
organise findings.

**Dialectical refinement** — Counter-perspectives are not negations but
principled alternatives that reveal what primary readings depend on.

---

## Naming rationale

**`s/`** — The namespace alias. Short for `semantics`.

**Texan** — "Text analysis" compressed into a distinctive term. Evokes both
"text" and "scan" to suggest systematic examination. Not generic enough to
be confused with other analytical constructs.

**Viewpoint** — A specific interpretive position, characterised by assumptions,
values, and theoretical commitments. Deliberately spatial: different positions
see different aspects.

**Distill** — Reduction to essential semantic content while preserving
argumentative structure. Like physical distillation: the volatile essentials
are captured; the inert is left behind.

**Chronicle** — Temporal semantic extraction: timeline, causality, periodisation.
From *chronos* (time) — the analysis of how a text's content unfolds through
time.

---

## Part I: Primary analysis

---

### `s/texan`

Comprehensive semantic extraction through systematic application of analytical
models. The primary entry point for structured textual interpretation.

#### Signature

```clojure
(s/texan source
  :from              :text | :url | :file | :document
  :models            [:argumentation :framing :rhetoric :ethics :sentiment
                      :style :logical :contextual :power :facts-assumptions
                      :temporal :stakeholder | :all | custom-model-vector]
  :depth             :shallow | :moderate | :comprehensive
  :locale            :nl | :en | :de | :fr | ...
  :perspective       :neutral | :critical | :sympathetic | viewpoint-object
  :generate-counter  boolean
  :trace-reasoning   boolean
  :surface           [:claims :evidence :tensions :gaps :presuppositions]
  :output            :edn | :json | :markdown-report)
```

#### Parameters

**`:models`** — Analytical lenses to apply. Each model generates distinct
semantic facets:
- `:argumentation` — claim structure, premise-conclusion relations, logical
  validity, burden of proof allocation, argument patterns (straw man, ad hominem,
  appeal to authority)
- `:framing` — what is foregrounded versus backgrounded; which actors are
  agents versus patients; which problems are named and which go unnamed;
  metaphor systems at work
- `:rhetoric` — persuasive strategies; ethos (credibility construction), pathos
  (emotional appeals), logos (rational argument); audience adaptation; register
- `:ethics` — explicit normative claims; implicit value commitments; stakeholders
  present and absent; distributive effects; whose interests are served
- `:sentiment` — emotional valence, intensity, and targets; shifts in affective
  register across the text
- `:style` — lexical register, syntactic complexity, hedging patterns, passive
  versus active voice, nominalisation, technical density
- `:logical` — deductive and inductive structure; assumption dependency;
  logical gaps; counterfactual implications
- `:contextual` — intertextual references, assumed background knowledge, genre
  conventions being honoured or violated
- `:power` — whose voice is authorised; whose knowledge counts; institutional
  positioning; silences and exclusions
- `:facts-assumptions` — distinguishing empirical claims from assumptions;
  what would have to be true for the argument to hold
- `:temporal` — temporal structure; causality claims; periodisation; projections
  and their epistemic status
- `:stakeholder` — who has interests in this text; how each stakeholder is
  positioned; whose interests are advanced or threatened

**`:surface`** — What to make explicit in the output beyond the model's
primary findings:
- `:claims` — every assertoric claim, separated from evidence
- `:evidence` — evidence offered for each claim
- `:tensions` — internal contradictions or unresolved conflicts
- `:gaps` — what the text does not address that the topic demands
- `:presuppositions` — what the text assumes without arguing for

#### Example: Policy document analysis

```clojure
(s/texan "https://government.nl/climate-policy-2025"
  :from             :url
  :models           [:argumentation :framing :stakeholder :ethics]
  :depth            :comprehensive
  :locale           :nl
  :perspective      :neutral
  :generate-counter true
  :trace-reasoning  true
  :surface          [:claims :gaps :presuppositions]
  :output           :edn)

;; Returns:
{:source {:url "..." :retrieved "2025-11-03"}

 :argumentation {
   :main-claim     "Carbon neutrality by 2035 is achievable and necessary"
   :premises [
     {:claim    "Current emission trajectory exceeds Paris Agreement commitments"
      :evidence "RIVM data 2024"
      :strength :high}
     {:claim    "Renewable transition creates net employment"
      :evidence "TNO projection, unverified by third party"
      :strength :medium}]
   :logical-gaps [
     "No mechanism specified for heavy industry transition"
     "Agricultural sector exemptions not justified"]
   :burden-of-proof :not-fully-discharged}

 :framing {
   :primary-frame   "Technical challenge with engineering solutions"
   :foregrounded    ["efficiency gains" "technology innovation" "economic opportunity"]
   :backgrounded    ["distribution of costs" "fossil fuel industry adjustment"]
   :agents          ["government" "technology sector" "renewable investors"]
   :patients        ["environment" "future generations"]
   :notable-absence "Low-income households bear higher energy cost burden — not addressed"}

 :stakeholder {
   :named   ["industry" "municipalities" "citizens"]
   :absent  ["agricultural sector" "fossil fuel workers" "energy-poor households"]
   :benefits {:industry "Transition subsidies and regulatory certainty"
              :municipalities "Renewable infrastructure investment"}
   :risks   {:unaddressed "Regressive impact of energy cost increases"}}

 :presuppositions [
   "Technological solutions will scale as projected"
   "Economic growth and emission reduction are compatible"
   "Public acceptance of transition costs is achievable"]

 :counter-perspective {
   :position "Policy is technically optimistic and socially incomplete"
   :argument "The employment projections cite unverified modelling; the
              agricultural sector receives exemptions without justification;
              and the cost burden on low-income households — documented in
              energy poverty literature — is entirely absent from the analysis."
   :grounding "Distributive justice framework; empirical scepticism of
               unverified projections"}}
```

---

### `s/viewpoint`

Produces an explicit interpretation of a text from a specific stakeholder
position, role, or analytical framework. Not a neutral reading but a
perspectival one — the interpretation a particular kind of reader would
actually produce.

#### Signature

```clojure
(s/viewpoint source
  :as         :role-keyword | viewpoint-definition
  :focus      [:interests :risks :opportunities :obligations :blind-spots]
  :compare-to [:other-viewpoint ...]
  :output     :edn | :markdown-report)
```

#### Parameters

**`:as`** — The interpretive position:
Built-in roles: `:regulator`, `:compliance-officer`, `:legal-counsel`,
`:affected-party`, `:journalist`, `:auditor`, `:risk-manager`, `:beneficiary`,
`:critic`, `:advocate`, `:engineer`, `:executive`, `:ethicist`

Custom viewpoint definition:
```clojure
{:role        "Dutch privacy regulator (AP)"
 :priorities  [:data-subject-rights :controller-obligations :enforcement]
 :framework   :gdpr-dutch-implementation
 :blind-spots "May underweight data-driven public interest arguments"}
```

#### Example

```clojure
(s/viewpoint gdpr-policy-document
  :as [:compliance-officer :legal-counsel :affected-party]
  :focus  [:risks :obligations :gaps]
  :compare-to :all)

;; Three perspectives, each seeing different things in the same document:
;; compliance-officer: focuses on audit trail requirements, documentation gaps
;; legal-counsel: focuses on liability exposure, ambiguous clauses
;; affected-party: focuses on rights claims, enforcement mechanisms, redress
;; 
;; compare-to :all: identifies where perspectives agree and where they diverge
```

---

### `s/critique`

Systematically identifies weaknesses, gaps, unverified assumptions, and
logical vulnerabilities in an analysis or document.

#### Signature

```clojure
(s/critique target
  :dimensions [:logical-consistency :evidential-support :scope-completeness
               :assumption-validity :internal-contradictions :missing-stakeholders]
  :severity   :all | :significant-only
  :constructive boolean
  :output     :critique-report)
```

#### Parameters

**`:constructive`** — When true, each identified weakness is accompanied by
a specific suggestion for how it could be addressed, strengthened, or better
justified. The critique becomes a revision guide rather than an evaluation.

#### Example

```clojure
(s/critique risk-assessment-report
  :dimensions [:evidential-support :scope-completeness :assumption-validity]
  :severity   :significant-only
  :constructive true)

;; Returns:
{:target "risk-assessment-report"
 :overall-verdict "Methodologically incomplete; risks are understated"
 :findings [
   {:dimension   :evidential-support
    :finding     "Section 3.2 claims 'low probability' for supply chain disruption
                  but cites no data source for the probability estimate"
    :severity    :significant
    :suggestion  "Either cite a methodology (historical frequency analysis,
                  expert elicitation) or qualify as 'assessed as low' rather
                  than asserting low probability"}

   {:dimension   :scope-completeness
    :finding     "Cyber risk assessment covers only external threats; insider
                  threat (the primary vector in financial services breaches
                  per DBIR 2024) is absent"
    :severity    :significant
    :suggestion  "Add insider threat section covering: privileged access misuse,
                  unintentional exposure, social engineering of employees"}

   {:dimension   :assumption-validity
    :finding     "Business continuity plan assumes 4-hour recovery window;
                  the cited IT infrastructure has SLA of 8-hour RTO"
    :severity    :significant
    :suggestion  "Either renegotiate IT SLA or revise BCP recovery window
                  to be consistent"}]}
```

---

### `s/synthesise`

Integrates multiple perspectives or analyses into a coherent unified understanding,
preserving genuine tensions while resolving spurious conflicts.

#### Signature

```clojure
(s/synthesise analyses
  :identify    [:convergences :divergences :productive-tensions :spurious-conflicts]
  :resolve     :productive-tensions | :spurious-conflicts | :both | :none
  :preserve    [:genuine-disagreements]
  :frame-as    :balanced-assessment | :strongest-case | :research-summary
  :output      :synthesis-report)
```

#### Design rationale

The distinction between genuine disagreement and spurious conflict is central
to synthesis. A genuine disagreement exists when two analyses produce
incompatible claims that cannot both be true — they reflect different values,
different frameworks, or different factual judgments. A spurious conflict exists
when two analyses appear to disagree but are actually addressing different
aspects of the same question.

Genuine disagreements should be preserved — synthesis that collapses them into
artificial consensus misrepresents the actual state of knowledge. Spurious
conflicts should be resolved — they are clarifications, not real tensions.

---

## Part II: Targeted extraction

---

### `s/distill`

Compresses a text to its essential semantic content while preserving its
argumentative structure. Different from summarisation: `s/distill` preserves
the logical skeleton of the argument, not just the main points.

#### Signature

```clojure
(s/distill source
  :preserve   [:argument-structure :key-claims :evidence-links :qualifications]
  :target-length :fraction | :word-count
  :for        :audience-keyword
  :output     :distilled-text | :structured-outline)
```

#### Design rationale

Summarisation asks "what are the main points?" Distillation asks "what is the
argumentative structure?" A distilled text can be expanded back into the
original's logic without loss. A summary cannot. For legal, policy, and
technical documents where argument structure is the content, distillation is
the appropriate operation.

#### Example

```clojure
(s/distill "procurement-policy-v4.pdf"
  :preserve    [:argument-structure :key-claims :qualifications]
  :target-length (/ 1 5)    ;; Reduce to 20% of original length
  :for         :executive
  :output      :structured-outline)

;; Returns structured outline preserving logical skeleton:
;; Main claim: New procurement thresholds reduce administrative burden while maintaining control
;; ├── Sub-claim: Thresholds below €50K permit direct award
;; │   └── Qualification: Unless framework agreement is available
;; ├── Sub-claim: €50K–€250K require three-quote procedure
;; │   └── Evidence: Comparable to prior policy; no change in risk exposure
;; └── Sub-claim: Above €250K require formal tender
;;     └── Qualification: Emergency exceptions require Director approval
```

---

### `s/compare`

Produces a structured semantic comparison of two or more texts — identifying
where they agree, where they diverge, what each says that the others do not,
and what contradictions exist between them.

#### Signature

```clojure
(s/compare texts
  :dimensions  [:claims :positions :evidence :framing :gaps]
  :focus       "natural-language description of what the comparison is for"
  :output      :comparison-matrix | :comparison-report)
```

#### Example

```clojure
(s/compare [eu-ai-act-text dutch-ai-bill-text]
  :dimensions  [:claims :positions :gaps]
  :focus       "Where does the Dutch implementation diverge from the EU Act,
                and where does it impose additional obligations?")

;; Returns:
{:texts ["eu-ai-act" "dutch-ai-bill"]
 :convergences [
   "Both require conformity assessments for high-risk AI systems"
   "Both establish national supervisory authority requirements"]
 :divergences [
   {:topic    "Prohibited AI practices"
    :eu-act   "Explicitly prohibits social scoring by public authorities"
    :nl-bill  "Includes social scoring prohibition; adds emotional recognition
               in professional settings as prohibited"}
   {:topic    "SME exemptions"
    :eu-act   "Lighter-touch requirements for providers < 10 employees"
    :nl-bill  "No SME exemption — full requirements apply to all providers"}]
 :unique-to-nl ["Mandatory human review for algorithmic benefit decisions"
                "Six-month reporting cycle for high-risk system registrations"]
 :unique-to-eu ["Regulatory sandbox provisions not replicated in NL bill"]}
```

---

### `s/chronicle`

Extracts the temporal structure of a text — timeline of events, causal chains,
periodisation, and the epistemic status of past, present, and future claims.

#### Signature

```clojure
(s/chronicle source
  :extract     [:timeline :causality :periodisation :projections]
  :distinguish [:stated :inferred :projected :speculative]
  :output      :chronological-model | :timeline-report)
```

#### Design rationale

Historical documents, policy narratives, and strategic plans are temporally
structured — they make claims about how things came to be, how they currently
stand, and how they will develop. `s/chronicle` makes this temporal structure
explicit: what happened when, what caused what, what is projected with what
confidence, and what epistemic status each temporal claim carries.

#### Example

```clojure
(s/chronicle "digital-transformation-strategy.pdf"
  :extract     [:timeline :causality :projections]
  :distinguish [:stated :inferred :projected :speculative])

;; Returns:
{:past [
   {:period "2018-2021"
    :events ["Legacy system implementation" "Initial digitalisation failures"]
    :causality "Budget shortfalls caused delayed migration; vendor lock-in resulted from 2019 decision"
    :epistemic-status :stated}]
 :present [
   {:state "Hybrid infrastructure with legacy and modern systems operating in parallel"
    :epistemic-status :stated}]
 :projections [
   {:horizon "2026"
    :claim   "Full cloud migration completed"
    :basis   "Current migration velocity extrapolated linearly"
    :epistemic-status :projected
    :confidence-note "Linear extrapolation assumes no further procurement delays — contested by CIO in Q3 update"}
   {:horizon "2028"
    :claim   "€12M annual savings realised"
    :basis   "McKinsey analysis cited in appendix B"
    :epistemic-status :speculative
    :confidence-note "Savings projections in comparable migrations have achieved 40-60% of forecast"}]}
```

---

## Part III: Advanced composition

---

### `s/counter-manifest`

Constructs a principled alternative interpretation of a text, grounded in a
different analytical framework, value system, or set of factual assumptions.
Not a refutation but a coherent alternative reading that a reasonable analyst
with different commitments could defend.

#### Signature

```clojure
(s/counter-manifest primary-analysis
  :from-position   viewpoint-definition
  :grounds         [:different-values :different-framework :different-facts]
  :must-acknowledge [:what-primary-analysis-gets-right]
  :output          :counter-analysis)
```

#### Design rationale

Counter-manifest is stronger than critique. Critique identifies weaknesses.
Counter-manifest constructs an alternative — a complete, self-consistent
reading that someone with different commitments would defend. This is the
most productive form of intellectual challenge: not "you are wrong" but "here
is how someone else, with different but defensible commitments, would read
this."

#### Example

```clojure
(s/counter-manifest primary-policy-analysis
  :from-position   {:role     "Fiscal conservative economist"
                    :values   [:fiscal-discipline :market-efficiency :private-sector-primacy]
                    :framework :public-choice-theory}
  :grounds         [:different-values :different-framework]
  :must-acknowledge [:empirical-findings-primary-cites])

;; Returns a complete alternative reading:
;; Acknowledges: the emission reduction target is empirically grounded
;; Challenges: the instrument choice (regulation vs. carbon pricing)
;; Alternative claim: Carbon pricing would achieve targets at lower economic cost
;;   while avoiding the regulatory capture risk inherent in sector-specific exemptions
;; Grounding: Public choice theory predicts lobbying for exemptions;
;;            economic theory favours price signals over command-and-control
```

---

### `s/semantic-profile`

Generates a "semantic fingerprint" of a text — characterising its argumentative
complexity, conceptual density, rhetorical sophistication, and stylistic
signatures. Enables comparison across documents and detection of anomalies.

#### Signature

```clojure
(s/semantic-profile source
  :dimensions  [:argumentative-complexity :conceptual-density :rhetorical-sophistication
                :hedging-patterns :claim-density :evidence-quality]
  :compare-to  [baseline-text ...]
  :output      :profile-report)
```

#### Example

```clojure
(s/semantic-profile "contract-final.pdf"
  :dimensions  [:argumentative-complexity :hedging-patterns :claim-density]
  :compare-to  [standard-nda-template])

;; Returns:
{:profile {
   :argumentative-complexity :low
   :note "Predominantly definitional and procedural; few inferential steps"
   :hedging-patterns {
     :frequency :high
     :style     "Predominantly epistemic hedging ('may', 'where applicable', 'subject to')"
     :note      "High hedging is appropriate for contracts; signals well-drafted uncertainty management"}
   :claim-density :moderate}
 :vs-template {
   :divergences [
     "Section 7.3 removes standard limitation-of-liability cap — significant deviation"
     "IP assignment clause is broader than template default — requires counsel review"
     "Governing law changed from NL to UK — post-Brexit implications"]}}
```

---

## Best practices

### Choose models that serve the purpose

Applying all analytical models to every text is expensive and produces
information the practitioner may not need. A compliance analysis needs
`:ethics`, `:facts-assumptions`, and `:contextual`. A rhetorical analysis
of a speech needs `:rhetoric`, `:framing`, and `:sentiment`. Choose models
that serve the analytical purpose. Use `:all` only for comprehensive research
where multiple facets genuinely matter.

### Counter-perspectives are primary deliverables

A `s/texan` result without a counter-perspective is a preliminary finding.
Always use `:generate-counter true` for consequential analyses. The counter-
perspective reveals what the primary reading depends on — and what it gets
right by showing what a good-faith alternative must acknowledge.

### Preserve the inferred-stated distinction

Never present an inference as a statement. When a text implies something
without stating it, the analysis must mark that implication as inferred. In
legal and policy contexts, the difference between "the regulation states" and
"the regulation implies" is the difference between a binding obligation and a
contested interpretation.

### Profile before deep analysis

For long documents, use `s/semantic-profile` first to characterise the text
before committing to comprehensive analysis. A document that profiles as
low-complexity with high hedging and low claim-density may not warrant
comprehensive `s/texan` treatment — a shallow or moderate analysis may suffice.

---

## Integration patterns

### Semantics as the interpretation layer

The semantics grimoire typically operates on outputs from the domain grimoire
or on raw documents that feed into domain models.

```clojure
;; Analyse a regulation to extract domain knowledge
(~> "gdpr-art-5.pdf"
  (s/texan      :models [:argumentation :ethics :facts-assumptions]
                :generate-counter true)
  (s/distill    :preserve [:argument-structure :key-claims])
  (d/model "GDPR Article 5"
    :from-analysis true))
```

### Perspective as quality mechanism

```clojure
;; Multi-perspective review of a contract before signing
(parallel contract-review
  :operations [
    (as :legal-counsel      (s/viewpoint contract :as :legal-counsel
                              :focus [:risks :obligations]))
    (as :compliance-officer (s/viewpoint contract :as :compliance-officer
                              :focus [:regulatory-gaps]))
    (as :commercial-lead    (s/viewpoint contract :as :executive
                              :focus [:opportunities :constraints]))]
  :combine-results :synthesise)
```

---

## Grimoire metadata

```clojure
{:grimoire    "semantics"
 :namespace   "s/"
 :version     "2.0.0"
 :description "Structured semantic extraction, perspectival analysis,
               dialectical reasoning, and textual interpretation"

 :constructs {
   :primary-analysis   [s/texan s/viewpoint s/critique s/synthesise]
   :targeted-extraction [s/distill s/compare s/chronicle]
   :advanced           [s/counter-manifest s/semantic-profile]}

 :best-for [
   "Policy and regulatory document analysis with competing stakeholder interests"
   "Legal document interpretation with multiple analytical lenses"
   "Multi-perspective synthesis with preserved tensions"
   "Argumentative structure extraction and logical gap identification"
   "Comparative analysis of multiple documents on a shared topic"
   "Temporal structure extraction from strategic and historical documents"
   "Counter-perspective generation for contested interpretations"]

 :works-with [:core :domain :eloquence]

 :key-concepts [
   {:term "Perspectival analysis"
    :definition "Interpretation from a specific analytical position, making its
                 assumptions explicit and acknowledging what other positions
                 would legitimately see differently"}
   {:term "Provenance chain"
    :definition "The traceable path from claim to evidence to model to
                 interpretive choice. Every analytical claim has one."}
   {:term "Counter-perspective"
    :definition "A principled alternative interpretation grounded in different
                 but defensible commitments. Not a refutation — a coherent
                 alternative reading."}
   {:term "Distillation"
    :definition "Reduction to argumentative skeleton while preserving logical
                 structure. Different from summarisation, which captures main
                 points but not argument form."}
   {:term "Semantic profile"
    :definition "Statistical and structural characterisation of a text's
                 argumentative complexity, rhetorical features, and stylistic
                 signatures — a semantic fingerprint."}
   {:term "Chronicle"
    :definition "The temporal structure of a text: timeline, causal claims,
                 projections, and the epistemic status of past, present,
                 and future assertions."}]}
```

---

## Implementation notes for LLM processors

### Model application discipline

Apply only the specified `:models`. Do not add additional models because they
seem relevant. The practitioner's model selection is an analytical choice;
adding unrequested models changes the analysis's scope.

When `:models :all` is specified, apply every available model and organise
findings by model. Flag where models produce convergent or divergent findings
on the same textual element.

### The stated/inferred boundary

This is the most important disciplinary boundary in semantic analysis. A
textual element marked `:stated` must have a direct quote or clear paraphrase
from the source. A textual element marked `:inferred` must have explicit
reasoning showing why the text implies it. Never mark something `:stated`
without sourcing it. Never mark something `:inferred` without showing the
inference chain.

### Counter-perspective quality

A counter-perspective is not adequate if it:
- Simply negates the primary analysis ("the primary analysis is wrong")
- Introduces factual claims not supportable from the text or cited sources
- Does not acknowledge what the primary analysis correctly identifies
- Is grounded in a position no reasonable analyst would hold

A good counter-perspective is one that a rigorous analyst with different but
defensible commitments could defend to a peer review.

### Presupposition identification

Presuppositions are what a text assumes without arguing for. Common signals:
- Definite descriptions that presuppose existence ("The economic benefits...")
- Factive verbs that presuppose truth of their complements ("...has succeeded in...")
- Conventional implicatures ("even the critics acknowledge...")
- Generic statements that presuppose type generalisation ("Citizens want...")

Mark presuppositions with `:presupposed true` and note whether they are
contested, uncontested, or empirically verifiable.

### Depth calibration

At `:depth :shallow`: primary claim, main evidence, key framing device. No
counter-perspective. One to two sentences per dimension.

At `:depth :moderate`: full argumentative structure, main framing choices,
key stakeholders, major gaps, counter-perspective at moderate detail.

At `:depth :comprehensive`: every claim sourced, every presupposition named,
every inference made explicit, full counter-perspective with grounding, gap
analysis across all specified dimensions, tensions within the primary analysis
identified.