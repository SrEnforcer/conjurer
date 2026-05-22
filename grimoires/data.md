# data.md — Conjurer Data Grimoire

The spellbook for information. Data is the substrate through which systems
know things — it is not merely storage but the epistemological foundation of
every system's understanding of its domain. The `data` grimoire provides a
complete vocabulary for the data lifecycle: generation, schema definition,
transformation, validation, profiling, provenance, and privacy.

---

## Philosophy

### Data as epistemological substrate

Systems know things through their data. A payment processor's understanding
of a customer's creditworthiness is exactly its data. A hospital's knowledge
of a patient's condition is its records. An e-commerce platform's belief about
available inventory is its database. This means that bad data is not merely
an inconvenience — it is a *false belief held by the system*. A system that
trusts malformed data acts on false beliefs, and its behaviour degrades
accordingly.

This framing has consequences. Data quality is not a hygiene concern — it is
an epistemic concern. Schema definitions are not bureaucratic artefacts — they
are *formal statements of what the system can know and how*. Transformation
pipelines are not mechanical processes — they are *reasoning chains* that
derive new knowledge from existing knowledge. Provenance is not metadata —
it is *the system's record of how it came to believe what it believes*.

The `data` grimoire is built around this epistemological model. Every construct
is designed to make the system's knowledge more accurate, more complete, more
traceable, and more honest about its limitations.

### Schema as contract and specification

A schema makes implicit structure explicit. Without a schema, every component
that touches a data record carries its own mental model of what fields exist,
what types they hold, and what values are valid. These mental models diverge.
With a schema, there is one specification, and components are validated against
it rather than against each developer's assumption.

Schemas serve multiple roles simultaneously: they document expectations for
humans, enable validation for systems, guide generation for tests, govern
transformation for pipelines, and drive test generation for quality assurance.
This multiplicity is not incidental — it is why schemas belong in `data` rather
than scattered across the other grimoires.

### Quality by construction, not inspection

The most expensive time to find a data quality problem is after it has
propagated through a pipeline, been persisted to storage, and informed a
downstream decision. The cheapest time is at the point of entry. `data`
constructs are designed around this principle: validate early, validate
often, make violations visible immediately, and never pass bad data to the
next stage.

This principle also drives the test generation approach: schemas carry enough
information to generate comprehensive tests automatically. Manual test writing
for standard validation scenarios is a waste of effort that `data/generate-tests`
eliminates.

### Five design principles

**Schema as contract** — Schemas are first-class artefacts that drive the
entire data lifecycle. Where traditional approaches leave schema implicit in
code, Conjurer makes it explicit and reusable.

**Declarative transformation** — Specify desired outcomes, not procedural steps.
Describe what transformed data should look like; the system determines how.

**Quality by construction** — Build quality into the lifecycle from the start.
Generate data that satisfies constraints by design. Validate during
transformation to catch issues before propagation.

**Locale and cultural awareness** — Data has cultural context. Dutch postal
codes, IBAN formats, BSN check digits, name conventions — the grimoire
understands these natively.

**Lineage and provenance** — Data's history matters. Where did it come from?
What transformations were applied? What was masked and why? These questions
must be answerable.

---

## Naming rationale

**`data/`** — The namespace prefix. Short and unambiguous.

**Schema** — From Greek *skhēma*, "form, shape." A schema gives data its form.

**Synthetic** — From Greek *synthetikos*, "skilled in putting together."
Synthetic data assembles realistic structure without containing real sensitive
information.

**Pipeline** — Operations connected in sequence, each receiving the previous
stage's output. Data flows through the pipeline as water through pipes.

**Lineage** — The data's ancestry: where it came from, how it was transformed,
what decisions it informed. Lineage makes provenance traceable.

---

## Part I: Generation and synthesis

Realistic data is essential for development, testing, demonstration, and
privacy-preserving analytics. Generation functions manifest datasets that
match production statistical characteristics without containing sensitive
information.

---

### `data/schema`

Defines a formal schema for an entity type — the canonical specification of
what the data is, what it must contain, what constraints it must satisfy, and
what it means.

#### Signature

```clojure
(data/schema entity-name
  :fields       {field-name field-spec ...}
  :required     [field ...]
  :unique       [:field | [:field-a :field-b] ...]
  :indexes      [{:fields [...] :type :btree | :hash | :fulltext} ...]
  :constraints  [{:rule expression :message string :severity :error | :warning} ...]
  :relationships [{:field :target-entity :type :one-to-many | :many-to-one | :many-to-many
                   :cascade :delete | :preserve | :nullify} ...]
  :compliance   [:gdpr :hipaa :pci-dss ...]
  :phi-fields   [:field ...]
  :pci-fields   [:field ...]
  :immutable    [:field ...]
  :output       :edn | :json-schema | :sql-ddl | :graphql-schema | :openapi)
```

#### Parameters

**`entity-name`** — The entity type being defined. Used as the root identifier
throughout the data lifecycle.

**`:fields`** — Map of field names to specifications. Field specs combine type,
format, constraints, and semantic markers:
- Type: `:uuid`, `:string`, `:integer`, `:decimal`, `:boolean`, `:date`,
  `:timestamp`, `:array`, `:map`, `:enum`
- Format: `:email`, `:phone`, `:dutch-postal-code`, `:dutch-bsn`, `:iban`,
  `:iso-4217`, `:iso-3166`, `:url`
- Constraints: `:min`, `:max`, `:min-length`, `:max-length`, `:pattern`,
  `:unique`, `:optional`, `:immutable`
- Semantics: `:phi true`, `:pci true`, `:encrypted true`, `:generated true`

**`:compliance`** — Compliance frameworks that apply to this entity. Named
frameworks activate implied behaviours: `:gdpr` marks PHI fields and adds
right-to-erasure support; `:hipaa` adds audit-logging requirements; `:pci-dss`
marks cardholder data fields for encryption.

**`:phi-fields`** — Fields containing protected health information. Triggers
HIPAA-appropriate handling regardless of whether `:hipaa` is in `:compliance`.

**`:immutable`** — Fields that must never change after initial creation.
`:created-at`, `:id`, and audit fields are common candidates.

#### Example 1: Order schema with compliance

```clojure
(data/schema :order
  :fields {
    :order-id     {:type :uuid :generated true :immutable true}
    :customer-id  {:type :uuid :references :customer}
    :placed-at    {:type :timestamp :default :now :immutable true}
    :items        {:type :array :element-type :order-item :min-length 1}
    :subtotal     {:type :decimal :precision 2 :min 0}
    :vat-amount   {:type :decimal :precision 2 :min 0}
    :total        {:type :decimal :precision 2 :min 0}
    :currency     {:type :string :format :iso-4217 :default "EUR"}
    :status       {:type :enum
                   :values [:cart :submitted :confirmed :shipped :delivered
                            :cancelled :refunded]
                   :default :cart}
    :payment-method {:type :enum
                     :values [:ideal :credit-card :bank-transfer :paypal]
                     :required-when (fn [o] (#{:confirmed :shipped :delivered} (:status o)))}
    :tracking-number {:type :string :optional true
                      :pattern "^[A-Z]{2}[0-9]{9}[A-Z]{2}$"
                      :required-when (fn [o] (= :shipped (:status o)))}}

  :required  [:order-id :customer-id :placed-at :items :total :status]
  :unique    [:order-id]
  :indexes   [{:fields [:customer-id] :type :btree}
              {:fields [:placed-at]   :type :btree}
              {:fields [:status]      :type :hash}]

  :constraints [
    {:rule    (fn [o] (= (:total o) (+ (:subtotal o) (:vat-amount o))))
     :message "total must equal subtotal + vat-amount"
     :severity :error}
    {:rule    (fn [o] (>= (:subtotal o) 0))
     :message "subtotal must be non-negative"
     :severity :error}]

  :relationships [
    {:field :customer-id :target :customer :type :many-to-one :cascade :preserve}
    {:field :items       :target :order-item :type :one-to-many :cascade :delete}]

  :compliance [:gdpr]
  :output :edn)
```

#### Example 2: Patient schema with HIPAA compliance

```clojure
(data/schema :patient
  :fields {
    :patient-id  {:type :uuid :generated true :immutable true}
    :mrn         {:type :string :pattern "^MRN[0-9]{10}$" :unique true :phi true}
    :first-name  {:type :string :min-length 1 :max-length 100 :phi true}
    :last-name   {:type :string :min-length 1 :max-length 100 :phi true}
    :dob         {:type :date :min "1900-01-01" :max :today :phi true :immutable true}
    :ssn         {:type :string :pattern "^[0-9]{3}-[0-9]{2}-[0-9]{4}$"
                  :encrypted true :phi true}
    :gender      {:type :enum :values [:male :female :other :unknown]}
    :email       {:type :email :optional true :phi true}
    :phone       {:type :phone :optional true :phi true}
    :consent-given {:type :boolean :required true}
    :created-at  {:type :timestamp :default :now :immutable true}
    :updated-at  {:type :timestamp :default :now :auto-update true}}

  :required  [:patient-id :mrn :first-name :last-name :dob :gender :consent-given]
  :unique    [:patient-id :mrn :ssn]
  :phi-fields [:first-name :last-name :dob :ssn :email :phone :mrn]

  :constraints [
    {:rule    (fn [p] (or (:email p) (:phone p)))
     :message "At least one contact method (email or phone) is required"
     :severity :error}]

  :compliance [:hipaa :hitech]

  ;; HIPAA compliance activates automatically:
  ;; ✓ Audit logging on every phi-field access or mutation
  ;; ✓ Encryption required for ssn, dob, email, phone at rest
  ;; ✓ Retention policy: 7 years after last encounter
  ;; ✓ Access control: minimum-necessary standard enforced
  )
```

---

### `data/generate`

Manifests complete, realistic datasets based on a schema. Generates synthetic
data that respects constraints, maintains referential integrity, and exhibits
statistically realistic distributions.

#### Signature

```clojure
(data/generate entity-type
  :count         n
  :schema        schema-definition
  :locale        :nl | :en | :de | :fr | :es | ...
  :quality       :basic | :realistic | :production
  :constraints   [{:field :rule} ...]
  :relationships {:field {:references parent-dataset :distribution :distribution-type}}
  :distributions {:field :normal | :uniform | :zipf | :pareto | :log-normal | :poisson}
  :anomalies     {:rate 0.02 :types [:missing-required :out-of-range :wrong-type]}
  :seed          n
  :output        :edn | :json | :csv | :sql)
```

#### Parameters

**`:quality`** — Realism level:
- `:basic` — structurally valid but generic; fast generation
- `:realistic` — varied distributions, culturally appropriate values, realistic
  correlations (older customers have longer tenure; VIP customers have more
  orders)
- `:production` — statistically indistinguishable from real production data;
  includes rare edge cases, outliers, and complex cross-field correlations

**`:anomalies`** — Intentionally inject known-bad data at a specified rate,
for testing validation and error handling. `:types` specifies what kinds of
anomalies to introduce: missing required fields, values outside valid ranges,
wrong types, duplicate unique keys.

**`:locale`** — Activates locale-specific generation: Dutch customers get valid
BSN numbers (11-proof check digit), postal codes in `#### AA` format, Dutch
mobile numbers (`+316...`), Dutch street names and province names. German
customers get valid Steuernummer formats, German postal codes and city names.

#### Example 1: Dutch e-commerce customers with realistic distributions

```clojure
(data/generate :customer
  :count  500
  :locale :nl
  :quality :realistic
  :schema {
    :id           {:type :uuid}
    :bsn          {:type :string :format :dutch-bsn :unique true}
    :first-name   :string
    :last-name    :string
    :email        {:type :email :unique true}
    :phone        {:type :phone :format :dutch-mobile}
    :postal-code  {:type :string :format :dutch-postal-code}
    :city         :string
    :dob          {:type :date :min "1940-01-01" :max "2005-12-31"}
    :since        {:type :date :min "2018-01-01" :max "2025-11-01"}
    :order-count  :integer
    :ltv          {:type :decimal :precision 2}}
  :constraints [
    {:field :since :after :dob}
    {:field :ltv   :min 0}]
  :distributions {
    :order-count :zipf       ;; Few heavy buyers, many light buyers
    :ltv         :pareto}    ;; 80/20 — few customers drive most revenue
  :seed 42
  :output :edn)

;; ✓ BSN numbers pass 11-proof algorithm
;; ✓ Postal codes match Dutch #### AA format with real city-code pairings
;; ✓ Mobile numbers are valid Dutch +316 numbers
;; ✓ :since is always after :dob
;; ✓ order-count and ltv follow realistic heavy-tail distributions
;; ✓ Reproducible across runs with :seed 42
```

#### Example 2: Relational generation with referential integrity

```clojure
(def customers (data/generate :customer :count 100 :locale :nl :schema customer-schema :seed 42))

(data/generate :order
  :count  500
  :schema order-schema
  :relationships {
    :customer-id {:references customers :field :id :distribution :zipf}}
  :distributions {:total :log-normal :item-count :poisson}
  :constraints   [{:field :placed-at :after-referenced-field [:customer-id :since]}]
  :seed 43
  :output :edn)

;; ✓ Every :customer-id references an actual customer
;; ✓ :placed-at is always after the referenced customer's :since date
;; ✓ :distribution :zipf — some customers have many orders, most have few
```

#### Example 3: Anomaly injection for validation testing

```clojure
(data/generate :customer
  :count    1000
  :schema   customer-schema
  :quality  :realistic
  :anomalies {:rate 0.05    ;; 5% of records contain anomalies
              :types [:missing-required :out-of-range :duplicate-unique]}
  :seed 99
  :output :edn)

;; Returns 1000 records, ~50 of which contain intentional defects:
;; - Some records missing :email (required field)
;; - Some records with :dob in the future
;; - Some records with duplicate :bsn values
;; 
;; Ideal for testing that validation pipelines catch all defect types.
;; The defect rate and types are controlled and reproducible.
```

---

## Part II: Transformation and conversion

Data rarely arrives in the exact form needed. Transformation functions reshape
data declaratively while maintaining semantic integrity.

---

### `data/transform`

Applies a declarative sequence of operations to data, reshaping structure,
filtering records, enriching fields, and aggregating values.

#### Signature

```clojure
(data/transform source
  :operations    [operation ...]
  :streaming     boolean
  :batch-size    n
  :error-handling :skip | :stop | :collect | :dead-letter
  :output        :edn | :json | :csv
  :manifest      result-binding)
```

#### Operation vocabulary

```clojure
;; Filtering
{:op :filter        :predicate (fn [r] (> (:age r) 18))}
{:op :reject        :predicate (fn [r] (nil? (:email r)))}

;; Field mapping
{:op :rename        :from :first_name :to :first-name}
{:op :map-field     :field :email :fn clojure.string/lower-case}
{:op :map           :fn (fn [r] (assoc r :full-name (str (:first-name r) " " (:last-name r))))}
{:op :drop-fields   :fields [:internal-id :legacy-code]}
{:op :keep-fields   :fields [:id :email :name]}

;; Enrichment
{:op :enrich        :field :geocoded :from (fn [r] (geocode (:address r)))}
{:op :join          :with other-dataset :on :id :type :left}
{:op :lookup        :field :customer-tier :in tier-table :key :customer-id}

;; Aggregation
{:op :group-by      :field :category}
{:op :aggregate     :measures {:count :count :total {:field :amount :fn :sum}}}
{:op :window        :type :tumbling | :sliding :size duration}

;; Sorting and deduplication
{:op :sort-by       :field :created-at :direction :desc}
{:op :deduplicate   :on [:email]}
{:op :limit         :n 1000}

;; Derived fields
{:op :derive        :field :age :from :dob :using :years-since}
{:op :coerce        :field :amount :to :decimal :precision 2}
{:op :normalise     :field :status :mapping {:ACTIVE :active :INACTIVE :inactive}}
```

#### Example: Customer enrichment pipeline

```clojure
(~> "customers-raw.csv"
  (data/transform
    :operations [
      {:op :parse      :format :csv :header true}
      {:op :filter     :predicate (fn [r] (seq (:email r)))}
      {:op :map-field  :field :email :fn clojure.string/lower-case}
      {:op :deduplicate :on [:email]}
      {:op :coerce     :field :age :to :integer}
      {:op :reject     :predicate (fn [r] (< (:age r) 18))}]
    :streaming true :batch-size 5000)

  (data/transform
    :operations [
      {:op :enrich :field :risk-band
       :from (fn [r] (classify-risk (:credit-score r)))}
      {:op :derive :field :segment
       :from [:total-orders :ltv]
       :using (fn [r] (cond (> (:ltv r) 5000) :vip
                            (> (:ltv r) 1000) :gold
                            :else :standard))}])

  (data/validate :against customer-schema :on-failure :collect))
```

---

### `data/convert-format`

Translates data between formats while preserving semantic meaning. Handles
format-specific nuances intelligently.

#### Signature

```clojure
(data/convert-format source
  :from     :csv | :json | :xml | :excel | :parquet | :avro | :ndjson
  :to       :csv | :json | :xml | :excel | :parquet | :avro | :ndjson
  :schema   schema-definition
  :preserve [:precision :types :structure :metadata]
  :options  {:format-specific-options}
  :validate-output boolean
  :output   :edn | {:type :file :path "path"}
  :manifest result-binding)
```

#### Design rationale

Format conversion hides complexity. CSV lacks a date standard; JSON loses
decimal precision with floats; XML encodes hierarchy differently than JSON;
Excel has complex type systems with formula evaluation. Naive conversion loses
information or introduces errors.

The `:schema` parameter provides semantic guidance — a field marked as
`:decimal :precision 2` will be written to Parquet as `DECIMAL(38,2)`, not
as a float. A `:timestamp` field will use ISO-8601 in JSON, epoch milliseconds
in Parquet, and locale-appropriate strings in Excel. The schema makes these
translation decisions consistent and explicit.

#### Example: CSV to Parquet with precision preservation

```clojure
(data/convert-format "transactions.csv"
  :from :csv
  :to   :parquet
  :schema {
    :id        :uuid
    :amount    {:type :decimal :precision 2}   ;; Must not become float
    :timestamp {:type :timestamp :format :iso-8601}
    :currency  {:type :string :format :iso-4217}}
  :preserve [:precision :types]
  :options  {:parquet {:compression :snappy :row-group-size 100000}}
  :validate-output true
  :output   {:type :file :path "transactions.parquet"})

;; :amount is stored as DECIMAL(38,2) in Parquet — no precision loss
;; :timestamp preserves microsecond precision
;; :currency is stored as FIXED_LEN_BYTE_ARRAY(3)
```

---

### `data/pipeline`

Constructs named, multi-stage data processing pipelines with explicit error
handling, monitoring, and checkpointing.

#### Signature

```clojure
(data/pipeline name
  :source       source-specification
  :stages       [stage-definition ...]
  :error-handling {:strategy :stop | :dead-letter | :retry
                   :dead-letter-destination destination}
  :monitoring   {:metrics boolean :logging :level :alerts [alert-spec ...]}
  :checkpointing {:enabled boolean :interval n :storage destination}
  :output       output-specification
  :manifest     result-binding)
```

#### Design rationale

Pipelines decompose complex data workflows into testable, observable stages.
Each stage has clear input and output contracts. Independent stages can run
in parallel. Failures at any stage are handled according to a declared
strategy rather than propagating silently.

The `:checkpointing` parameter is critical for long-running pipelines over
large datasets. If a pipeline processing five million records fails at record
4.8 million, checkpointing allows resuming from the last checkpoint rather
than reprocessing everything from the start.

#### Example: Production ETL with comprehensive resilience

```clojure
(data/pipeline "customer-etl"
  :source {:type :database
           :query "SELECT * FROM raw_customers WHERE processed_at IS NULL"
           :batch-size 10000}

  :stages [
    {:name :validate-and-clean
     :fn   (~> stage-input
             (data/validate :against raw-customer-schema :on-failure :collect)
             (data/transform :operations [
               {:op :filter     :predicate (fn [r] (seq (:email r)))}
               {:op :map-field  :field :email :fn clojure.string/lower-case}
               {:op :deduplicate :on [:email]}]))}

    {:name :enrich
     :fn   (parallel enrichment-ops
             :operations [
               (data/transform stage-input
                 :operations [{:op :enrich :field :geocoded :from geocode-api}]
                 :error-handling :skip)
               (data/transform stage-input
                 :operations [{:op :enrich :field :credit :from credit-api}]
                 :error-handling :skip)]
             :combine-results :merge
             :on-error :best-effort)}

    {:name :apply-business-rules
     :fn   (data/transform stage-input
             :operations [
               {:op :derive :field :tier :from [:ltv :order-count]
                :using (fn [r] (cond (> (:ltv r) 10000) :platinum
                                     (> (:ltv r) 5000)  :gold
                                     :else :standard))}])}

    {:name :load
     :fn   (retry db-load
             :operation (fn [records]
                          (batch-upsert target-db :customers records))
             :attempts 3 :backoff :exponential
             :retry-on [connection-error? deadlock?])}]

  :error-handling {:strategy :dead-letter
                   :dead-letter-destination {:type :database :table "etl_errors"}}

  :monitoring {:metrics true
               :logging :info
               :alerts  [{:condition (fn [m] (< (:success-rate m) 0.90))
                          :action    :page-on-call}]}

  :checkpointing {:enabled true :interval 5000}

  :output {:type :database :table :customers :on-conflict :update})
```

---

## Part III: Validation and quality

---

### `data/validate`

Validates data against a schema, collecting violations and returning a
structured quality report.

#### Signature

```clojure
(data/validate data
  :against    schema
  :on-failure :stop | :collect | :warn
  :include    [:schema-violations :constraint-violations :referential-integrity]
  :sample-invalid n
  :output     :validation-report)
```

#### Parameters

**`:on-failure`** — `:stop` halts on first violation. `:collect` gathers all
violations before returning. `:warn` logs violations but returns the data
anyway, for non-critical paths.

**`:sample-invalid`** — Include up to `n` example invalid records in the
report, with specific violation details. Essential for diagnosing systematic
data quality issues.

#### Example

```clojure
(data/validate imported-orders
  :against    order-schema
  :on-failure :collect
  :sample-invalid 10
  :output :validation-report)

;; Returns:
{:status           :partial-pass
 :total            10000
 :valid            9847
 :invalid          153
 :violations {
   :missing-required   [{:field :total :count 12}]
   :type-mismatch      [{:field :amount :expected :decimal :found :string :count 89}]
   :constraint-failure [{:rule "total = subtotal + vat" :count 52}]}
 :sample-invalid [
   {:record  {:order-id "..." :amount "€127.50" :total nil}
    :violations ["amount: expected decimal, found string"
                 "total: required field is nil"]}]
 :recommendations [
   "The 89 string amounts appear to have currency symbols — strip '€' before coercion"
   "The 52 total mismatches are clustered on orders from supplier-id 'SUP-009'"]}
```

---

### `data/profile`

Generates a statistical profile of a dataset — distributions, cardinalities,
null rates, value ranges, and quality indicators — without modifying the data.

#### Signature

```clojure
(data/profile dataset
  :fields       [field ...] | :all
  :statistics   [:distribution :cardinality :nulls :ranges :patterns :outliers]
  :sample-size  n | :full
  :compare-to   baseline-profile
  :output       :profile-report)
```

#### Design rationale

Validation answers "does this data satisfy its schema?" Profiling answers "what
does this data actually look like?" These are different questions. A dataset
can be valid (every record satisfies the schema) but anomalous (a field that
is usually populated is suddenly 80% null; a value that usually appears in
one category has shifted to another). Profiling detects these drifts.

The `:compare-to` parameter enables drift detection: compare today's profile
against yesterday's baseline and surface what has changed. This is essential
for monitoring production data pipelines.

#### Example

```clojure
(data/profile customer-dataset
  :statistics  [:distribution :cardinality :nulls :outliers]
  :sample-size :full
  :compare-to  baseline-profile-yesterday)

;; Returns:
{:dataset    "customers"
 :records    487302
 :profiled-at "2025-11-03T08:00:00Z"

 :fields {
   :status {
     :cardinality 5
     :distribution {:active 0.78 :inactive 0.14 :pending 0.07 :suspended 0.01}
     :drift {:vs-baseline "pending increased 0.03 → 0.07"
             :severity :warning}}

   :email {
     :null-rate   0.002
     :unique-rate 0.999
     :patterns    {:format-valid 0.998 :format-invalid 0.002}
     :drift       :none}

   :ltv {
     :min     0.0
     :max     98450.0
     :mean    847.3
     :median  234.5
     :p95     3200.0
     :p99     12000.0
     :outliers [{:record-id "..." :value 98450.0 :z-score 4.2}]
     :drift   {:vs-baseline "mean increased 847 → 891" :severity :info}}}

 :overall-quality-score 0.94
 :drift-alerts [:pending-rate-increase]}
```

---

### `data/generate-tests`

Automatically generates comprehensive test suites from schemas, covering valid
cases, boundary conditions, error scenarios, and performance tests.

#### Signature

```clojure
(data/generate-tests schema
  :coverage      :minimal | :standard | :comprehensive | :exhaustive
  :include       [:valid-cases :boundary-cases :invalid-cases
                  :constraint-violations :performance-tests]
  :custom-cases  [test-case ...]
  :performance   {:generate {:count n :max-ms n}
                  :validate {:count n :max-ms n}}
  :output        :clojure-test | :junit | :pytest
  :manifest      test-suite)
```

#### Design rationale

Schemas encode enough information to generate most tests automatically:
required fields generate null tests; unique fields generate duplicate tests;
format constraints generate invalid-format tests; numeric ranges generate
boundary tests. Manual test writing for these standard scenarios is mechanical
work that belongs to the machine.

Custom cases fill the gap: complex multi-field interactions, domain-specific
edge cases, and integration scenarios that require human knowledge of the
domain.

#### Example

```clojure
(data/generate-tests customer-schema
  :coverage     :comprehensive
  :include      [:valid-cases :boundary-cases :invalid-cases :performance-tests]
  :custom-cases [
    {:name     "international-customer-no-dutch-bsn"
     :input    {:id (uuid) :email "user@example.de" :locale :de :bsn nil}
     :expected :valid
     :note     "BSN is not required for non-Dutch customers"}]
  :performance  {:generate {:count 1000 :max-ms 1000}
                 :validate {:count 10000 :max-ms 5000}}
  :output :clojure-test)

;; Returns test suite with:
;; ✓ valid-customer-minimal (required fields only)
;; ✓ valid-customer-all-fields
;; ✓ boundary-age-minimum (age = 18)
;; ✓ boundary-age-maximum (age = 150)
;; ✓ boundary-age-below-min (age = 17, expected invalid)
;; ✓ boundary-balance-zero (0.00, valid)
;; ✓ boundary-balance-negative (-0.01, invalid)
;; ✓ invalid-missing-email
;; ✓ invalid-bsn-fails-11-check
;; ✓ invalid-dutch-postal-code-no-space
;; ✓ constraint-violation-no-contact-method
;; ✓ performance-generate-1000-records (<1000ms)
;; ✓ custom-international-customer-no-bsn
;; → 94 tests total, covering 100% of schema constraints
```

---

## Part IV: Provenance and privacy

---

### `data/lineage`

Tracks how data flows and transforms through a pipeline, producing a
provenance record that makes the data's history inspectable and auditable.

#### Signature

```clojure
(data/lineage pipeline-or-transformation
  :track        [:transformations :enrichments :drops :schema-changes]
  :record-to    destination
  :include-samples boolean
  :output       :lineage-graph | :lineage-report)
```

#### Design rationale

When a compliance officer asks "how did this customer's email address come to
be in this marketing database?" the answer must be traceable. When a data
analyst asks "why does this customer's segment differ from yesterday?" the
transformation chain must be inspectable. When an auditor asks "who touched
this patient record and what did they do to it?" the lineage must be complete.

`data/lineage` wraps a pipeline or transformation and produces an out-of-band
provenance record. Like `witness` in core, it observes without modifying. The
lineage record documents every transformation applied, every field enriched,
every record dropped and why, and every schema change encountered.

#### Example

```clojure
(data/lineage
  (~> raw-customer-import
    (data/transform :operations cleaning-ops)
    (data/transform :operations enrichment-ops)
    (data/validate  :against customer-schema))
  :track   [:transformations :enrichments :drops]
  :record-to lineage-store
  :include-samples true)

;; Lineage record:
{:pipeline-run "run-2025-11-03-08:00"
 :stages [
   {:stage :cleaning
    :input-count  50000
    :output-count 48523
    :dropped      1477
    :drop-reasons {"empty-email" 1204 "duplicate-email" 273}
    :transformations ["email → lowercase" "whitespace-trimmed"]}
   {:stage :enrichment
    :enriched-fields [:geocoded :risk-band]
    :enrichment-failures {:geocoded 43 :risk-band 0}
    :samples [{:record-id "..." :before {...} :after {...}}]}
   {:stage :validation
    :violations-found 152
    :quarantined       152}]
 :total-duration-ms 8432}
```

---

### `data/mask`

Applies privacy-preserving transformations to data — anonymisation, pseudonymisation,
and redaction — while preserving the data's structural and statistical properties
for testing and analytics use.

#### Signature

```clojure
(data/mask dataset
  :strategy   :anonymise | :pseudonymise | :redact | :synthetic-substitute
  :fields     {field-name masking-rule ...}
  :preserve   [:distributions :referential-integrity :format-validity]
  :seed       n
  :reversible boolean
  :output     :masked-edn)
```

#### Parameters

**`:strategy`** — The masking approach:
- `:anonymise` — irreversible; information cannot be recovered
- `:pseudonymise` — reversible with a key; the same input always produces the
  same pseudonym, preserving referential integrity
- `:redact` — replace with a fixed sentinel (e.g. `"[REDACTED]"`)
- `:synthetic-substitute` — replace with a statistically similar synthetic
  value (name replaced with realistic fake name; postcode replaced with
  realistic fake postcode)

**`:preserve`** — What statistical properties to maintain:
- `:distributions` — synthetic substitutes follow the same distributions as
  originals
- `:referential-integrity` — a customer-id that appears in orders still
  appears in the masked customer dataset
- `:format-validity` — masked values still pass format validation (a masked
  BSN still passes the 11-proof check)

**`:reversible`** — When true (only valid with `:pseudonymise`), the system
records a key that allows de-pseudonymisation. The key must be stored and
managed separately from the masked data.

#### Example

```clojure
(data/mask production-customer-snapshot
  :strategy   :pseudonymise
  :fields     {
    :bsn        {:rule :replace-with-valid-bsn}
    :first-name {:rule :replace-with-realistic-name :locale :nl}
    :last-name  {:rule :replace-with-realistic-name :locale :nl}
    :email      {:rule :replace-with-valid-email}
    :phone      {:rule :replace-with-valid-dutch-mobile}
    :iban       {:rule :replace-with-valid-iban :country :nl}
    :street     {:rule :replace-with-realistic-dutch-street}
    :postal-code {:rule :replace-format-preserving}}
  :preserve   [:distributions :referential-integrity :format-validity]
  :seed       42
  :reversible false
  :output     :masked-edn)

;; Returns dataset suitable for use in test/staging environments:
;; ✓ No real personal data — safe to share with developers
;; ✓ BSN numbers pass 11-proof check
;; ✓ Emails are format-valid (but at non-real domains)
;; ✓ IBANs pass checksum validation
;; ✓ Distributions preserved — name frequency follows Dutch name distribution
;; ✓ Customer-orders referential integrity maintained across both masked datasets
```

---

### `data/reconcile`

Compares two datasets that should match — identifying records present in one
but absent in the other, field-level discrepancies, and systematic patterns
in the differences.

#### Signature

```clojure
(data/reconcile dataset-a dataset-b
  :on          :primary-key-field
  :compare     [:all-fields | field-list]
  :tolerance   {:field {:type :absolute | :relative :value n} ...}
  :identify    [:missing-in-a :missing-in-b :field-mismatches :duplicates]
  :output      :reconciliation-report)
```

#### Design rationale

Reconciliation is a fundamental data quality operation that the original spec
did not address. It answers: "Does our database match the source of truth?"
"Did our migration transfer all records correctly?" "Does the report match
the underlying data?" These are common questions in finance, compliance, and
data migration — and they all require the same underlying operation: a
systematic, field-level comparison of two datasets that should agree.

#### Example

```clojure
(data/reconcile
  (query-db "SELECT * FROM customers")
  (read-file "customers-from-erp.csv")
  :on      :customer-id
  :compare [:email :address :credit-limit :status]
  :tolerance {:credit-limit {:type :absolute :value 0.01}}
  :identify  [:missing-in-a :missing-in-b :field-mismatches])

;; Returns:
{:status :discrepancies-found
 :total-in-a       48250
 :total-in-b       48319
 :matched          48231
 :missing-in-a        88  ;; in ERP but not in database
 :missing-in-b        19  ;; in database but not in ERP
 :field-mismatches   412

 :mismatch-detail {
   :email          {:count 12  :sample [{:id "..." :in-a "old@" :in-b "new@"}]}
   :credit-limit   {:count 380 :note "380 within €0.01 tolerance — ignored"
                    :exceeding-tolerance 32}
   :status         {:count 400
                    :pattern "All mismatches have status :active in DB, :inactive in ERP
                              — probable sync lag"}}

 :recommendations [
   "88 ERP records not in database: investigate if these are recent additions"
   "Status mismatch pattern suggests a sync job has fallen behind"]}
```

---

## Best practices

### Validate at entry; never at exit

The cheapest moment to catch a data quality problem is when data enters the
system. Validating at the point of output — after transformation, enrichment,
and storage — is expensive in both compute and consequence. Build validation
as the first stage of every pipeline, not as a final check.

### Make constraints explicit in schemas

Every business rule that applies to data belongs in the schema, not scattered
across application code. "Orders total must equal subtotal + VAT" is a schema
constraint. "Email must be unique per customer" is a schema constraint.
Explicit constraints enable automatic validation, test generation, and
documentation — all at once.

### Use `:anomalies` in test data generation

Generating only valid test data tests the happy path. The pipelines that matter
most are the ones that handle bad data gracefully. Use `:anomalies` to inject
known-bad records into test datasets, then verify your validation catches them
and your error handling routes them appropriately.

### Profile before and after migrations

Data migrations are the highest-risk data operation. Profile the source dataset
before migration and the target dataset after. Compare the profiles. Any
significant drift — changed distributions, increased null rates, lost records
— indicates something went wrong. Profiling makes migration validation
systematic rather than manual.

### Pseudonymise, don't copy production data

The temptation to use production data in test environments is strong — "it's
more realistic." The risks (accidental exposure, compliance violation, audit
finding) are not worth it. Use `data/mask` with `:synthetic-substitute` to
create test data that is statistically realistic without containing real
personal information.

---

## Integration patterns

### Schema as the common contract

A `data/schema` defined once becomes the source of truth across multiple
grimoires. It drives `data/generate` for test data, `data/validate` for
quality assurance, `data/generate-tests` for test suites, and `d/scope`
in the domain grimoire for model alignment.

```clojure
(def order-schema (data/schema :order ...))

;; One schema drives multiple downstream uses:
(def test-orders      (data/generate :order :schema order-schema :count 1000))
(def validation-suite (data/generate-tests order-schema :coverage :comprehensive))
(def quality-report   (data/validate imported-orders :against order-schema))
```

### Threading data through pipelines

`~>` from core composes data operations into readable pipelines. Each step
is a `data/` invocation that transforms the value being threaded.

```clojure
(~> "raw-import.csv"
  (data/transform :operations [parse-ops])
  (data/validate  :against order-schema :on-failure :collect)
  (data/transform :operations [enrichment-ops])
  (data/lineage   :track [:all] :record-to provenance-store)
  (data/convert-format :from :edn :to :parquet))
```

### Domain-informed schema design

Domain models from the `domain` grimoire inform schema design. An entity
definition in a domain model should map directly to a `data/schema`.

```clojure
(def patient-domain (d/explore clinical-docs :focus [:entities :constraints]))

(data/schema :patient
  :fields      (d/extract patient-domain :what :entities :matching {:name "patient"} :as :fields)
  :constraints (d/extract patient-domain :what :constraints :matching {:applies-to "patient"} :as :list)
  :compliance  [:hipaa])
```

---

## Grimoire metadata

```clojure
{:grimoire    "data"
 :namespace   "data/"
 :version     "2.0.0"
 :description "Complete data lifecycle: schema definition, generation,
               transformation, validation, profiling, lineage, and privacy"

 :constructs {
   :definition    [data/schema]
   :generation    [data/generate]
   :transformation [data/transform data/convert-format data/pipeline]
   :quality       [data/validate data/profile data/generate-tests]
   :provenance    [data/lineage data/mask data/reconcile]}

 :best-for [
   "Synthetic data generation for testing without real personal data"
   "Schema-driven validation and test generation"
   "ETL pipeline construction with resilience and monitoring"
   "Data quality profiling and drift detection"
   "Privacy-preserving data masking for test environments"
   "Data reconciliation for migrations and audits"
   "Locale-aware data generation (Dutch, German, English, French)"]

 :works-with [:core :domain :orchestrate]

 :key-concepts [
   {:term "Schema"
    :definition "Formal specification of data structure, types, constraints,
                 and compliance requirements. The single source of truth that
                 drives generation, validation, and testing."}
   {:term "Synthetic data"
    :definition "Artificially generated data that mimics production statistical
                 characteristics without containing real sensitive information"}
   {:term "Lineage"
    :definition "The provenance record of how data was derived: what
                 transformations were applied, what was enriched, what was
                 dropped and why"}
   {:term "Profile"
    :definition "A statistical characterisation of a dataset: distributions,
                 cardinalities, null rates, outliers. Answers 'what does this
                 data actually look like?' rather than 'is it valid?'"}
   {:term "Reconciliation"
    :definition "Systematic comparison of two datasets that should match,
                 identifying discrepancies, missing records, and field-level
                 differences"}
   {:term "Pseudonymisation"
    :definition "Replacing identifying information with consistent pseudonyms,
                 preserving referential integrity while removing direct
                 identifiability. Reversible with a key."}
   {:term "Anomaly injection"
    :definition "Intentionally introducing known-bad records into test datasets
                 at a controlled rate, to verify validation and error handling"}]}
```

---

## Implementation notes for LLM processors

### Schema interpretation

When processing `data/schema`, treat `:compliance` as a multiplier on the
field-level annotations: `:hipaa` in `:compliance` means all `:phi true`
fields automatically require audit logging, encryption at rest, and
minimum-necessary access controls — even if not explicitly stated per field.
`:gdpr` means all fields containing personal data must support right-to-erasure
and have a documented legal basis for processing.

### Locale-aware generation

When generating with `:locale :nl`:
- BSN: generate using the 11-proof (elfproef) algorithm; all generated BSNs
  must pass `sum(d_i × (9-i)) mod 11 == 0`
- Postal codes: format `#### AA` where the digit prefix maps to a real Dutch
  municipality; the letter suffix is any valid two-letter combination
- Phone numbers: +31 6xx xxx xxxx for mobile; +31 (0)x for landlines
- IBAN: `NL##BANK#########` where the check digits are computed correctly
- Names: draw from Dutch name frequency distributions (de Jong, Jansen,
  van den Berg, etc.)

### Distribution fidelity

When `:quality :production` is specified, generate data where:
- Order counts follow Zipf's law (few heavy buyers, many light buyers)
- Revenue follows Pareto distribution (80% of revenue from 20% of customers)
- Timestamps cluster around business hours and weekdays
- Geographic distributions reflect the locale's actual population distribution
- Cross-field correlations are realistic (older customers have longer tenure;
  customers from major cities have higher LTV)

### Anomaly injection discipline

When `:anomalies` is specified, the anomalies must be:
1. Controlled: exactly `rate × count` records contain anomalies
2. Reproducible: same `:seed` produces same anomaly positions
3. Typed: the specific anomaly types requested are what appear
4. Trackable: the validation report can identify all injected anomalies

Never introduce anomalies that are not in the requested `:types` list.

### Masking determinism

When `:pseudonymise` is specified with a `:seed`, the same input value must
always produce the same pseudonym within a single masking run. This is essential
for referential integrity: if customer-id `abc123` appears in both the customer
table and the orders table, both masked datasets must use the same pseudonym
for `abc123`.

### Profile drift detection

When `:compare-to baseline-profile` is specified in `data/profile`, flag
drifts using these severity thresholds (adjustable per use case):
- `:info` — change > 5% in a metric
- `:warning` — change > 15% in a metric or null rate increase > 2 percentage points
- `:critical` — cardinality drops to 0 for a non-empty field, or null rate
  exceeds 50% for a required field