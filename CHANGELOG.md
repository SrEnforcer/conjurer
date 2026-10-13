# Changelog

All notable changes to this project will be documented in this file.

This changelog is intentionally initialized at the current maturity baseline.
Earlier exploratory evolution is treated as pre-history.

## Unreleased

### Added

- `design/conjurer.cnj`: twenty decisions recovered from the design sessions of 2025-10-31 to 2026-10-12, read by speaker. Each says why where the maintainer gave a reason, and marks a reason as the model's where he accepted one. They date and explain four of the five house rules, record the June greenfield stance that later version decisions partly reversed, and show that the October candidates were adopted on delegation. Two reasons that were never given stay in `:open`.
- `design/conjurer.cnj`: the language's own charter. Goals, a decision log recovered from this changelog, the proposals, git and the maintainer's design notes — each entry graded with `:recovered` and its `:source` — plus four decisions taken on 2026-10-13, open questions where a reason was never recorded, and four graded `f/candidate` forms. The hoists `:decision/three-version-lines` and `:decision/template-owns-cnj-structure` now resolve. Listed in `README.md` and `SKILL.md` and shipped with the package.
- **Session transcripts as evidence** (`exhume.md` 2.0.0 → 2.1.0). `x/reconstruct-decisions` takes `:transcripts` in `:from` and a new `:transcripts` parameter locating them. A transcript is read by speaker: a choice the practitioner stated or accepted is a decision, a proposal the model made and nobody took up is not, and output accepted without comment gets a `:speculative` why. New example, implementation note *Read a transcript by speaker*, and key concepts *Speaker attribution* and *Crystallisation*. Catalogue `index.edn` 2.0.0 → 2.1.0 for the new key parameter.
- **The variance surface** (`core.md` 3.0.0 → 3.1.0). Part IV names the binding statements of a specification that only the `:llm` layer will honour, says how to read them off the form and how to move one off the surface, and `explain :show` gains `:variance-surface`. Implementation note and key concept added; `quick-reference.md` gains *Where a binding statement is honoured*; `SKILL.md` refers to it.
- **Crystallising an exploratory prototype**: a new integration pattern in `exhume.md`, with diagram, for turning a prototype built in conversation into a charter. `conjurer.md` gains *Conjurer is not vibe coding — but it can absorb it* under *What Conjurer is not*; `architecture.md` mentions the reverse flow as the way out of exploration.
- `architecture.md`: a high-level overview with diagrams — vocabulary, the determinism boundary between the specification, conjurer-mcp and the model, the specification stack, processing an invocation, plan before act, the round trip, and conjurer-mcp. Referenced from the end of `conjurer.md`.
- Specification evaluation of October 2026 (`proposals/2026-10-spec-evaluation.md`): the design questions left after the consistency and semantic passes — expression prelude, the time of execution primitives, names and decision identifiers, the confidence vocabulary, ownership of the `.cnj` structure, practitioner grimoires, `shape`, and the version model — graded as twelve `f/candidate` forms, three of them alternatives recommended against.

### Changed

- Adoption of the October 2026 evaluation (`proposals/2026-10-spec-evaluation.md`, Part V). Grimoire versions: core 2.4.0 → 3.0.0, exhume 1.1.2 → 2.0.0, agent 1.1.1 → 2.0.0, foresight 1.0.0 → 1.1.0, semantics 2.1.0 → 2.1.1, reasoning 1.2.2 → 1.2.3, orchestrate 2.1.1 → 2.1.2. Catalogue `index.edn` 1.7.0 → 2.0.0. Package and release-please manifest aligned with this changelog at 1.2.0.
- **Names and references.** A name may be written as a symbol or a keyword; references to a kind of form use namespaced keywords (`:decision/...`, `:target/...`, `:spell/...`, `:core/...`).
- **Decision identifiers.** Charter decisions carry `:id` and `:supersedes`; a reversal is a new entry, never an edit. `f/hoist :into` uses `:decision/<id>`.
- **The `.cnj` structure** is defined only in `template.md` Part II, now nine sections with abstractions (lore, shape, spell, grimoire) and foresight; the template no longer copies signatures. Core keeps a diagram and a pointer; core Part VII follows its construct map.
- **The prelude.** Core Part V lists the expression forms every processor understands and a deterministic processor may evaluate; every other head is a semantic function. Incantation expansion and structural `ensure` predicates follow the rule; `index.edn` carries `:prelude`.
- **Time by position.** A core execution primitive is performed when it stands alone and describes the artefact when it stands inside a manifestation; `conjure` gains `:behaviour`, and runtime examples moved inside the `conjure` they describe.
- **Confidence.** Two axes, provenance and degree, with shorthand for either and numbers only with a named basis. *Breaking:* `x/recover-model` and `x/reconstruct-decisions` take `:grade :each` instead of `:confidence :grade-each`; `a/define :style` takes `:disposition` instead of `:confidence`.
- **Practitioner grimoires.** Spells enter a namespace by name, a practitioner grimoire is a `.cnj` file, `asset :type :grimoire` is listed, and the namespace rule in `template.md` matches `data/`.
- **`shape`** gains `:extends` and `:sensitive-fields` by class (`:phi`, `:pii`, `:pci`).
- **Sensitive fields.** *Breaking:* `data/schema` takes `:sensitive-fields` with the same classes as `shape` instead of `:phi-fields` and `:pci-fields`, and drops the per-field `:phi true` and `:pci true` markers; the `:phi-fields` shorthand on `shape` is removed. `:gdpr` now applies to `:pii` fields, not PHI. data 2.1.1 → 3.0.0.
- **Three version lines** are stated in `template.md` and `README.md`: release, catalogue, grimoire.
- Template example rule relaxed to at least one example per construct; `s/synthesise` gains its example; example corrections in core and foresight (a candidate's own `:status` is never edited; its current status is read from `:history`).

### Fixed

- Consistency pass after the 2026-10-12 specification review. No symbol was added, removed or renamed; the catalogue is unchanged.
- `SKILL.md` brought in line with `core`: the eighth principle, calibrated certainty, added; `:requires` counts as constraint intent only when its value is a field-to-constraint map; `:as` removed from the output-binding equivalence class (it names a result shape and is the `as` construct); the fast reference gains `materialise`, `spell`, incantation preview, the certainty qualifiers, `given` and `ensure`, and the skill description names them; `(target :typescript ...)` corrected to name the output; `:forbids` added to the result-quality rule; hardcoded symbol counts removed.
- The phantom form `(context establish ...)` removed from `SKILL.md`, `template.md` and `examples/conjurer-site/domain.cnj`.
- `conjurer.md`: the ecosystem section now names all six project-level constructs (`materialise` and `grimoire` were missing); repeated passages in the ground truths replaced by references to the principles they restate; "fully determined" softened to "largely determined"; "not a specification language" sharpened to "not a formal specification language".
- `template.md`: the bar `|` is documentation notation for signatures only; an invocation or `.cnj` file writes a choice as `(one-of ...)`. `examples/dice-forge.cnj` follows the rule.
- `core.md` (2.3.0 → 2.3.1): phantom forms in examples replaced (`validate` → `data/validate`, `(order :status :paid)` → a free-variable predicate, nameless `retry` and positional `parallel` given their signatures, a target-less `witness` wrapped around its invocation); `:forbids` added to the intent-topology key concept; `refine :when` described as dormant rather than "activates automatically"; `allow` values called illustrative rather than placeholders; drafting-history phrases removed; plain-text fences tagged.
- `eloquence.md` (2.1.0 → 2.1.1): `e/refine` → core `refine`. `reasoning.md` (1.2.0 → 1.2.1): `o/branch` → core `branch`. `data.md` (2.1.0 → 2.1.1), `domain.md` (2.1.0 → 2.1.1), `web.md` (2.1.0 → 2.1.1): drafting-history phrases removed.
- British spelling completed in `conjurer.md`, `README.md`, `template.md`, `quick-reference.md`, `agent.md` (1.1.0 → 1.1.1) and `exhume.md` (1.1.1 → 1.1.2), including catalog → catalogue in prose. Symbol names (`e/formalize`, `e/localize`, `w/analyze`) and parameter keywords are unchanged.
- `quick-reference.md`: the `materialise` row gains its Part column and follows the construct-map order.

### Changed

- Semantic fixes after the 2026-10-12 specification review (round 2). `index.edn` 1.6.0 → 1.7.0 for key-parameter changes; no symbol was added, removed or renamed.
- `branch :cases` and `ward :recover` are vectors of pattern–operation pairs, tried in the order written, first match wins. As maps they relied on an order EDN does not have, while `branch` examples used overlapping predicates and the `ward` note matched "in declaration order". A new `branch` implementation note states the matching rule.
- Odd-arity parameters removed: `ward :escalate :when p` → `:escalate-when p`; `refine :deepen :by n` → `:deepen n`; `:for-each resource-in coll` → `:for-each coll`. `template.md` gains a "Form shape" rule: `(head name :param value ...)`, with value qualifiers, anonymous forms and relational forms as the named exceptions, and parameters always in pairs.
- `ensure` no longer over-claims a layer: `:verify-via :mcp` applies only where the MCP server offers a structural checker for the artefact, and otherwise falls back to `:llm`, said out loud; `:on-violation :halt` defined for layers that run after materialisation (`:tests`, `:lint`).
- `conjure` lists `:within` (the attachment point for `ensure`, used throughout but never declared); `ensure` explains why it attaches while `given` stands alone.
- `refine` gains `:because` (used in core and `conjurer.md`, never declared) and may refine a `spell`: the pattern changes for later casts, earlier manifestations are not regenerated.
- Lifetimes given an end: `given :scope :session` lasts until a later `given` states a contrary fact; `context :active-in :block` lives within the `using` form that applies it; `given :scope :block` names real enclosing forms instead of `do`.
- Grimoire versions: core 2.3.1 → 2.4.0, reasoning 1.2.1 → 1.2.2, taxonomy 1.1.0 → 1.1.1, orchestrate 2.1.0 → 2.1.1 (a nameless `ward` with `:protect nil` in the circuit-breaker template replaced by a plain fallback). `README.md` and `SKILL.md` examples follow the new forms.

## 1.2.0 - 2026-07-01

### Added

- Named the paradigm. `conjurer.md` gains a "What Conjurer is" section (the positive sibling of "What Conjurer is not") classifying the language as **intent-sourced programming** — *intent is the source, code is the build* — with its four commitments (semantic execution, spec-as-authority, first-class uncertainty, bidirectionality) and its lineage (MDA, Simonyi's Intentional Programming, contrasted with Spec-Driven Development). Echoed as a one-liner in `README.md`.
- The Dice Forge (`examples/dice-forge.cnj`): the canonical single-file example, a browser dice workshop replacing the duplicate single-file copy of the conjurer-site project. `examples-README.md` reworked to index three distinct worked projects (dice-forge, conjurer-site, conjurer-mcp) rather than two organisational patterns of one.
- Specification evaluation with graded extension candidates (`proposals/2026-07-spec-evaluation.md`), scored with foresight's recommended set and expressed as `f/candidate` forms.
- User abstraction layer in `core`, closing the vocabulary–spec gap: `spell` (named reusable invocation pattern), `charm` (anonymous invocation for pipeline steps), and `incantation` (macro with a deterministic, inspectable expansion phase via `:expand :preview`).
- New core construct `grimoire` for packaging spells, lore, and shapes into a named, versioned practitioner grimoire, registrable via `asset`.
- New `:forbids` slot in the intent topology of `conjure`: load-bearing prohibitions with the same binding force as `:requires`, opposite sign.
- Two new ground truths in `conjurer.md`: "The artefact records the organization as much as the intent" (structure as organizational evidence — domain-motivated vs organization-motivated seams) and "An unexplained artefact is load-bearing until shown otherwise" (the action discipline for an unrecoverable why), plus a four-movement reading map at the head of the section.

### Changed

- Updated catalog and references (`index.edn`, `quick-reference.md`, `README.md`, `SKILL.md`, `conjurer.md`) for the expanded symbol surface (137 → 141).
- README no longer hardcodes the symbol count (it had drifted from `index.edn`).
- Compressed the "Symmetry compresses; broken symmetry informs" ground truth to half its length; its four claims (exploited symmetry, measured loss, manufactured counter-reading, plan/act separation) survive intact, and the plan/act corollary now cites incantation's preview phase alongside materialise's preflight.
- Deep pass over `taxonomy.md` (grimoire → 1.1.0). Fixed a catalog contradiction: `quick-reference.md` documented `:membership` as `:monothetic | :polythetic` while the grimoire defines `:rules | :examples | :both` — the parameter is now documented in the grimoire (mapping the styles to monothetic/polythetic classification) and the quick-reference matches. Added the missing `:manifest` parameter to `t/validate` and `t/browse` (the library's only constructs without it). Added `:driver` to `t/evolve`, carrying `d/evolve`'s epistemic distinction (the domain moved vs. the carving was wrong) into taxonomy evolution, with boundary notes distinguishing `t/evolve`/`d/evolve` and `t/align`/`d/compare`. Example fixes: a `data/transform` op missing its `:fields` key, two malformed `r/decide` usages rewritten (one as a proper `branch` route), and the crosswalk-as-taxonomy usage pattern replaced with an honest browse-then-reclassify flow. Catalogs synced (`index.edn` also gained `t/evolve`'s missing `:version` key-param).
- Hardened the "Implementation notes for LLM processors" genre. `template.md` now defines the genre's contract: a modality scale (must/never binding; prefer/should yielding-but-surfaced; flag = surface-and-continue — the certainty vocabulary applied to the language's own instructions), a precedence rule (explicit invocation parameters > implementation notes > inference from examples), layer attribution for runtime-property directives, and per-construct (not per-pipeline) binding of disciplines; `SKILL.md` echoes the precedence rule. Core's "Semantic understanding" note now disambiguates the three readings of `:requires` (topology vector, validation map, stage dependency) by value shape. A new core note, "Exceeding the requested scope", states the shared rule that reconciled semantics' apply-only-requested-models discipline with web's always-surface-error-paths discipline; both notes now cross-reference it. Runtime-property directives in orchestrate (circuit-breaker shared state, audit immutability) and agent (audit-log immutability) reframed as generation directives with honest layer attribution.
- Editorial pass over the remaining nine grimoires. `data.md` and `orchestrate.md`: replaced all host-language `fn` lambdas with the free-variable predicate convention (`(> age 18)`, `(= status :shipped)`) and native `charm` forms; `clojure.string/lower-case` → `:using :lowercase`; pipeline stage keys `:fn` → `:do` (matching `ritual`); `o/fan-out`'s `:reduce-fn` renamed to the declarative `:reduce-with` (catalog updated); `o/react`'s event mapping and dedup keys made declarative. `reasoning.md` and `exhume.md`: removed the REPL idiom `*1` from usage patterns. `semantics.md`: `(/ 1 5)` → the EDN ratio literal `1/5`; `s/viewpoint :as` signature now admits the vector form its example uses. `eloquence.md`: restructured an integration pipeline that referenced unbound names. `agent.md`: the witness integration example now wraps the composition invocation rather than observing its result after the fact. `web.md`: removed the stale "Responsive" key concept that contradicted `w/responsive`'s strategy-not-a-switch philosophy. `data.md`: one remaining "original spec" drafting phrase removed. `taxonomy.md` and `foresight.md` required no changes.
- Editorial pass over `domain.md` examples and prose: fixed the phantom `context establish` form (core's `context` takes only a name), retitled the mislabelled "Dutch healthcare" example (it models the US ACA), aligned `d/query`'s result-shape parameter with `d/extract` (`:as`), activated the generated healthcare DSL via `using` instead of a raw Clojure `require`, cross-linked `d/generate-dsl :conjurer-extension` to the new core `grimoire` construct, removed drafting-history phrases ("the original spec/design"), extended the Part II intro to cover its structure/evolution constructs, and normalised spelling (modeling → modelling, artifact → artefact, stray `:nl` default → `:en`).
- Editorial pass over `core.md` examples and prose: fixed phantom symbols (`e/format` → `e/compose`; `d/comprehensive-analysis` removed), replaced host-language `fn`/`map`/`#()` escapes with native `charm` and `o/fan-out` forms, blessed `def` as the outer equivalent of `:manifest`, documented the unit-form idiom (`(eur 10000)`, `(minutes 5)`) and the predicate-binding convention, added a "One state, five homes" disambiguation table (`context` / `assume` / `given` / `lore` / `asset`), added a materialise implementation note, and normalised spelling (artifact → artefact).

## 1.1.0 - 2026-06-10

### Added

- New `foresight` grimoire (`f/`) for forward-looking deliberation with `f/candidate`, `f/reassess`, and `f/hoist`.
- New core construct `materialise` for two-phase target execution: deterministic preflight followed by semantic generation.

### Changed

- Updated catalog and references (`index.edn`, `quick-reference.md`, `README.md`, `SKILL.md`) to include the expanded grimoire/symbol surface.
- Extended `r/decide` with optional `:from-candidates` traceability to connect decisions to foresight candidates.
- Expanded `x/recover-stack` to model external package-sourced standards and distinguish `:implicit` conventions alongside `:declared` and `:enforced` evidence.

## 1.0.0 - 2026-06-06

### Added

- Mature, internally coherent Conjurer specification baseline.
- Complete standard grimoire library including `exhume` as reverse-flow complement.
- Unified symbol catalog and reference set for current language surface.

### Notes

- This entry marks the point where the project reached its current detailed and durable form.