# Conjurer

*A declarative language for LLM interaction.*

---

## The central tension

Every programming language makes a wager about where intelligence lives. Conventional languages bet it lives in the machine: give the computer perfectly unambiguous instructions, and it will execute them faithfully. The human's job is translation — taking intent and grinding it down into syntax the parser will accept. The machine stays fixed; the human descends to meet it.

This wager made sense when the machine was a finite automaton. It makes less sense now.

Large language models do not parse strings against a grammar. They approximate meaning conditioned on context — which means they can accept semantic *equivalence classes*, not merely syntactic identity. The same intent expressed a dozen different ways produces the same result. Ambiguity, which compilers reject as error, LLMs resolve through inference. Context, which compilers discard as irrelevant, LLMs accumulate as interpretive mass.

Conjurer is a language built for this different machine. Its wager is the opposite: intelligence lives in the collaboration between human intent and model capability. The human stays at the level of intent; the machine ascends to meet them.

---

## Why "Conjurer"

The name carries more than etymology. It carries the entire design philosophy.

**From Clojure's `conj`.** Clojure's `conj` function adds an element to a collection while respecting the collection's natural structure. Add to a vector and the element appears at the end; add to a list and it appears at the front. The function understands the inherent character of each data structure and works *with* it rather than imposing uniform behavior.

```clojure
(conj [1 2 3] 4)   ;; => [1 2 3 4]  — vector: appends
(conj '(1 2 3) 4)  ;; => (4 1 2 3)  — list: prepends
```

Conjurer does the same for LLMs. It works with the model's natural strengths — contextual inference, semantic understanding, pattern recognition across vast domains — rather than forcing it into the rigid role of a syntax-checker. The phonetic similarity between *Clojure* and *Conjurer* is intentional: a lineage, not a coincidence.

**From the act of conjuring.** To conjure is to summon something into existence through seemingly magical means, yet with deliberate intent and understanding of underlying principles. This is precisely what happens when a Conjurer invocation is processed: the practitioner states what should exist, and the system brings it into being through trained understanding of patterns, structures, and relationships. The practitioner who conjures is not commanding — they are *invoking*. The word suggests collaboration, not dictation.

**From the grimoire tradition.** In historical magical practice, a grimoire is a textbook of spells — not a collection of arbitrary incantations but an organized body of knowledge, each spell encoding expertise about how to summon a particular kind of effect. Conjurer's libraries are grimoires in precisely this sense: thematic collections of invocations, each encoding deep domain expertise, each a literate artifact that teaches as much as it specifies.

---

## The paradigm shift

Understanding Conjurer requires understanding what it changes about the programmer's relationship to specification.

In conventional programming, a specification is a *contract with a parser*. Every character must be in the right place; every type must be declared; every edge case must be handled explicitly. The specification is complete or it is wrong.

In Conjurer, a specification is a *contract with understanding*. It must convey intent with sufficient clarity for the system to make good decisions — but it need not be exhaustive. The system fills gaps through contextual inference, domain knowledge, and established conventions. Gaps are not errors; they are invitations.

This changes what "correct" means. A Conjurer invocation is correct if it produces a manifestation that faithfully serves the practitioner's intent — regardless of whether every parameter was specified, regardless of whether the same words were used consistently, regardless of syntactic form. Correctness is semantic, not syntactic.

It also changes what "complete" means. A Conjurer program is never complete in the sense that a compiled program is complete — it is always open to refinement, always capable of being deepened, always responsive to new context. Completeness is progressive, not final.

---

## Seven design principles

### I. Declarative supremacy

Specify *what* should exist, not *how* to create it.

The force of declarative specification lies not in what it forbids — imperative instructions — but in what it liberates: specification at the level of intent. The distance between what a practitioner wants and what a machine executes is a *semantic* gap, not a syntactic one. Traditional languages close this gap by forcing the human downward. Conjurer reverses the direction: the machine ascends toward the human.

This is not a concession to imprecision. It is a redefinition of what precision means. Consider:

```clojure
(conjure inventory-reconciliation
  :strategy :eventual-consistency
  :conflict-resolution :last-write-wins
  :audit-trail true)
```

This declaration is *sharper* than a hundred lines of imperative code, because code fixes implementation details that may betray intent the moment the environment shifts — a different database, a different consistency model, a different team's conventions. The declaration survives. The implementation is regenerated from it, always faithful to the stated intent.

---

### II. Semantic richness over syntactic rigidity

Meaning matters more than form.

Conventional languages enforce syntactic precision because their parsers are finite automata: they accept or reject strings. An LLM is a probability distribution over meaning conditioned on context — which means it accepts semantic equivalence classes, not merely syntactic identity. Conjurer exploits this.

The following three invocations are equivalent. All are valid. All produce the same manifestation:

```clojure
(conjure user-form :validates [:email-format :age-minimum :password-strength])
(conjure user-form :ensures [:valid-email :legal-age :secure-password])
(conjure user-form :requires {:email :valid-format :age {:at-least 18}})
```

The language is not sloppy — it is *semantically polymorphic*. The same meaning, many legal expressions. Practitioners write in whatever vocabulary comes naturally to them. The system understands the intent regardless of the words used to express it.

---

### III. Semantic gravity

Context accumulates mass. The heavier it grows, the more precisely it determines interpretation — and the terser your invocations can become.

A single `context establish` slightly biases how the system interprets ambiguous terms. A rich, multi-dimensional context nearly *determines* interpretation — ambiguity collapses under its mass. This is not a limitation; it is the mechanism by which sessions become increasingly expressive as shared understanding deepens.

```clojure
(context establish
  :domain :financial-services
  :regulations [:psd2 :aml-kyc]
  :entities {:transaction [:amount :currency :timestamp :counterparty]
             :account     [:id :balance :currency :risk-rating]})

;; This terse invocation is now fully determined:
(conjure transaction-processor)

;; Semantic gravity fills in: PSD2 strong authentication, AML monitoring,
;; ISO-4217 currency handling, EUR as default, audit trail on every operation.
;; The context carries the mass; the invocation carries only the delta.
```

The implication for experienced practitioners: invocations grow *shorter* as sessions mature, not longer. Complexity dissolves into context. This is the opposite of most programming — where specificity demands verbosity. In Conjurer, specificity is front-loaded into the context layer, and subsequent invocations reap the benefit.

---

### IV. Productive ambiguity

Some ambiguity is not a deficiency in the specification. It is a deliberate invitation for creative manifestation.

When a practitioner writes `"make this feel warmer and more encouraging for new users"`, the vagueness is not an error. It is a signal: *I trust your judgment here.* Over-specifying what "warmer" means would constrain outcomes the practitioner cannot anticipate. Productive ambiguity creates space for the system to discover good solutions that no complete specification would have reached.

Conjurer distinguishes two kinds of ambiguity:

**Resolvable ambiguity** — the intent is clear but underspecified; the system infers from context and proceeds, noting its interpretation. Most ambiguity is of this kind.

**Productive ambiguity** — the vagueness is deliberate; the system exercises judgment, explains its choices, and invites refinement. This is not a failure state — it is how the best collaborative work happens.

```clojure
;; Resolvable: the system knows what "customer" means from context
(conjure customer-report)

;; Productive: deliberately open — the system exercises UX judgment
(refine onboarding-flow
  "Make this feel warmer and more encouraging for new users")
;; System explains its interpretation choices; practitioner refines from there.
```

The key discipline: never mistake productive ambiguity for laziness. The practitioner who writes vaguely because they haven't thought it through is not practicing Conjurer well. The practitioner who writes vaguely because they trust the system to find good solutions is practicing it fluently.

---

### V. Progressive refinement

Complexity accretes. Initial invocations are sketches, not blueprints.

`refine` is not merely an enhancement mechanism — it is a *discovery tool*. The act of manifesting an initial, incomplete specification and then refining it often reveals requirements that were invisible before the first manifestation existed. The system's response becomes a mirror in which the practitioner sees what they actually wanted.

```clojure
;; Sketch — broad intent, minimal specification
(conjure recommendation-engine :for user-content-matching)

;; The manifestation reveals an assumption: collaborative filtering only.
;; The practitioner realizes new users have no history to filter from.

(refine recommendation-engine
  "Works well, but new users with no history get nothing useful.
   Add content-based fallback for users with fewer than 10 interactions.")

;; Now the practitioner sees the cold-start problem clearly.
(refine recommendation-engine
  :cold-start-threshold 10
  :cold-start-strategy :content-based
  :transition :hybrid-blended
  :diversity-weight 0.15
  :because "User feedback shows over-focusing causes boredom over time")
```

Three invocations. The first was nearly content-free. The second was natural language. The third was precise and reasoned. This is what progressive refinement looks like in practice: the language meets the practitioner wherever their understanding currently is, and moves with them toward clarity.

---

### VI. Intent topology

Not all parts of a specification are equally central. Conjurer acknowledges this.

Some requirements are *load-bearing* — the system fails without them, or worse, operates in silent violation of a constraint that matters. Some are *peripheral* — valuable if achievable, acceptable to defer if not. Some are *aesthetic* — style preferences that should inform but never override correctness. Some are *temporal* — right for a future iteration, premature now.

This structural property of intent is its *topology*. Conjurer makes it explicit:

```clojure
(conjure payment-processor
  :requires  [:pci-compliance :idempotency :audit-trail]
  :prefers   [:real-time-fraud-detection :multi-currency-support]
  :style     {:error-messages :user-friendly :verbosity :minimal}
  :deferred  [:analytics-integration :a-b-testing-hooks])
```

When constraints conflict — and in real systems they always eventually conflict — the topology tells the system how to choose. `:requires` always wins. `:prefers` yields to `:requires` but ranks above `:style`. `:deferred` items are recorded but not manifested. The practitioner never has to adjudicate these trade-offs explicitly; the topology does it for them.

---

### VII. Collaborative discovery

The practitioner-system relationship in Conjurer is not command-and-execute. It is co-authorship.

The system does not merely execute specifications — it participates in clarifying them, surfacing tensions within them, and proposing improvements the practitioner had not anticipated. A system processing `(conjure checkout-flow :handles [:cart :payment :confirmation])` might manifest the artifact *and* note: "The payment step has no error-recovery path for gateway timeouts — I've added exponential retry with graceful degradation, but you may want to review the fallback messaging tone." This is not overreach. It is what a skilled collaborator does.

Collaborative discovery is surfaced through three constructs: `explain`, which makes the system's interpretive choices transparent on demand; `meta-query`, which lets the practitioner ask questions about the manifestation's assumptions and trade-offs; and `witness`, which captures the system's reasoning non-invasively as the session unfolds.

Together, these turn a Conjurer session from monologue into dialogue. The practitioner does not issue commands and receive deliverables. They engage in a conversation about intent, with the system as a capable, opinionated interlocutor.

---

## What Conjurer is not

**Conjurer is not prompt engineering.** Prompts are flat, single-turn, and informal. Conjurer invocations are structured, composable, context-aware, and iterable. A prompt is a letter; a Conjurer session is a working relationship.

**Conjurer is not a domain-specific language.** DSLs sacrifice generality for expressiveness in a narrow domain. Conjurer is general-purpose — it addresses any domain through its grimoire system — while remaining semantically rich in each of them.

**Conjurer is not a specification language.** Specification languages like TLA+ or Alloy describe systems formally so they can be verified. Conjurer describes systems declaratively so they can be manifested. Verification is not the goal; creation is.

**Conjurer is not natural language programming.** Natural language is unstructured; Conjurer has syntax, composition rules, and semantic conventions. The structure is not a tax on expressiveness — it is what makes invocations composable, context-aware, and reusable across sessions.

**Conjurer is not a thin wrapper around LLM prompts.** The grimoire system, context inheritance, execution primitives, and semantic constructs constitute a genuine language with semantics. The LLM is the runtime, but the language has its own theory.

---

## The grimoire ecosystem

Conjurer's standard library is organized into grimoires — thematic collections of invocations, each encoding specialized expertise. Every grimoire is a literate programming artifact: philosophy, function specifications, and worked examples woven together as a unified document.

The grimoires are peers, not a hierarchy. `core` is foundational in the sense that its constructs appear in all programs — but `semantics` is not less important than `domain`; they address different concerns with equal depth.

| Grimoire | What it encodes |
|---|---|
| **core** | The language's fundamental constructs: `conjure`, `refine`, `context`, `using`, `ritual`, `explain`, `witness`, `weave`, `ward`, `~>`, and the execution primitives |
| **domain** | The discipline of knowledge extraction: exploring documents, modeling domains, resolving conflicts between sources, generating domain-specific languages |
| **data** | The full lifecycle of data: schema definition, synthetic generation, transformation pipelines, validation, format conversion |
| **web** | Web development from analysis to artifact: style extraction, component generation, full-stack prototyping, accessibility-first design |
| **semantics** | Deep textual understanding: multi-model analysis, perspectival interpretation, synthesis across competing viewpoints |
| **reasoning** | Inference from facts and rules: deductive, inductive, abductive derivation with explicit traceability |
| **taxonomy** | Classification systems and hierarchical organization: controlled vocabularies, facets, and concept trees |
| **orchestrate** | Workflow coordination: multi-stage pipelines, saga patterns, circuit breakers, human-in-the-loop integration |
| **eloquence** | Communication as a first-class concern: tone, audience, rhetorical structure, cross-cultural adaptation |



---

## The practitioner

Conjurer is designed for people who think in systems but prefer to communicate in intent. The ideal practitioner is not someone who wants to avoid writing code — it is someone who recognizes that the highest-leverage thing they can do is specify *what* a system should do with great clarity, and then trust a capable collaborator to determine *how*.

This requires a different skill than conventional programming. The skill is not precision in syntax — it is precision in *intent*. It is knowing what you want clearly enough to state it declaratively. It is knowing when to be specific and when to leave productive space for judgment. It is knowing when the first manifestation has revealed something about your requirements that you did not know before you saw it.

These are the skills of a good systems thinker, a good designer, a good product leader. Conjurer makes them executable.

---

## How to read this specification

**Start with the grimoires, not the constructs.** Each grimoire opens with a philosophical section that explains *why* it exists and what design principles govern it. Reading these sections gives you the language's shape before you encounter its surface.

**Read examples before signatures.** The function signatures are precise but abstract. The examples are concrete and reveal the intent behind the design. When a signature confuses you, skip to the first example.

**Treat the integration patterns as the curriculum.** The most important things in Conjurer happen at the boundaries between grimoires — where `d/explore` flows into `data/schema`, where `s/texan` feeds `e/format`, where `o/define-workflow` composes `w/component` generation. These patterns are where the language's expressive power becomes visible.

**Read the implementation notes for LLM processors.** Even if you are not building a Conjurer interpreter, these sections articulate the semantic commitments the language makes — what each construct promises, how ambiguity should be resolved, what "production quality" means in context. They are the language's contract with its runtime.

---

*Continue to [`grimoires/core.md`](grimoires/core.md) for the language's foundational constructs.*