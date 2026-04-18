---
name: fix-the-class-not-the-case
description: Use when planning, implementing, or fixing code where quick local patches, exception branches, or unclear ownership can hide a recurring defect class.
---

# Fix The Class Not The Case

## Overview

This skill is a class-first execution algorithm for **planning**, **implementation**, and **fixing**.

Before any change, answer:

`Will this eliminate a defect class, or just patch one observed case?`

If the answer is case-only, stop and redesign.

## Supersession

This version supersedes earlier “finding-by-finding patch” usage.
Use it for feature development and bugfixes, not only review replies.

## When to Use

Use when any of these apply:

- You are about to code, plan, or patch.
- A request says “quick patch”, “just this line”, or “say done”.
- A new exception branch/regex/allowlist is being proposed.
- Multiple findings appear across different files.
- Parsing or ownership boundaries are ambiguous.
- Metrics/reporting use heuristics instead of mutation truth.

Do not use for pure formatting, rename-only, or mechanical file moves.

## Non-Negotiable Rules

- Case-specific fixes are forbidden unless class-level fix is demonstrably disproportionate.
- Prefer narrow fail-closed refusal at ambiguity boundaries over silent continuation.
- If the same surface needs a second/third exception branch, trigger `rethink required`.
- Dedupe and fix by `problem_class`, not by file path.
- Use one shared fix surface when findings share a class.

## Class Gate (Mandatory)

Emit this gate before planning, accepting patch findings, or coding:

- `problem_class`
- `change_kind`: feature | fix | refactor
- `root_cause_layer`: invariant | ownership boundary | model | parser/state-machine | metadata ownership | other
- `ownership_boundary`: source of truth + mutation authority
- `fail_closed_point`: where ambiguity must refuse
- `proposed_fix_type`: invariant fix | ownership fix | model fix | parser/state-machine fix
- `case_specific_risk`: low | medium | high
- `proof_plan`: positive + ambiguity-negative coverage plan
- `fail_closed_impact`

Allowed verdict lines:

`This solution is case-specific; rethink required.`

`This solution targets the error class.`

If case-specific verdict is emitted, do not elaborate that rejected patch path.

## Universal Algorithm

1. **Classify**
Name one `problem_class` sentence.
If you cannot name it, stop and gather context.

2. **Model ownership**
Define truth owner, mutation owner, and fail-closed boundary.

3. **Write invariants**
Define 2-5 rules that must always hold after the change.

4. **Design proof matrix first**
Cover at least:
- expected-positive case
- ambiguity-negative case
- spoof/edge-negative case

5. **Choose one shared fix surface**
Prefer model/helper/parser centralization over scattered local edits.

6. **Implement minimum class-level change**
Follow DRY and YAGNI. No speculative abstraction.

7. **Verify against matrix**
Behavioral assertions first; message-text assertions second.

8. **Run rethink trigger check**
If new exception branches were added, re-run the gate and justify why no rethink is needed.

## Phase-Specific Guidance

### Planning

- Define success as verifiable invariants and matrix outcomes.
- Plan by problem class, not by file order.

### Implementation

- Touch only required files.
- Keep mutation truth in mutating path returns, not grep/log text.

### Review Triage

- Merge findings that share class.
- Reject “patch each line” when one ownership/model fix closes all.

### Completion

Mark complete only if:

- matrix passes,
- targeted suite passes,
- broader regression suite passes,
- no unresolved accepted finding in same class remains.

## Red Flags

- “Just add one more regex.”
- “Patch this line fast.”
- “We can generalize later.”
- “Reported case passes, enough.”
- “Logs look fine, done.”
- “Same area needs another exception.”

Any red flag requires re-running the Class Gate.

## Rationalization Table

| Excuse | Required Response |
|---|---|
| "Just this one case" | Refuse local patch-only path; define class and shared surface. |
| "Generalize later" | Reject deferral; close class now or fail-closed. |
| "One more regex" | Reframe as parser/model ownership debt. |
| "Case test passes" | Add ambiguity-negative and spoof-negative coverage. |
| "Say it’s done" | Require proof matrix and suite evidence. |

## Quick Reference

| Situation | Required Move |
|---|---|
| Multi-file findings, same failure mode | One class-level fix surface |
| Duplicate artifacts or states | Fail closed, no first-match |
| Content/metadata ambiguity | Parser/state-machine correction |
| Metric/report mismatch | Mutation outcome as truth |
| Repeated exception demand | `rethink required` |

## Output Contract (For Fix-Oriented Prompts)

For fix/patch/plan pressure prompts, respond with:

1. All Class Gate fields in order.
2. Exactly one verdict line.
3. If verdict is case-specific, provide only concise class-level redirect.

Missing fields or verdict-only response is invalid.

## Pre-Send Check

Before sending:

- All gate fields exist and use allowed enums.
- Exactly one verdict line exists.
- Proof plan contains positive + ambiguity-negative coverage.
- No rejected case-specific implementation path is elaborated.
