# Changelog

All notable changes to this project will be documented in this file.

This changelog is intentionally initialized at the current maturity baseline.
Earlier exploratory evolution is treated as pre-history.

## 1.2.0 - 2026-07-01

### Added

- Specification evaluation with graded extension candidates (`proposals/2026-07-spec-evaluation.md`), scored with foresight's recommended set and expressed as `f/candidate` forms.
- User abstraction layer in `core`, closing the vocabulary–spec gap: `spell` (named reusable invocation pattern), `charm` (anonymous invocation for pipeline steps), and `incantation` (macro with a deterministic, inspectable expansion phase via `:expand :preview`).
- New core construct `grimoire` for packaging spells, lore, and shapes into a named, versioned practitioner grimoire, registrable via `asset`.
- New `:forbids` slot in the intent topology of `conjure`: load-bearing prohibitions with the same binding force as `:requires`, opposite sign.
- Two new ground truths in `conjurer.md`: "The artefact records the organization as much as the intent" (structure as organizational evidence — domain-motivated vs organization-motivated seams) and "An unexplained artefact is load-bearing until shown otherwise" (the action discipline for an unrecoverable why), plus a four-movement reading map at the head of the section.

### Changed

- Updated catalog and references (`index.edn`, `quick-reference.md`, `README.md`, `SKILL.md`, `conjurer.md`) for the expanded symbol surface (137 → 141).
- README no longer hardcodes the symbol count (it had drifted from `index.edn`).
- Compressed the "Symmetry compresses; broken symmetry informs" ground truth to half its length; its four claims (exploited symmetry, measured loss, manufactured counter-reading, plan/act separation) survive intact, and the plan/act corollary now cites incantation's preview phase alongside materialise's preflight.
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