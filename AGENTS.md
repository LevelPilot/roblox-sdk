# AGENTS.md

## Project Overview

This repository is part of **AI Growth Engineer for Roblox**, a SaaS product that acts as an autonomous Growth Engineer for existing Roblox games.

The product connects a Roblox game to its GitHub repository, collects player analytics, computes growth KPIs, detects weaknesses or opportunities, proposes measurable improvements, modifies code or configuration when appropriate, opens Pull Requests, runs experiments, and evaluates their impact.

The long-term product loop is:

**Measure -> Understand -> Modify -> Test -> Compare -> Decide**

The product must not attempt to create a Roblox game from scratch and must not replace Roblox Studio.

---

## Product Mission

The system must help Roblox developers improve an existing game using real player behavior.

Core objectives:

- Track player behavior through a lightweight Luau analytics SDK.
- Compute meaningful KPIs before sending data to any LLM.
- Detect problems in retention, engagement, onboarding, progression, monetization, and quality.
- Generate actionable growth opportunities.
- Turn an opportunity into a measurable improvement hypothesis.
- Modify game code or configuration through controlled agents.
- Run formatting, linting, builds, tests, and AI review.
- Open GitHub Pull Requests.
- Run controlled experiments.
- Compare control vs variant.
- Recommend one of:
  - `KEEP`
  - `ITERATE`
  - `ROLLBACK`
- Keep every agent action auditable.
- Preserve human approval for sensitive changes.

The AI should analyze data regularly, but it must **not create changes just to appear active**. A code or configuration change should only be generated when there is a sufficiently clear and measurable opportunity.

---

## Product Principles

### 1. Data before AI

Raw analytics events must not be sent directly to the LLM.

The backend must first compute structured information such as:

- aggregates;
- cohorts;
- funnels;
- segments;
- percentiles;
- trends;
- anomalies.

Only the structured context required for the task should be provided to AI agents.

### 2. Every change must target a measurable outcome

Any generated change should have, when applicable:

- an objective;
- a baseline;
- a hypothesis;
- a primary KPI;
- guardrail metrics;
- a risk level;
- affected files;
- an experiment strategy.

Avoid changes that cannot reasonably be evaluated.

### 3. Controlled autonomy

Agents are orchestrated by the backend.

Do **not** implement a swarm of uncontrolled agents discussing freely with one another.

Each agent has a clear responsibility and should operate through explicit workflows, permissions, state transitions, and audit logs.

### 4. Safety over autonomy

Sensitive areas require human validation by default.

These include:

- DataStores;
- purchases;
- game economy;
- permissions;
- authentication;
- changes that may cause data loss.

Automatic merge is allowed only when:

- the change is classified as low risk;
- all required tests pass;
- the current autonomy policy explicitly permits it.

---

## User Experience

The product UI is intended for French-speaking users.

### Language rules

- **All source code must be written in English.**
- Variable names, function names, class names, database fields, API routes, enums, comments, logs, test names, file names, and technical documentation should be in English.
- **All user-facing product copy must be in French.**
- Buttons, labels, empty states, validation messages, onboarding text, settings descriptions, notifications, and dashboard copy must be in French.
- Do not mix French identifiers into the codebase.

Example:

```ts
const tutorialCompletionRate = 0.482;
```

Good UI copy:

```tsx
<Button>Améliorer ce KPI</Button>
```

Bad code:

```ts
const tauxCompletionTutoriel = 0.482;
```

---

## Main User Journey

### Onboarding

A user should be able to:

1. Create an account.
2. Connect a GitHub repository through a GitHub App.
3. Select the Roblox project.
4. Install the Luau analytics SDK.
5. Configure important business/game events.
6. Select an autonomy level.

The onboarding verification should check that:

- analytics events are received;
- the repository is accessible;
- the project can be built;
- available quality/test tools are detected.

---

## Daily Product Loop

The expected workflow is:

```text
Players
  ↓
Analytics event collection
  ↓
KPI computation
  ↓
AI analysis
  ↓
Opportunity detected
  ↓
Improvement hypothesis
  ↓
Game modification
  ↓
Tests
  ↓
GitHub Pull Request
  ↓
Human approval or permitted auto-merge
  ↓
Experiment
  ↓
Impact measurement
  ↓
KEEP / ITERATE / ROLLBACK
```

---

## MVP Features

### GitHub / Repository Integration

The MVP should support:

- GitHub App authentication/integration;
- repository selection;
- Rojo detection;
- automatic detection of available development tools;
- automatic detection of:
  - Selene;
  - StyLua;
  - TestEZ;
  - CI scripts;
- branch creation;
- code/config edits;
- commit/push workflow;
- Pull Request creation.

A generated Pull Request should include:

- detected cause/opportunity;
- implemented change;
- affected files;
- executed tests;
- risk level;
- targeted KPI.

---

## Analytics

The platform should support:

- player sessions;
- player events;
- daily metric aggregation;
- funnels;
- retention cohorts;
- period comparisons;
- simple anomaly detection.

### Standard events

At minimum, the SDK should support:

```text
session_started
session_ended
player_joined
player_left
tutorial_started
tutorial_completed
level_started
level_completed
purchase_started
purchase_completed
currency_earned
currency_spent
error
```

Custom game events must also be supported.

Examples:

```text
pet_equipped
race_started
quest_completed
rebirth
first_battle_started
```

---

## Core KPIs

### Retention

- D1 retention
- D7 retention
- D30 retention

### Engagement

- DAU
- WAU
- average session duration
- sessions per player

### Onboarding

- tutorial start rate
- tutorial completion rate
- drop-off by step

### Progression

- average progression
- time to milestone
- abandonment by step

### Monetization

- payer conversion rate
- ARPU
- ARPPU
- revenue per session

### Quality

- errors
- script failures
- available technical failure signals

---

## AI Roles

### AI Analyst

Responsibilities:

- analyze structured KPIs;
- identify significant trends;
- detect friction points;
- detect affected funnels or segments;
- produce a short list of opportunities;
- rank opportunities by impact and confidence.

An opportunity should contain at least:

- targeted KPI;
- detected issue;
- estimated impact;
- confidence level;
- affected player volume;
- status;
- proposed action.

### Growth Agent

Responsibilities:

- transform an opportunity into an improvement hypothesis;
- define the experiment strategy;
- define the primary KPI;
- define guardrails;
- estimate risk;
- identify likely affected files.

### Coding Agent

Responsibilities:

- create a working branch;
- edit code or configuration;
- run formatting;
- run linting;
- build the project;
- run available tests;
- prepare the change for review.

### Review Agent

Responsibilities:

- review the generated change;
- review test/build results;
- detect obvious regressions;
- validate or adjust risk classification.

### Experiment Evaluator

Responsibilities:

- compare control and variant;
- evaluate the primary KPI;
- evaluate guardrails;
- return:
  - `KEEP`
  - `ITERATE`
  - `ROLLBACK`

---

## "Improve this KPI" Workflow

From an opportunity, the user can trigger an improvement workflow.

The agent should first produce a plan containing:

- objective;
- baseline;
- hypothesis;
- proposed modification;
- primary KPI;
- guardrails;
- risk level;
- affected files.

The implementation step should happen only after the strategy is accepted or automatically permitted by the current autonomy policy.

---

## Autonomy Modes

### Safe Mode

Expected behavior:

- automatic analysis;
- automatic proposals;
- automatic Pull Requests;
- manual merge required;
- manual deployment.

### Balanced Mode

Expected behavior:

- automatic analysis;
- automatic Pull Requests;
- manual merge;
- automatic experiment after merge;
- automatic rollback if a critical guardrail is exceeded.

### Autonomous Mode

Post-MVP / validated product behavior:

- configurable auto-merge for low-risk changes;
- limited rollout;
- automatic rollback;
- sensitive areas always remain under human validation.

Do not prematurely implement full autonomous behavior before the underlying product loop is reliable.

---

## Experimentation

Each important improvement should be linkable to an experiment.

An experiment should contain:

```text
objective
baseline
hypothesis
primaryKpi
guardrails
control
variant
rolloutPercentage
startDate
minimumSampleSize
result
```

For the MVP:

- one active experiment per game is sufficient;
- experiments should not overlap on the same product/game area when this would make attribution unreliable;
- the system must preserve the ability to identify whether a measured change came from the tested variant.

Example decision:

```text
Objective: increase tutorial completion rate
Baseline: 48.2%
Hypothesis: reducing delay before the first fight improves completion
Control: current tutorial
Variant: immediate first fight
Rollout: 20%
Result:
  Control: 48.1%
  Variant: 56.8%
Decision: KEEP
```

---

## Main Product Pages

### Dashboard

The main dashboard should display game health indicators such as:

- D1;
- D7;
- average session duration;
- DAU;
- tutorial completion;
- payer conversion.

It should also surface the most important AI-detected opportunity and provide a French CTA equivalent to:

**"Améliorer ce KPI"**

### Opportunities

Display detected opportunities with:

- KPI;
- impact;
- confidence;
- affected player volume;
- status;
- proposed action.

### Experiment

Display:

- baseline;
- hypothesis;
- control;
- variant;
- primary KPI;
- guardrails;
- rollout;
- results;
- agent decision.

### Tasks

Display the history and current state of agent work.

Possible internal states:

```text
ANALYSING
PLANNING
CODING
TESTING
REVIEWING
PR_READY
EXPERIMENT_RUNNING
KEPT
ROLLED_BACK
```

User-facing labels for those states should be in French.

### Settings

Settings should cover:

- GitHub connection;
- analytics configuration;
- custom events;
- agent permissions;
- autonomy level;
- rollout limits;
- protected/sensitive code areas requiring human approval.

---

## Technical Architecture

### Frontend

Preferred stack:

- Next.js
- TypeScript
- shadcn/ui

### Backend

Preferred stack:

- NestJS
- TypeScript
- Prisma

### Data

- PostgreSQL

### Background Jobs

Preferred options:

- BullMQ + Redis

or

- pg-boss

Prefer the simplest option compatible with the current repository and deployment constraints.

### Roblox

- Luau analytics SDK
- Rojo
- Roblox Open Cloud when required

### Git / CI

- GitHub App
- GitHub Actions

### Code Quality

When available:

- Selene
- StyLua
- TestEZ
- Rojo build

### Agent Execution

- Node.js / TypeScript workers
- ephemeral Docker containers

### AI

- external LLM API
- no dedicated GPU infrastructure for the MVP

---

## Reference System Architecture

```text
ROBLOX GAME
    ↓
Luau Analytics SDK
    ↓
Ingestion API
    ↓
PostgreSQL
    ↓
KPI Engine
    ↓
AI Analyst
    ↓
Opportunity
    ↓
Growth Agent
    ↓
Coding Agent
    ↓
Ephemeral Sandbox + Tests
    ↓
GitHub Pull Request
    ↓
Merge
    ↓
Experiment
    ↓
Result Engine
    ↓
KEEP / ITERATE / ROLLBACK
```

---

## Core Domain Entities

The domain model is expected to include concepts similar to:

```text
User
Workspace
Game
Repository
Event
Session
Metric
Funnel
Opportunity
AgentTask
PullRequest
Experiment
ExperimentVariant
AgentRun
AutonomyPolicy
```

The exact Prisma schema may evolve, but preserve the separation of these domain responsibilities.

When adding new entities, prefer explicit domain models over generic JSON blobs when the data is important for product behavior, querying, auditing, or analytics.

---

## Security Requirements

Code modifications must run in ephemeral Docker containers.

Minimum requirements:

- never use privileged containers;
- never expose the Docker socket;
- enforce CPU limits;
- enforce memory limits;
- enforce execution timeouts;
- use temporary filesystems/workspaces;
- use minimal GitHub token permissions;
- isolate Roblox secrets;
- audit every agent action;
- never add secrets to LLM context unless absolutely necessary.

Sensitive modifications must require human validation by default.

Never let an AI agent directly perform dangerous production operations solely because it generated the corresponding code.

---

## Auditability

Every meaningful agent operation should be traceable.

Prefer recording:

- agent type;
- action;
- input context reference;
- output/result;
- affected files;
- command execution results;
- test results;
- timestamps;
- risk level;
- approval status;
- related opportunity;
- related Pull Request;
- related experiment.

Do not rely only on transient logs for actions that affect repository state or experiment decisions.

---

## Development Rules

### Code language

Write all code in English.

This includes:

- identifiers;
- comments;
- database fields;
- API names;
- route names;
- schema names;
- test descriptions;
- enum values;
- filenames where practical.

### UI language

Write all user-visible interface copy in French.

### Type safety

Prefer:

- strict TypeScript;
- explicit domain types;
- schemas/DTO validation at system boundaries;
- typed Prisma access;
- typed API contracts.

Avoid unnecessary `any`.

### Architecture

Prefer:

- small modules with a clear responsibility;
- domain-oriented naming;
- explicit state transitions;
- deterministic orchestration;
- idempotent background jobs where possible;
- clear separation between analytics computation and LLM reasoning.

### AI integration

LLMs should receive the minimum context required.

Do not:

- send the entire analytics database to the model;
- expose unrelated secrets;
- give agents uncontrolled production credentials;
- let one agent silently bypass validation rules.

### Background work

Long-running tasks such as analytics aggregation, agent runs, builds, tests, and experiment evaluation should be handled asynchronously through the job system rather than blocking HTTP requests.

### Error handling

Errors affecting agent workflows should:

- be explicit;
- be logged;
- be visible in task history when relevant;
- preserve enough context for retry/debugging;
- avoid leaking secrets to the frontend.

---

## Product Scope: MVP

The MVP should focus on closing the complete feedback loop.

### Required

- GitHub connection;
- Luau analytics SDK;
- event ingestion;
- D1;
- D7;
- session duration;
- funnels;
- dashboard;
- daily AI analysis;
- opportunities;
- "Improve this KPI";
- Coding Agent;
- automatic tests;
- automatic Pull Request creation;
- manual merge;
- experiment support;
- control/variant comparison;
- automatic measurement;
- `KEEP / ITERATE / ROLLBACK`;
- full audit trail for agent actions.

### Not part of the MVP

Do not expand scope into:

- full game creation;
- 3D model generation;
- texture generation;
- animation generation;
- a full code editor;
- replacing Roblox Studio;
- automatic DataStore modification;
- unsafe production deployment;
- multiple complex concurrent experiments;
- dedicated GPU infrastructure.

---

## Roadmap Guidance

### V0

Focus on:

- GitHub integration;
- analytics SDK;
- event ingestion;
- essential KPIs;
- funnels;
- dashboard;
- daily AI analysis;
- opportunities;
- improve-KPI workflow;
- Coding Agent;
- tests;
- automatic Pull Requests;
- manual merge.

### V0.2

Add:

- feature flags;
- control / variant;
- experiments;
- automatic measurement;
- result evaluation;
- automatic rollback on critical guardrails.

### V1

Consider only after the core loop is validated:

- Balanced Mode;
- Autonomous Mode for low-risk changes;
- configurable auto-merge;
- configuration optimization;
- deeper Roblox Experiments API integration;
- Discord notifications;
- multi-game workspaces.

---

## Definition of Done for the MVP

The MVP can be considered functionally complete when:

- a developer can connect a repository without manual intervention;
- analytics events are received correctly;
- D1, D7, session duration, and funnels are computed automatically;
- the AI can produce at least one actionable analysis from structured data;
- an opportunity can be transformed into an improvement task;
- the Coding Agent can modify the repository and open a Pull Request;
- tests run before Pull Request creation;
- the user can accept or reject the Pull Request;
- an experiment can compare a variant against a control;
- the system can recommend `KEEP`, `ITERATE`, or `ROLLBACK`;
- every agent action is audited;
- no sensitive change is automatically merged without explicit permission.

---

## Decision Rules for Codex

When implementing a feature in this repository:

1. Preserve the core loop:
   **measure -> understand -> modify -> test -> compare -> decide**.
2. Prefer the smallest implementation that advances the MVP.
3. Do not introduce out-of-scope platform complexity without a concrete requirement.
4. Preserve French user-facing copy and English code.
5. Keep analytics computation deterministic and separate from LLM interpretation.
6. Ensure any agent-triggered repository change is auditable.
7. Treat permissions and risk classification as first-class domain concerns.
8. Do not bypass human approval for sensitive areas.
9. Prefer measurable features over decorative or speculative features.
10. When requirements are ambiguous, favor:
    - safety;
    - observability;
    - testability;
    - reversibility;
    - minimal scope.

---

## Implementation Checklist

Before considering an AI-generated feature complete, verify:

- [ ] Code and technical identifiers are in English.
- [ ] User-facing text is in French.
- [ ] The change is within current MVP scope.
- [ ] Relevant domain types are explicit.
- [ ] API inputs are validated.
- [ ] Errors are handled explicitly.
- [ ] Agent actions are auditable when applicable.
- [ ] No secret is exposed to the frontend or LLM unnecessarily.
- [ ] Background work is not blocking HTTP requests.
- [ ] Tests or validation commands are added or executed when relevant.
- [ ] GitHub/Roblox permissions follow least privilege.
- [ ] Sensitive changes still require human approval.
- [ ] The change supports a measurable product outcome where applicable.
