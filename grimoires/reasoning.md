# reasoning.md — Conjurer Reasoning Grimoire

The spellbook for inference. Every other grimoire operates on *what is* —
existing documents, existing data, existing code, existing workflows. The
`reasoning` grimoire operates on *what follows*: given these facts and these
rules, what must be true? Given this observation, what could explain it? Given
these claims, which are inconsistent? Given these constraints, what is possible?

Reasoning is the cognitive operation that connects knowledge to conclusion.
Without it, a system can know everything and infer nothing.

---

## Philosophy

### The gap between knowing and concluding

The existing grimoires give Conjurer remarkable epistemic reach. `domain`
extracts what a domain *is*. `semantics` analyses what a text *means*.
`data` validates what data *satisfies*. But none of these grimoires can
answer the next question: *given all of this, what follows?*

Consider: a domain model encodes that GDPR requires data minimisation. A
data schema describes which fields are collected. Neither grimoire alone can
answer: "Are we collecting more than GDPR permits?" That question requires
reasoning — the explicit derivation of a conclusion from the relationship
between two bodies of knowledge.

This gap exists everywhere consequential decisions are made. Does this
applicant meet the eligibility criteria? Do these symptoms point to a
diagnosis? Does this contract clause create the obligation the party believes
it does? Do these architectural choices satisfy the stated quality attributes?
In every case, someone must reason from facts and rules to conclusions. The
`reasoning` grimoire gives Conjurer the vocabulary to do this explicitly,
traceably, and honestly.

### Reasoning as relationship, not assertion

The fundamental character of reasoning is relational — it concerns the
*relationship between claims*, not the claims themselves in isolation. A
fact asserted is an assertion. A conclusion derived is a reasoning product.
The difference is provenance: a derived conclusion traces to the premises that
produced it, and that trace is the reasoning itself.

This has a critical design consequence. The `reasoning` grimoire is built
around chains of custody. Every conclusion must trace to its premises. Every
rule application must be explicit. Every inference must be distinguishable
from an assertion. A system that produces conclusions without traceable
derivation paths is not reasoning — it is asserting confidently, which is
a very different and much more dangerous thing.

### Three modes of inference

Classical logic distinguishes three forms of inference, each with different
epistemic force:

**Deductive** reasoning derives necessary conclusions: if the premises are
true, the conclusion *must* be true. A tax rule applied to an income bracket
produces a deductively derived tax liability. The conclusion is as certain as
the premises and the rule.

**Inductive** reasoning derives probable conclusions: a pattern observed in
many cases is generalised to a new case. The conclusion is probably true but
not necessarily so. Risk scoring from historical patterns is inductive; the
score is an estimate, not a certainty.

**Abductive** reasoning derives the *best explanation*: given an observation,
what hypothesis most plausibly accounts for it? Medical diagnosis is abductive;
so is debugging. The conclusion is a candidate explanation, not a proven fact.

The `reasoning` grimoire handles all three modes, always making the mode
explicit — because the epistemic status of a conclusion depends entirely on
which mode produced it.

### The boundary with other grimoires

**`semantics`** identifies argument *structure* — that a text contains a
claim, some premises, and an inference. `reasoning` evaluates argument
*validity* — whether the inference is actually warranted by the premises.

**`domain`** models what *exists* in a domain. `reasoning` derives what
*follows* from that existence — the implications, obligations, and constraints
that domain facts entail.

**`orchestrate`** coordinates *processes*. `reasoning` evaluates *decisions*
within processes — what branch should be taken given these conditions, what
rule applies given these facts.

**`data`** validates that data satisfies a schema. `reasoning` validates that
*claims about data* follow from the data's content.

---

## Naming rationale

**`reasoning`** — From Latin *ratio*, calculation, account, reason. The
deliberate choice of this plain, precise word over alternatives like `logic`
or `inference` reflects the grimoire's scope: not just formal logical systems
but the full range of structured, traceable thinking that moves from what
is known to what follows.

**`r/`** — The short namespace alias.

**`r/derive`** — From Latin *derivare*, to lead away from, to draw from a
source. The primary act: drawing conclusions from their sources.

**`r/rules`** — Explicit conditional knowledge: if these conditions hold,
then this follows. The encoded knowledge that drives inference.

**`r/decide`** — Structured selection: given inputs, determine the applicable
conclusion through a declared decision model.

**`r/hypothesise`** — From Greek *hypotithenai*, to put under, to suppose.
Abductive generation of candidate explanations for observations.

**`r/trace`** — The derivation chain made visible. Not the conclusion but
the path to it.

---

## Part I: Logical foundations

The foundation of reasoning is the explicit representation of what is known
and what rules govern inference from that knowledge.

---

### `r/model`

Constructs an explicit logical model — a named collection of facts, definitions,
axioms, and constraints that form the epistemic foundation for subsequent
reasoning.

#### Signature

```clojure
(r/model name
  :facts       [{:claim string :source string :confidence :high | :medium | :low} ...]
  :definitions {:term "definition" ...}
  :axioms      ["always-true statement" ...]
  :constraints ["must-hold condition" ...]
  :inherits    parent-model
  :active-in   :session | :block
  :manifest    model-binding)
```

#### Parameters

**`:facts`** — Contingent truths: things believed to be true based on evidence
or observation. Every fact carries a `:source` (where it came from) and a
`:confidence` level (how certain we are). Facts can be wrong; they are not
axioms.

**`:definitions`** — Conceptual definitions that fix the meaning of terms
within the model. Definitions are neither true nor false — they are
stipulations that make subsequent reasoning precise.

**`:axioms`** — Foundational truths accepted without proof within this model.
Used for established principles, legal presumptions, or scientific laws that
are treated as given.

**`:constraints`** — Conditions that must hold across the model. Any reasoning
that would violate a constraint is flagged as inconsistent with the model.

**`:inherits`** — Extends a parent model, adding or overriding specific
elements while inheriting the rest.

#### Design rationale

Reasoning without an explicit model is reasoning in the dark. `r/model` forces
the practitioner to articulate the epistemic foundation before drawing
conclusions from it. This discipline surfaces assumptions that would otherwise
remain invisible, enables sharing of reasoning foundations across invocations,
and makes the basis for every conclusion inspectable.

The distinction between facts and axioms is not merely philosophical — it is
operationally important. A fact can be challenged with new evidence; an axiom
cannot be challenged within the model (though the model itself can be
questioned). A patient's blood pressure reading is a fact; the principle that
correlation does not imply causation is an axiom.

#### Example 1: GDPR compliance model

```clojure
(r/model gdpr-compliance
  :facts [
    {:claim      "Organisation processes personal data of EU residents"
     :source     "Data mapping exercise 2025-Q3"
     :confidence :high}
    {:claim      "Organisation currently has no legal basis documented for newsletter emails"
     :source     "DPO audit finding 2025-08-14"
     :confidence :high}
    {:claim      "Retention period for transaction data is currently 10 years"
     :source     "Data retention policy v2.1"
     :confidence :high}]

  :definitions {
    "personal data"   "Any information relating to an identified or identifiable natural person (Art. 4(1) GDPR)"
    "processing"      "Any operation performed on personal data (Art. 4(2) GDPR)"
    "lawful basis"    "One of the six bases in Art. 6(1) GDPR that makes processing lawful"
    "retention period" "The period for which personal data is kept before erasure or anonymisation"}

  :axioms [
    "Processing of personal data is unlawful without a valid lawful basis (Art. 6(1) GDPR)"
    "Personal data must not be kept longer than necessary for its purpose (Art. 5(1)(e) GDPR)"
    "Data subjects have the right to erasure where data is no longer necessary (Art. 17 GDPR)"]

  :constraints [
    "Every processing activity must have exactly one identified lawful basis"
    "Retention periods must be justified against the stated processing purpose"]

  :active-in :session
  :manifest  gdpr-model)
```

#### Example 2: Eligibility model for social benefit

```clojure
(r/model bijstand-eligibility
  :definitions {
    "aanvrager"        "The person applying for the benefit"
    "verblijfsstatus"  "The legal residence status in the Netherlands"
    "vermogensgrens"   "The asset threshold above which the benefit is denied"}

  :axioms [
    "Participation Act (Participatiewet) governs entitlement to bijstand"
    "Entitlement requires: lawful residence + age 18-67 + assets below threshold + insufficient income"
    "Partner's income and assets are included in the assessment"]

  :facts [
    {:claim "Asset threshold 2025: €7,605 single / €15,210 couple"
     :source "Participatiewet art. 34, as amended 2025"
     :confidence :high}]

  :constraints [
    "A person cannot simultaneously receive bijstand and WW"
    "Self-employment income must be assessed over 3 months before granting benefit"]

  :manifest eligibility-model)
```

---

### `r/rules`

Defines a named, reusable rule set — explicit if-then conditionals that encode
the inferential structure of a domain. Rules are the engine of systematic
reasoning.

#### Signature

```clojure
(r/rules name
  :rules [
    {:name       :rule-name
     :if         "condition in natural language or predicate"
     :then       "conclusion"
     :unless     "exception condition"
     :strength   :definitive | :presumptive | :defeasible
     :source     "origin of the rule"
     :priority   n}
    ...]
  :conflict-resolution :priority | :specificity | :recency
  :active-in   :scope
  :manifest    rule-set-binding)
```

#### Parameters

**`:strength`** — The logical force of the rule:
- `:definitive` — no exceptions; the conclusion always follows when conditions
  are met. Mathematical and physical laws.
- `:presumptive` — the conclusion follows unless rebutted; the burden of proof
  shifts. Legal presumptions work this way.
- `:defeasible` — the conclusion follows by default but can be overridden by
  more specific rules or additional evidence. Most business rules are defeasible.

**`:conflict-resolution`** — What to do when multiple rules apply and produce
different conclusions:
- `:priority` — higher-priority rules win
- `:specificity` — more specific rules win over more general ones
- `:recency` — most recently enacted rules win

**`:unless`** — An exception condition. When present, the rule does not fire
even if its `:if` condition is met, provided the `:unless` condition also holds.
This encodes defeasibility explicitly rather than requiring a separate override
rule.

#### Example 1: VAT rules

```clojure
(r/rules vat-classification
  :rules [
    {:name     :standard-rate
     :if       "supply of goods or services in the Netherlands"
     :then     "VAT rate is 21%"
     :strength :definitive
     :source   "Wet OB 1968 art. 9"
     :priority 10}

    {:name     :reduced-rate-food
     :if       "supply is food or non-alcoholic beverage for human consumption"
     :then     "VAT rate is 9%"
     :unless   "supply is restaurant or catering service"
     :strength :definitive
     :source   "Wet OB 1968 Tabel I post a.1"
     :priority 20}

    {:name     :zero-rate-export
     :if       "supply is export to country outside EU"
     :then     "VAT rate is 0%"
     :strength :definitive
     :source   "Wet OB 1968 art. 9 lid 2 sub b"
     :priority 30}

    {:name     :exempt-healthcare
     :if       "supply is medical or healthcare service by licensed provider"
     :then     "supply is VAT exempt"
     :strength :definitive
     :source   "Wet OB 1968 art. 11 lid 1 sub g"
     :priority 30}]

  :conflict-resolution :priority
  :manifest vat-rules)
```

#### Example 2: Credit decision rules

```clojure
(r/rules credit-decision
  :rules [
    {:name     :automatic-decline-recent-default
     :if       "applicant has payment default within past 24 months"
     :then     "application is declined"
     :strength :definitive
     :priority 100}

    {:name     :automatic-approve-low-risk
     :if       "credit score > 750 AND requested amount < 3× monthly income AND debt-to-income < 0.30"
     :then     "application is approved at standard rate"
     :strength :definitive
     :priority 50}

    {:name     :refer-to-underwriter
     :if       "credit score between 650 and 750 OR debt-to-income between 0.30 and 0.40"
     :then     "application is referred to underwriter review"
     :strength :definitive
     :priority 40}

    {:name     :decline-insufficient-income
     :if       "monthly income < requested monthly repayment × 1.5"
     :then     "application is declined for affordability"
     :strength :definitive
     :priority 80}]

  :conflict-resolution :priority
  :manifest credit-rules)
```

---

## Part II: Core inference

---

### `r/derive`

The primary inference operation. Given a set of facts and a rule set, derives
the conclusions that necessarily, probably, or plausibly follow — with a
complete derivation chain.

#### Signature

```clojure
(r/derive conclusions
  :from      facts-or-model
  :using     rules-or-rule-set
  :mode      :deductive | :inductive | :abductive | :mixed
  :depth     n
  :threshold confidence-threshold
  :explain   boolean
  :surface   [:conclusions :derivation-chain :open-questions :underdetermined]
  :manifest  derivation-result)
```

#### Parameters

**`:depth`** — How many inferential steps to follow from the initial facts.
Depth 1 applies rules directly to the given facts. Depth 2 also applies rules
to the first-order conclusions. Depth 3 continues. Deep derivation chains
reveal non-obvious implications but also accumulate uncertainty.

**`:threshold`** — Minimum confidence for a conclusion to be included in the
output. Lower thresholds produce more speculative conclusions; higher thresholds
produce sparser but more reliable ones.

**`:surface [:underdetermined]`** — Surface conclusions where the available
facts and rules are insufficient to determine the answer — questions that could
be resolved with additional information. These are as valuable as the derived
conclusions: they reveal what the practitioner needs to find out.

#### Design rationale

`r/derive` is the engine that makes `r/rules` and `r/model` useful. Rules and
facts without inference are merely a database. Inference turns them into a
reasoning system.

The explicit `:mode` parameter is not merely taxonomic — it changes how
conclusions should be interpreted. A deductive conclusion inherits the
certainty of its premises. An inductive conclusion is a generalisation that
new evidence could overturn. An abductive conclusion is a candidate
explanation that competes with others. Without knowing the mode, a conclusion
cannot be correctly used.

The `:explain true` parameter is non-negotiable for high-stakes domains.
A compliance conclusion without its derivation chain cannot be audited. A
credit decision without its reasoning cannot be challenged by the applicant.
In any context where the conclusion matters, the chain matters equally.

#### Example 1: GDPR compliance derivation

```clojure
(r/derive "What GDPR obligations apply to our newsletter processing?"
  :from    gdpr-compliance-model
  :using   (r/rules gdpr-obligations
             :rules [
               {:name :no-lawful-basis-unlawful
                :if   "processing activity has no documented lawful basis"
                :then "processing is unlawful under Art. 6(1) GDPR"
                :strength :definitive}
               {:name :consent-for-marketing
                :if   "processing purpose is direct marketing to individuals"
                :then "appropriate lawful basis is consent (Art. 6(1)(a)) or legitimate interest (Art. 6(1)(f)) subject to balancing test"
                :strength :presumptive}])
  :mode    :deductive
  :depth   2
  :explain true
  :surface [:conclusions :derivation-chain :open-questions])

;; Returns:
{:conclusions [
   {:conclusion  "Newsletter email processing is currently unlawful"
    :confidence  :high
    :strength    :definitive
    :derivation  [
      "Fact: No lawful basis documented for newsletter emails [DPO audit 2025-08-14]"
      "Axiom: Processing without lawful basis is unlawful (Art. 6(1) GDPR)"
      "Rule: no-lawful-basis-unlawful fires"
      "→ Conclusion: newsletter processing is unlawful"]}

   {:conclusion  "To lawfully continue, organisation must establish either consent or legitimate interest basis"
    :confidence  :high
    :strength    :presumptive
    :derivation  [
      "Fact: purpose is direct marketing to individuals [inferred from newsletter nature]"
      "Rule: consent-for-marketing fires"
      "→ Conclusion: consent or legitimate interest required"
      "Note: legitimate interest requires balancing test — not automatic"]}]

 :open-questions [
   "Has a legitimate interest assessment been conducted for newsletter processing?"
   "Are newsletter recipients able to withdraw consent / object? Is the mechanism documented?"
   "What is the legal basis for retaining historical newsletter engagement data?"]

 :underdetermined [
   {:question    "Is legitimate interest available as a basis?"
    :missing-fact "Result of legitimate interest balancing test"
    :impact      "Determines whether consent collection is required or LI basis can be relied upon"}]}
```

#### Example 2: Eligibility determination

```clojure
(r/derive "Is this applicant eligible for bijstand?"
  :from {:applicant {:age 34
                     :verblijfsstatus :permanent-resident
                     :maandinkomen   0
                     :vermogen       4200
                     :partner        nil}}
  :using eligibility-model
  :mode  :deductive
  :depth 1
  :explain true)

;; Returns:
{:conclusions [
   {:conclusion "Applicant meets the eligibility conditions for bijstand"
    :confidence :high
    :derivation [
      "Condition 1: Age 18-67 → age 34 ✓"
      "Condition 2: Lawful residence → permanent resident ✓"
      "Condition 3: Assets below threshold → €4,200 < €7,605 (single) ✓"
      "Condition 4: Insufficient income → monthly income €0 ✓"
      "Condition 5: No partner → single threshold applies ✓"
      "→ All eligibility conditions met"]}]

 :open-questions [
   "Has the applicant been self-employed in the past 6 months? (3-month income assessment may apply)"
   "Has the applicant received WW in the past 12 months? (Cannot combine with bijstand)"]}
```

---

### `r/decide`

Evaluates a structured decision model — decision table, decision tree, or
scoring model — against a set of inputs, producing the applicable conclusion
and the path through the decision structure that reached it.

#### Signature

```clojure
(r/decide decision-model
  :given   input-map
  :model   :decision-table | :decision-tree | :scoring-model | :rule-set
  :explain boolean
  :surface [:decision :path :alternatives :sensitivity]
  :manifest decision-result)
```

#### Parameters

**`:surface [:alternatives]`** — Show which other decision branches were
considered but not taken. Useful for understanding how close the decision
was to a different outcome.

**`:surface [:sensitivity]`** — Show which inputs, if changed, would produce
a different decision. "If credit score had been 755 instead of 745, the
outcome would have been automatic approval." Essential for fairness auditing
and applicant communication.

#### Example: Credit application decision

```clojure
(r/decide credit-rules
  :given   {:credit-score         720
            :monthly-income       4500
            :requested-amount     18000
            :debt-to-income       0.28
            :recent-default       false
            :requested-monthly-repayment 340}
  :model   :rule-set
  :explain true
  :surface [:decision :path :sensitivity])

;; Returns:
{:decision    :refer-to-underwriter
 :confidence  :high
 :path [
   {:rule     :automatic-decline-recent-default
    :fired    false
    :reason   "No recent default — rule does not apply"}
   {:rule     :automatic-approve-low-risk
    :fired    false
    :reason   "Credit score 720 < 750 threshold — auto-approve conditions not met"}
   {:rule     :refer-to-underwriter
    :fired    true
    :reason   "Credit score 720 is in range 650-750 — referral triggered"}]

 :sensitivity [
   {:input     :credit-score
    :change    "Increase to 751+"
    :effect    "Decision changes to :automatic-approve at standard rate"}
   {:input     :debt-to-income
    :change    "Increase to 0.31+"
    :effect    "Referral condition would still hold; no decision change at this threshold"}]}
```

---

### `r/hypothesise`

Abductive reasoning: given an observation or set of observations, generates
candidate explanations ranked by plausibility. Each hypothesis is a coherent
account of what *could* have produced the observed facts.

#### Signature

```clojure
(r/hypothesise observation
  :from           facts-or-model
  :using          domain-knowledge
  :candidates     n
  :rank-by        :plausibility | :simplicity | :explanatory-power | :testability
  :must-explain   [:observation ...]
  :may-not-assume [:excluded-hypothesis ...]
  :output         :ranked-hypotheses)
```

#### Parameters

**`:rank-by`** — The criterion for ordering candidate hypotheses:
- `:plausibility` — most consistent with prior probability and background knowledge
- `:simplicity` — fewest unexplained residuals; Occam's razor
- `:explanatory-power` — accounts for the most observations including peripheral ones
- `:testability` — most amenable to empirical verification or refutation

**`:may-not-assume`** — Hypotheses to exclude from consideration. Useful
when some candidate explanations have already been ruled out by prior
investigation.

#### Design rationale

Abductive reasoning is the form of inference most common in diagnostic,
investigative, and scientific contexts — yet it is the least formalised. A
doctor doesn't derive a diagnosis; they hypothesise the most plausible one.
An engineer doesn't prove a bug's cause; they hypothesise the most likely one.
`r/hypothesise` makes this reasoning explicit, structured, and transparent.

#### Example 1: Incident investigation

```clojure
(r/hypothesise "API error rate increased from 0.1% to 12% at 14:23 UTC"
  :from   {:observations [
             "Error rate spike at 14:23 UTC"
             "Spike is on POST /payments endpoint specifically"
             "GET endpoints unaffected"
             "Database query latency unchanged"
             "Deployment occurred at 14:20 UTC"
             "Error type: NullPointerException in PaymentProcessor.validate()"]}
  :rank-by    :plausibility
  :candidates 3)

;; Returns:
{:hypotheses [
   {:rank        1
    :hypothesis  "The 14:20 deployment introduced a null-handling regression in PaymentProcessor.validate()"
    :plausibility :high
    :evidence-for ["Deployment immediately precedes spike"
                   "Error type points to specific code path"
                   "Scope limited to POST — consistent with write-path code change"]
    :evidence-against ["Deployment was to payment-service v2.3.1, described as a config change only"]
    :testable-via "Review diff of PaymentProcessor.validate() between v2.3.0 and v2.3.1"
    :if-correct  "Rolling back to v2.3.0 should resolve the issue"}

   {:rank        2
    :hypothesis  "A downstream dependency (payment gateway) changed its response format, causing NullPointerException when parsing the new format"
    :plausibility :medium
    :evidence-for ["NullPointerException consistent with unexpected null in parsed response"
                   "External services do change APIs"]
    :evidence-against ["No corresponding gateway incident report"
                       "Timing correlation with deployment is coincidental on this hypothesis"]
    :testable-via "Check payment gateway changelog and compare response format with code expectations"}

   {:rank        3
    :hypothesis  "A subset of payment request payloads is missing a required field, triggering the null exception"
    :plausibility :low
    :evidence-for ["NullPointerException is consistent with missing field"]
    :evidence-against ["Error rate jumped sharply rather than gradually — suggests code change, not data change"
                       "Would expect errors to cluster on specific customers, not uniformly"]
    :testable-via "Sample erroring requests and check for structural differences"}]}
```

#### Example 2: Diagnostic reasoning

```clojure
(r/hypothesise "Patient presents with fatigue, weight gain, cold intolerance, and constipation"
  :from   {:symptoms  ["fatigue" "weight-gain" "cold-intolerance" "constipation"]
           :patient   {:age 42 :sex :female :family-history [:thyroid-disease]}
           :labs      {:tsh 8.2 :free-t4 0.7}}
  :using  clinical-endocrine-knowledge
  :rank-by :explanatory-power
  :candidates 3)

;; Returns ranked differential diagnoses with explanatory coverage
;; and recommended confirmatory investigations for each
```

---

## Part III: Verification

---

### `r/check`

Verifies logical relationships between claims: does this conclusion follow
from these premises? Are these claims consistent with each other? Does this
claim contradict established facts in the model?

#### Signature

```clojure
(r/check target
  :against    facts-model-or-claims
  :for        :entailment | :consistency | :contradiction | :independence
  :using      rules-or-axioms
  :explain    boolean
  :output     :check-result)
```

#### Parameters

**`:for`** — What relationship to verify:
- `:entailment` — does the target *follow* from the given facts/rules?
- `:consistency` — is the target *compatible* with the given facts/rules?
- `:contradiction` — does the target *conflict* with the given facts/rules?
- `:independence` — is the target *neither entailed nor contradicted* by the given facts?

#### Example 1: Policy consistency check

```clojure
(r/check "Our 10-year transaction data retention is proportionate"
  :against gdpr-compliance-model
  :for     :consistency
  :using   (r/rules proportionality
             :rules [{:name :storage-limitation
                      :if   "retention period exceeds what is necessary for the stated purpose"
                      :then "retention violates storage limitation principle (Art. 5(1)(e))"
                      :strength :definitive}])
  :explain true)

;; Returns:
{:verdict  :check-fails
 :finding  "Claim is not consistent with GDPR storage limitation principle"
 :reasoning [
   "GDPR Art. 5(1)(e) requires data be kept no longer than necessary for the purpose"
   "Transaction data purpose: fraud prevention and accounting"
   "Fraud prevention: typically 3-5 years per industry practice"
   "Accounting: 7 years under Dutch Burgerlijk Wetboek art. 3:15i"
   "10 years exceeds the maximum justified by either purpose"
   "→ Retention period is not consistent with proportionality requirement"]
 :implication "Retention policy must be reduced to ≤7 years or purpose must be re-specified with justification"}
```

#### Example 2: Argument validity check

```clojure
(r/check "Therefore, all our processing is lawful"
  :against {:premises [
             "We have documented consent for newsletter processing"
             "We have documented legitimate interest for analytics"]}
  :for     :entailment
  :explain true)

;; Returns:
{:verdict   :entailment-fails
 :finding   "Conclusion does not follow from the premises"
 :gap       "Premises establish lawful basis for two specific activities.
             Conclusion claims lawfulness of all processing.
             Processing activities not addressed: HR data, supplier data,
             customer support records, CCTV, website cookies."
 :repair    "Either enumerate all processing activities and confirm basis for each,
             or qualify the conclusion to match the scope of the premises"}
```

---

### `r/contradict`

Actively searches a set of claims or a belief model for internal
contradictions — pairs or groups of claims that cannot all be true simultaneously.

#### Signature

```clojure
(r/contradict belief-set
  :using   rules-or-axioms
  :severity :all | :significant-only
  :explain boolean
  :output  :contradiction-report)
```

#### Example

```clojure
(r/contradict policy-document-claims
  :using   vat-rules
  :explain true)

;; Returns:
{:contradictions [
   {:claims [
     "Our catering service is VAT exempt"
     "All our food services qualify for the 9% reduced rate"]
    :contradiction "Catering and restaurant services are explicitly excluded from the
                    food reduced-rate provision (Wet OB 1968 Tabel I). The first
                    claim (VAT exempt) and the second (9% reduced rate) cannot
                    both be correct. Catering is standard-rated at 21%."
    :severity :significant
    :resolution "Catering services should be classified at 21% standard rate.
                 Verify whether any exemption claim has been relied upon in past filings."}]}
```

---

## Part IV: Explanation and communication

---

### `r/trace`

Produces a complete, readable derivation chain for a conclusion — the explicit
step-by-step path from premises and rules to the final conclusion. Where
`r/derive` produces conclusions with embedded derivation, `r/trace` is a
dedicated tool for making a specific derivation maximally transparent.

#### Signature

```clojure
(r/trace conclusion
  :from      derivation-result | conclusion-binding
  :format    :step-by-step | :tree | :natural-language
  :audience  :technical | :legal | :general
  :annotate  [:rule-citations :confidence-at-each-step :alternatives-considered]
  :output    :derivation-document)
```

#### Parameters

**`:format`**:
- `:step-by-step` — numbered inference steps, each citing the rule and facts used
- `:tree` — branching structure showing how different streams of evidence
  combine into the conclusion
- `:natural-language` — written as coherent prose, suitable for regulatory
  submissions or explanations to affected parties

**`:audience`** — Shapes vocabulary and level of formality. `:legal` produces
output with rule citations in standard citation format. `:general` produces
plain language explanation of the reasoning without citations.

#### Example: Explanation to applicant

```clojure
(r/trace bijstand-decision
  :format   :natural-language
  :audience :general
  :annotate [:alternatives-considered])

;; Returns plain-language explanation suitable for providing to the applicant:
;; "We reviewed your application for income support (bijstand) on [date].
;;  We looked at four things required by the Participation Act:
;;
;;  1. Age: You are 34 years old, which is within the eligible range of 18 to 67. ✓
;;  2. Residence status: Your permanent residence permit means you have lawful
;;     residence in the Netherlands. ✓
;;  3. Assets: Your total assets of €4,200 are below the threshold of €7,605
;;     for a single person. ✓
;;  4. Income: You currently have no monthly income. ✓
;;
;;  Because all four conditions are met, you are entitled to income support.
;;
;;  We also checked whether you have been self-employed recently. If you have
;;  been self-employed in the past six months, we may need to assess your
;;  income over a three-month period first. Please let us know if this applies."
```

---

### `r/argue`

Constructs a formal argument for a position — explicit premises, inference
steps, and conclusion — suitable for legal documents, policy submissions,
or structured debate.

#### Signature

```clojure
(r/argue position
  :grounds   [supporting-fact-or-rule ...]
  :rebuttals [anticipated-objection ...]
  :backing   [authority-or-evidence ...]
  :qualifier :necessarily | :probably | :plausibly | :presumptively
  :format    :toulmin | :classical | :legal-brief
  :output    :argument-document)
```

#### Parameters

**`:format`** — The argumentative structure:
- `:toulmin` — Toulmin model: claim, grounds, warrant, backing, qualifier, rebuttal.
  Widely used in legal and policy argumentation.
- `:classical` — Aristotelian: premises, inference, conclusion.
- `:legal-brief` — Legal brief format: question presented, short answer,
  statement of facts, argument.

#### Example: Regulatory submission argument

```clojure
(r/argue "The proposed cookie consent mechanism meets ePrivacy Directive requirements"
  :grounds   [
    "The mechanism requires affirmative action before any non-essential cookies are set"
    "Decline option is presented with equal visual prominence to the accept option"
    "Granular consent is provided per cookie category"
    "Consent is freely given — no service denial for declining non-essential cookies"]
  :rebuttals [
    {:objection "The pre-ticked boxes in the 'statistics' category constitute implied consent"
     :response  "The pre-ticked boxes were removed in version 3.2 (see exhibit B)"}]
  :backing   [
    "WP29 Guidelines on Consent (WP259 rev.01)"
    "EDPB Guidelines 05/2020 on consent"]
  :qualifier :probably
  :format    :legal-brief)
```

---

## Best practices

### State facts and rules before deriving conclusions

Resist the temptation to jump directly to `r/derive` without first establishing
the model and rules explicitly. The discipline of articulating `r/model` and
`r/rules` surfaces assumptions that would otherwise remain invisible — and
those hidden assumptions are precisely where reasoning goes wrong.

### Make the mode explicit always

Never allow the inference mode to be implicit. Label every conclusion as
deductive, inductive, or abductive. The epistemic status of a conclusion —
how certain it is, how it can be challenged, what would overturn it — depends
entirely on the mode of inference that produced it.

### Surface open questions alongside conclusions

`r/derive` with `:surface [:open-questions]` often produces findings as
valuable as the conclusions themselves. The questions that cannot be answered
with available facts are precisely the questions that need to be investigated.
A derivation that surfaces no open questions is likely a derivation that has
not probed the boundaries of its own completeness.

### Distinguish rules from facts from axioms

A rule is a conditional inference pattern. A fact is a contingent truth. An
axiom is a foundational assumption. Conflating them leads to reasoning that
cannot be audited: when a conclusion is challenged, it must be possible to
identify whether the challenge targets a rule (the inference pattern), a fact
(the empirical claim), or an axiom (the foundational assumption).

### Trace every high-stakes conclusion

In any domain where a conclusion materially affects a person — credit decisions,
eligibility determinations, compliance findings, risk assessments — the
derivation chain is not optional documentation. It is the substance of the
decision. Produce it. Store it. Make it available to those affected.

---

## Integration patterns

### Reasoning as the decision layer within orchestrate

Workflow decisions — which branch to take, when to escalate, when an exception
applies — belong in `r/decide` rather than in `o/branch` conditionals. `r/decide`
makes the decision logic explicit, documented, and auditable. `o/branch` routes;
`r/decide` decides.

```clojure
(o/define-workflow :loan-application
  :stages [
    {:name :assess-eligibility
     :operation (r/decide credit-rules
                  :given    application-data
                  :model    :rule-set
                  :explain  true)}

    {:name      :route-decision
     :operation (branch :on eligibility-result
                  :cases {:approved       (conjure issue-offer)
                          :referred        (o/human-approval :reviewers [:underwriter])
                          :declined        (conjure generate-decline-letter)})}])
```

### Domain model as the fact base for reasoning

A domain model produced by `d/explore` or `d/model` becomes the fact base
for `r/model`. The domain's entities, constraints, and relationships are
facts about the world; the reasoning grimoire draws conclusions from them.

```clojure
(def regulation   (d/explore "participatiewet.pdf" :focus [:constraints :rules]))
(def applicant    (d/model "Applicant" :entities {:applicant applicant-data}))

(r/model eligibility-context
  :facts   (d/extract applicant   :what :entities :as :facts)
  :axioms  (d/extract regulation  :what :constraints :as :axioms)
  :manifest eligibility-base)

(r/derive "What is the applicant's eligibility status?"
  :from  eligibility-base
  :mode  :deductive
  :explain true)
```

### Semantics → reasoning pipeline

`s/texan` extracts the argumentative structure of a text. `r/check` evaluates
whether that structure is logically valid. Together they form a complete
argument assessment pipeline.

```clojure
(~> policy-document
  (s/texan     :models [:argumentation :facts-assumptions])
  (r/check     :for :consistency :against regulatory-model :explain true)
  (r/contradict :using domain-rules :explain true)
  (e/compose "Policy Argument Assessment"
    :audience :legal-counsel
    :purpose  :report))
```

### Reasoning traces as eloquence source

A `r/trace` derivation is structured knowledge that `e/compose` can transform
into audience-appropriate communication.

```clojure
(def derivation (r/derive eligibility-conclusion :from model :explain true))

;; For the applicant: plain language
(e/compose "Your Application Outcome"
  :from      (r/trace derivation :format :natural-language :audience :general)
  :audience  :end-user :tone :conversational)

;; For the supervisor: technical trace
(e/compose "Eligibility Decision Record"
  :from      (r/trace derivation :format :step-by-step :annotate [:rule-citations])
  :audience  :compliance-officer :tone :formal)
```

---

## Grimoire metadata

```clojure
{:grimoire    "reasoning"
 :namespace   "r/"
 :version     "1.0.0"
 :description "Explicit logical inference: deductive, inductive, and abductive
               reasoning with full derivation tracing and chain-of-custody provenance"

 :constructs {
   :foundations  [r/model r/rules]
   :inference    [r/derive r/decide r/hypothesise]
   :verification [r/check r/contradict]
   :explanation  [r/trace r/argue]}

 :best-for [
   "Regulatory compliance determination: do our practices satisfy the rules?"
   "Eligibility and entitlement decisions with auditable derivation chains"
   "Business rule evaluation and decision table execution"
   "Incident investigation and root-cause hypothesis generation"
   "Policy consistency checking and contradiction detection"
   "Argument construction for legal and regulatory submissions"
   "Decision explainability for affected parties and regulators"]

 :works-with [:core :domain :semantics :orchestrate :eloquence]

 :key-concepts [
   {:term "Deductive reasoning"
    :definition "Inference where the conclusion necessarily follows from the premises.
                 If the premises are true and the rule is valid, the conclusion must
                 be true. No exceptions."}
   {:term "Inductive reasoning"
    :definition "Inference from observed patterns to probable generalisations.
                 The conclusion probably follows, but new evidence can overturn it."}
   {:term "Abductive reasoning"
    :definition "Inference to the best explanation. Given observations, what hypothesis
                 most plausibly accounts for them? The conclusion is a candidate, not
                 a certainty."}
   {:term "Derivation chain"
    :definition "The explicit path from premises and rules to conclusion. The reasoning
                 itself — not just the result. Every high-stakes conclusion requires one."}
   {:term "Defeasible rule"
    :definition "A rule that holds by default but can be overridden by more specific
                 rules or additional evidence. Most business rules are defeasible."}
   {:term "Open question"
    :definition "A conclusion that cannot be determined from available facts and rules.
                 Surfacing open questions is as important as deriving conclusions."}
   {:term "Sensitivity"
    :definition "Which inputs, if changed, would produce a different decision.
                 Essential for fairness auditing and explaining decisions to affected parties."}]}
```

---

## Implementation notes for LLM processors

### The chain-of-custody requirement

This is the non-negotiable discipline of the reasoning grimoire. Every derived
conclusion must include its derivation chain. Every step in the chain must
cite the specific fact, rule, or axiom that produced it. A conclusion without
provenance is an assertion — and the reasoning grimoire does not produce
assertions.

When `:explain true` is specified, always produce the derivation chain.
When `:explain` is not specified, include a summary derivation by default —
never produce a bare conclusion without at least a one-line justification.

### Mode discipline

Always make the inference mode explicit in the output, whether or not the
practitioner specified it. If the practitioner specifies `:mode :deductive`
but the inference is actually probabilistic, flag the mismatch rather than
producing false certainty.

Epistemic markers by mode:
- Deductive conclusions: "follows necessarily", "must be", "is required by"
- Inductive conclusions: "is probable", "evidence suggests", "pattern indicates"
- Abductive conclusions: "most plausibly explains", "best account of", "consistent with"

### Open question discipline

When facts are insufficient to determine a conclusion, produce the question
rather than an uncertain conclusion. "Is the applicant currently self-employed?"
is more useful than "Eligibility is uncertain (0.6 confidence)." The question
identifies what needs to be investigated; the confidence score does not.

Open questions should:
1. Be specific enough to be answerable by investigation
2. Identify which conclusion they affect
3. Note what the impact of each possible answer would be

### Rule conflict resolution

When multiple rules apply to the same situation and produce different conclusions,
apply the declared `:conflict-resolution` strategy and make the conflict explicit
in the output. Never silently apply one rule over another without surfacing the
conflict. The practitioner must know that a conflict existed and how it was resolved.

### Sensitivity analysis

When `:surface [:sensitivity]` is requested in `r/decide`, identify the inputs
whose change would most plausibly alter the decision. Compute sensitivity for:
- Input values close to a decision threshold
- Required conditions that were borderline
- Rules that almost fired but did not

Report the minimum change needed in each sensitive input to produce a different
outcome. This is not a request for extensive computation — it is a request for
the system's assessment of which inputs are near decision boundaries.

### Contradiction severity

When `r/contradict` finds contradictions, classify their severity:
- `:critical` — the contradiction directly undermines a derived conclusion or
  a compliance claim; immediate resolution required
- `:significant` — the contradiction affects a secondary claim or creates
  ambiguity in interpretation; should be resolved before relying on the model
- `:minor` — the contradiction exists in peripheral claims that do not affect
  current derivations; should be noted but does not block use of the model

### Abductive ranking

When ranking hypotheses in `r/hypothesise`, apply the following hierarchy to
break ties between equally plausible hypotheses:
1. **Consistency with all observations** — hypotheses that explain more
   observations rank higher
2. **Background probability** — more common explanations rank above rare ones
3. **Testability** — hypotheses that can be more easily confirmed or refuted
   rank above those that cannot
4. **Simplicity** — all else being equal, simpler hypotheses are preferred

Always surface the evidence against each hypothesis alongside the evidence for
it. A hypothesis with strong evidence for it and strong evidence against it is
less reliable than one with moderate evidence for and no evidence against.