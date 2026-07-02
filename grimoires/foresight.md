# foresight.md — Conjurer Foresight Grimoire

The spellbook for what might become. Every other grimoire works on what *is* —
intent to manifest, a domain to model, code to recover, a decision to make.
`foresight` works on what is *not yet*: capabilities deliberately deferred,
graded on arrival, reassessed as the project changes around them, and eventually
either promoted to a decision or allowed to lapse. It is how a project keeps an
honest, dated account of the ideas it set aside on purpose.

---

## Philosophy

### The deliberation gap

Conjurer already reasons richly about the present and the past. `r/decide`
selects among live alternatives; `r/revise` propagates the consequences of a
fact that turned out wrong; `r/hypothesise` ranks explanations for an
observation. And `conjure :deferred` records, inline, that a capability was
noted but not manifested in this invocation. These are good tools, and between
them they cover reasoning over what *is* and what *was*.

None of them covers what *might become*. The gap is not a reasoning gap — it is
a **deliberation gap**. When a practitioner sets an idea aside, they are not
making a decision (there is nothing to decide yet) and they are not inferring
anything (there is no observation to explain). They are forming a *graded
opinion about a future possibility*: this is worth keeping, here is how
attractive it looks right now, here is why now is not the time, and here is what
would have to change for that to change. `conjure :deferred` records the bare
fact of deferral — what was not done — but says nothing about how attractive the
deferred thing is, why it was kept rather than abandoned, or when that judgment
should be revisited. A project accumulates dozens of such deferrals across many
invocations with no way to triage them, compare them, or see how the team's view
of them moved over time.

`foresight` fills that gap. It gives the deferred idea a graded record, a dated
lifecycle, and a history — so that a backlog of "maybe later" is not a pile of
forgotten notes but a maintained, honest account of structured opinion under
uncertainty about the future.

### Why this is a different epistemic posture

It would be tempting to file these forms under `reasoning`, but the epistemic
mode is genuinely different, and the difference is the reason `foresight` is its
own grimoire. The `r/` forms perform *inference over a model* — they derive,
verify, and revise conclusions from premises and observations. Prospective
deliberation is not inference. There is no model to reason over, because the
subject is a possibility that does not yet exist; there is only judgment formed
under uncertainty about a future context that has not arrived. Forming and
maintaining that judgment honestly — grading it, dating it, revisiting it as
conditions change without erasing what you thought before — is a discipline of
its own. It is closer to keeping an honest journal of intent than to drawing a
conclusion.

This is also why `foresight` is not project management. It records deliberate,
graded opinion, not tasks, tickets, assignees, or milestones. It imposes no
ordering and enforces no workflow. It is the structured-opinion layer that sits
*before* `r/decide` — the backlog phase, while options are still maturing — and
it provides exactly what `conjure :deferred` deliberately omits: structure,
grading, and history.

### Principles

**A deferred idea is a graded candidate, not nothing.** The discipline of
foresight is to treat "maybe later" as a first-class object with an assessment
attached, not as a comment that rots. What you chose not to build is information,
and recording *why* and *how attractive* makes it actionable when the time comes.

**Keep the assessment honest over time.** A candidate's attractiveness changes as
the project changes around it — a dependency lands and difficulty drops, a market
shifts and value rises. The honest response is to record a *dated reassessment*,
not to edit the original score. Editing erases the trajectory; the trajectory is
how a future reader understands why the team's view moved, and it is itself
evidence worth keeping. This is the durable-intent ground truth applied to
opinion: the judgment is perishable, so preserve each version of it with its date.

**A candidate must say why it was deferred, not merely that it was.** A candidate
without a rationale for deferral is indistinguishable from an abandoned one — it
records that something was not done but not why it is worth keeping. The rationale
is what makes the candidate reconsiderable; without it, reassessment has nothing
to push against.

**Opening and closing are symmetric.** `conjure :deferred` opens a capability's
existence as a noted-but-unmanifested thing; `f/hoist` closes it by promoting it
to the decision or target it became. A candidate that matures should graduate
through an explicit, dated event that binds it forward to what it turned into —
not vanish silently from a backlog or get edited into a tombstone comment.

### Naming rationale

**`foresight`** — The faculty of looking ahead and judging what is worth
preparing for. Not prediction (foresight does not claim to know the future) but
*prudent attention to possibility* — exactly the posture of grading a deferred
idea and keeping that grade honest as the future arrives.

**`f/`** — The namespace prefix.

**`candidate`** — From Latin *candidatus*, one who stands for selection. A
candidate is not yet chosen; it stands in the pool, assessed, awaiting the moment
when a decision becomes live. The word carries exactly the pre-decision status the
form records.

**`reassess`** — To assess again. Not to *correct* (the original was right for its
time) but to *re-judge* against changed context. The prefix *re-* is doing honest
work: it marks a new assessment in a series, not a replacement of the old one.

**`hoist`** — To raise up. A candidate that has earned promotion is hoisted out of
the backlog and into a decision — lifted from "might become" to "is." The word
connotes a deliberate, effortful lift, which is what graduating a candidate should
be: an event, not a quiet edit.

---

## Part I: Grading and tracking candidates

### `f/candidate`

Records a deliberately deferred capability as a graded, dated, lifecycle-bearing
candidate for future decision-making. The first-class object that `conjure
:deferred` only gestures at.

#### Signature

```clojure
(f/candidate :id identifier
  :label      "human-readable description"
  :added      "YYYY-MM-DD"               ;; when this candidate was first recorded
  :status     :proposed                  ;; :proposed | :planned | :hoisted | :abandoned
  :scores     {:feasibility 1-10
               :elegance    1-10
               :containment 1-10
               :value       1-10}
  :rationale  "why this is worth keeping, and why it is deferred not abandoned"
  :conditions ["what would have to change for this to be reconsidered"]  ;; optional
  :cluster    keyword                    ;; optional: grouping / affinity tag
  :history    [reassessment ...])        ;; optional: dated reassessments (see f/reassess)
```

#### Parameters

**`:id`** — A stable identifier. Reassessments and the eventual hoist reference
it, so it must not change once recorded.

**`:status`** — Lifecycle position: `:proposed` (noted, not yet committed to a
cycle), `:planned` (accepted into an upcoming cycle), `:hoisted` (promoted to a
decision — set by `f/hoist`), `:abandoned` (deliberately dropped, with a dated
reason in `:history`).

**`:scores`** — A multi-dimensional assessment. The *structure* (a map of
dimension to a number) is fixed; the *dimensions and scale* are conventional. The
recommended set normalises polarity so that **higher is always better**, which
makes scores summable at equal weight without sign-juggling:

```clojure
;; Recommended scoring set. Scale 1–10. Higher is always more attractive, so a
;; plain sum at equal weight is a fair total. A project may choose different
;; dimensions or a 1–5 scale, but should be consistent across its candidates so
;; reassessment trajectories remain comparable.
;;   :feasibility — how achievable        (1 = very hard,  10 = trivial)
;;   :elegance    — fit with the design    (1 = hacky,      10 = native/pure)
;;   :containment — how contained the change (1 = large blast radius, 10 = tiny)
;;   :value       — usefulness in practice  (1 = marginal,   10 = essential)
```

**`:rationale`** — Required. Why the candidate is worth keeping *and* why it is
deferred rather than abandoned. A candidate without this is indistinguishable from
an abandoned idea.

**`:conditions`** — Optional triggers for reconsideration ("once the parser is
ported", "if a second consumer appears"). They turn a vague "later" into a
checkable "when".

**`:history`** — Optional list of dated reassessments (each an `f/reassess`,
below). Co-located with the candidate so a reader sees the whole trajectory in one
place.

#### Design rationale

`f/candidate` exists because `conjure :deferred` is deliberately minimal and a
project needs more. `:deferred` records, inline within a manifestation, that a
capability was noted and not built — and that is the right scope for it; it should
stay minimal. But it offers no way to say how attractive the deferred thing is,
why it survived rather than being dropped, or when the judgment should be
revisited, and it offers no way to gather deferrals from across many invocations
into one triageable place. `f/candidate` is that place: a standalone, graded,
dated record of a single deferred possibility.

It is distinct from `r/decide` precisely because no decision is being made. The
practitioner is maintaining the *pre-decision* backlog — ranking and re-ranking
options while they mature, before any of them is live enough to commit to.
`r/decide` is the moment options are evaluated to an outcome; `f/candidate` is the
patient phase before that moment, where the candidates accumulate their
assessments and their histories so that, when a decision does become live,
`r/decide` has a well-graded set to work from.

The required `:rationale` and the optional `:conditions` are what make a candidate
*reconsiderable* rather than merely *recorded*. A backlog of deferred ideas with
no reasons is a graveyard; a backlog where each entry says why it was kept and
what would change its standing is a working instrument. The discipline the form
enforces is small but real: to defer honestly, say why.

#### Example: A deferred capability, graded on arrival

```clojure
(f/candidate :diff-intent
  :label   "x/diff-intent — detect drift between a .cnj and the code it produced"
  :added   "2026-06-07"
  :status  :proposed
  :scores  {:feasibility 6 :elegance 8 :containment 7 :value 8}
  :rationale "Now that exhume can recover a spec from code, comparing that against
              the authored .cnj is the natural next capability — it would make
              exhume a maintenance tool, not just a bootstrap one. Deferred because
              the recovery arc only just stabilised; a drift tool built on an
              unproven recovery would inherit its uncertainty."
  :conditions ["exhume has had at least one more real-world validation run"
               "x/recover-stack's output proves stable across ecosystems"]
  :cluster :exhume-v2)
;; ✓ A first-class record: graded (every dimension higher-is-better, so the total
;;   29/40 is a fair at-a-glance attractiveness), dated, with a rationale that says
;;   why it is KEPT and why DEFERRED, and explicit conditions for reconsideration.
;;   This is everything conjure :deferred omits, made durable.
```

#### Usage patterns

```clojure
;; Gather a project's deferred ideas into a comparable, triageable backlog
(f/candidate :salvage     :label "x/salvage — reuse triage" :added "2026-06-07"
  :status :proposed :scores {:feasibility 7 :elegance 6 :containment 8 :value 6}
  :rationale "…" :cluster :exhume-v2)
(f/candidate :diff-intent :label "x/diff-intent — drift detection" :added "2026-06-07"
  :status :proposed :scores {:feasibility 6 :elegance 8 :containment 7 :value 8}
  :rationale "…" :cluster :exhume-v2)
;; same :cluster makes them comparable as a group; the score totals rank them
```

---

### `f/reassess`

Records a dated re-evaluation of an existing candidate as the project's context
changes — a new assessment in a series, never a replacement of the old one.
Preserves the trajectory of the team's evolving judgment.

#### Signature

```clojure
(f/reassess :of identifier               ;; the :id of the f/candidate being reassessed
  :date       "YYYY-MM-DD"
  :scores     {:feasibility 1-10         ;; only the dimensions that changed need appear
               :value       1-10}
  :rationale  "what changed in the context, and why the assessment changed"
  :status     :planned)                  ;; optional: if the reassessment moves the lifecycle
```

This is normally recorded inside the candidate's `:history` list, keeping the
whole trajectory co-located and readable in one place.

#### Parameters

**`:of`** — The `:id` of the candidate being reassessed.

**`:date`** — When this reassessment was formed. Dating is the whole point: a
series of dated reassessments is the trajectory.

**`:scores`** — The updated dimensions. Only those that changed need appear; the
rest are understood to carry forward from the prior assessment.

**`:rationale`** — What changed in the *context* (not a correction of a past
error) and why the assessment moved. "The parser landed, so feasibility rose from
6 to 9" is a reassessment; "the original 6 was a mistake" is not — that would be
an edit, and edits erase history.

**`:status`** — Optional. A reassessment may move the lifecycle (e.g.
`:proposed` → `:planned`) when the changed assessment warrants it.

#### Design rationale

`f/reassess` exists to keep the candidate's assessment honest *over time* without
destroying its past. The naïve alternative — editing the original `:scores` in
place when the team's view changes — silently erases the trajectory, leaving a
reader unable to see that a capability was once judged low-value and became
high-value, or why. That lost trajectory is exactly the kind of evidence the
language fights elsewhere to preserve: the durable-intent ground truth says the
judgment is perishable, so each version of it must be kept with its date.

The form is deliberately distinct from `r/revise`, and the distinction is the
reason it lives here rather than in `reasoning`. `r/revise` handles a *fact* that
turned out wrong: a premise is corrected and the consequences propagate through
prior conclusions. `f/reassess` handles a case where nothing was wrong — the
original assessment was correct *for its time* — but the *context* changed and the
judgment should be revisited. One is correction; the other is dated re-judgment.
Conflating them would mislead a reader into thinking a past assessment was an
error when it was simply superseded.

A sequence of `f/reassess` entries forms a **scored trajectory**, and that
trajectory is useful in its own right: tooling over the history can surface
candidates whose scores are trending upward (rising priority) or whose most recent
reassessment is old (a stale judgment overdue for another look). None of that is
possible if reassessment happens by editing the original in place.

#### Example: A candidate reassessed after a dependency lands

```clojure
;; The candidate, later, with two dated reassessments in its history:
(f/candidate :diff-intent
  :label  "x/diff-intent — detect drift between a .cnj and the code it produced"
  :added  "2026-06-07"
  :status :planned
  :scores {:feasibility 6 :elegance 8 :containment 7 :value 8}   ;; original, preserved
  :rationale "…"
  :history [
    (f/reassess :of :diff-intent
      :date    "2026-08-14"
      :scores  {:feasibility 9}             ;; only feasibility moved
      :rationale "x/recover-stack proved stable across Node, Python, and .NET in
                  three real runs — building a drift tool on it is now low-risk,
                  so feasibility rose from 6 to 9. Value and the rest unchanged."
      :status  :planned)                    ;; promoted from :proposed
    (f/reassess :of :diff-intent
      :date    "2026-10-02"
      :scores  {:value 9}
      :rationale "A second team started consuming recovered .cnj files; drift
                  between spec and code now bites more than one project, so value
                  rose from 8 to 9.")])
;; ✓ The original scores are untouched; each reassessment is dated, scoped to what
;;   changed, and carries its own rationale. The trajectory (feasibility 6→9,
;;   value 8→9) is visible and explains WHY the team's view rose — none of which
;;   survives if you just edit the original numbers.
```

---

## Part II: Closing a candidate

### `f/hoist`

Promotes a mature candidate out of the backlog and into the decision or target it
becomes — a single, dated graduation event that binds the candidate forward to
its outcome. The structural counterpart of `conjure :deferred`: where `:deferred`
opens a candidate's existence, `f/hoist` closes it.

#### Signature

```clojure
(f/hoist :of identifier                  ;; the :id being promoted
  :date     "YYYY-MM-DD"
  :into     decision-reference           ;; the decision, target, or spell it becomes
  :outcomes [keyword ...]                ;; what the promotion produced
  :note     "optional rationale for the timing")
```

After an `f/hoist`, the candidate's `:status` is considered `:hoisted`.

#### Parameters

**`:of`** — The `:id` of the candidate being promoted.

**`:date`** — When the promotion happened.

**`:into`** — A reference to the artefact the candidate became: a `charter`
decision entry, a new `target`, a new spell. This is the forward binding — it lets
a future reader follow the candidate's history *forward* to the thing that closed
it, rather than losing the thread at the moment of promotion.

**`:outcomes`** — What the promotion produced (e.g. `[:new-grimoire :catalog-bump]`),
a compact record of the candidate's consequences.

**`:note`** — Optional rationale for *why now* — what tipped the candidate from
"planned" to "done".

#### Design rationale

`f/hoist` exists because a candidate that matures needs a *graduation*, not a
quiet disappearance. In practice, without it, promotion is modelled by hand in two
disconnected places — a tombstone comment where the candidate used to live, and a
fresh entry in `charter :decisions` — with no structural link between them. The
candidate's history simply stops, and a reader cannot follow it forward to the
decision it became. `f/hoist` makes the promotion a single act that records the
final status, dates it, and — crucially — *binds the candidate to its outcome* via
`:into`, so the thread survives.

The form completes a symmetry the language already half-expresses. `conjure
:deferred` opens a capability's life as a noted-but-unmanifested possibility;
`f/hoist` closes it by lifting it into the decision or target it became. Between
the two sits the candidate's whole tracked existence — graded at `f/candidate`,
re-judged through `f/reassess`, and finally graduated at `f/hoist`. This is the
opening/closing symmetry the broken-symmetry ground truth names, made concrete: a candidate
is not conserved across its lifecycle (it stops being a candidate), but its
history is *accounted for* — the `:into` binding ensures what it became is
followable, even after it retires from the backlog.

There is deliberately no separate `f/abandon`. Abandonment is a status, not an
event: it produces nothing, binds to nothing, and is fully captured by a dated
`f/reassess` that sets `:status :abandoned` with a rationale. Hoisting is an event
because it *produces* something — a decision, a target, a spell — and that
production is what `:into` and `:outcomes` record. Inventing an `f/abandon` to
mirror `f/hoist` would be the symmetry-for-its-own-sake error the broken-symmetry
ground truth warns against: not every act has a meaningful inverse, and forcing one here
would add a form that records nothing the candidate's own status does not.

#### Example: Promoting a candidate to a decision

```clojure
(f/hoist :of :diff-intent
  :date     "2026-11-20"
  :into     :charter-decision/x-diff-intent-accepted
  :outcomes [:new-construct :exhume-version-bump :catalog-update]
  :note     "Two consumers and a stable recovery layer made the drift tool worth
             building; promoted into a charter decision to add x/diff-intent to
             the exhume grimoire.")
;; The original candidate's :status is now :hoisted. Its history (original scores +
;; two reassessments) remains, and :into binds it forward to the decision it became —
;; so a future reader can trace diff-intent from first deferral to final acceptance.
;; ✓ One dated event, not a tombstone comment plus a disconnected decision entry.
```

---

## Best practices

### Defer with a reason or do not defer

The required `:rationale` is the heart of the form. A candidate that records only
*that* something was set aside, not *why* it is worth keeping, is an abandoned idea
wearing a candidate's clothes. If you cannot say why it is worth keeping, abandon
it honestly (`:status :abandoned`) rather than letting it clutter the backlog.

### Reassess, never edit

When the project changes and a candidate's attractiveness moves, add a dated
`f/reassess` to its `:history` — do not edit the original `:scores`. The original
was right for its time; editing it erases the trajectory that explains how the
team's view evolved, and the trajectory is the most useful thing the form
produces.

### Keep the scoring set consistent

Pick a scoring set and a scale and hold to them across the project's candidates.
Comparable scores are what make a backlog triageable and a trajectory meaningful;
a candidate scored on a 1–5 value scale cannot be compared to one scored 1–10, and
a reassessment that switches scales records nothing useful. The recommended set
(feasibility, elegance, containment, value, all higher-is-better) makes totals
summable at equal weight, but any consistent set works.

### Hoist as an event, abandon as a status

When a candidate graduates, record an `f/hoist` with its `:into` binding so the
thread survives forward to what it became. When a candidate is dropped, a dated
`f/reassess` setting `:status :abandoned` is enough — do not reach for a symmetric
"abandon event" that records nothing the status does not.

### Anti-patterns

**The rotting backlog.** A pile of `f/candidate`s that are never reassessed is
worse than no backlog, because it looks maintained while being stale. A candidate
whose most recent assessment is a year old is making a year-old claim about a
project that has moved on. Reassess periodically, or abandon honestly.

**Editing scores in place.** Silently changing a candidate's original `:scores`
when your view changes destroys the trajectory and makes the history a lie — the
record will show only the latest judgment, dated as if it were the first. Always
reassess with a new dated entry.

**Rationale-free deferral.** Recording a candidate with no `:rationale` (or a
hollow one like "might be useful") produces an entry no one can act on at
reassessment time, because there is nothing to test the changed context against.
The rationale is what a reassessment pushes against.

**Treating it as a task tracker.** `foresight` records graded opinion, not work.
The moment a candidate grows an assignee, an effort estimate, and a due date, it
has left the grimoire's purpose — those belong in a project tool, not in a `.cnj`.
A candidate is a judgment about a possibility, not a commitment to do work.

**Mistaking a candidate for a decision.** A `f/candidate` is explicitly
pre-decision. Using it to record something already committed to skips the
deliberation it exists to support; record the commitment as a `charter` decision
or a `target` instead, and reserve candidates for what is genuinely still maturing.

---

## Integration patterns

### Foresight sits before reasoning

The `f/` forms maintain the backlog; `r/decide` consumes it when options become
live. The clean handoff is that a set of mature candidates becomes the alternative
set a decision evaluates.

```clojure
;; When the time comes to commit, the candidates become live alternatives
(r/decide
  :among         [:diff-intent :salvage :counter-manifest-tooling]
  :from-candidates [:diff-intent :salvage :counter-manifest-tooling]   ;; the f/candidate ids
  :criteria      [:value :feasibility :strategic-fit]
  :manifest      v2-direction)
;; :from-candidates closes the loop: the decision records which deliberation it
;; grew from, so the chosen candidate's history connects forward to the decision,
;; just as f/hoist :into connects it the other way.
```

### Foresight closes back into the charter

A hoisted candidate becomes a charter decision, and the `:into` binding makes the
candidate's whole history a traceable preamble to that decision.

```clojure
(~> (f/hoist :of :diff-intent :into :charter-decision/x-diff-intent-accepted
      :outcomes [:new-construct])
  ;; the charter gains a decision; the candidate's graded history explains how it
  ;; got there — deferral, reassessments, and the conditions that finally tipped it
  )
```

### Foresight and conjure :deferred

`conjure :deferred` and `f/candidate` are complementary, not redundant.
`:deferred` is the inline, local note within a manifestation that a capability was
not built; `f/candidate` is the standalone, graded, tracked record of one such
deferral promoted into the backlog. A natural flow is to note `:deferred` items as
they arise during manifestation, then promote the ones worth tracking into
`f/candidate`s.

```clojure
;; During manifestation, a capability is noted as deferred (local, minimal):
(conjure payment-processor
  :handles  [:charge :refund]
  :deferred [:multi-currency :installment-plans])

;; Worth tracking? Promote one into a graded candidate (standalone, durable):
(f/candidate :multi-currency
  :label  "multi-currency support for the payment processor"
  :added  "2026-06-09" :status :proposed
  :scores {:feasibility 5 :elegance 7 :containment 4 :value 9}
  :rationale "High value once we expand beyond one market; deferred because the
              single-currency path must prove out first. Low containment — touches
              pricing, display, and settlement.")
```

---

## Grimoire metadata

```clojure
{:grimoire    "foresight"
 :namespace   "f/"
 :version     "1.0.0"
 :description "Forward-looking structured opinion: graded deferred candidates,
               dated reassessment that preserves the trajectory of judgment, and
               the lifecycle promotion that closes a candidate into a decision"

 :constructs {
   :grading-and-tracking [f/candidate f/reassess]
   :closure             [f/hoist]}

 :best-for [
   "Maintaining a graded backlog of deliberately deferred capabilities"
   "Recording why an idea was kept rather than abandoned, and under what conditions to reconsider"
   "Tracking how the team's assessment of a possibility changed over time, with dates"
   "Promoting a mature candidate into a decision with a traceable forward binding"
   "Triaging many conjure :deferred items into a comparable, maintained set"]

 :works-with [:core :reasoning]

 :key-concepts [
   {:term "Deliberation gap"
    :definition "The space between reasoning about what is (the r/ forms) and the
                 bare inline note of what was deferred (conjure :deferred):
                 forming and maintaining a graded opinion about what MIGHT become.
                 foresight fills it."}
   {:term "Graded candidate"
    :definition "A deliberately deferred capability recorded as a first-class
                 object — multi-dimensional score, lifecycle status, date, and a
                 required rationale for deferral — rather than a comment that rots."}
   {:term "Normalised scoring"
    :definition "The recommended score set (feasibility, elegance, containment,
                 value) is polarity-normalised so higher is always better, making
                 totals summable at equal weight without sign-juggling. Structure
                 is fixed; dimensions and scale are a project's consistent choice."}
   {:term "Scored trajectory"
    :definition "The series of dated f/reassess entries on a candidate — the
                 history of the team's evolving judgment. Preserved rather than
                 edited away, so a reader can see how and why a view changed."}
   {:term "Hoist as event, abandon as status"
    :definition "Promotion is an event (f/hoist) because it produces something —
                 a decision, a target — and binds the candidate forward to it.
                 Abandonment is merely a status, fully captured by a dated reassess;
                 it warrants no separate form."}]}
```

---

## Implementation notes for LLM processors

### A candidate is opinion, not inference

When processing `f/candidate`, do not treat the scores as derived facts or attempt
to compute them from a model. They are the practitioner's recorded judgment.
Preserve them as given, require the `:rationale`, and never silently fill scores
the practitioner did not provide. If asked to suggest scores, mark them clearly as
suggestions for the practitioner to accept or change — the judgment is theirs.

### Reassess adds; it never overwrites

When processing `f/reassess`, append a dated entry to the candidate's history;
never modify the original `:scores`. Only the dimensions named in the reassessment
change; the rest carry forward. Preserve every prior assessment with its date and
rationale — the trajectory is the value, and an implementation that flattens it to
the latest figures has discarded the point of the form. Treat a reassessment as a
dated re-judgment under changed context, distinct from an `r/revise` correction of
a wrong fact.

### Respect the polarity convention but do not assume it

The recommended set is higher-is-better across all dimensions, so a plain equal-
weight sum is a fair total. But a project may declare a different set or scale.
Read the dimensions as given; do not assume a fixed set, and do not compute a total
that mixes a project's dimensions with the recommended ones. If polarity is
ambiguous in a project's custom set, surface that rather than guessing a direction.

### Hoist binds forward; abandonment does not need an event

When processing `f/hoist`, set the candidate's status to `:hoisted`, preserve its
full history, and record the `:into` binding as a forward reference to the artefact
it became, so the candidate remains traceable to its outcome after leaving the
backlog. Do not synthesise an abandonment event — an abandoned candidate is one
whose latest dated reassessment sets `:status :abandoned`, nothing more.

### foresight is not a workflow engine

Do not impose ordering, priority, or scheduling on candidates beyond what the
practitioner records. The grimoire maintains assessments; it does not enforce a
process. Surfacing derived views (rising trajectories, stale assessments) is
useful; turning the backlog into a task queue with assignees and deadlines is
outside the grimoire's purpose.

---

*A deferred idea is not nothing. It is a graded candidate, and the discipline of
foresight is to keep its assessment honest as the future arrives — recording why
it was kept, dating each change of mind without erasing the last, and graduating
it openly when its time comes. A backlog kept this way is not a graveyard of
forgotten notes but a living account of what the project might yet become.*