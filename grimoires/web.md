# web.md — Conjurer Web Grimoire

The spellbook for the browser. Web development is the art of collapsing three
distinct languages — structure, presentation, behaviour — into a single
coherent experience. The `web` grimoire operates at a level above this
complexity: practitioners describe *what the interface should be*, and the
system manifests the HTML, CSS, and JavaScript that realise it.

---

## Philosophy

### The interface as conversation

An interface is not a document. It is a conversation between the system's
knowledge and the user's intent. Every click is a question; every response
is an answer. A good interface makes that conversation feel effortless — the
user's intent flows naturally into action, and the system's responses arrive
without friction or confusion.

This framing has consequences for how the `web` grimoire is designed. It does
not simply generate code — it generates *conversations*. The structure of a
page reflects the structure of a user's mental model. The hierarchy of
components reflects the hierarchy of decisions the user needs to make. The
visual language reflects the emotional register appropriate to the context.
A payment confirmation feels different from an error message. An onboarding
flow feels different from a dashboard. Good interface design honours these
distinctions; good tooling makes honouring them easy.

### Three generative tensions

**Simplicity versus power** — The most expressive invocations are the shortest.
`(w/prototype "Analytics dashboard with real-time charts" :type :dashboard)`
should manifest a complete, working, production-quality dashboard without
requiring the practitioner to specify every component. The system's
accumulated knowledge of dashboard conventions fills the gaps. But when the
practitioner does specify, the system honours every detail.

**Convention versus configuration** — Conventions encode accumulated wisdom
about what works. A landing page needs a hero, features, social proof, and
a call to action — not because this is the only way, but because it is a
proven pattern that serves users well. Convention accelerates; configuration
enables deviation when deviation serves the user better.

**Aesthetics versus accessibility** — Beautiful interfaces that exclude people
are not beautiful interfaces. Accessibility is not a constraint imposed on
design; it is a dimension of design quality. An interface that communicates
its structure clearly to a screen reader communicates it more clearly to all
users. Colour contrast that works for colour-blind users works better for
everyone in bright light. The `web` grimoire treats WCAG compliance as a
minimum standard, not an optional add-on.

### Production quality from the first invocation

Generated code is immediately deployable. No placeholder images, no dummy
data labelled "TODO", no components that look finished but have no behaviour.
The first manifestation is production-ready. Refinement improves it; it does
not complete it.

---

## Naming rationale

**`w/`** — The short namespace alias. Web invocations are frequent; brevity
matters.

**Prototype** — From Greek *prōtótupos*, "first impression." In Conjurer, a
prototype is the first full manifestation — complete and deployable, not a
wireframe.

**Component** — A self-contained, reusable interface element with defined
variants and states.

**Token** — A design token is a named design decision: a colour, a spacing
value, a type size. Tokens are the vocabulary of a design system.

---

## Part I: Analysis and extraction

Understanding existing web experiences provides the foundation for creation.
Analysis functions extract what a site *is* so the practitioner can build
what a site *should be*.

---

### `w/analyze`

Performs comprehensive analysis of a website or design artefact, extracting
visual design system, structural organisation, component patterns, and
accessibility characteristics.

#### Signature

```clojure
(w/analyze source
  :from          :url | :html | :css | :screenshot
  :extract       [:visual-design :structure :patterns :accessibility :performance]
  :depth         :shallow | :moderate | :comprehensive
  :compare-to    reference-design-system
  :output        :design-system | :audit-report)
```

#### Parameters

**`:extract`** — Dimensions to analyse:
- `:visual-design` — colour palette, typography system, spacing scale, shadow
  definitions, animation timings
- `:structure` — component hierarchy, page anatomy, navigation patterns,
  layout systems (Grid, Flexbox), responsive breakpoints
- `:patterns` — interaction patterns, conversion flows, social proof placement,
  progressive disclosure structures
- `:accessibility` — WCAG compliance level, missing ARIA attributes, colour
  contrast failures, keyboard navigation gaps, focus management issues
- `:performance` — critical render path, bundle structure, image optimisation
  gaps, render-blocking resources

**`:compare-to`** — Compare the extracted design system against a reference
(a brand guide, another extracted system, or an NL Design System token set)
and surface divergences.

#### Example: Complete site analysis

```clojure
(w/analyze "https://www.tilburg.nl"
  :from    :url
  :extract [:visual-design :structure :accessibility]
  :depth   :comprehensive)

;; Returns:
{:site      "tilburg.nl"
 :analysed-at "2025-11-03"

 :visual-design {
   :colors {
     :primary   "#E30613"
     :secondary "#003366"
     :accent    "#FFB81C"
     :neutral   {100 "#F8F9FA" ... 900 "#212529"}
     :semantic  {:success "#27AE60" :warning "#F39C12"
                 :danger  "#E74C3C" :info "#3498DB"}}
   :typography {
     :fonts  {:heading "RijksoverheidSansWebText"
              :body    "RijksoverheidSansWebText"
              :fallback "Arial, sans-serif"}
     :scale  {:base 16 :ratio 1.25
              :sizes {:xs 0.75 :sm 0.875 :base 1 :lg 1.25 :xl 1.5}}}
   :spacing {:system :8px-grid :scale [0 4 8 12 16 24 32 48 64 96]}}

 :structure {
   :layout-system   [:flexbox :grid]
   :breakpoints     [640 768 1024 1280]
   :navigation      {:type :top-nav :sticky true :search true}
   :page-patterns   [:hero :content-cards :cta-banner :footer-links]}

 :accessibility {
   :wcag-level      :AA
   :issues [
     {:type     :colour-contrast
      :element  ".text-muted"
      :ratio    3.8
      :required 4.5
      :severity :error}
     {:type     :missing-alt
      :count    12
      :severity :error}
     {:type     :focus-not-visible
      :elements [".nav-link" ".card-link"]
      :severity :warning}]
   :passes  [:keyboard-navigation :aria-landmarks :heading-hierarchy
             :skip-links :form-labels]}}
```

---

### `w/extract-style`

Extracts visual design tokens from a source — colours, typography, spacing,
components — and normalises them into a portable theme definition.

#### Signature

```clojure
(w/extract-style source
  :from            :url | :css | :scss | :figma
  :focus           [:colors :typography :spacing :shadows :components :animations]
  :normalise-names boolean
  :generate-variants boolean
  :map-to-tokens   :nl-design-system | :tailwind | :custom
  :output          :theme | :token-set)
```

#### Parameters

**`:map-to-tokens`** — Map extracted values to a known token naming convention.
`:nl-design-system` maps to the NL Design System token structure, enabling
extracted themes to integrate directly with Dutch government component
libraries. `:tailwind` maps to Tailwind CSS variable names.

**`:generate-variants`** — Automatically generate the full shade scale for
extracted colours (50 through 950 using OKLCH for perceptual uniformity),
and complete size scales for typography and spacing.

#### Example: Rijkshuisstijl extraction

```clojure
(w/extract-style "https://www.rijksoverheid.nl"
  :from             :url
  :focus            [:colors :typography :spacing]
  :normalise-names  true
  :generate-variants true
  :map-to-tokens    :nl-design-system)

;; Returns NL Design System-compatible token set:
{:nl-design-system {
   :color {
     :primary {:value "#01689B"
               :variants {100 "#e6f0f5" 200 "#b3d1e2" 500 "#01689B" 900 "#003456"}}
     :text    {:body "#000000" :subtle "#3c3c3c"}}
   :typography {
     :font-family {:heading "RijksoverheidSansWebText" :body "RijksoverheidSerif"}
     :scale       {:sm 14 :base 16 :lg 18 :xl 24 :2xl 32}}
   :space        {:1 4 :2 8 :4 16 :6 24 :8 32 :12 48 :16 64}}}
```

---

### `w/extract-structure`

Extracts the structural organisation of a page or application: component
hierarchy, section types, navigation patterns, and the user journey they
encode.

#### Signature

```clojure
(w/extract-structure source
  :from   :url | :html
  :depth  :shallow | :deep
  :infer  [:user-journey :conversion-funnel :information-architecture]
  :output :structure-map | :architecture-diagram)
```

#### Example

```clojure
(w/extract-structure "https://stripe.com"
  :from  :url
  :depth :deep
  :infer [:user-journey :conversion-funnel])

;; Returns:
{:page-type :saas-landing-page
 :sections  [
   {:type :hero      :pattern :centered-with-visual
    :purpose "Communicate value proposition and primary CTA"}
   {:type :features  :pattern :icon-grid-3col
    :purpose "Demonstrate capability breadth"}
   {:type :social-proof :pattern :logo-carousel
    :purpose "Establish credibility"}
   {:type :pricing   :pattern :tier-comparison-3col
    :purpose "Drive conversion decision"}]
 :conversion-funnel [:awareness :interest :consideration :decision :action]
 :cta-count 8
 :navigation {:type :sticky-nav :links 6}}
```

---

## Part II: Generation

---

### `w/prototype`

Generates a complete, deployable web project from a high-level description.
The primary manifestation function of the web grimoire.

#### Signature

```clojure
(w/prototype description
  :type          :landing-page | :dashboard | :app | :widget
                 | :blog | :e-commerce | :portal | :form
  :style         [:modern | :minimal | :glassmorphism | :neumorphism
                  | :brutalism | :retro | :corporate | :playful]
  :layout        [:single-page | :multi-section | :sidebar | :split | :grid]
  :color-scheme  :light | :dark | :auto
  :colors        {:primary "#..." :secondary "#..." :accent "#..."}
  :apply-theme   extracted-theme
  :from-domain   domain-model
  :components    [:navbar :hero :cards :forms :tables :charts
                  :modals :drawers :toasts :footer ...]
  :features      [:responsive :dark-mode :animations :accessibility
                  :i18n :pwa :offline :real-time]
  :accessibility :wcag-aa | :wcag-aaa
  :framework     :vanilla | :react | :vue | :svelte | :alpine
  :css           :vanilla | :tailwind | :scss | :css-modules
  :output        :files | :project | :single-file)
```

#### Parameters

**`:accessibility`** — Accessibility conformance level. `:wcag-aa` (default)
meets legal requirements in most jurisdictions. `:wcag-aaa` meets the highest
standard. In either case, the generated code includes: semantic HTML5 elements,
ARIA attributes where needed, keyboard navigation, focus management, sufficient
colour contrast, and screen reader compatibility.

**`:from-domain`** — A domain model (from `d/explore` or `d/model`) that
informs the prototype's entities, forms, tables, and navigation. The prototype
understands the domain's entities and generates appropriate CRUD interfaces,
validation rules derived from domain constraints, and navigation structures
that mirror the domain's organisation.

**`:apply-theme`** — An extracted theme (from `w/extract-style`) to apply.
The prototype uses the theme's colour tokens, typography, spacing, and
component styles. Combine with `:customize` to override specific tokens.

#### Example 1: SaaS landing page

```clojure
(w/prototype "Project management SaaS for development teams"
  :type         :landing-page
  :style        [:modern :glassmorphism]
  :color-scheme :dark
  :colors       {:primary "#6366f1" :secondary "#8b5cf6" :accent "#ec4899"}
  :components   [:navbar :hero :features :pricing :testimonials :cta :footer]
  :features     [:responsive :animations :dark-mode]
  :accessibility :wcag-aa
  :framework    :vanilla
  :css          :scss
  :output       :project)

;; Generates:
;; project/
;; ├── package.json
;; ├── src/
;; │   ├── index.html         ← Semantic HTML5, ARIA landmarks, skip links
;; │   ├── scss/
;; │   │   ├── _tokens.scss   ← Design tokens as CSS custom properties
;; │   │   ├── _components.scss
;; │   │   └── _animations.scss
;; │   └── js/
;; │       └── main.js        ← ES6+, IntersectionObserver for animations
;; └── dist/
;;
;; Accessibility checklist (auto-generated with the project):
;; ✓ All images have descriptive alt text
;; ✓ Colour contrast ≥ 4.5:1 for body text, ≥ 3:1 for large text
;; ✓ Focus visible on all interactive elements
;; ✓ Keyboard navigable without mouse
;; ✓ Skip navigation link to main content
;; ✓ Heading hierarchy (h1 → h2 → h3) respected throughout
;; ✓ Form inputs have associated labels
;; ✓ ARIA roles on custom interactive components
```

#### Example 2: Domain-driven portal

```clojure
(def crm-domain (d/explore "crm-requirements.pdf" :depth 3))

(w/prototype "CRM Customer Portal"
  :type        :app
  :from-domain crm-domain
  :framework   :react
  :css         :tailwind
  :features    [:responsive :dark-mode :real-time]
  :accessibility :wcag-aa
  :output      :project)

;; System generates interfaces for all entities in crm-domain:
;; ✓ Customer list with search, filter, and sort
;; ✓ Customer detail view with all domain attributes
;; ✓ Contact history timeline
;; ✓ Opportunity pipeline (if in domain)
;; ✓ Forms with validation derived from domain constraints
;; ✓ Navigation structure reflecting domain entity relationships
```

#### Example 3: Applying an extracted theme

```clojure
(def gemeente-theme (w/extract-style "https://www.tilburg.nl" :map-to-tokens :nl-design-system))

(w/prototype "Tilburg Digital Services Portal"
  :type        :portal
  :apply-theme gemeente-theme
  :components  [:header :search :service-cards :contact-cta :footer]
  :features    [:responsive :accessibility]
  :accessibility :wcag-aaa   ;; Government portals target AAA
  :framework   :vanilla
  :output      :project)

;; Uses gemeente-theme's colours, typography, and spacing throughout
;; Overrides nothing — the extracted theme is applied faithfully
```

---

### `w/component`

Generates an individual UI component with all its variants, states, and
interaction patterns.

#### Signature

```clojure
(w/component type
  :variant    :primary | :secondary | :outline | :ghost | :destructive
  :size       :xs | :sm | :md | :lg | :xl
  :style      [:modern ...]
  :states     [:default :hover :active :focus :disabled :loading :error]
  :props      {:prop value ...}
  :framework  :vanilla | :react | :vue | :svelte
  :stories    boolean
  :a11y       :full | :basic
  :output     :code | :storybook)
```

#### Parameters

**`:stories`** — When true, generates Storybook-compatible stories alongside
the component code. Each variant and state becomes a named story. Essential
for design system documentation.

**`:a11y`** — Accessibility implementation depth. `:basic` adds ARIA attributes
and keyboard handling. `:full` adds complete ARIA patterns per the WAI-ARIA
Authoring Practices Guide, including complex widgets like comboboxes, data grids,
and disclosure widgets.

#### Example: Accessible data table

```clojure
(w/component :data-table
  :states  [:empty :loading :populated :error :sorted :filtered]
  :props   {:sortable true :filterable true :selectable :multi :paginated true}
  :a11y    :full
  :stories true
  :framework :react
  :output  :code)

;; Generated component includes:
;; ✓ role="grid" with proper aria-* attributes
;; ✓ Keyboard navigation: arrow keys between cells, Home/End, Page Up/Down
;; ✓ aria-sort on column headers when sorted
;; ✓ aria-selected on rows when selected
;; ✓ aria-live region for sort/filter change announcements
;; ✓ Loading state with aria-busy="true"
;; ✓ Empty state with descriptive message
;; ✓ Storybook stories for every state combination
```

---

### `w/tokens`

Defines, manages, and exports a design token system — the named design
decisions that provide consistency across a component library.

#### Signature

```clojure
(w/tokens name
  :primitives  {:color {:red {50 "#fff5f5" ... 950 "#2d0001"} ...}
                :space [0 4 8 12 16 24 32 48 64 96 128]
                :radius [0 2 4 6 8 12 16 24 "50%"]}
  :semantic    {:color {:background {:default "@color.neutral.50"
                                     :subtle   "@color.neutral.100"}
                        :text {:primary "@color.neutral.900"
                               :muted   "@color.neutral.500"}
                        :brand {:default "@color.primary.500"
                                :hover   "@color.primary.600"}}}
  :components  {:button {:padding       "@space.2 @space.4"
                          :border-radius "@radius.2"
                          :font-weight   "600"}}
  :export-as   [:css-custom-properties :scss-variables :js-object :tailwind-config
                :nl-design-system]
  :output      :token-set)
```

#### Design rationale

Design tokens are the bridge between design decisions and code. Without tokens,
colour values scatter across stylesheets, change in one place but not another,
and the visual language drifts into inconsistency. With tokens, a colour change
is a one-line edit that propagates everywhere.

The three-tier structure — primitives, semantic, component — encodes a
deliberate philosophy. Primitives are raw values with no meaning (`red.500`).
Semantic tokens assign meaning (`color.text.danger`). Component tokens apply
semantic tokens to specific components (`button.background.destructive`).
When the brand colour changes, only the primitive changes; semantic and
component tokens follow automatically.

---

## Part III: Audit and quality

---

### `w/audit`

Performs a comprehensive audit of a web project or URL across accessibility,
performance, SEO, and code quality dimensions.

#### Signature

```clojure
(w/audit source
  :from       :url | :html | :project-path
  :dimensions [:accessibility :performance :seo :code-quality :security]
  :standard   :wcag-aa | :wcag-aaa | :lighthouse | :custom
  :severity   :all | :errors-only | :errors-and-warnings
  :output     :audit-report | :fix-suggestions)
```

#### Design rationale

Code that generates code must be able to audit code. `w/audit` closes the loop:
a practitioner can generate a prototype with `w/prototype`, audit it with
`w/audit`, and refine it based on the findings — all within the same grimoire.

The `:output :fix-suggestions` mode goes further than identifying problems: it
produces a prioritised list of specific code changes that would resolve each
finding, suitable for feeding directly into a `refine` invocation.

#### Example

```clojure
(w/audit "https://generated-portal.example.com"
  :dimensions [:accessibility :performance :seo]
  :standard   :wcag-aa
  :output     :fix-suggestions)

;; Returns:
{:url    "generated-portal.example.com"
 :score  {:accessibility 87 :performance 94 :seo 91}

 :issues [
   {:dimension  :accessibility
    :severity   :error
    :wcag       "1.4.3"
    :element    ".card-description"
    :finding    "Text colour #767676 on #F5F5F5 background fails contrast ratio (2.9:1 < 4.5:1)"
    :fix        "Change color to #595959 or darken background to #FFFFFF"}

   {:dimension  :accessibility
    :severity   :error
    :wcag       "4.1.2"
    :element    ".icon-button"
    :finding    "Button has no accessible name"
    :fix        "Add aria-label=\"Close\" or include visually-hidden text span"}

   {:dimension  :performance
    :severity   :warning
    :finding    "3 images missing width/height attributes cause layout shift (CLS 0.18)"
    :fix        "Add explicit width and height to img elements"}]

 :refine-invocation
   "(refine generated-portal
      :focus-on :accessibility
      :fix [:colour-contrast :icon-button-labels :image-dimensions])"}
```

---

### `w/migrate`

Migrates a web project from one framework, CSS approach, or toolchain to
another, preserving visual appearance and behaviour while updating the
implementation.

#### Signature

```clojure
(w/migrate source-project
  :from    {:framework :vanilla :css :scss}
  :to      {:framework :react :css :tailwind}
  :preserve [:visual-design :behaviour :accessibility :seo]
  :strategy :component-by-component | :full-rewrite
  :output  :migrated-project)
```

#### Design rationale

Framework migrations are painful and risky. The visual design, behaviour, and
accessibility of the source must survive the migration intact. `w/migrate`
makes migration declarative: the practitioner specifies what they are moving
from, what they are moving to, and what must be preserved. The system handles
the mechanical translation.

#### Example

```clojure
(w/migrate "legacy-portal/"
  :from     {:framework :vanilla :css :bootstrap-4}
  :to       {:framework :react :css :tailwind}
  :preserve [:visual-design :behaviour :accessibility]
  :strategy :component-by-component)

;; Migrates component by component:
;; ✓ Header: Bootstrap navbar → React component with Tailwind
;; ✓ Tables: jQuery DataTables → React table with Tailwind
;; ✓ Forms: Bootstrap forms → React Hook Form with Tailwind
;; ✓ All ARIA attributes and keyboard patterns preserved
;; ✓ Visual appearance preserved — same colours, spacing, typography
;; ✓ Migration report: 23 components migrated, 2 require manual review
```

---

## Best practices

### Accessibility is correctness, not decoration

Accessibility failures are correctness failures. A button with no accessible
name is as broken as a button with no click handler — it simply fails for
a different user. Use `:accessibility :wcag-aa` on every `w/prototype`
invocation. Use `w/audit` after every significant refinement. Treat
accessibility findings with the same urgency as functional bugs.

### Extract before you design

Before designing a new system that must co-exist with existing brand assets,
use `w/extract-style` to capture what exists. Designing against an extracted
token set ensures consistency. Without this step, colour values diverge,
spacing drifts, and the new system looks slightly wrong next to the old one.

### Apply tokens, not values

Never hard-code a colour value, spacing value, or type size in a component.
Always reference a design token. When the brand colour changes, one token
value changes and everything updates. When you hard-code values, change is
a search-and-replace exercise that always misses something.

### Domain-first for data-heavy interfaces

When generating interfaces for domain-heavy applications (CRM, healthcare
portals, government services), use `:from-domain` with a domain model rather
than describing the interface manually. The domain model encodes entity
relationships, field types, constraints, and valid states — all of which
should inform the interface. Generating from domain ensures consistency
between the interface and the underlying data model.

### Prototype at the right level of fidelity

`w/prototype` generates a complete, deployable project. If you need a sketch
to validate a concept before committing to a full prototype, use `w/component`
for individual elements or ask for a single-file output. Match fidelity to
purpose: sketches for concept validation, prototypes for stakeholder review,
production builds for deployment.

---

## Integration patterns

### Extract → customise → prototype

The canonical pattern for brand-consistent generation:

```clojure
(def brand-theme
  (w/extract-style corporate-site
    :map-to-tokens :nl-design-system))

(w/prototype "Internal Tools Portal"
  :apply-theme brand-theme
  :from-domain ops-domain
  :type        :app
  :framework   :react
  :output      :project)
```

### Domain → prototype → audit → refine

Complete quality loop:

```clojure
(def portal
  (~> domain-model
    (w/prototype "Service Portal"
      :type :portal :accessibility :wcag-aaa)
    (w/audit :dimensions [:accessibility :performance])
    ;; audit returns :refine-invocation
    ))
```

### Threading design token changes

```clojure
(~> (w/tokens "Municipality Theme"
      :primitives {:color {:primary {...}}}
      :semantic   {:color {:brand {:default "@color.primary.500"}}})
  (w/prototype "Portal" :from-tokens true)
  (w/audit :dimensions [:accessibility]))
```

---

## Grimoire metadata

```clojure
{:grimoire    "web"
 :namespace   "w/"
 :version     "2.0.0"
 :description "Web analysis, extraction, generation, auditing, and migration"

 :constructs {
   :analysis    [w/analyze w/extract-style w/extract-structure]
   :generation  [w/prototype w/component w/tokens]
   :quality     [w/audit w/migrate]}

 :best-for [
   "Landing pages, dashboards, and web applications from declarative descriptions"
   "Design system extraction from existing sites"
   "NL Design System and Rijkshuisstijl integration"
   "Accessibility-first interface generation (WCAG AA/AAA)"
   "Domain-driven interface generation from domain models"
   "Framework migration with visual and behaviour preservation"
   "Design token management and multi-format export"]

 :works-with [:core :domain :data]

 :key-concepts [
   {:term "Design token"
    :definition "A named design decision: a colour, spacing value, or type size.
                 Tokens decouple design decisions from implementation, enabling
                 consistent change propagation."}
   {:term "Design system"
    :definition "A coherent collection of design tokens, components, and patterns
                 that provides consistent visual language across an interface"}
   {:term "WCAG"
    :definition "Web Content Accessibility Guidelines. AA is the legal minimum
                 in most jurisdictions; AAA is the highest standard."}
   {:term "NL Design System"
    :definition "The Dutch government's shared design system and component library,
                 using a token-based architecture compatible with w/extract-style"}
   {:term "Responsive"
    :definition "Layouts that adapt appropriately across device sizes, from
                 mobile (320px) through tablet (768px) to desktop (1280px+)"}]}
```

---

## Implementation notes for LLM processors

### Production quality means complete code

Every `w/prototype` and `w/component` invocation must produce code that:
- Has no placeholder text (`Lorem ipsum`, `TODO`, `PLACEHOLDER`)
- Has no broken or missing functionality
- Includes realistic sample content appropriate to the domain
- Has complete, working JavaScript (no stub functions)
- Compiles without errors with the specified toolchain

### Accessibility as a first-class constraint

When `:accessibility :wcag-aa` is specified (which is the default):
- Every `<img>` must have an `alt` attribute
- Every `<input>`, `<select>`, and `<textarea>` must have an associated `<label>`
- Colour contrast must be ≥ 4.5:1 for body text, ≥ 3:1 for large text
- All interactive elements must be keyboard operable
- Focus must be visible on all interactive elements (not removed with `outline: none`)
- Headings must form a logical hierarchy
- ARIA landmark roles must be present: `header`, `nav`, `main`, `footer`
- Skip navigation link must be first focusable element

With `:accessibility :wcag-aaa`, additionally:
- Colour contrast ≥ 7:1 for body text
- No content flashes more than 3 times per second
- All complex components follow WAI-ARIA Authoring Practices patterns precisely

### Token application

When `:apply-theme` is provided, apply all tokens from the theme to CSS custom
properties before generating any component styles. Never hard-code a colour or
spacing value that appears in the token set. Component styles reference tokens
via `var(--token-name)`.

### Framework idioms

Generated code must follow each framework's idiomatic patterns:
- **React**: functional components with hooks; no class components; TypeScript
  types when applicable; React Hook Form for forms
- **Vue**: Composition API (`setup` function); not Options API
- **Svelte**: reactive declarations and `$:` syntax
- **Vanilla**: ES6+ modules; no jQuery; Web Components where appropriate

### Domain-driven generation

When `:from-domain` is provided:
- Every entity in the domain model becomes a section or route in the interface
- Entity attributes map to form fields with appropriate input types
- Domain constraints map to client-side validation rules
- Entity relationships inform navigation (breadcrumbs, linked views)
- Operations in the domain model map to buttons and actions in the interface