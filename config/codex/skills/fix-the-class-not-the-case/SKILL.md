---
name: fix-the-class-not-the-case
description: Use when Codex is about to write code, propose a patch, address review feedback, add an exception branch, extend regex or allowlist or denylist logic, or resolve ambiguous parsing, state, or duplicate-artifact behavior where there is risk of fixing one observed case instead of the underlying error class.
---

# Fix The Class Not The Case

Before writing code or suggesting a patch, ask:

`Does this change close a case, or eliminate an error class?`

Apply this in both first implementations and review-finding fixes.

## Non-Negotiable Rule

- Case-specific fixes are forbidden unless a class-level fix is demonstrably disproportionate. Prefer fail-closed behavior over silent ambiguity.
- Fail-closed does not mean broad production crashes. Prefer narrow, typed, ownership-aligned refusal at the ambiguity boundary over silent success or generic exceptions.
- Treat a fix as suspect when it handles only one observed token, artifact, branch, or log shape.
- If the same surface needs a second or third exception branch, mark `rethink required`.
- Do not answer review findings with a quick patch before stating root cause and affected layer.

## Mini Workflow

1. Classify the change: case closure or class fix.
2. Name the root-cause layer before editing.
3. Prefer the smallest class-level fix.
4. If the proposal is still case-specific, stop and rethink.

## Patch Gate

Emit this brief assessment before patching:

- `problem_class`
- `root_cause_layer`: invariant | ownership boundary | model | parser/state-machine | metadata ownership | other
- `proposed_fix_type`: invariant fix | ownership fix | model fix | parser/state-machine fix
- `case_specific_risk`: low | medium | high
- `fail_closed_impact`

Use the verdict strings below verbatim.

If the proposal only closes one example, say:

`This solution is case-specific; rethink required.`

After this verdict, do not recommend, elaborate, or soften the rejected case-specific patch. Redirect to the smallest class-level or fail-closed fix.

If the proposal removes the underlying error class, say:

`This solution targets the error class.`

## First-Implementation Questions

Answer these before shaping logic:

- `who owns this?`
- `which fields are mutable?`
- `where is the fail-closed point?`
- `what happens under ambiguity?`
- `how are content and metadata separated?`

## Red Flags

Treat these as warning signs, not default fixes:

- special-case `if`
- adding one more regex exception
- growing allowlist or denylist
- a test that locks only one observed instance
- heuristic metrics or logs used as truth
- selecting the first duplicate match
- counting text patterns instead of returning the real mutation outcome

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

When triggered, propose a mini-refactor or rethink. Do not add one more case patch.

## Examples

- Bad: add another regex for `~~~`.
- Good: resolve fenced or preformatted content vs metadata at parser level.
- Bad: choose the first matching artifact when duplicates exist.
- Good: fail closed when duplicate artifacts exist.
- Bad: count `"purged"` with `grep`.
- Good: return the real mutation outcome from the mutating path.
