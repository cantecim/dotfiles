---
name: fix-the-class-not-the-case
description: Use when Codex is about to write code, propose a patch, address review feedback, add an exception branch, extend regex or allowlist or denylist logic, or resolve ambiguous parsing, state, or duplicate-artifact behavior where there is risk of fixing one observed case instead of the underlying error class.
---

# Fix The Class Not The Case

## Overview

Before planning or coding, ask:

`Does this change close a case, or eliminate an error class?`

Apply this in planning, triage, patching, and validation. This skill is for class-level fixes, not finding-level band-aids.

## When to Use

Use when one or more of these signals appear:

- Review asks for "just patch this line" but symptoms span multiple call sites.
- Proposal adds one more regex/allowlist/denylist exception.
- Ownership of state, artifact, or mutation boundary is ambiguous.
- Parser/model mixes content and metadata.
- A recently patched area receives another related finding.

Do not use for purely mechanical renames or formatting-only changes.

## Non-Negotiable Rule

- Case-specific fixes are forbidden unless a class-level fix is demonstrably disproportionate. Prefer fail-closed behavior over silent ambiguity.
- Fail-closed does not mean broad production crashes. Prefer narrow, typed, ownership-aligned refusal at the ambiguity boundary over silent success or generic exceptions.
- Treat a fix as suspect when it handles only one observed token, artifact, branch, or log shape.
- If the same surface needs a second or third exception branch, mark `rethink required`.
- Do not answer review findings with a quick patch before stating root cause and affected layer.
- Never start with a verdict line. Start with `problem_class:` and complete the full canonical gate before verdict.
- Brevity pressure never waives required fields. If details are unknown, emit concise placeholder values rather than omitting fields.

## Core Pattern

1. Classify the change: case closure or class fix.
2. Name the root-cause layer before editing.
3. Prefer the smallest class-level fix.
4. If the proposal is still case-specific, stop and rethink.

## Gate Contract (Canonical)

Emit this assessment before planning, triage acceptance, or patching:

- `problem_class`
- `root_cause_layer`: invariant | ownership boundary | model | parser/state-machine | metadata ownership | other
- `proposed_fix_type`: invariant fix | ownership fix | model fix | parser/state-machine fix
- `case_specific_risk`: low | medium | high
- `fail_closed_impact`

Use the verdict strings below verbatim:

`This solution is case-specific; rethink required.`

`This solution targets the error class.`

If you emit the case-specific verdict, do not elaborate that patch. Redirect to the smallest class-level or fail-closed fix.

### Response Contract (Strict)

For any fix-oriented request (including terse pressure prompts), emit:

1. The five canonical fields above, in order.
2. Exactly one verdict line (one of the two canonical strings).
3. If verdict is case-specific, stop rejected-path details and give only a concise class-level redirect.

This includes question-style prompts such as "Can we just add another regex...?" and completion-pressure prompts such as "say it's done."

Use this shape:

```text
problem_class: ...
root_cause_layer: invariant | ownership boundary | model | parser/state-machine | metadata ownership | other
proposed_fix_type: invariant fix | ownership fix | model fix | parser/state-machine fix
case_specific_risk: low | medium | high
fail_closed_impact: ...
This solution is case-specific; rethink required.
```

or

```text
problem_class: ...
root_cause_layer: invariant | ownership boundary | model | parser/state-machine | metadata ownership | other
proposed_fix_type: invariant fix | ownership fix | model fix | parser/state-machine fix
case_specific_risk: low | medium | high
fail_closed_impact: ...
This solution targets the error class.
```

Do not emit a verdict-only response. Missing gate fields is a contract failure.
Do not start with either verdict string.

### Pre-Send Output Check (Mandatory)

Before finalizing any response covered by this skill, verify:

- `problem_class` exists
- `root_cause_layer` exists and uses an allowed value
- `proposed_fix_type` exists and uses an allowed value
- `case_specific_risk` exists and uses an allowed value
- `fail_closed_impact` exists
- exactly one canonical verdict line exists

If any check fails, regenerate the response until all checks pass.
If the first non-empty line is a verdict string, regenerate.

### Planning Gate

Before writing implementation steps, extend the canonical assessment with:

- `ownership_boundary`: who owns truth and mutation authority
- `fail_closed_point`: where ambiguity must refuse
- `proof_plan`: how tests will prove class-level closure

### Triage Gate

Before accepting review findings:

- Dedupe by `problem_class`, not by file.
- Map each accepted finding to one root-cause layer.
- If findings share a class, prefer one shared model/helper fix surface over multiple local patches.
- Reject patch-each-line strategy when a central ownership/model fix can remove the class.

### Patch Gate

Before editing, run the canonical assessment and verdict exactly once.
Do not skip the canonical fields for "quick patch", "just do it", or "say it's done" prompts.

### Validation Gate

Before marking complete:

- Tests must prove invariant/ownership behavior, not only message text.
- Include at least one ambiguity-negative and one expected-positive case.
- Treat mutation outcomes as truth; do not use grep/log heuristics as truth.
- If new exception branches were added, rerun Planning Gate and justify why rethink is not required.

## First-Implementation Questions

Answer these before shaping logic:

- `who owns this?`
- `which fields are mutable?`
- `where is the fail-closed point?`
- `what happens under ambiguity?`
- `how are content and metadata separated?`

## Quick Reference

| Situation | Required move |
|---|---|
| Same finding class appears in multiple files | One shared fix surface (model/helper/invariant) |
| Duplicate artifacts/states with ambiguous selection | Fail closed; do not pick first match |
| Parser/content boundary unclear | Parser/state-machine fix, not regex expansion |
| Metrics/reporting mismatch | Return mutation outcome from mutating path |
| New exception branch needed in recently patched area | Trigger `rethink required` |

## Red Flags

Treat these as warning signs, not default fixes:

- special-case `if`
- adding one more regex exception
- growing allowlist or denylist
- a test that locks only one observed instance
- heuristic metrics or logs used as truth
- selecting the first duplicate match
- counting text patterns instead of returning the real mutation outcome
- jumping to a verdict before printing canonical gate fields

## Preferred Fix Types

Prefer fixes in these classes:

- invariant fix
- ownership fix
- model fix
- parser/state-machine fix

Choose the smallest class-level fix. Stay DRY and YAGNI. Do not overbuild.

## Rethink Triggers

- Same area gets another finding after a recent patch.
- Same surface wants a second or third exception branch.
- Parser ambiguity mixes content and metadata.
- Duplicate artifacts or states exist and the current idea guesses instead of failing closed.
- Plan and patch disagree on ownership or fail-closed boundary.

When triggered, propose a mini-refactor or rethink. Do not add one more case patch.

## Common Mistakes

- Mistake: Accepting findings one-by-one and patching each line locally.
  Fix: Group by `problem_class` and patch a shared surface.
- Mistake: Passing tests for only the reported example.
  Fix: Add ambiguity-negative plus expected-positive coverage.
- Mistake: Using grep/log text as mutation truth.
  Fix: Assert real mutation outcomes from write path.
- Mistake: Keeping both plan-gate and patch-gate schemas drifting apart.
  Fix: Reuse one canonical gate contract.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Just patch this one finding" | One-off patch often preserves the class defect. |
| "We can generalize later" | Deferred generalization usually becomes recurring review debt. |
| "One more regex will cover it" | Repeated regex exceptions indicate parser/model debt. |
| "This test passes the reported case" | Case-pass is not class-closure; add ambiguity-negative coverage. |
| "I can answer with only a verdict; the fields are implied" | Verdict-only responses hide ownership and fail-closed choices; emit the full gate contract first. |
| "It's just a yes/no question" | Question phrasing does not waive gate fields; emit the full contract before verdict. |
| "I'll keep it short and skip fields" | Brevity does not waive the gate contract; regenerate until all required fields are present. |
| "Start with the verdict to be faster" | Verdict-first output is invalid; `problem_class` must be first and gate must be complete. |

## Examples

- Bad: add another regex for `~~~`.
- Good: resolve fenced or preformatted content vs metadata at parser level.
- Bad: choose the first matching artifact when duplicates exist.
- Good: fail closed when duplicate artifacts exist.
- Bad: count `"purged"` with `grep`.
- Good: return the real mutation outcome from the mutating path.
