# agent.md — Conjurer Agent Grimoire

The spellbook for autonomous action. Where `orchestrate` coordinates known
steps along known paths, `agent` navigates unknown terrain toward known
destinations — and sometimes helps discover what the destination should be.
An agent does not execute instructions; it pursues goals. The difference is
the difference between a procedure and a judgment.

---

## Philosophy

### Choreography versus improvisation

Every complex system requires coordination. The question is what *kind* of
coordination — and the answer depends on how much of the path is known in
advance.

`orchestrate` is choreography: the steps are specified, the routing is
declared, the compensations are registered. The workflow knows exactly what
to do in each situation. Its power is predictability; its limit is that it
can only handle situations it was designed for.

`agent` is improvisation within constraints: the goal is specified, the
capabilities are declared, the constraints are bounded — but the *path* to
the goal is determined by the agent's judgment as it acts. An agent can
try an approach, observe what it produced, revise its strategy, delegate
a sub-task it cannot handle alone, and report what it learned. It handles
situations it was not explicitly designed for, because its design is a set
of capabilities rather than a set of steps.

The practitioner's decision — workflow or agent — follows from the structure
of the task itself:

- **Known path, known steps**: use `o/define-workflow`
- **Known goal, unknown path**: use `a/delegate`
- **Known goal, known approach, specific ask**: use `a/invoke`
- **Contested or complex goal, needs exploration**: use `a/supervise` with a team

Neither paradigm is superior. Using an agent for a task that has a perfectly
specifiable workflow wastes autonomy on a problem that does not need it.
Using a workflow for a task that requires judgment produces brittle
specifications that break on every edge case they were not designed to handle.

### Why multiple agents produce what single agents cannot

A single agent, however capable, has a single perspective. It has trained
strengths and trained blind spots. It surfaces the considerations its
architecture makes salient and misses the ones it was not shaped to see.

A security-specialist agent examining an architecture sees threat surfaces,
trust boundaries, and attack vectors. A performance-specialist agent examining
the same architecture sees bottlenecks, lock contention, and cache misses.
A product-specialist agent sees user friction, missing affordances, and
conversion blockers. These perspectives are not reducible to each other.
No architecture review that applies only one of them is complete.

Multi-agent systems enable *epistemic diversity* — the simultaneous application
of genuinely different frameworks to the same problem. The `a/compose` and
`a/supervise` constructs make this diversity structural rather than accidental.
The practitioner declares which perspectives to apply; the system applies
them in parallel and synthesises the result.

This is not redundancy. It is coverage. Consensus among specialists is
more reliable than the output of any single generalist, precisely because
the specialists disagree productively — each pushing the final result toward
quality that no one of them could achieve alone.

### Trust and the transparency imperative

Autonomous agents acting with broad authority are a category of risk. An
agent given an unclear goal and wide latitude can produce impressive output
in the wrong direction — and may have made many self-reinforcing decisions
before the problem becomes visible.

The `agent` grimoire is built around two mitigations:

**Explicit constraints.** Every agent definition declares `:constraints` —
what the agent must not do, what it must always do, what it may never produce.
These are not hints; they are architectural boundaries that the agent
honours regardless of what the goal seems to require. An agent instructed
to produce TypeScript that never throws exceptions applies that constraint
even when a naive approach would throw.

**Earned autonomy through transparency.** Agents report their reasoning,
not just their outputs. `a/delegate` returns not just the produced artefact
but the path the agent took — what it tried, what it observed, what it
decided, where it was uncertain. This earned autonomy model means
practitioners can extend trust incrementally: tight constraints and
frequent reporting for new agent types; looser constraints and summary
reporting for well-understood ones.

### The agent grimoire's relationship to other grimoires

**`core` provides `handover`** — the context transfer mechanism. When a
practitioner hands off to a specialist agent, `handover` packages the
charter, domain model, assets, and target specifications. `agent` describes
what the receiving agent *is* and *does with* that context.

**`orchestrate` handles deterministic workflows.** When an agent completes
a step and the next step is fully determined, the transition belongs in an
`o/define-workflow`. When the next step requires agent judgment, it stays
in the agent.

**`semantics`, `reasoning`, and `domain`** are the analytical engines that
agents invoke. A domain-specialist agent uses `d/explore` to understand
its territory. A compliance agent uses `r/derive` to determine what rules
apply. A documentation agent uses `e/compose` to write to its audience.
Agents are coordinators of grimoire capabilities, not replacements for them.

### Four design principles

**Goal specification over step specification** — Agents are directed toward
outcomes, not procedures. The practitioner specifies what should be achieved;
the agent determines how.

**Earned autonomy** — Agents report their reasoning. Constraints are explicit.
Trust is extended incrementally as reliability is demonstrated.

**Epistemic diversity through specialization** — Different agents bring
genuinely different perspectives. Multi-agent coordination produces results
that no single perspective could reach alone.

**Graceful human integration** — Agents augment human judgment; they do not
replace it. The patterns for surfacing agent outputs to human reviewers are
as important as the patterns for autonomous execution.

---

## Naming rationale

**`agent`** — From Latin *agere*, to do, to act. In philosophy of action,
an agent is an entity that acts with intention — not merely a mechanism
that reacts to inputs. This is the precise distinction from an orchestrated
step: a workflow step executes; an agent acts. The choice of this word
over alternatives like "worker" or "executor" is deliberate.

**`a/`** — The short namespace alias.

**`a/define`** — Declaring an agent's identity: its capabilities, specializations,
constraints, and memory model.

**`a/invoke`** — From Latin *invocare*, to call upon. A directed call with
a specific task and expected output — the agent equivalent of a function call.

**`a/delegate`** — From Latin *delegare*, to entrust with authority. You
delegate to someone you trust to exercise judgment; you give instructions
to someone who executes mechanically. The word carries the right connotation
of granted autonomy.

**`a/compose`** — From Latin *componere*, to put together. Multiple agents
assembled into a coordinated pipeline.

**`a/supervise`** — From Latin *super* + *videre*, to see from above. A
supervisor maintains the view of the whole while the team works on the parts.

**`a/evaluate`** — From Latin *evaluare*, to determine the value of. Structured
assessment of an agent's output against explicit criteria.

**`a/reflect`** — From Latin *reflectere*, to bend back. An agent turns
its attention back on its own output and reasoning.

**`a/negotiate`** — From Latin *negotiari*, to carry on business between
parties. To negotiate is to arrive at agreement through structured exchange
rather than unilateral assertion.

---

## Part I: Agent definition

### `a/define`

Declares an agent's identity — its specialization, the standards and domain
knowledge it applies, the artefacts it produces, the constraints it operates
within, and how it manages state across invocations.

An agent definition is not a prompt. It is a capability declaration: a
structured description of what kind of reasoning the agent applies, what
it knows, what it will and will not do. The definition is an `asset` — it
can be registered and referenced by name throughout the project.

#### Signature

```clojure
(a/define name
  :description    "what this agent does and why it exists"
  :specializes-in [:capability ...]
  :knows          [:asset-name ...]
  :produces       [:artefact-type ...]
  :accepts        [:context-type ...]
  :constraints    ["hard constraint on agent behaviour" ...]
  :style          {:reasoning   :explicit | :implicit
                   :confidence  :calibrated | :assertive
                   :verbosity   :terse | :standard | :detailed}
  :memory         :none | :session | :task
  :version        semver
  :manifest       agent-binding)
```

#### Parameters

**`:specializes-in`** — The capabilities that distinguish this agent from
a general-purpose system. A specialist applies deeper knowledge and more
rigorous standards to its domain than a generalist would. Named capabilities
should correspond to grimoire constructs or domain expertise areas:
`:typescript-generation`, `:security-review`, `:domain-modelling`,
`:regulatory-compliance`, `:api-design`, `:test-generation`.

**`:knows`** — Registered `asset` definitions this agent applies. When
an agent `:knows [:team-coding-standard]`, it fetches that asset's
`:location` file and applies all `:enforces` constraints and `:prohibits`
anti-patterns to every artefact it produces. Knowledge is not metadata —
it changes behaviour.

**`:constraints`** — Hard limits on agent behaviour. These are not style
preferences; they are non-negotiable constraints that apply regardless of
what the goal seems to require. An agent with a constraint "Never produce
code that catches and swallows exceptions" applies that constraint even
when the goal makes it tempting to do so.

**`:style`**:
- `:reasoning :explicit` — the agent narrates its reasoning alongside its
  output. Slows production; increases inspectability.
- `:reasoning :implicit` — the agent produces output without narrating
  reasoning unless asked. Faster; requires `a/reflect` or `explain` for
  transparency.
- `:confidence :calibrated` — the agent hedges where uncertain and is
  explicit about what it does not know.
- `:confidence :assertive` — the agent commits to its output without
  hedging. Appropriate when the practitioner will evaluate and correct.

**`:memory`**:
- `:none` — no state across invocations; each call is independent
- `:session` — accumulates task-level state within the current session
- `:task` — persists state across sessions for the duration of a named task

#### Design rationale

The agent definition is the agent's contract with the practitioner. Without
it, the practitioner cannot reason about what an agent will do in situations
the examples do not cover. Without explicit `:constraints`, there is no
principled way to audit agent behaviour. Without `:knows`, the application
of standards is invisible.

A well-defined agent can be reasoned about in the abstract: "Would the
security-reviewer agent flag this pattern?" If the agent has explicit
specializations and constraints, this question is answerable. If it does
not, it is not.

#### Example 1: TypeScript code generation agent

```clojure
(a/define :typescript-agent
  :description    "Generates TypeScript following team functional coding standard;
                   specialises in REST API and data layer implementations"
  :specializes-in [:typescript-generation :api-design :schema-definition]
  :knows          [:team-coding-standard :openapi-conventions]
  :produces       [:typescript-source :openapi-spec :zod-schemas :test-suite]
  :accepts        [:domain-model :openapi-spec :conjurer-target :user-stories]
  :constraints    [
    "Never produce TypeScript that uses throw for business logic errors"
    "All external boundaries must have runtime validation"
    "No implicit any — all types must be explicit"
    "Functions must be pure unless explicitly annotated as effectful"]
  :style          {:reasoning  :explicit
                   :confidence :calibrated}
  :memory         :task
  :version        "1.2.0"
  :manifest       typescript-agent)
```

#### Example 2: Security review agent

```clojure
(a/define :security-reviewer
  :description    "Reviews artefacts for security vulnerabilities, threat
                   vectors, and compliance with secure-by-default principles"
  :specializes-in [:security-review :threat-modelling :owasp-top-10
                   :secrets-management :auth-review]
  :knows          [:owasp-top-10 :team-security-policy]
  :produces       [:security-report :threat-model :remediation-plan]
  :accepts        [:source-code :api-spec :architecture-diagram :database-schema]
  :constraints    [
    "Report all findings regardless of perceived severity — never suppress"
    "Distinguish between confirmed vulnerabilities and theoretical risks"
    "Always propose a specific remediation for every finding"]
  :style          {:reasoning  :explicit
                   :confidence :calibrated
                   :verbosity  :detailed}
  :memory         :session
  :version        "2.0.0"
  :manifest       security-reviewer)
```

---

### `a/memory`

Defines a named memory store for an agent — explicit, inspectable operational
state that persists across invocations within the memory scope.

Agent memory is distinct from all other state mechanisms in Conjurer:

- `context` holds *domain knowledge* — what the domain is
- `charter` holds *project history* — what was decided and why
- `assume` holds *operative constraints* — what the environment looks like
- `a/memory` holds *task-level operational state* — what this agent has
  done, what it learned, what partial progress it has made

#### Signature

```clojure
(a/memory name
  :for      :agent-name
  :scope    :session | :task
  :schema   {:field :type ...}
  :initial  {:field initial-value ...}
  :manifest memory-binding)
```

#### Parameters

**`:scope`**:
- `:session` — memory lives for the current session; lost when the session ends
- `:task` — memory persists across sessions for the duration of a named task;
  survives session boundaries and editor restarts

**`:schema`** — The structure of what the agent remembers. Making the
schema explicit makes the memory inspectable: a practitioner can query
the agent's memory to understand its current state.

#### Design rationale

Without explicit memory, an agent that runs for multiple turns cannot
accumulate learning across those turns. Each invocation starts cold.
For long tasks — code generation across many files, multi-day analysis
projects, iterative refinement cycles — this is deeply limiting.

With `a/memory`, the agent knows what it has already tried. It knows
which sub-tasks failed and which succeeded. It knows what it was uncertain
about and what it resolved. This accumulated operational knowledge is what
enables an agent to tackle genuinely complex tasks without cycling through
the same failures repeatedly.

#### Example: Code generation agent memory

```clojure
(a/memory typescript-agent-state
  :for     :typescript-agent
  :scope   :task
  :schema  {
    :generated-files    [:array :string]
    :failed-attempts    [:array {:file :string :approach :string :error :string}]
    :resolved-ambiguities [:array {:question :string :resolution :string}]
    :pending-sub-tasks  [:array :string]
    :quality-score      :number}
  :initial {
    :generated-files    []
    :failed-attempts    []
    :resolved-ambiguities []
    :pending-sub-tasks  []
    :quality-score      nil})
```

---

## Part II: Invocation and delegation

### `a/invoke`

Directs an agent to perform a specific, well-defined task with a specified
input and expected output. The agent equivalent of a function call — the
practitioner knows what the agent should do and is directing it precisely.

#### Signature

```clojure
(a/invoke agent-name-or-binding
  :task      "specific task description"
  :with      context-or-data
  :given     {:additional-constraint value ...}
  :produce   :artefact-type | [:artefact-types ...]
  :explain   boolean
  :timeout   duration-ms
  :manifest  result-binding)
```

#### Parameters

**`:task`** — A specific, directed task description. Not a goal (that is
`:delegate`), but a precise ask. "Review this function for security
vulnerabilities" is an invocation task. "Make this codebase secure" is a
delegation goal.

**`:given`** — Additional constraints or context that apply only to this
invocation, supplementing but not replacing the agent's definition.

**`:explain`** — When true, the agent narrates its reasoning alongside
the result. Overrides the agent's `:style :reasoning` setting for this
invocation.

#### Design rationale

The distinction between `a/invoke` and `a/delegate` is the distinction
between directed and autonomous work. `a/invoke` is appropriate when the
practitioner knows exactly what they want and is directing the agent to
produce it. The agent applies its specialization and constraints but does
not exercise strategic judgment about approach.

`a/delegate` is appropriate when the practitioner knows the desired outcome
but trusts the agent to determine the path. Use `a/invoke` for specific
tasks; use `a/delegate` for goals.

#### Example 1: Code review invocation

```clojure
(a/invoke security-reviewer
  :task    "Review the payment processing module for security vulnerabilities"
  :with    (read-file "src/payments/processor.ts")
  :given   {:context "This module handles Stripe webhook events and updates
                      subscription state. PCI scope is limited to tokenised
                      card references only."}
  :produce :security-report
  :explain true
  :manifest payment-review)
```

#### Example 2: Type generation invocation

```clojure
(a/invoke typescript-agent
  :task    "Generate Zod schemas and TypeScript types for all entities
            in the subscription domain model"
  :with    subscription-domain-model
  :produce [:zod-schemas :typescript-types]
  :manifest domain-types)
```

#### Example 3: Documentation invocation

```clojure
(a/invoke documentation-agent
  :task    "Write JSDoc comments for all exported functions in the
            billing module"
  :with    (read-files "src/billing/**/*.ts")
  :given   {:audience    :external-developers
            :style       :terse-but-complete
            :include     [:params :returns :throws :example]}
  :produce :annotated-source
  :manifest documented-billing)
```

---

### `a/delegate`

Assigns a goal to an agent with autonomy to determine and execute the
approach. The agent acts, observes the results of its actions, revises
its strategy, and reports back — not just with the output but with the
path it took to produce it.

#### Signature

```clojure
(a/delegate agent-name-or-binding
  :goal      "outcome to achieve"
  :context   context-data
  :within    {:max-turns   n
              :constraints ["additional constraint for this delegation"]
              :must-report [:decision :attempt :uncertainty :completion]}
  :memory    memory-binding
  :approve   :each-step | :major-decisions | :on-completion | :never
  :manifest  delegation-result)
```

#### Parameters

**`:goal`** — The desired outcome, stated as an outcome rather than a
procedure. "Implement a subscription billing API that satisfies the domain
model" is a goal. "Write these three endpoints in this order using these
patterns" is an instruction — use `a/invoke` for that.

**`:within`**:
- `:max-turns` — the maximum number of autonomous reasoning steps the
  agent may take. Acts as a budget; prevents runaway delegation.
- `:constraints` — delegation-specific constraints supplementing the
  agent's definition.
- `:must-report` — which events the agent must surface during delegation.
  `:decision` reports every significant choice. `:attempt` reports each
  approach tried. `:uncertainty` reports when the agent is not confident.
  `:completion` reports only when done.

**`:approve`** — When human approval is required:
- `:each-step` — the practitioner approves before each agent action.
  Maximum control; minimum autonomy.
- `:major-decisions` — the agent identifies decisions with significant
  consequences and pauses for approval on those.
- `:on-completion` — the practitioner reviews the complete result before
  it is accepted. Standard for trusted agents on well-understood tasks.
- `:never` — fully autonomous; appropriate only for well-constrained,
  reversible tasks.

#### Design rationale

`a/delegate` is the primary mechanism for autonomous agent work. The
`:max-turns` budget is critical: it prevents the failure mode where an
agent pursues an increasingly complex approach to a misunderstood goal.
The budget forces either completion or a report of progress-and-blockage
within a known horizon.

The `:must-report` parameter operationalises earned autonomy: a new agent
type or a novel task warrants `:must-report [:decision :attempt]` — the
practitioner sees every significant move. A well-understood agent on a
routine task warrants `:must-report [:completion]`. Trust is extended
through demonstrated reliability, not assumed.

#### Example 1: API implementation delegation

```clojure
(a/delegate typescript-agent
  :goal    "Implement the complete subscription management REST API as
            specified by the subscription domain model and api target.
            The API must be production-ready: full validation, error
            handling, and unit tests for all endpoints."
  :context {:domain-model  subscription-domain-model
            :target        api-target
            :asset         team-coding-standard}
  :within  {:max-turns    20
            :constraints  ["Each endpoint must have at least 3 unit tests"
                           "All error responses must conform to RFC 7807"]
            :must-report  [:decision :uncertainty :completion]}
  :memory  typescript-agent-state
  :approve :major-decisions
  :manifest api-implementation)

;; The agent:
;; 1. Plans its implementation order based on domain model dependencies
;; 2. Implements each endpoint, reporting decisions about edge case handling
;; 3. Pauses for approval when it encounters an ambiguous requirement
;; 4. Generates tests alongside each endpoint
;; 5. Reports completion with a summary of what was built and what was deferred
```

#### Example 2: Research and analysis delegation

```clojure
(a/delegate domain-analyst-agent
  :goal    "Produce a comprehensive understanding of GDPR Article 17
            (right to erasure) as it applies to a multi-tenant SaaS
            platform with shared database tenancy. Surface every
            implementation consideration."
  :context {:platform-model  saas-domain-model
            :tenancy-model   :shared-schema-with-discriminator}
  :within  {:max-turns   8
            :must-report [:decision :uncertainty]}
  :approve :on-completion
  :manifest erasure-analysis)
```

#### Example 3: Exploratory refactoring

```clojure
(a/delegate typescript-agent
  :goal    "Identify and eliminate the three most significant sources of
            technical debt in the billing module. For each, explain why
            it is debt, propose a refactoring, and estimate the risk."
  :context {:source-files (read-files "src/billing/**/*.ts")}
  :within  {:max-turns   12
            :must-report [:decision]}
  :approve :each-step   ;; This is exploratory — practitioner stays close
  :manifest refactoring-plan)
```

---

## Part III: Multi-agent coordination

### `a/compose`

Assembles a pipeline of agents where each agent's output becomes the next
agent's input. Enables the systematic application of multiple specialised
perspectives to the same artefact, accumulating quality through sequential
transformation.

#### Signature

```clojure
(a/compose name
  :agents   [{:agent    agent-name-or-binding
              :role     "what this agent contributes to the pipeline"
              :task     task-description-or-invocation
              :produces :binding-name} ...]
  :strategy :sequential | :parallel | :parallel-then-merge
  :synthesise {:agent :synthesis-agent :goal "how to combine outputs"}
  :on-agent-failure :stop | :skip | :compensate
  :manifest result-binding)
```

#### Parameters

**`:strategy`**:
- `:sequential` — each agent's output is the next agent's input; output
  builds through the pipeline
- `:parallel` — all agents receive the same input and work simultaneously;
  outputs are independent
- `:parallel-then-merge` — agents work in parallel; a synthesis step then
  combines their outputs into a unified result

**`:synthesise`** — When `:parallel-then-merge` is the strategy, this
specifies how to combine the parallel outputs. A synthesis agent reads
all outputs and produces a unified artefact that honours all perspectives.

**`:on-agent-failure`**:
- `:stop` — halt the pipeline if any agent fails
- `:skip` — continue with remaining agents; note the failure in the result
- `:compensate` — invoke compensation for completed stages before stopping

#### Design rationale

The value of `a/compose` lies in its systematic application of diverse
perspectives. A single expert produces a single perspective's output.
A composed pipeline produces something shaped by multiple perspectives —
and the ordering of agents in a sequential pipeline is itself a design
decision about how quality accumulates.

A sequential pipeline of domain-analyst → code-generator → security-reviewer
produces different results than domain-analyst → security-reviewer → code-generator.
In the first, the security reviewer critiques finished code. In the second,
security requirements inform the code before it is written. The ordering
matters and should be deliberate.

#### Example 1: Sequential quality pipeline

```clojure
(a/compose subscription-api-pipeline
  :agents [
    {:agent    domain-analyst-agent
     :role     "Validate that the domain model is complete and consistent"
     :task     "Review the subscription domain model for gaps and ambiguities"
     :produces :validated-domain}

    {:agent    typescript-agent
     :role     "Implement the validated domain as TypeScript"
     :task     "Generate the complete API implementation from the domain model"
     :produces :api-implementation}

    {:agent    security-reviewer
     :role     "Audit the implementation for security issues"
     :task     "Review the generated API for OWASP Top 10 vulnerabilities"
     :produces :security-report}

    {:agent    documentation-agent
     :role     "Document the secure implementation"
     :task     "Generate API documentation for external developers"
     :produces :api-documentation}]

  :strategy :sequential
  :on-agent-failure :stop
  :manifest pipeline-result)
```

#### Example 2: Parallel multi-perspective review

```clojure
(a/compose architecture-review
  :agents [
    {:agent    security-reviewer
     :role     "Security perspective"
     :task     "Identify security risks and threat vectors"
     :produces :security-findings}

    {:agent    performance-analyst-agent
     :role     "Performance perspective"
     :task     "Identify bottlenecks and scalability concerns"
     :produces :performance-findings}

    {:agent    accessibility-reviewer-agent
     :role     "Accessibility perspective"
     :task     "Identify barriers for users with disabilities"
     :produces :accessibility-findings}

    {:agent    maintainability-agent
     :role     "Long-term maintenance perspective"
     :task     "Identify technical debt and complexity hotspots"
     :produces :maintainability-findings}]

  :strategy :parallel-then-merge
  :synthesise {
    :agent :synthesis-agent
    :goal  "Produce a unified architecture review that prioritises findings
            across all four perspectives, identifies where perspectives
            agree, and flags where they are in tension"}

  :on-agent-failure :skip
  :manifest comprehensive-review)
```

---

### `a/supervise`

Coordinates a team of agents under a supervising agent that maintains the
overall view, assigns sub-tasks, monitors progress, resolves conflicts between
agents, and synthesises their outputs into a coherent whole.

Where `a/compose` is a pipeline with a predetermined structure, `a/supervise`
allows the supervisor to dynamically assign work, redirect agents, and
decide when the team's output is complete.

#### Signature

```clojure
(a/supervise supervisor-agent
  :team      [:agent-name ...]
  :goal      "what the team should produce as a whole"
  :context   context-data
  :strategy  :divide-and-conquer | :debate | :peer-review | :iterative-refinement
  :budget    {:max-total-turns n :max-rounds n}
  :approve   :on-completion | :after-each-round | :never
  :manifest  supervision-result)
```

#### Parameters

**`:strategy`**:
- `:divide-and-conquer` — the supervisor breaks the goal into sub-tasks
  and assigns one or more to each agent; synthesises the results
- `:debate` — agents are presented with the same problem and produce
  competing solutions; the supervisor adjudicates
- `:peer-review` — one agent produces a primary output; others critique it;
  the original agent revises; the supervisor determines when the result
  is acceptable
- `:iterative-refinement` — agents work in rounds; each round's output
  is input to the next round's critique; the supervisor stops when
  quality meets threshold

**`:budget`** — Total turn limits across the team and maximum number of
coordination rounds. Essential for preventing runaway supervision cycles.

#### Example 1: Divide-and-conquer implementation

```clojure
(a/supervise architect-agent
  :team   [:typescript-agent :database-agent :test-agent]
  :goal   "Implement the complete subscription billing platform —
           API, database schema, and test suite — as a cohesive system
           where every layer is consistent with the others"
  :context {:domain-model  subscription-domain-model
             :targets       [api-target database-target test-target]
             :assets        [team-coding-standard]}
  :strategy :divide-and-conquer
  :budget  {:max-total-turns 60 :max-rounds 3}
  :approve :after-each-round
  :manifest platform-implementation)

;; The architect-agent:
;; 1. Assigns the database schema to :database-agent
;; 2. Assigns the API implementation to :typescript-agent (after schema is complete)
;; 3. Assigns test generation to :test-agent (alongside or after API)
;; 4. Reviews integration consistency between layers
;; 5. Requests revisions from specific agents when inconsistencies are found
;; 6. Reports to practitioner after each round for approval before continuing
```

#### Example 2: Peer review strategy

```clojure
(a/supervise senior-review-agent
  :team     [:typescript-agent :security-reviewer]
  :goal     "Produce a payment processing implementation that is both
             functionally complete and security-hardened"
  :context  {:domain-model  payment-domain-model
             :target        payment-api-target}
  :strategy :peer-review
  :budget   {:max-total-turns 30 :max-rounds 3}
  :approve  :on-completion
  :manifest payment-implementation)

;; Round 1: :typescript-agent produces initial implementation
;; Round 2: :security-reviewer critiques it; identifies three issues
;; Round 3: :typescript-agent revises in response to the critique
;; supervisor: determines revised output meets quality threshold; stops
```

---

### `a/negotiate`

Structures a dialogue between two or more agents to arrive at a shared
position on a contested or complex question. Not debate (where agents
argue against each other) but negotiation — where agents work *toward*
a position that each can genuinely endorse.

#### Signature

```clojure
(a/negotiate topic
  :agents      [:agent-a :agent-b ...]
  :context     context-data
  :rounds      n
  :converge-on :consensus | :synthesis | :recommendation-with-dissents
  :facilitated-by :agent-name
  :manifest    negotiation-result)
```

#### Parameters

**`:converge-on`**:
- `:consensus` — all agents must endorse the final position; dissent
  is not acceptable as an outcome
- `:synthesis` — a unified position that incorporates elements from all
  agents' positions, acknowledging trade-offs
- `:recommendation-with-dissents` — a primary recommendation, with
  minority positions documented alongside it and their reasoning preserved

**`:facilitated-by`** — An optional agent that manages the negotiation
process: keeps the conversation on topic, summarises positions, identifies
convergences, and determines when further rounds would not be productive.

#### Design rationale

Some design questions have no single correct answer — only trade-offs that
different frameworks evaluate differently. API versioning strategy. Database
sharding approach. Eventual versus strong consistency. Microservices versus
modules. These are questions where a single agent producing a recommendation
is less reliable than two or three specialist agents working toward a shared
position.

`a/negotiate` externalises this process: the different positions are
made visible, the arguments are recorded, and the convergence (or
principled disagreement) is documented. The result is not just a decision
but the reasoning behind it — inspectable, revisable, and honest about
where genuine disagreements persist.

#### Example: Data model design negotiation

```clojure
(a/negotiate "How should subscription plan changes be represented in the data model?"
  :agents  [:domain-analyst-agent :database-agent :typescript-agent]
  :context {:domain-model     subscription-domain-model
            :current-approach "Single subscription record with plan_id foreign key"}
  :rounds  3
  :converge-on :recommendation-with-dissents
  :facilitated-by :architect-agent)

;; Returns:
{:topic    "Subscription plan change data model"
 :recommendation
   "Use an immutable subscription-version table: each plan change creates
    a new version record with effective_from timestamp. The current version
    is always the latest. This approach preserves full history without
    requiring a separate event log."
 :consensus-reached true
 :rationale
   "Domain analyst: supports billing history queries without joins.
    Database agent: append-only pattern suits PostgreSQL; index on
    subscription_id + effective_from is efficient.
    TypeScript agent: maps cleanly to Result type without nullable fields."
 :dissents []
 :alternatives-considered [
   {:approach  "Mutation log / event sourcing"
    :rejected  "Overhead not justified at current scale; adds complexity
                to simple queries"}
   {:approach  "JSONB history column on subscription"
    :rejected  "Sacrifices queryability for storage convenience"}]}
```

---

## Part IV: Quality and reflection

### `a/evaluate`

Assesses an agent's output against explicit quality criteria, producing a
structured evaluation that identifies strengths, weaknesses, and specific
improvements.

#### Signature

```clojure
(a/evaluate output
  :against   [:criterion ...]
  :using     :agent-name | evaluation-rubric
  :dimension [:correctness :completeness :style :security
              :performance :maintainability :accessibility ...]
  :produce   :score | :pass-fail | :detailed-assessment | :improvement-plan
  :improve   boolean
  :manifest  evaluation-result)
```

#### Parameters

**`:against`** — Explicit criteria the output is evaluated against. These
should be specific and testable: "All exported functions have JSDoc comments"
is evaluable. "Code is readable" is not.

**`:improve`** — When true, the evaluation produces not just a verdict
but a revised version of the input that addresses the identified weaknesses.
The revised version is available alongside the evaluation report.

#### Example

```clojure
(a/evaluate api-implementation
  :against   [
    "All endpoints have corresponding unit tests"
    "No TypeScript any types"
    "All error responses conform to RFC 7807"
    "Rate limiting is applied to all authenticated endpoints"
    "No secrets or credentials appear in source code"]
  :using     :quality-reviewer-agent
  :dimension [:correctness :security :completeness]
  :produce   :improvement-plan
  :improve   true
  :manifest  evaluation-result)

;; Returns:
{:score        0.82
 :pass         true
 :findings [
   {:criterion  "All endpoints have corresponding unit tests"
    :verdict    :fail
    :detail     "DELETE /subscriptions/:id has no unit tests"
    :severity   :high}
   {:criterion  "No TypeScript any types"
    :verdict    :pass}
   {:criterion  "Rate limiting applied to all authenticated endpoints"
    :verdict    :partial
    :detail     "Rate limiting present on POST endpoints; missing on GET /subscriptions"}]
 :improved-output api-implementation-v2  ;; :improve true
 :improvements-applied [
   "Added 4 unit tests for DELETE /subscriptions/:id"
   "Added rate limiting middleware to GET /subscriptions"]}
```

---

### `a/reflect`

An agent examines its own output — the reasoning that produced it,
the alternatives it did not pursue, the assumptions it made, and the
ways the output might be improved or might fail in production.

Self-reflection is the mechanism by which an agent's output improves
without external critique. Where `a/evaluate` applies an external
standard, `a/reflect` applies the agent's own deeper judgment to its
initial work.

#### Signature

```clojure
(a/reflect output
  :questions ["question to examine" ...]
  :from      :agent-name
  :depth     :surface | :thorough
  :produce   :reflection-report | :improved-output | :both
  :manifest  reflection-result)
```

#### Parameters

**`:questions`** — Specific dimensions to examine. Generic reflection
produces generic insights. Specific questions produce specific ones:
"What assumptions did I make about the data schema that might not hold?"
produces more actionable output than "How could this be better?"

**`:depth`**:
- `:surface` — the agent examines obvious alternatives and immediate
  improvements. Fast; suitable for routine quality checks.
- `:thorough` — the agent examines assumptions, edge cases, failure modes,
  and alternatives it deliberately set aside. Slower; appropriate before
  handing off to downstream agents or practitioners.

#### Example

```clojure
(a/reflect domain-analysis-output
  :questions [
    "What assumptions did I make about entity relationships that the
     requirements do not explicitly support?"
    "Which entities did I group together that might warrant separation
     at scale?"
    "What edge cases in the business rules did I treat as obvious
     that might actually be contested?"
    "What would need to change if the multi-tenancy model shifted from
     shared schema to separate database per tenant?"]
  :from   domain-analyst-agent
  :depth  :thorough
  :produce :both
  :manifest domain-reflection)

;; Returns:
{:reflection {
   :assumptions-made [
     "Subscription is always associated with exactly one customer.
      The requirements do not address shared subscriptions or B2B2C models."
     "Currency is fixed per subscription. The requirements mention multi-currency
      as a future consideration but I modelled it as locked at subscription creation."]
   :structural-choices [
     "PlanVersion and Plan are separate entities. This was a contested choice.
      If plan history is not required, a simpler mutable Plan is sufficient."]
   :edge-cases-requiring-clarification [
     "Subscription pause: the domain model allows pause but does not specify
      whether billing continues or suspends during a pause."]}
 :improved-output domain-analysis-v2}
```

---

## Best practices

### Choose the right invocation pattern

The practitioner's mental model for choosing:

| Situation | Pattern |
|---|---|
| Specific task, known approach, expected output | `a/invoke` |
| Goal known, path not specified | `a/delegate` |
| Multiple sequential specialists needed | `a/compose :sequential` |
| Multiple parallel perspectives needed | `a/compose :parallel-then-merge` |
| Complex goal requiring dynamic task assignment | `a/supervise` |
| Contested design decision | `a/negotiate` |
| Output quality verification | `a/evaluate` |
| Agent examines its own assumptions | `a/reflect` |

### Budget delegation generously but not infinitely

A `:max-turns` budget that is too low forces the agent to cut corners or
fail on complex tasks. A budget with no ceiling is an invitation to runaway
reasoning. Start with a generous budget for new agents and tasks; calibrate
it downward as reliability is established.

### Require explicit reporting early; relax it as trust is earned

New agent definitions and novel task types should use
`:must-report [:decision :attempt :uncertainty]`. This is expensive in
tokens and time but inexpensive in errors — the practitioner can catch
misunderstandings before they compound. As an agent demonstrates reliable
behaviour on a task type, reduce the reporting requirement.

### Reflect before handover

Before issuing a `handover` to a specialist agent, apply `a/reflect` to the
context being handed over. The reflection may surface assumptions that the
receiving agent will not have the context to question. Better to surface them
now than to discover the handover was built on contested foundations.

### Evaluate before accepting

Never accept an agent's output as final without evaluation. Even a simple
`a/evaluate :produce :pass-fail :against [explicit-criteria]` is better
than implicit acceptance. The criteria force the practitioner to articulate
what "good" means — and often reveal that the implicit standard was less
demanding than it should have been.

### Define agents before invoking them

An agent invoked without a definition is a prompt. An agent invoked with
a definition is a capability declaration with explicit constraints, known
specializations, and inspectable behaviour. The definition is what makes
the agent auditable and extensible.

---

## Integration patterns

### Agent as the consumer of handover

The canonical flow from `core`'s `handover` to the `agent` grimoire:

```clojure
;; In the Conjurer session: package context and declare intent
(handover :to :typescript-agent
  :from     current-session
  :scope    [:api]
  :include  [:charter :domain-model :target-specs :assets])

;; In the receiving agent session: the agent picks up and acts
(a/delegate typescript-agent
  :goal    "Implement the API as specified in the handover package"
  :context handover-package
  :within  {:max-turns 20 :must-report [:decision :completion]}
  :approve :on-completion)
```

The `handover` packages the context; `a/delegate` directs the action.
These are complementary constructs, not alternatives.

### Compose with witness for auditability

Inserting `witness` into an `a/compose` pipeline produces an audit trail
of each agent's contribution without modifying what the agents produce.

```clojure
(a/compose audited-pipeline
  :agents [
    {:agent :typescript-agent
     :task  "Generate API implementation"
     :produces :api-impl}

    {:agent :security-reviewer
     :task  "Review implementation"
     :produces :security-report}]

  :strategy :sequential
  :manifest pipeline-result)

;; Wrap each stage with witness for full audit trail:
(witness pipeline-result
  :observe  [:decisions :alternatives :confidence-levels]
  :record-to pipeline-audit-log)
```

### Negotiate then decide with reasoning

```clojure
;; Use reasoning grimoire to derive obligations from negotiation outcome
(def data-model-decision
  (a/negotiate "Event sourcing vs direct mutation for billing state"
    :agents    [:domain-analyst-agent :database-agent]
    :rounds    3
    :converge-on :recommendation-with-dissents))

;; Then derive what that decision implies
(r/derive "What does this data model choice imply for the read API?"
  :from  data-model-decision
  :using billing-api-rules
  :mode  :deductive
  :explain true)
```

### Quality loop: generate, evaluate, reflect, improve

```clojure
(~> domain-model
  (a/invoke typescript-agent
    :task    "Generate initial API implementation"
    :produce :typescript-source)

  (a/evaluate
    :against   api-quality-criteria
    :produce   :improvement-plan
    :improve   true)

  (a/reflect
    :questions ["What requirements might not be satisfied by the evaluation criteria?"]
    :depth     :thorough
    :produce   :improved-output)

  (witness :observe [:quality-progression] :record-to quality-log))
```

### Agent team with orchestrate approval gate

```clojure
;; Combine agent supervision with orchestrate's human-approval
(o/define-workflow :agent-assisted-implementation
  :stages [
    {:name      :domain-analysis
     :operation (a/invoke domain-analyst-agent
                  :task "Validate and complete the domain model"
                  :with requirements)}

    {:name      :human-review-of-analysis
     :operation (o/human-approval
                  :reviewers [:domain-expert :product-lead]
                  :data      domain-analysis-output
                  :timeout   (hours 24))}

    {:name      :implementation
     :operation (a/supervise architect-agent
                  :team    [:typescript-agent :database-agent :test-agent]
                  :goal    "Implement the approved domain model"
                  :budget  {:max-total-turns 60})}

    {:name      :final-review
     :operation (a/evaluate implementation-result
                  :using   :quality-reviewer-agent
                  :produce :detailed-assessment)}])
```

---

## Grimoire metadata

```clojure
{:grimoire    "agent"
 :namespace   "a/"
 :version     "1.0.0"
 :description "Autonomous agent definition, invocation, delegation, multi-agent
               coordination, and quality assurance patterns"

 :constructs {
   :definition    [a/define a/memory]
   :invocation    [a/invoke a/delegate]
   :coordination  [a/compose a/supervise a/negotiate]
   :quality       [a/evaluate a/reflect]}

 :best-for [
   "Autonomous implementation from goal specifications"
   "Multi-perspective architecture and code reviews"
   "Sequential quality pipelines (generate → review → secure → document)"
   "Contested design decisions via structured negotiation"
   "Complex implementation tasks requiring dynamic sub-task assignment"
   "Self-improving outputs through structured reflection"
   "Human-in-the-loop agent workflows with approval gates"]

 :works-with [:core :orchestrate :domain :semantics :reasoning :eloquence]

 :key-concepts [
   {:term "Agent"
    :definition "An entity that acts with intention toward a goal, exercising
                 judgment about how to proceed — as opposed to a mechanism that
                 executes a predetermined sequence of steps."}
   {:term "Invocation"
    :definition "A directed, specific task assignment to an agent. The practitioner
                 specifies both the task and the expected output form. The agent
                 applies its specialization but does not exercise strategic judgment
                 about approach."}
   {:term "Delegation"
    :definition "An autonomous task assignment toward a goal. The practitioner
                 specifies the desired outcome; the agent determines and executes
                 the path. The agent may try approaches, observe results, revise,
                 and delegate sub-tasks within its budget."}
   {:term "Epistemic diversity"
    :definition "The application of multiple genuinely different analytical
                 frameworks to the same problem. Multi-agent composition enables
                 this; single-agent reasoning cannot."}
   {:term "Earned autonomy"
    :definition "A trust model where agents receive tighter constraints and
                 more frequent reporting requirements for new task types, and
                 looser constraints and summary reporting as reliability is
                 demonstrated."}
   {:term "Agent memory"
    :definition "Operational state that accumulates across an agent's invocations
                 within a task — what has been tried, what failed, what was learned.
                 Distinct from context (domain knowledge), charter (project history),
                 and assume (operative constraints)."}
   {:term "Supervision"
    :definition "A coordination pattern where one agent maintains the overall view
                 of a goal, dynamically assigns work to specialist agents, monitors
                 progress, and synthesises outputs into a coherent whole."}
   {:term "Negotiation"
    :definition "A structured dialogue between agents to arrive at a shared position
                 on a contested or complex question — working toward agreement rather
                 than debating against each other."}]}
```

---

## Implementation notes for LLM processors

### The orchestrate / agent boundary

When deciding whether a task belongs in `o/define-workflow` or `a/delegate`:
- Known steps, known routing: workflow
- Goal specified, path undetermined: delegation
- The test is: "Could I write a complete workflow specification without
  knowing more?" If yes, write the workflow. If no, delegate.

### Agent definition compliance

When an agent with a definition executes a task, all `:constraints` apply
unconditionally — even when honouring them makes the task harder. If a
constraint and a goal are in genuine tension, surface the tension rather than
silently violating the constraint. "The goal requires exception throwing, but
my constraint prohibits it in business logic. Here are two approaches that
satisfy both:" is the correct response.

### The `:max-turns` budget

Every `a/delegate` and `a/supervise` invocation has a `:max-turns` budget.
When the budget is exhausted before completion:
1. Report progress made so far — what was accomplished, what remains
2. Report the blockage — why completion was not reached
3. Report what additional context or budget would allow completion
4. Do not silently truncate or produce an incomplete result without flagging it

### Memory accumulation

When `:memory` is specified and an agent has a `:memory` binding, update
the memory store after each significant action: each file generated, each
approach tried, each ambiguity resolved. Memory is not a summary written
at the end — it is a running accumulation that informs subsequent steps
within the same task.

### Reflection depth calibration

At `:depth :surface`:
- Name the two or three most obvious alternatives not pursued
- Identify any assumptions the output makes that are not in the input
- Flag the one most likely source of downstream problems

At `:depth :thorough`:
- All alternatives considered and the reasoning for each rejection
- All assumptions, including those the agent treated as obvious
- Edge cases that the output does not handle
- Failure modes in production that the output does not account for
- What would need to change if a key constraint were relaxed

### Negotiation facilitation

When facilitating a negotiation:
1. Allow each agent to state its initial position fully before any discussion
2. Identify points of genuine agreement and genuine disagreement explicitly
3. Do not rush to synthesis — premature synthesis suppresses productive tension
4. After each round, summarise what has converged and what remains open
5. Stop when further rounds would not be productive — when positions are stable
   and arguments are repeating

### Evaluation precision

When evaluating output `:against` criteria, every criterion must receive an
explicit verdict: `:pass`, `:fail`, or `:partial`. "The evaluation was generally
positive" is not an evaluation. "Criterion 3 fails because X; criterion 5 is
partial because Y but not Z" is an evaluation.

When `:improve true` is specified, the improved output must address every
`:fail` and `:partial` finding. Selective improvement — fixing some findings
while ignoring others — is not acceptable.