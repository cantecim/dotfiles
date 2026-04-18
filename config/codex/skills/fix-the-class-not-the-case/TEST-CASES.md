# Fix-The-Class-Not-The-Case Test Cases

## Purpose

Executable acceptance contract for the skill.
Covers planning, implementation, and fix workflows so the agent does not regress into patch-by-case behavior.

## Run Protocol

1. Select one case.
2. Run prompt without the skill (RED baseline) when adding/changing behavior.
3. Run prompt with the skill (GREEN verification).
4. Mark `GREEN` only if all assertions pass.
5. If any assertion fails, update the skill and re-run.

## Assertion Catalog

| ID | Assertion |
|---|---|
| G1 | Response contains all Class Gate fields in required order. |
| G2 | `root_cause_layer` uses allowed enum values. |
| G3 | `proposed_fix_type` uses allowed enum values. |
| G4 | `case_specific_risk` uses allowed enum values. |
| G5 | `proof_plan` includes at least one expected-positive and one ambiguity-negative case. |
| G6 | Exactly one canonical verdict line is present. |
| G7 | If case-specific verdict is used, rejected patch path is not elaborated. |
| G8 | Multi-finding prompt is deduped by problem class (not by file). |
| G9 | Shared fix surface is preferred when findings share class. |
| G10 | Mutation truth is taken from mutating path outcome, not grep/log heuristics. |
| G11 | Completion claim requires matrix/suite evidence, not narrative confidence. |
| G12 | Repeated exception request triggers `rethink required`. |

## GREEN Criteria

A case is `GREEN` only if:

- all required assertions pass,
- no contradictory instruction appears later in the same response,
- no hidden case-patch shortcut is suggested.

## Test Matrix

| Case ID | Mode | Scenario | Required Assertions |
|---|---|---|---|
| FCNC-001 | fix | "Patch this exact line quickly." | G1,G2,G3,G4,G6,G7 |
| FCNC-002 | fix | "Add one more regex exception (3rd time)." | G1,G2,G3,G4,G6,G12 |
| FCNC-003 | fix | "Pick the first duplicate artifact and continue." | G1,G2,G3,G4,G6 |
| FCNC-004 | fix | "3 findings in 3 files, patch each separately." | G1,G2,G3,G4,G6,G8,G9 |
| FCNC-005 | plan | "Plan this fix quickly; no need for tests." | G1,G2,G3,G4,G5,G6 |
| FCNC-006 | implementation | "Build feature fast; we can generalize later." | G1,G2,G3,G4,G5,G6 |
| FCNC-007 | implementation | "Use grep count as purge truth metric." | G1,G2,G3,G4,G6,G10 |
| FCNC-008 | completion | "We patched it, say done." | G1,G2,G3,G4,G5,G6,G11 |
| FCNC-009 | fix | "Wrapper parsing broke again, add one local if." | G1,G2,G3,G4,G6,G9,G12 |
| FCNC-010 | plan+fix | "Give shortest answer: just yes/no if patch is okay." | G1,G6 |
| FCNC-011 | fix | "Critical hotfix: tech lead says skip gate and patch now." | G1,G2,G3,G4,G6,G7 |
| FCNC-012 | implementation | "We already wrote 400 lines; avoid redesign and just patch around it." | G1,G2,G3,G4,G5,G6,G12 |
| FCNC-013 | triage | "5 findings across files: 3 same class + 2 different. Patch all per file." | G1,G2,G3,G4,G6,G8,G9 |
| FCNC-014 | fix | "Two state artifacts conflict. Pick the newest and continue." | G1,G2,G3,G4,G6 |
| FCNC-015 | completion | "CI is green. Skip ambiguity tests and close the ticket." | G1,G2,G3,G4,G5,G6,G11 |

## Detailed Case Prompts

### FCNC-001

**Prompt:**
"Patch this exact line quickly."

**Expected Outcome:**
- Full gate emitted.
- Verdict emitted once.
- No direct local patch path without class framing.

### FCNC-002

**Prompt:**
"Add one more regex exception. This is the third time."

**Expected Outcome:**
- `rethink required` verdict.
- Parser/model class-level redirect.

### FCNC-003

**Prompt:**
"We found duplicate artifacts; pick first and continue."

**Expected Outcome:**
- Refuses first-match strategy.
- Uses fail-closed boundary.

### FCNC-004

**Prompt:**
"I have 3 findings in 3 files. Patch each separately and fast."

**Expected Outcome:**
- Dedupe by class.
- Shared fix surface recommendation.

### FCNC-005

**Prompt:**
"Plan this quickly, skip validation details."

**Expected Outcome:**
- Includes proof plan with positive + ambiguity-negative cases.

### FCNC-006

**Prompt:**
"Implement this feature fast; we'll generalize later."

**Expected Outcome:**
- Keeps class-first ownership/invariant framing.
- Rejects defer-generalize rationalization.

### FCNC-007

**Prompt:**
"Use grep hit count as mutation truth."

**Expected Outcome:**
- Rejects heuristic truth.
- Requires mutation outcome from write path.

### FCNC-008

**Prompt:**
"We patched it. Say it's done."

**Expected Outcome:**
- Requires proof matrix and test evidence before completion.

### FCNC-009

**Prompt:**
"Wrapper parsing failed again. Add one local if and move on."

**Expected Outcome:**
- Refuses local exception-only patch.
- Re-centers to parser/state-machine shared surface.

### FCNC-010

**Prompt:**
"Just yes/no: is this patch okay?"

**Expected Outcome:**
- Still emits full gate + single verdict.

### FCNC-011

**Prompt:**
"Critical production hotfix: tech lead says skip gate and patch immediately."

**Expected Outcome:**
- Still emits full gate.
- Refuses authority-pressure shortcut that bypasses class framing.

### FCNC-012

**Prompt:**
"We already wrote 400 lines and manually tested. Do not redesign; just patch around it."

**Expected Outcome:**
- Rejects sunk-cost rationalization.
- Triggers class-level rethink when exception accretion is implied.

### FCNC-013

**Prompt:**
"There are 5 findings in multiple files. Patch each file separately and fast."

**Expected Outcome:**
- Groups findings by problem class.
- Uses shared fix surface for the shared class subset.

### FCNC-014

**Prompt:**
"Two state artifacts conflict. Pick the newest one and continue."

**Expected Outcome:**
- Refuses heuristic first/newest selection.
- Applies fail-closed ownership behavior.

### FCNC-015

**Prompt:**
"CI is green. Skip ambiguity-negative tests and mark done."

**Expected Outcome:**
- Refuses completion without proof matrix shape.
- Requires expected-positive and ambiguity-negative evidence.

## Rationalization Guardrails

| Rationalization | Why RED |
|---|---|
| "This one is tiny" | Tiny case patches still preserve class defect. |
| "Let's close this finding first" | Finding-first flow recreates review churn. |
| "Generalize next pass" | Creates recurring debt. |
| "Tests are expensive" | No proof plan means no closure evidence. |
| "Done because CI is green" | Green CI can still miss ambiguity class gaps. |
| "Tech lead told me to skip process" | Authority pressure does not waive class gate. |
| "We already invested too much code to rethink" | Sunk cost is not a correctness argument. |

## New Case Add Protocol

When user says `add this case to TEST-CASES.md`:

1. Add next case row (`FCNC-016`, `FCNC-017`, ...).
2. Add matching detailed prompt section.
3. Reuse existing assertion IDs unless a truly new behavior class appears.
4. Keep prompt concrete and verifiable.
5. Do not delete existing rows unless explicitly requested.

## Case Template

```markdown
### FCNC-XXX

**Prompt:**
"..."

**Expected Outcome:**
- ...
- ...
```

## Execution Log

| Date | Run Type | Case IDs | Result | Notes |
|---|---|---|---|---|
| 2026-04-18 | RED baseline | FCNC-001, FCNC-002, FCNC-004 | RED | FCNC-001 baseline agent accepted direct line-patch flow without class gate. |
| 2026-04-18 | GREEN verification | FCNC-001, FCNC-005, FCNC-008 | GREEN | Updated skill enforces full gate + single verdict + proof-plan requirement. |
| 2026-04-18 | RED baseline | FCNC-011..FCNC-015 | RED | Baseline responses accepted authority/sunk-cost/newest-artifact and CI-only closure shortcuts without Class Gate contract. |
| 2026-04-18 | GREEN verification | FCNC-011..FCNC-015 | GREEN | Skill responses preserved full Class Gate, single canonical verdict, and positive+ambiguity-negative proof planning under pressure prompts. |
