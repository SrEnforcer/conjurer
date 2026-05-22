# orchestrate.md — Conjurer Orchestrate Grimoire

The spellbook for coordination. Real systems are not single operations —
they are ecosystems of cooperating processes that must succeed together,
fail together gracefully, and maintain consistency across boundaries that
no single operation controls. The `orchestrate` grimoire provides the
vocabulary for expressing these cooperative structures: workflows that
span services, sagas that maintain consistency across failures, circuits
that prevent cascading collapse, and observability that makes complex
execution visible.

---

## Philosophy

### Coordination as a first-class problem

Most programming abstractions address *computation within a service*. The
hard problems in modern systems are *between* services: how do we ensure
that a payment and an inventory update happen together or not at all? How
do we prevent one slow downstream service from degrading the entire request
path? How do we resume a long-running workflow after a failure without
reprocessing work already completed?

These coordination problems have known solutions — saga patterns, circuit
breakers, checkpointing, scatter-gather, compensation. But these solutions
are typically embedded in imperative code as scattered mechanisms rather
than expressed as explicit, composable, declarative structures. The
`orchestrate` grimoire makes coordination *visible*: every routing decision,
every error recovery strategy, every observability concern is stated
explicitly in the workflow definition rather than concealed in implementation.

### Workflow as institutional memory

A well-specified workflow is not just executable code — it is a record of
how the organisation has decided to perform a process. The routing decisions
capture policy: "if the risk score exceeds threshold X, escalate to a human
reviewer." The compensation handlers capture the organisation's agreement
about what "undoing" means: "a refund within 5 business days constitutes
adequate reversal of a failed payment." The monitoring configuration captures
the organisation's standards: "we page on-call when success rate drops below
90%."

These decisions belong in the workflow specification, not scattered across
code comments and team wikis. `orchestrate` gives them a home.

### The orchestrate/core boundary

`core` provides execution primitives: `sequence`, `parallel`, `branch`,
`retry`, `intercept`, `ward`. These are foundational — they express *how
operations relate*. `orchestrate` provides workflow-level abstractions built
on these primitives: named workflows with versioning, state management across
long execution spans, saga compensation patterns, circuit breakers, scheduled
execution, and human-in-the-loop integration. The boundary is: core for
primitive composition; orchestrate for workflow-level coordination.

### Five design principles

**Declarative workflow specification** — Workflows describe what should
happen, not how the machinery makes it happen. Coordination logic is visible
in the specification.

**State as first-class** — Workflow state is explicit data that flows through
the definition, enabling clear reasoning, testability, and persistence for
fault tolerance.

**Sophisticated error recovery** — Failures are inevitable. The question is
not whether failures happen but what the system does when they do. Every
failure mode has a declared recovery strategy.

**Observability throughout** — Production workflows require visibility into
execution. Logging, metrics, tracing, and alerting are built into the
workflow definition, not added as afterthoughts.

**Composition and reuse** — Complex workflows build from simpler sub-workflows.
Coordination patterns are encapsulated, tested independently, and reused.

---

## Naming rationale

**`o/`** — The short namespace alias.

**Workflow** — Coordinated sequence of operations from initiation to completion.

**Saga** — From Old Norse saga, a narrative of connected episodes. In
distributed systems, a saga maintains consistency across services through
compensating transactions — it can "tell the story backwards" when failures
require undoing prior steps.

**Circuit breaker** — Electrical safety device that interrupts current when
detecting faults. Software circuit breakers detect systematic failures and
fail fast to prevent cascading collapse.

**Checkpoint** — A persisted state snapshot that enables resumption from
a known point after failure, avoiding reprocessing of completed work.

---

## Part I: Workflow definition and execution

---

### `o/define-workflow`

Creates a declarative workflow specification — a named, versioned coordination
structure with explicit stages, routing, state management, error recovery,
and observability.

#### Signature

```clojure
(o/define-workflow name
  :description     string
  :version         semver
  :inputs          {:param-name :type ...}
  :outputs         {:result-name :type ...}
  :stages          [stage-definition ...]
  :state           {:persistence :memory | :database | :redis
                    :schema      state-schema}
  :error-handling  {:strategy   :retry | :compensate | :circuit-breaker | :fallback
                    :dead-letter destination}
  :monitoring      {:metrics boolean :tracing boolean :logging :level
                    :alerts  [alert-spec ...]}
  :timeout         duration
  :idempotency-key :field-name
  :manifest        workflow-definition)
```

#### Parameters

**`:stages`** — The workflow's steps. Each stage definition:
```clojure
{:name          :stage-name
 :operation     invocation-or-fn
 :on-success    :next-stage-name | nil (terminal)
 :on-failure    :error-stage-name | :compensate | :dead-letter
 :compensate    compensation-invocation    ;; for saga patterns
 :timeout       duration
 :retries       {:attempts n :backoff :exponential}
 :requires      [:prior-stage-name ...]   ;; dependency declaration
 :produces      :result-binding}
```

**`:state`** — How workflow state persists:
- `:memory` — in-process; lost on restart (suitable for short-lived workflows)
- `:database` — persisted to a relational store; enables resumption after failure
- `:redis` — persisted to Redis; fast; suitable for high-throughput workflows

**`:idempotency-key`** — A field from `:inputs` that uniquely identifies this
workflow instance. If a workflow with the same key is already running or has
completed successfully, the new invocation returns the existing result without
re-executing. Essential for payment and order workflows where duplicate
execution is harmful.

#### Example: Customer onboarding workflow

```clojure
(o/define-workflow :customer-onboarding
  :description "Complete onboarding for new B2B customers"
  :version     "2.1.0"

  :inputs {:application   :map
           :documents     :array
           :submitted-by  :uuid}

  :outputs {:customer-id   :uuid
            :account-ids   [:array :uuid]
            :welcome-email :sent | :queued}

  :stages [
    {:name      :validate-application
     :operation (conjure application-validator
                  :data application :schema b2b-schema)
     :on-success :enrich-company-data
     :on-failure :reject-with-reason
     :timeout    30000}

    {:name      :enrich-company-data
     :operation (parallel company-enrichment
                  :operations [
                    (conjure kvk-lookup :chamber-number (:kvk application))
                    (conjure credit-check :company-id (:company-id application))]
                  :combine-results :merge
                  :on-error :best-effort)
     :on-success :manual-review
     :timeout    60000}

    {:name      :manual-review
     :operation (o/human-approval
                  :reviewers [:onboarding-team]
                  :data      {:application application :enrichment enrichment-result}
                  :timeout   (hours 48)
                  :deadline-action :escalate-to-manager)
     :on-success :provision-accounts
     :on-failure :reject-with-reason}

    {:name      :provision-accounts
     :operation (sequence account-provisioning
                  :operations [
                    (conjure create-crm-record    :data application)
                    (conjure create-billing-account :data application)
                    (conjure setup-access-control  :customer-id crm-id)]
                  :on-error :compensate)
     :compensate (conjure deprovision-partial-accounts :context stage-state)
     :on-success :send-welcome
     :on-failure :compensate-and-alert}

    {:name      :send-welcome
     :operation (conjure send-onboarding-email
                  :to     (:email application)
                  :template :b2b-welcome-v3)
     :on-success nil   ;; terminal stage
     :on-failure :queue-email-retry}]

  :state {:persistence :database}

  :error-handling {:strategy :compensate
                   :dead-letter {:type :database :table "onboarding_failures"}}

  :monitoring {:metrics true
               :tracing true
               :logging :info
               :alerts  [
                 {:condition (fn [m] (> (:p95-duration-hours m) 72))
                  :message   "Onboarding p95 exceeding 72-hour SLA"
                  :action    :page-on-call}]}

  :timeout       (hours 96)
  :idempotency-key :application-id)
```

---

### `o/execute-workflow`

Initiates an instance of a defined workflow, managing its lifecycle from
invocation through completion or terminal failure.

#### Signature

```clojure
(o/execute-workflow workflow-definition
  :inputs        {:param value ...}
  :priority      :standard | :high | :critical
  :dry-run       boolean
  :resume-from   checkpoint-id
  :manifest      execution-handle)
```

#### Parameters

**`:dry-run`** — Execute the workflow logic without side effects. Useful for
validating workflow definitions and testing routing decisions before
committing to production execution.

**`:resume-from`** — Resume execution from a named checkpoint, skipping stages
already completed. Used for recovery after partial failure.

---

### `o/workflow-status`

Queries the current state of a running or completed workflow instance.

#### Signature

```clojure
(o/workflow-status execution-handle
  :include    [:current-stage :stage-history :state-snapshot :metrics :errors])
```

#### Example

```clojure
(o/workflow-status onboarding-execution
  :include [:current-stage :stage-history :metrics])

;; Returns:
{:workflow    :customer-onboarding
 :instance-id "inst-2025-11-03-0042"
 :status      :awaiting-human-approval
 :current-stage {:name :manual-review
                 :started-at "2025-11-03T09:15:00Z"
                 :waiting-for "onboarding-team review"
                 :deadline "2025-11-05T09:15:00Z"}
 :stage-history [
   {:name :validate-application :status :completed :duration-ms 843}
   {:name :enrich-company-data  :status :completed :duration-ms 4210
    :note "Credit check returned :medium risk"}]
 :metrics {:elapsed-hours 4.2 :stages-completed 2 :stages-remaining 3}}
```

---

## Part II: Coordination patterns

---

### `o/scatter-gather`

Distributes work to multiple operations in parallel (scatter), then aggregates
the results according to a declared strategy (gather). A high-level abstraction
over `parallel` from core.

#### Signature

```clojure
(o/scatter-gather name
  :scatter     {worker-id operation ...}
  :gather      :merge | :first-wins | :quorum | :custom-fn
  :timeout     duration
  :min-responses n
  :on-timeout  :use-available | :fail
  :manifest    result-binding)
```

#### Parameters

**`:gather :quorum`** — Accept the result only when a minimum number of
workers agree. Used for consensus operations where a single source is not
authoritative.

**`:min-responses`** — Minimum number of successful responses needed before
triggering gather. If fewer succeed within `:timeout`, trigger `:on-timeout`
behaviour.

#### Example: Multi-source credit assessment

```clojure
(o/scatter-gather credit-assessment
  :scatter {
    :experian  (conjure credit-check :provider :experian :company-id id)
    :equifax   (conjure credit-check :provider :equifax  :company-id id)
    :internal  (conjure credit-check :provider :internal-model :company-id id)}
  :gather        :quorum
  :min-responses 2
  :timeout       10000
  :on-timeout    :use-available
  :manifest assessment-result)

;; ✓ All three credit checks run concurrently
;; ✓ Result is accepted when ≥ 2 sources respond
;; ✓ If only 1 responds within 10 seconds, use-available rather than fail
;; ✓ Final result includes all successful responses with source attribution
```

---

### `o/human-approval`

Implements human-in-the-loop pattern for workflows requiring manual review,
approval, or decision-making that the system cannot or should not make
autonomously.

#### Signature

```clojure
(o/human-approval
  :reviewers        [:role | :user-id ...]
  :data             display-data
  :options          {:approve description :reject description :escalate description}
  :timeout          duration
  :deadline-action  :escalate | :auto-approve | :auto-reject | :cancel
  :escalate-to      [:reviewer ...]
  :notification     {:channels [:email :slack :teams] :template :keyword}
  :audit-trail      boolean)
```

#### Design rationale

Automation is valuable but not always appropriate. Payment fraud decisions
above certain thresholds require human judgment. Employee termination
workflows must include HR sign-off. Medical dosing decisions in clinical
systems require physician approval. `o/human-approval` provides a structured,
auditable pattern for these human checkpoints rather than leaving them as
implicit email chains or verbal handoffs.

The `:deadline-action` parameter specifies what happens when the timeout expires
without a decision. This forces explicit policy: does an unanswered review
default to rejection (safe), approval (permissive), escalation (responsible),
or cancellation (conservative)?

#### Example: Compliance exception approval

```clojure
(o/human-approval
  :reviewers   [:compliance-officer :legal-counsel]
  :data        {:exception-request exception-data
                :risk-assessment   risk-report
                :business-case     justification}
  :options     {:approve  "Approve exception for stated period and scope"
                :reject   "Reject; require alternative approach"
                :escalate "Escalate to Chief Compliance Officer"}
  :timeout     (hours 24)
  :deadline-action :escalate
  :escalate-to [:chief-compliance-officer]
  :notification {:channels [:email :teams]
                 :template :compliance-exception-review}
  :audit-trail true)

;; ✓ Both reviewers receive structured notification with all required data
;; ✓ Decision and reasoning are permanently recorded in audit trail
;; ✓ After 24 hours without decision, automatically escalates to CCO
;; ✓ Escalation itself gets a 24-hour window before further escalation
```

---

### `o/circuit-breaker`

Monitors calls to a downstream dependency and "opens the circuit" when
systematic failures are detected — failing fast to protect the system from
cascading failures and allowing the downstream service time to recover.

#### Signature

```clojure
(o/circuit-breaker name
  :protect      operation
  :open-when    {:error-rate    threshold   ;; fraction 0.0-1.0
                 :window-size   n           ;; number of calls to evaluate
                 :min-calls     n}          ;; minimum calls before evaluation
  :reset-after  duration
  :half-open    {:allow-through n}          ;; test calls when half-open
  :on-open      callback-fn
  :fallback     fallback-operation
  :manifest     result-binding)
```

#### States

A circuit breaker cycles through three states:
- **Closed** — normal operation; all calls pass through; failures are counted
- **Open** — failure threshold exceeded; all calls fail fast with fallback;
  downstream service is not called
- **Half-open** — after `:reset-after` duration, allows through `:allow-through`
  test calls; if they succeed, circuit closes; if they fail, circuit re-opens

#### Example: Payment gateway protection

```clojure
(o/circuit-breaker payment-gateway
  :protect    (conjure gateway-call :payment payment-data)
  :open-when  {:error-rate  0.5    ;; Open when 50%+ calls fail
               :window-size 20     ;; Evaluated over last 20 calls
               :min-calls   10}    ;; Don't open on fewer than 10 calls
  :reset-after (seconds 30)
  :half-open  {:allow-through 3}
  :on-open    (fn [stats]
                (log/warn "Payment gateway circuit opened"
                          :error-rate (:error-rate stats))
                (metrics/gauge "payment.circuit.state" :open))
  :fallback   (conjure queue-payment-async
                :payment payment-data
                :notify-customer true)
  :manifest   payment-result)
```

---

### `o/schedule`

Defines a scheduled, recurring workflow trigger — the equivalent of a
declarative cron job with observability, error handling, and overlap
prevention built in.

#### Signature

```clojure
(o/schedule name
  :trigger       {:cron "0 8 * * 1-5"} | {:interval (hours 1)} | {:at "09:00"}
  :timezone      "Europe/Amsterdam"
  :workflow      workflow-definition
  :inputs        {:param value ...}
  :overlap       :skip | :queue | :cancel-previous
  :on-failure    :retry | :alert | :skip-until-next
  :monitoring    {:metrics boolean :alert-on-failure boolean}
  :active        boolean)
```

#### Parameters

**`:overlap`** — What to do when a scheduled trigger fires while the previous
instance is still running:
- `:skip` — skip this trigger; the previous run is still in progress
- `:queue` — queue this trigger; it runs when the previous completes
- `:cancel-previous` — cancel the running instance and start fresh

#### Example: Daily reconciliation

```clojure
(o/schedule daily-account-reconciliation
  :trigger   {:cron "0 6 * * 1-5"}    ;; 06:00 weekdays
  :timezone  "Europe/Amsterdam"
  :workflow  account-reconciliation-workflow
  :inputs    {:date :yesterday :source :primary-ledger}
  :overlap   :skip
  :on-failure :alert
  :monitoring {:metrics true :alert-on-failure true}
  :active    true)
```

---

### `o/replay`

Re-executes a workflow instance from a specific stage, using the original
inputs and state up to that stage but potentially with modified inputs or
corrected data. Essential for recovering from data quality issues that
caused partial failures.

#### Signature

```clojure
(o/replay execution-handle
  :from-stage     :stage-name
  :with-overrides {:input-field new-value ...}
  :dry-run        boolean
  :manifest       new-execution-handle)
```

#### Design rationale

Failures in production are not always failures of code — they are often
failures of data. A mis-formatted input field, a temporary downstream
unavailability, a data quality issue caught mid-workflow. When the data
problem is corrected, the workflow should not have to restart from the
beginning — especially if early stages are expensive (external API calls,
manual approvals that have already been completed).

`o/replay` preserves the completed portion of a workflow and re-executes
from the point of failure with corrected data.

#### Example

```clojure
;; The onboarding workflow failed at :provision-accounts because
;; the CRM system was briefly unavailable. The CRM is now back.
(o/replay failed-onboarding-execution
  :from-stage :provision-accounts
  ;; No overrides needed — the failure was infrastructure, not data
  :dry-run false)
```

---

### `o/audit-trail`

Produces a complete, human-readable execution history of a workflow instance
— every decision made, every stage executed, every error encountered, every
human action taken.

#### Signature

```clojure
(o/audit-trail execution-handle
  :include     [:decisions :state-transitions :human-actions :errors :timing]
  :format      :chronological | :by-stage | :anomalies-only
  :output      :audit-report)
```

#### Design rationale

Compliance, incident investigation, and operational review all require the
ability to answer "exactly what happened?" for a specific workflow instance.
`o/audit-trail` produces a complete answer — not just the final state but
the complete sequence of decisions, inputs, outputs, errors, and human
interventions that produced it.

#### Example

```clojure
(o/audit-trail onboarding-execution-0042
  :include [:decisions :human-actions :errors :timing]
  :format  :chronological)

;; Returns:
{:workflow  :customer-onboarding
 :instance  "inst-0042"
 :timeline [
   {:time "09:00:12" :event :workflow-started :inputs {:company "ACME BV" :kvk "12345678"}}
   {:time "09:00:13" :event :stage-started    :stage :validate-application}
   {:time "09:00:14" :event :stage-completed  :stage :validate-application :result :valid}
   {:time "09:00:14" :event :stage-started    :stage :enrich-company-data}
   {:time "09:00:19" :event :enrichment-partial
    :detail "KvK lookup succeeded; credit check timed out — proceeding with :medium risk default"}
   {:time "09:00:19" :event :stage-completed  :stage :enrich-company-data}
   {:time "09:00:19" :event :stage-started    :stage :manual-review}
   {:time "11:32:07" :event :human-action     :actor "analyst@company.nl"
    :action :approved :notes "Financials reviewed; credit risk acceptable"}
   {:time "11:32:08" :event :stage-completed  :stage :manual-review}
   {:time "11:32:08" :event :stage-started    :stage :provision-accounts}
   {:time "11:32:14" :event :error            :stage :provision-accounts
    :error "CRM temporarily unavailable — HTTP 503"}
   {:time "11:32:14" :event :stage-failed     :stage :provision-accounts}
   {:time "11:32:14" :event :compensation-started :compensate :deprovision-partial}
   {:time "11:32:15" :event :compensation-completed}
   {:time "11:32:15" :event :workflow-paused  :reason "awaiting-replay"}]}
```

---

## Part III: Error recovery patterns

---

### Saga with compensation

Saga is the canonical pattern for maintaining consistency in long-running
transactions that span multiple services. Each stage registers a compensating
operation; if any stage fails after prior stages have succeeded, compensations
run in reverse order.

```clojure
(o/define-workflow :order-placement-saga
  :stages [
    {:name      :reserve-inventory
     :operation (conjure reserve :items order-items)
     :compensate (conjure release-reservation :items order-items)
     :on-failure :compensate}

    {:name      :authorise-payment
     :operation (conjure authorise :amount total :card card-token)
     :compensate (conjure void-authorisation :auth-id auth-id)
     :on-failure :compensate}

    {:name      :create-shipment
     :operation (conjure create-shipment-record :order order-id)
     :compensate (conjure cancel-shipment :shipment-id shipment-id)
     :on-failure :compensate}]

  :error-handling {:strategy :compensate})

;; If :create-shipment fails after :authorise-payment and :reserve-inventory succeeded:
;; System automatically executes:
;; → void-authorisation
;; → release-reservation
;; In reverse order — clean, consistent rollback.
```

---

## Best practices

### Name your compensations explicitly

Every stage that modifies shared state should have an explicit `:compensate`
handler. Not every stage needs one (reading data has no side effect to undo)
but every stage that does should make its compensation visible in the
specification rather than relying on implicit rollback.

### Set idempotency keys on every stateful workflow

If a workflow can be triggered multiple times for the same logical operation
(network retries, user double-clicks, queue re-delivery), it must have an
`:idempotency-key`. Without one, duplicate executions cause duplicate state
mutations.

### Size timeouts to actual recovery expectations

A timeout on a human approval stage should be the business SLA for that
review, not an arbitrary technical default. A timeout on an external API call
should be the maximum acceptable latency for that call's use case. Timeouts
communicate policy and must be deliberate.

### Make escalation paths explicit

Every `:deadline-action` and `:on-failure` is a policy decision. When a
human review times out, does it auto-approve or escalate? When a compensation
fails, who is notified? These questions have answers in every organisation;
those answers belong in the workflow specification.

### Monitor at the workflow level, not just the operation level

Individual operation metrics are necessary but not sufficient. A workflow can
succeed at every stage while still behaving badly at the workflow level —
taking too long overall, having too many manual interventions, failing too
frequently at one particular stage. Workflow-level metrics surface these
systemic issues.

---

## Integration patterns

### Orchestrate as the cross-grimoire glue

The orchestrate grimoire coordinates outputs from all other grimoires into
coherent end-to-end workflows.

```clojure
(o/define-workflow :document-intelligence-pipeline
  :stages [
    {:name :explore    :operation (d/explore documents :depth 3)}
    {:name :analyse    :operation (s/texan domain-model :models [:argumentation :risk])}
    {:name :generate   :operation (data/generate :from-domain domain-model :count 100)}
    {:name :prototype  :operation (w/prototype "Analysis Portal" :from-domain domain-model)}
    {:name :review     :operation (o/human-approval :reviewers [:analyst-team])}
    {:name :report     :operation (e/compose "Executive Summary" :from-analysis analysis)}])
```

### Circuit breakers on all external calls

Every call to an external service should be wrapped in a circuit breaker.
The exact parameters vary by service criticality and expected reliability,
but the pattern is universal.

```clojure
;; Template: external service call with circuit breaker
(o/circuit-breaker service-name
  :protect    (retry service-call :attempts 3 :backoff :exponential)
  :open-when  {:error-rate 0.5 :window-size 20 :min-calls 10}
  :reset-after (seconds 30)
  :fallback   (ward :protect nil :recover {open? graceful-degradation}))
```

---

## Grimoire metadata

```clojure
{:grimoire    "orchestrate"
 :namespace   "o/"
 :version     "2.0.0"
 :description "Workflow definition, coordination patterns, error recovery,
               scheduling, and observability for complex multi-service operations"

 :constructs {
   :definition  [o/define-workflow o/execute-workflow o/workflow-status]
   :patterns    [o/scatter-gather o/human-approval o/circuit-breaker]
   :operations  [o/schedule o/replay o/audit-trail]}

 :best-for [
   "Multi-service workflows with saga compensation"
   "Human-in-the-loop approval processes with audit trails"
   "Long-running processes with checkpointing and resumption"
   "Scheduled recurring workflows with overlap management"
   "Circuit-breaker protection of external dependencies"
   "Failure recovery and replay from specific workflow stages"
   "Cross-grimoire workflow coordination"]

 :works-with [:core :domain :data :web :semantics :eloquence]

 :key-concepts [
   {:term "Saga"
    :definition "A pattern for distributed transactions that uses compensating
                 operations to undo prior stages when a later stage fails.
                 Maintains consistency without requiring distributed locks."}
   {:term "Circuit breaker"
    :definition "A protection mechanism that detects systematic failures in
                 a downstream dependency and fails fast to prevent cascading
                 collapse across the system."}
   {:term "Compensation"
    :definition "An operation that semantically undoes the effect of a
                 prior stage. Not always a perfect inverse — a refund
                 compensates a charge; a cancellation notice compensates
                 a confirmation email."}
   {:term "Checkpoint"
    :definition "A persisted snapshot of workflow state at a specific stage.
                 Enables resumption from a known point after failure."}
   {:term "Idempotency key"
    :definition "A unique identifier for a logical workflow instance that
                 prevents duplicate execution when the same workflow is
                 triggered multiple times."}
   {:term "Human-in-the-loop"
    :definition "A structured pattern for incorporating human judgment
                 into automated workflows, with defined timeouts,
                 escalation paths, and audit trails."}]}
```

---

## Implementation notes for LLM processors

### Stage dependency resolution

When stages declare `:requires [:prior-stage]`, execute them only after all
required stages complete. Stages without explicit dependencies can run in
parallel when they share no state mutations. Make parallelism opportunities
visible in the workflow documentation even if the orchestration runtime
determines actual scheduling.

### Compensation ordering

Compensation always runs in reverse stage order. If stages A, B, C completed
and D failed, compensate C, then B, then A. Never skip a compensation because
it seems unnecessary — the compensation handler was declared because the stage
has side effects, and those effects must be reversed.

### Idempotency enforcement

When `:idempotency-key` is specified and a workflow instance with that key
already exists:
- If the prior instance is **running**: return its execution handle; do not
  start a new instance
- If the prior instance **succeeded**: return its result immediately; do not
  re-execute
- If the prior instance **failed**: start a new instance (the failure may
  be retryable; the practitioner can control this with the `:on-failure` strategy)

### Circuit breaker state transitions

The circuit breaker must track state persistently — not just in-process — to
function correctly under horizontal scaling. A circuit that opens in one
process instance must be open in all instances. Use a shared store (Redis,
database) for circuit breaker state.

### Human approval audit requirements

Every `o/human-approval` interaction must be permanently logged with:
- The reviewer's identity
- The timestamp of the decision
- The decision taken (approve/reject/escalate)
- Any notes or reasoning provided
- The data presented to the reviewer at decision time (for evidential completeness)

This record must be immutable once written and retained for the compliance
period applicable to the workflow's domain.