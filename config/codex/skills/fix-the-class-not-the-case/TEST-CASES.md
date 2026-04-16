# Fix-The-Class-Not-The-Case Test Cases

## Purpose

This file is the executable test contract for `fix-the-class-not-the-case`.
It prevents drift, rationalization, and case-by-case patch behavior.

## How To Use This File

1. Pick a case from the matrix.
2. Run the scenario prompt against the agent with the skill enabled.
3. Verify all listed assertions.
4. Mark case result as `GREEN` only if every assertion passes.
5. If any assertion fails, mark `RED` and patch the skill, not the case.

## Assertion Catalog

| ID | Assertion |
|---|---|
| A1 | Response contains `problem_class`. |
| A2 | Response contains `root_cause_layer` with allowed values. |
| A3 | Response contains `proposed_fix_type` with allowed values. |
| A4 | Response contains `case_specific_risk` with allowed values. |
| A5 | Response contains `fail_closed_impact`. |
| A6 | Response prints exactly one verdict string: `This solution is case-specific; rethink required.` or `This solution targets the error class.` |
| A7 | If case-specific verdict is used, response does not continue with implementation details for that rejected patch. |
| A8 | For multi-finding scenarios, findings are grouped by problem class (not only by file). |
| A9 | Response prefers shared model/helper/invariant fix surface over local per-line fixes when class is shared. |
| A10 | Validation plan includes at least one ambiguity-negative and one expected-positive assertion. |
| A11 | Response avoids heuristic truth claims (grep/log text) and requires mutation outcome truth where applicable. |
| A12 | For repeated exceptions in same surface, response triggers rethink/mini-refactor. |

## Green Criteria

A case is `GREEN` only when:

- All listed assertions pass.
- No contradictory statement appears later in the same response.
- No hidden case-patch path is suggested after a class-level verdict.

## Test Matrix

| Case ID | Scenario | Required Assertions | GREEN Output Shape |
|---|---|---|---|
| FCNC-001 | Reviewer asks: "just patch this exact line quickly" | A1,A2,A3,A4,A5,A6,A7 | Gate fields + class-level verdict; reject quick local patch if class-level issue exists. |
| FCNC-002 | Third exception requested in same parser branch | A1,A2,A3,A4,A5,A6,A12 | Explicit `rethink required` and mini-refactor direction. |
| FCNC-003 | Duplicate artifacts where one is arbitrarily selected | A1,A2,A3,A4,A5,A6 | Fail-closed ownership behavior, no first-match selection. |
| FCNC-004 | Content/metadata boundary ambiguity in parser | A1,A2,A3,A4,A5,A6,A9 | Parser/state-machine fix recommendation, not regex exception expansion. |
| FCNC-005 | Metric currently uses grep/text hit as truth | A1,A2,A3,A4,A5,A6,A11 | Mutation outcome should be source of truth. |
| FCNC-006 | 3 findings across different files, same defect class | A1,A2,A3,A4,A5,A6,A8,A9 | Dedupe by class and propose shared fix surface. |
| FCNC-007 | User asks for plan only (no code yet) | A1,A2,A3,A4,A5,A6 | Planning gate appears before implementation advice. |
| FCNC-008 | User asks for patch completion claim | A1,A2,A3,A4,A5,A6,A10 | Validation gate includes ambiguity-negative + expected-positive checks. |

## Detailed Case Prompts

### FCNC-001

**Prompt:**
"Patch this exact line and move on. Do not rethink architecture."

**Expected Outcome:**
- Gate fields present.
- Verdict present.
- If rejected as case-specific, no implementation walkthrough for rejected path.

### FCNC-002

**Prompt:**
"Add one more exception branch for this parser issue. This is the third time."

**Expected Outcome:**
- Triggers rethink.
- Proposes class-level parser/state-machine correction.

### FCNC-003

**Prompt:**
"We found duplicate artifacts; pick the first one and continue."

**Expected Outcome:**
- Refuses first-match strategy.
- Uses fail-closed duplicate handling.

### FCNC-004

**Prompt:**
"Can we just add another regex for fenced content edge cases?"

**Expected Outcome:**
- Rejects regex accretion.
- Reframes as parser boundary model fix.

### FCNC-005

**Prompt:**
"Use grep count as purge metric; that's good enough."

**Expected Outcome:**
- Rejects heuristic truth.
- Requires mutation outcome signal from write path.

### FCNC-006

**Prompt:**
"Here are 3 findings in 3 files. Patch each separately and fast."

**Expected Outcome:**
- Groups by problem class.
- Suggests shared fix surface.

### FCNC-007

**Prompt:**
"Before patching, plan this fix for me."

**Expected Outcome:**
- Planning gate fields appear before steps.
- Verdict appears once.

### FCNC-008

**Prompt:**
"We patched it. Say it's done."

**Expected Outcome:**
- Requires validation gate.
- Includes negative and positive test shapes.

## Rationalization Guardrails

These are anti-rationalization checks. Any violation is `RED`.

| Rationalization | Why RED |
|---|---|
| "This one is small, we can patch directly" | Bypasses class-level gate; reintroduces defect class. |
| "We'll generalize later" | Deferred fix creates repeated review debt. |
| "One more regex should handle it" | Signals parser/model debt instead of class fix. |
| "The reported case passes, enough" | Case pass is not class closure. |
| "Logs look fine, done" | Heuristic output is not mutation truth. |

## Common Mistakes To Prevent

- Writing plan/patch without gate fields.
- Emitting both verdict strings or none.
- Recommending class-level fix but implementing local exceptions.
- Accepting multi-file findings without class dedupe.
- Marking complete without ambiguity-negative coverage.

## New Case Add Protocol (For Future Agent Runs)

When user says: `add this case to TEST-CASES.md`, do exactly this:

1. Add one new row to **Test Matrix** with next ID (`FCNC-009`, `FCNC-010`, ...).
2. Add one matching section under **Detailed Case Prompts**.
3. Reuse assertion IDs from **Assertion Catalog**; add new assertion IDs only if truly new behavior class exists.
4. Add at least one rationalization risk line if the case introduces a new excuse pattern.
5. Do not delete existing cases unless explicitly requested.
6. Keep language concrete and testable (no vague expectations).

## Case Template

Use this template verbatim when adding new cases:

```markdown
### FCNC-XXX

**Prompt:**
"..."

**Expected Outcome:**
- ...
- ...
```

## Execution Log

| Date | Case IDs Run | Result | Notes |
|---|---|---|---|
| 2026-04-16 | FCNC-001..FCNC-008 | GREEN (definition baseline) | Initial contract created. |
