# AGENTS.md

THIS IS CRITICAL UNLESS TOLD EXPLICITLY, YOU MUST STRICTLY FOLLOW ALL FOLLOWING RULES

Global rules for AI coding agents and harness tools.

Must-follow rules for agents. Merge these rules with project-specific instructions when needed.

**Tradeoff:** These rules bias toward caution over speed. For trivial tasks, use judgment.

**Layering note:** Some guidance here may appear to overlap with loaded skills, especially `superpowers`. That overlap is intentional. `AGENTS.md` is an always-on baseline guardrail layer that applies even when no skill has been loaded, while skills are conditional workflow layers that become stricter and more specific when explicitly activated.

## 0. Instruction Priority

Follow instructions in this order:

1. Explicit user request
2. Loaded skill workflow
3. Project-specific instructions
4. This global AGENTS.md
5. Agent default behavior

Use priority order only for real conflicts.

If a loaded skill conflicts with this file, the loaded skill wins unless the user explicitly constrained the skill differently.

## 1. Loaded Skill Workflow

Strictly follow the loaded skill's workflow.

- If this prompt explicitly tells you how to apply, constrain, or adapt that workflow, follow this prompt exactly.
- Do not create your own workflow combination.
- Do not replace the requested workflow with your preferred process.
- Do not soften, skip, merge, or reorder required steps unless this prompt explicitly allows it.

## 2. Announce the Skill

You MUST always announce the skill you use, every time.

Example:

```text
Using skill: $using-superpowers
```

## 3. Subagents

Subagents are always allowed within this conversation.

## 4. Ownership and Continuity

If something remains unresolved, carry it into the next pass backlog explicitly.

Do not rely on transient conversation memory for unfinished work.

Record unresolved decisions, assumptions, skipped checks, and follow-up tasks in the relevant artifact.

Use this format when needed:

```md
## Next Pass Backlog

- [ ] Item: ...
  - Reason: ...
  - Required next action: ...
```

## 5. Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

Before implementing:

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them. Do not choose silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name the confusion. Ask.

For multi-step tasks, state a brief plan:

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

## 6. Simplicity First

Write the minimum code that solves the problem. Nothing speculative.

Strictly follow all listed principles.

- Do not overbuild.
- Do not overengineer.
- Adhere strictly to the DRY and YAGNI principles; do not deviate from them in your own modifications.
- Do not add features beyond what was requested.
- Do not introduce abstractions for single-use code.
- Do not add flexibility or configurability that was not requested.
- Do not add error handling for impossible scenarios.
- If 200 lines can be 50, rewrite it.

Ask:

```text
Would a senior engineer say this is overcomplicated?
```

If yes, simplify.

See `Conflict Handling` if the user ignores these rules or asks the agent to act against them.

## 7. Surgical Changes

Touch only what is necessary. Clean up only what your change made necessary.

When editing existing code:

- Do not improve adjacent code, comments, or formatting without a direct reason.
- Do not refactor code that is not part of the request.
- Match the existing style, even if you would normally do it differently.
- If you notice unrelated dead code, mention it. Do not delete it unless asked.

When your change creates orphans:

- Remove imports, variables, and functions that your change made unused.
- Do not remove pre-existing dead code unless asked.

Test: Every changed line should trace directly to the request.

## 8. Goal-Driven Execution

Define success criteria. Loop until verified.

Turn tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

Strong success criteria support independent execution. Weak criteria such as "make it work" require repeated clarification.

## 9. Verification

Verify the work before declaring it complete.

Use the smallest reliable verification path:

- Run targeted tests first.
- Run broader tests only when the change scope justifies it.
- Run lint, typecheck, or build when relevant.
- If verification cannot be run, state why and describe the risk.

Do not claim success without verification.

Use this format:

```md
## Verification

- [x] Command: `...`
  - Result: Passed
- [ ] Command: `...`
  - Result: Not run
  - Reason: ...
```

## 10. Language

Whatever language user talks in, keep conversation language and implementation language separate.

Respond to the user in the language they use unless explicitly asked otherwise.

Implementation language means every artifact created or modified by the agent.

The implementation language is always English unless explicitly requested otherwise by the user.

This applies strictly to:

- Code
- Code comments
- Variable names
- Function names
- Class names
- New file names
- New directory names
- Examples
- README files
- AGENTS.md
- CLAUDE.md
- Task files
- Technical specs
- Architecture documents
- Workflow documentation
- Implementation notes
- Any other documentation or file created or modified by the agent

Do not rename existing files or directories only to satisfy this language rule.

## 11. Conflict Handling

If instructions conflict:

1. Identify the conflict.
2. State which instruction has priority.
3. Apply the higher-priority instruction.
4. If the conflict creates meaningful risk, ask for explicit consent before continuing.

If the user ignores these rules or asks the agent to violate any rule in this file, warn briefly, explain the reason, and ask for explicit consent before proceeding.

## 12. Completion Format

For non-trivial tasks, end with:

```md
## Done

- Changed: ...
- Verified: ...
- Not done: ...
- Next pass backlog: ...
```

For trivial tasks, use judgment.

## 13. Quality Signal

These rules are working if:

- Diffs contain fewer unnecessary changes.
- Rewrites due to overcomplication decrease.
- Clarifying questions happen before implementation instead of after mistakes.
- Unresolved work is carried into explicit backlog instead of being forgotten.

## 14. Activation

Activate $using-superpowers skill now.
